import fs from 'fs';
import path from 'path';
import http from 'http';
import open from 'open';
import * as openidClient from 'openid-client';
const { Issuer, generators, custom } = openidClient;
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

const __dirname = path.dirname(new URL(import.meta.url).pathname);

// Load config (jira.oauth.json preferred, fallback to template for structure)
const CONFIG_DIR = __dirname;
const TEMPLATE_PATH = path.resolve(CONFIG_DIR, 'jira.oauth.template.json');
const USER_CFG_PATH = path.join(CONFIG_DIR, 'jira.oauth.json');

function loadConfig() {
  const base = JSON.parse(fs.readFileSync(TEMPLATE_PATH, 'utf8'));
  if (fs.existsSync(USER_CFG_PATH)) {
    const user = JSON.parse(fs.readFileSync(USER_CFG_PATH, 'utf8'));
    return { ...base, ...user };
  }
  return base;
}

const cfg = loadConfig();

// Token storage
const TOKEN_DIR = path.resolve(CONFIG_DIR, cfg.tokenStoreDir || '.jira-oauth');
const TOKEN_FILE = path.join(TOKEN_DIR, 'tokens.json');

function ensureDir(p) {
  if (!fs.existsSync(p)) fs.mkdirSync(p, { recursive: true });
}

function saveTokens(tokens) {
  ensureDir(TOKEN_DIR);
  fs.writeFileSync(TOKEN_FILE, JSON.stringify(tokens, null, 2));
}

function loadTokens() {
  if (!fs.existsSync(TOKEN_FILE)) return null;
  return JSON.parse(fs.readFileSync(TOKEN_FILE, 'utf8'));
}

// OAuth: Atlassian Cloud authorization server
const ATLASSIAN_ISSUER = 'https://auth.atlassian.com';

// Helper: build openid client
async function buildClient() {
  const issuer = await Issuer.discover(ATLASSIAN_ISSUER);
  const client = new issuer.Client({
    client_id: cfg.clientId,
    client_secret: cfg.clientSecret,
    redirect_uris: [cfg.redirectUri],
    response_types: ['code'],
    token_endpoint_auth_method: 'client_secret_basic',
  });
  // Allow a bit longer for requests
  custom.setHttpOptionsDefaults({
    timeout: 15000,
  });
  return client;
}

// Start local auth server and run the auth code flow
export async function runAuthFlow() {
  if (!cfg.clientId || !cfg.clientSecret || !cfg.redirectUri) {
    throw new Error('Missing OAuth configuration. Copy jira.oauth.template.json to jira.oauth.json and fill clientId, clientSecret, redirectUri.');
  }

  const client = await buildClient();
  const codeVerifier = generators.codeVerifier();
  const codeChallenge = generators.codeChallenge(codeVerifier);

  const scope = (cfg.scopes || ['offline_access', 'read:jira-work', 'write:jira-work']).join(' ');
  const url = client.authorizationUrl({
    scope,
    code_challenge: codeChallenge,
    code_challenge_method: 'S256',
    audience: 'api.atlassian.com',
    prompt: 'consent',
  });

  // Start a small HTTP server to catch the callback
  const redirectUrl = new URL(cfg.redirectUri);
  const server = http.createServer(async (req, res) => {
    try {
      if (req.url && req.url.startsWith(redirectUrl.pathname)) {
        const reqUrl = new URL(req.url, `http://${req.headers.host}`);
        const params = client.callbackParams(reqUrl.toString());
        const tokenSet = await client.callback(cfg.redirectUri, params, { code_verifier: codeVerifier });
        saveTokens(tokenSet);
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end('<h1>Jira OAuth successful</h1><p>You can close this window and return to the terminal.</p>');
        server.close();
      } else {
        res.writeHead(404);
        res.end();
      }
    } catch (e) {
      res.writeHead(500, { 'Content-Type': 'text/plain' });
      res.end(`OAuth Error: ${e.message}`);
      server.close();
    }
  });

  await new Promise((resolve) => server.listen(Number(redirectUrl.port || 80), redirectUrl.hostname, resolve));
  await open(url);
  // Wait until server closes (auth completes)
  await new Promise((resolve) => server.on('close', resolve));
}

