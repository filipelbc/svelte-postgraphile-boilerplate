import { Pool } from 'pg';
import { PostGraphileOptions, makePluginHook, makeExtendSchemaPlugin, gql } from 'postgraphile';

export const database = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const schemas = ['public'];

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
};

export const port: number = process.env.PORT ? parseInt(process.env.PORT, 10) : 3000;
