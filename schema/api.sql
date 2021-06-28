-- Extensions

create extension pgcrypto;

-- Postgraphile User

create user postgraphile with
    superuser -- NOTE: only needed for `watchPg: true`
    password 'postgraphile_password';

-- Schemas

create schema api;
create schema account;

-- Security

revoke all on database app from public;
grant connect on database app to public;
grant usage on schema public, api to public;

-- User Roles

create role tokenless;

-- API Types

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

-- Account Tables

create table account.users
(
    id   bigint primary key generated always as identity,
    name text not null unique
);

create table account.user_passwords
(
    user_id         bigint primary key references account.users,
    hashed_password text not null
);

-- Auth API

create function api.register_user
(
    _name     text,
    _password text
)
returns void
language plpgsql
security definer
as $$
declare
    _new_user_id bigint;
begin
    if exists(select * from account.users where name = _name)
    then
        raise 'User already exists';
    end if;

    insert into account.users(name) values (_name) returning id into _new_user_id;

    insert into account.user_passwords(user_id, hashed_password) values
    (
        _new_user_id,
        crypt(_password, gen_salt('bf'))
    );
end
$$;

grant execute on function api.register_user to tokenless;

create function api.login_user
(
    _name     text,
    _password text
)
returns api.jwt_token_pair
language plpgsql
security definer
as $$
declare
    _user account.users;
begin

    select u.* into _user
    from account.users as u
    join account.user_passwords as p on p.user_id = u.id
    where u.name = _name
    and p.hashed_password = crypt(_password, p.hashed_password);

    if not found
    then
        raise 'Invalid name or password';
    end if;

    return (
        (
        '',
        extract(epoch from now() + interval '7 days'),
        _user.id,
        _user.name
        )::api.jwt_access_token,
        'refresh_token'
    )::api.jwt_token_pair;
end
$$;

grant execute on function api.login_user to tokenless;