// Get a valid access token, refreshing if needed
export async function getAccessToken() {
  const client = await buildClient();
  let tokens = loadTokens();
  if (!tokens) {
    throw new Error('Not authenticated. Run: npm run jira:auth');
  }

  const tokenSet = client.decryptIdToken ? tokens : tokens; // placeholder if future changes

  // If expired and we have refresh_token, refresh
  const now = Math.floor(Date.now() / 1000);
  if (tokens.expires_at && tokens.expires_at <= now + 60 && tokens.refresh_token) {
    const refreshed = await client.refresh(tokens.refresh_token);
    // openid-client returns TokenSet with properties
    const merged = {
      ...tokens,
      ...refreshed,
      access_token: refreshed.access_token,
      refresh_token: refreshed.refresh_token || tokens.refresh_token,
      expires_at: refreshed.expires_at,
      token_type: refreshed.token_type || 'Bearer',
      scope: refreshed.scope || tokens.scope,
    };
    saveTokens(merged);
    tokens = merged;
  }

  return tokens.access_token;
}

// Atlassian Cloud: Determine API base (Cloud requires a cloudId)
async function resolveCloudId(accessToken) {
  // GET https://api.atlassian.com/oauth/token/accessible-resources
  const resp = await fetch('https://api.atlassian.com/oauth/token/accessible-resources', {
    headers: {
      Authorization: `Bearer ${accessToken}`,
      Accept: 'application/json',
    },
  });
  if (!resp.ok) {
    const text = await resp.text();
    throw new Error(`Failed to resolve cloudId: ${resp.status} ${text}`);
  }
  const resources = await resp.json();
  // Find Jira with the configured baseUrl
  const match = resources.find((r) => r.url && cfg.baseUrl && r.url.toLowerCase().startsWith(cfg.baseUrl.toLowerCase()));
  if (!match) {
    throw new Error(`No accessible Jira resource matching baseUrl ${cfg.baseUrl}. Check account/app access.`);
  }
  return match.id;
}

export async function jiraApi(pathname, init = {}) {
  const accessToken = await getAccessToken();
  const cloudId = await resolveCloudId(accessToken);

  const url = `https://api.atlassian.com/ex/jira/${cloudId}${pathname}`;
  const headers = {
    Authorization: `Bearer ${accessToken}`,
    Accept: 'application/json',
    'Content-Type': 'application/json',
    ...(init.headers || {}),
  };
  const resp = await fetch(url, { ...init, headers });
  if (!resp.ok) {
    const text = await resp.text();
    throw new Error(`Jira API error ${resp.status}: ${text}`);
  }
  if (resp.status === 204) return null;
  return await resp.json();
}

// CLI helper to ensure auth quickly
export async function ensureAuth() {
  try {
    await getAccessToken();
    return true;
  } catch {
    return false;
  }
}

// expose config for other scripts
export function getConfig() {
  return cfg;
}

// When run directly, allow quick auth test
if (process.argv[1] && process.argv[1].endsWith('client.mjs')) {
  yargs(hideBin(process.argv))
    .command('auth', 'Run OAuth flow', {}, async () => {
      await runAuthFlow();
      console.log('OAuth tokens saved.');
    })
    .command('whoami', 'Test access by listing accessible resources', {}, async () => {
      const token = await getAccessToken();
      const resp = await fetch('https://api.atlassian.com/oauth/token/accessible-resources', {
        headers: { Authorization: `Bearer ${token}`, Accept: 'application/json' },
      });
      console.log(await resp.json());
    })
    .demandCommand()
    .help()
    .parse();
}
