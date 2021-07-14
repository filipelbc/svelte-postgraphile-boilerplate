/*
    Use this file to setup our schemas.
*/

drop schema if exists
    api,
    auth,
    tasks
    cascade;

create schema api;
create schema auth;
create schema tasks;

grant usage on schema api to public;
