import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { ensureAuth, jiraApi } from './client.mjs';

(async () => {
  const argv = yargs(hideBin(process.argv))
    .options({
      verbose: { type: 'boolean', desc: 'Show full issue details' }
    })
    .help()
    .argv;

  try {
    const authed = await ensureAuth();
    if (!authed) throw new Error('Not authenticated. Run: npm run jira:auth');

    // Use JQL to find issues assigned to current user
    const jql = 'assignee = currentUser()';
    const maxResults = 1000; // Adjust if you expect more issues
    
    const data = await jiraApi(`/rest/api/3/search?jql=${encodeURIComponent(jql)}&maxResults=${maxResults}&fields=key,summary,status,assignee`);

    if (argv.verbose) {
      console.log(`Found ${data.total} issues assigned to you:`);
      data.issues.forEach(issue => {
        console.log(`  ${issue.key}: ${issue.fields.summary} (${issue.fields.status.name})`);
      });
    } else {
      console.log(`You have ${data.total} assigned issues`);
    }
    
  } catch (e) {
    console.error('Error fetching assigned issues:', e.message);
    process.exit(1);
  }
})();
