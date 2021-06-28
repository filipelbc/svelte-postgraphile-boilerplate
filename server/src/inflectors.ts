import { makeAddInflectorsPlugin } from 'graphile-utils';

export default makeAddInflectorsPlugin(
  {
    // Our SQL convention is to prefix all argument names with `_`. On the
    // GraphQL side, we remove it.
    argument(name: string, index: number) {
      return this.coerceToGraphQLName(
        this.camelCase(name?.replace(/^_/, '') || `arg${index}`)
      );
    },
  },
  true
);
