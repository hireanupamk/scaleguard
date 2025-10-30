import { runAuthFlow } from './client.mjs';

(async () => {
  try {
    await runAuthFlow();
    console.log('OAuth complete. Tokens stored locally under .jira-oauth/tokens.json');
  } catch (e) {
    console.error('Auth failed:', e.message);
    process.exit(1);
  }
})();
