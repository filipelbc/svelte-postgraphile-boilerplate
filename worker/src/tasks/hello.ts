import type { JobHelpers } from 'graphile-worker';

type Payload = {
  name: string;
};

export default async (payload: Payload, helpers: JobHelpers) => {
  const { name } = payload;
  helpers.logger.info(`Hello, ${name}`);
};
