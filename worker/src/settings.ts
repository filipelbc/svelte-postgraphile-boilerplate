import { Pool } from 'pg';

export const database = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const concurrency = parseInt(process.env.CONCURRENCY || '1');

export const pollInterval = parseInt(process.env.POLL_INTERVAL || '1000');
