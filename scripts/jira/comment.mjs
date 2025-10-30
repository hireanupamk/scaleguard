import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { ensureAuth, jiraApi } from './client.mjs';

(async () => {
  const argv = yargs(hideBin(process.argv))
    .usage('Usage: $0 <issueKey> --text "Your comment"')
    .demandCommand(1)
    .options({
      text: { type: 'string', desc: 'Comment text', demandOption: true }
    })
    .help()
    .argv;

  const issueKey = argv._[0];

  try {
    const authed = await ensureAuth();
    if (!authed) throw new Error('Not authenticated. Run: npm run jira:auth');

    const payload = {
      body: {
        type: 'doc',
        version: 1,
        content: [
          {
            type: 'paragraph',
            content: [{ type: 'text', text: argv.text }]
          }
        ]
      }
    };

    const data = await jiraApi(`/rest/api/3/issue/${encodeURIComponent(issueKey)}/comment`, {
      method: 'POST',
      body: JSON.stringify(payload)
    });

    console.log(`Comment added to ${issueKey}: ${data.id}`);
  } catch (e) {
    console.error('Error adding comment:', e.message);
    process.exit(1);
  }
})();
