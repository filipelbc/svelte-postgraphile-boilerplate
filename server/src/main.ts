import { createServer } from 'http';
import { postgraphile } from 'postgraphile';
import { database, schemas, options, port } from './settings';

const middleware = postgraphile(database, schemas, options);

const server = createServer(middleware);

server.listen(port, () => {
  console.log(`Server running on:`, server.address());
  console.log(`PostGraphiQL available at: http://localhost:${port}${options.graphiqlRoute || '/graphiql'}`);
});
