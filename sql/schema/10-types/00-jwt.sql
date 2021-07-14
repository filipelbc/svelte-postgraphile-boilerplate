/*
    Use this file to declare custom types related to JWT.
*/

drop type if exists
    api.jwt_access_token,
    api.jwt_token_pair
    cascade;

create type api.jwt_access_token as (
    role      text,
    exp       integer,
    user_id   bigint,
    user_name text
);

create type api.jwt_token_pair as (
    access_token  api.jwt_access_token,
    refresh_token text
);
