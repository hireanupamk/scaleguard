import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { ensureAuth, jiraApi, getConfig } from './client.mjs';

(async () => {
  const argv = yargs(hideBin(process.argv))
    .options({
      project: { type: 'string', desc: 'Project key', default: getConfig().projectKeyDefault || 'PS' },
      summary: { type: 'string', desc: 'Issue summary', demandOption: true },
      description: { type: 'string', desc: 'Issue description' },
      type: { type: 'string', desc: 'Issue type name', default: 'Task' }
    })
    .help()
    .argv;

  try {
    const authed = await ensureAuth();
    if (!authed) throw new Error('Not authenticated. Run: npm run jira:auth');

    const payload = {
      fields: {
        project: { key: argv.project },
        summary: argv.summary,
        description: argv.description || '',
        issuetype: { name: argv.type }
      }
    };

    const data = await jiraApi('/rest/api/3/issue', {
      method: 'POST',
      body: JSON.stringify(payload)
    });

    console.log(`Created issue: ${data.key}`);
    console.log(JSON.stringify(data, null, 2));
  } catch (e) {
    console.error('Error creating issue:', e.message);
    process.exit(1);
  }
})();
