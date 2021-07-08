import { runMigrations } from 'graphile-worker';

import { database } from './settings';

runMigrations({
  pgPool: database,
}).catch((err) => {
  console.error(err);
  process.exit(1);
});
