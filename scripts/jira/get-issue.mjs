import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { ensureAuth, jiraApi } from './client.mjs';

(async () => {
  const argv = yargs(hideBin(process.argv))
    .usage('Usage: $0 <issueKey>')
    .demandCommand(1)
    .help()
    .argv;

  const issueKey = argv._[0];

  try {
    const authed = await ensureAuth();
    if (!authed) throw new Error('Not authenticated. Run: npm run jira:auth');

    const data = await jiraApi(`/rest/api/3/issue/${encodeURIComponent(issueKey)}`);
    console.log(JSON.stringify(data, null, 2));
  } catch (e) {
    console.error('Error getting issue:', e.message);
    process.exit(1);
  }
})();
