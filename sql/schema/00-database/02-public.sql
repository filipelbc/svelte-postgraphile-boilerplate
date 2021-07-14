/*
    Use this file to setup the public role and schema.
*/

revoke all on database app from public;
grant connect on database app to public;
grant usage on schema public to public;
