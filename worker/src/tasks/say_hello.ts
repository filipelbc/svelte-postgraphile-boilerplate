import type { JobHelpers } from 'graphile-worker';

type Payload = {
  id: Number;
};

export default async (payload: Payload, helpers: JobHelpers) => {
  const { id } = payload;

  const result = await helpers.query<{ name: string }>(
    'select name from api.users where id = $1::bigint',
    [id]
  );

  helpers.logger.info(`Hello, ${result.rows[0].name}`);
};
