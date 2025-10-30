Jira Integration Scripts (OAuth 2.0 for Jira Cloud)

Overview
This folder contains Node scripts to authenticate with Jira Cloud using OAuth 2.0 (3LO) and perform common developer actions:
- Authenticate and store refresh/access tokens locally
- Get a Jira issue
- Create a Jira issue
- Comment on a Jira issue
- Transition a Jira issue

Requirements
- Node 18+
- Jira Cloud base URL: https://scaleguard.atlassian.net
- Jira OAuth 2.0 (3LO) app in Atlassian Admin with:
  - Redirect URL: http://localhost:43123/callback
  - Scopes:
    - offline_access
    - read:jira-work
    - write:jira-work
    - Optional: read:jira-user (for user lookups)

Files
- auth.mjs: OAuth flow launcher and token persistence.
- client.mjs: Jira REST client bootstrap with OAuth tokens.
- get-issue.mjs: Fetch issue by key.
- create-issue.mjs: Create an issue in a project.
- comment.mjs: Add a comment to an issue.
- transition.mjs: List and perform transitions for an issue.
- get-assigned-issues.mjs: Count issues assigned to you.
- jira.oauth.template.json: Template for Jira OAuth client settings (copy and fill locally).
- tokens.json: Generated locally after auth (gitignored).

Setup
1) Create the OAuth app in Atlassian Admin
   - Go to: https://developer.atlassian.com/console/
   - Create OAuth 2.0 (3LO) App
   - Set Redirect URL to: http://localhost:43123/callback
   - Add scopes: offline_access, read:jira-work, write:jira-work
   - Copy Client ID and Client Secret

2) Configure local OAuth settings
   - Copy jira.oauth.template.json to jira.oauth.json
   - Fill:
     {
       "baseUrl": "https://scaleguard.atlassian.net",
       "projectKeyDefault": "PS",
       "clientId": "YOUR_CLIENT_ID",
       "clientSecret": "YOUR_CLIENT_SECRET",
       "redirectUri": "http://localhost:43123/callback"
     }

3) Install dependencies and run auth
   - npm install
   - npm run jira:auth
   - Your browser will open; login/consent; tokens.json will be created locally under scripts/jira/.jira-oauth/

Usage
- Get an issue:
  npm run jira:issue -- PS-123

- Create an issue:
  npm run jira:create -- --summary "My summary" --description "Optional desc" --type "Task" --project PS

- Comment:
  npm run jira:comment -- PS-123 --text "Deployed to QA"

- Transition (list):
  npm run jira:transition -- PS-123 --list
  Transition (perform by name or id):
  npm run jira:transition -- PS-123 --to "In Progress"

Notes
- Commit messages and PR titles should include keys like PS-123 to enable GitHub↔Jira linkage when the Atlassian GitHub App is installed.
- The commit-msg hook warns when missing a key but does not block.

Troubleshooting
- Invalid scopes: Ensure the app includes offline_access, read:jira-work, write:jira-work.
- Redirect mismatch: Redirect in your app must match http://localhost:43123/callback exactly.
- 401 after some time: Run jira:auth again to refresh tokens; token refresh is automatic but may require re-consent if revoked.
