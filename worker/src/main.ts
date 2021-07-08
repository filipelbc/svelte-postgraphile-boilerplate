import { run } from 'graphile-worker';

import * as tasks from './tasks';

import { database, concurrency, pollInterval } from './settings';

async function main() {
  const runner = await run({
    pgPool: database,
    concurrency,
    pollInterval,
    taskList: {
      say_hello: async (payload: any, helpers) => {
        await tasks.say_hello(payload, helpers);
      },
    },
  });

  await runner.promise;
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
