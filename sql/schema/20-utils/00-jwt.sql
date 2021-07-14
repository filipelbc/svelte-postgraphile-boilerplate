/*
    Use this file to setup utility functions related to JWT claims.
*/

drop function if exists auth.current_user_id cascade;

create function auth.current_user_id()
returns bigint
language sql stable
as $$
    select nullif(current_setting('jwt.claims.user_id', true), '')::bigint;
$$;
