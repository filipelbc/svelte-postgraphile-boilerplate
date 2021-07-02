import { GraphQLClient } from 'graphql-request';
import { getSdk } from './graphql-sdk';

const url = `${window.location.protocol}//${window.location.host}/graphql`

const client = new GraphQLClient(url);

export default getSdk(client);
