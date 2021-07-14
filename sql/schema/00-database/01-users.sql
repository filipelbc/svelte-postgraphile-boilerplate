/*
    Use this file to setup database users.
*/

drop user if exists
    postgraphile,
    graphile_worker;

create user postgraphile with
    superuser -- NOTE: only needed for `watchPg: true`
    password 'postgraphile_password';

create user graphile_worker with
    superuser -- NOTE: only needed for migrations
    password 'graphile_worker_password';
