import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { ensureAuth, jiraApi } from './client.mjs';

(async () => {
  const argv = yargs(hideBin(process.argv))
    .usage('Usage:\n  $0 <issueKey> --list\n  $0 <issueKey> --to "In Progress"  # by name\n  $0 <issueKey> --to-id 31          # by id')
    .demandCommand(1)
    .options({
      list: { type: 'boolean', desc: 'List available transitions' },
      to: { type: 'string', desc: 'Transition name to move the issue to' },
      'to-id': { type: 'string', desc: 'Transition id to move the issue to' }
    })
    .check((args) => {
      if (!args.list && !args.to && !args['to-id']) {
        throw new Error('Specify --list or one of --to / --to-id');
      }
      return true;
    })
    .help()
    .argv;

  const issueKey = argv._[0];

  try {
    const authed = await ensureAuth();
    if (!authed) throw new Error('Not authenticated. Run: npm run jira:auth');

    // List transitions
    const listResp = await jiraApi(`/rest/api/3/issue/${encodeURIComponent(issueKey)}/transitions?expand=transitions.fields`);
    const transitions = listResp.transitions || [];

    if (argv.list) {
      console.log(JSON.stringify(transitions.map(t => ({ id: t.id, name: t.name })), null, 2));
      process.exit(0);
    }

    let targetId = argv['to-id'];
    if (!targetId && argv.to) {
      const found = transitions.find(t => t.name.toLowerCase() === argv.to.toLowerCase());
      if (!found) {
        console.error(`Transition "${argv.to}" not found. Available: ${transitions.map(t => t.name).join(', ')}`);
        process.exit(2);
      }
      targetId = found.id;
    }

    if (!targetId) {
      console.error('No transition specified. Use --to "Name" or --to-id <id>.');
      process.exit(2);
    }

    const payload = { transition: { id: String(targetId) } };
    await jiraApi(`/rest/api/3/issue/${encodeURIComponent(issueKey)}/transitions`, {
      method: 'POST',
      body: JSON.stringify(payload)
    });

    console.log(`Transitioned ${issueKey} using transition id ${targetId}.`);
  } catch (e) {
    console.error('Error transitioning issue:', e.message);
    process.exit(1);
  }
})();
