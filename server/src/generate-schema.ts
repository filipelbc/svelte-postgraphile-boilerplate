import getPostgraphileSchemaBuilder from 'postgraphile';

import { database, schemas, options } from './settings';

async function main() {
  console.log('Generating GraphQL schema...');

  database.on('error', err => {
    console.error('PostgreSQL client generated error: ', err.message);
  });

  const { getGraphQLSchema } = getPostgraphileSchemaBuilder(database, schemas, { ...options, watchPg: false });

  await getGraphQLSchema();
  await database.end();
}

main().then(
  () => console.log('Done'),
  err => {
    console.error('Something went wrong: ', err.message);
    process.exit(1);
  }
);
