import { Pool } from 'pg';
import { PostGraphileOptions } from 'postgraphile';
import PgSimplifyInflectorPlugin from '@graphile-contrib/pg-simplify-inflector';

import inflectors from './inflectors';

export const database = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const schemas = ['api'];

export const options: PostGraphileOptions = {
  watchPg: true,
  graphiql: true,
  enhanceGraphiql: true,
  dynamicJson: true,
  setofFunctionsContainNulls: false,
  ignoreRBAC: false,
  showErrorStack: 'json',
  extendedErrors: ['hint', 'detail', 'errcode'],
  legacyRelations: 'omit',
  exportGqlSchemaPath: `${__dirname}/../schema.graphql`,
  sortExport: true,
  appendPlugins: [PgSimplifyInflectorPlugin, inflectors],
  graphileBuildOptions: {
    pgStrictFunctions: true,
  },
  pgDefaultRole: 'anonymous_user',
  jwtSecret: process.env.JWT_SECRET,
  jwtPgTypeIdentifier: 'api.jwt_access_token',
};

export const port: number = process.env.PORT
  ? parseInt(process.env.PORT, 10)
  : 3000;
