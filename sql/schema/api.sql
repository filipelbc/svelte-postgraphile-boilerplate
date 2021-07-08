-- Extensions

create extension pgcrypto;

-- Postgraphile User

create user postgraphile with
    superuser -- NOTE: only needed for `watchPg: true`
    password 'postgraphile_password';

-- Graphile Worker User

create user graphile_worker with
    superuser -- NOTE: only needed for migrations
    password 'graphile_worker_password';

-- Schemas

create schema api;
create schema auth;
create schema tasks;

-- Restrict by Default

revoke all on database app from public;
grant connect on database app to public;
grant usage on schema public, api to public;

-- User Roles

create role anonymous_user;
create role registered_user;

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

-- JWT Utils

create function auth.current_user_id()
returns bigint
language sql stable
as $$
    select nullif(current_setting('jwt.claims.user_id', true), '')::bigint;
$$;

-- Table: Users

create table api.users
(
    id   bigint primary key generated always as identity,
    name text not null unique
);

alter table api.users enable row level security;

grant select, update on table api.users to registered_user;

create policy own_rows on api.users to registered_user
    using (id = auth.current_user_id());

comment on table api.users is '@omit create,delete';
comment on column api.users.id is '@omit create,update,delete';

-- Table: User Passwords

create table auth.user_passwords
(
    user_id         bigint primary key references api.users,
    hashed_password text not null
);

-- JWT Utils

create function auth.make_jwt_token_pair
(
    _user api.users,
    _role text default 'registered_user'
)
returns api.jwt_token_pair
language plpgsql
security definer
as $$
begin

    return (
        (
            _role,
            extract(epoch from now() + interval '7 days'),
            _user.id,
            _user.name
        )::api.jwt_access_token,
        'refresh_token'
    )::api.jwt_token_pair;

end
$$;

-- Triggers

create function tasks.say_hello()
returns trigger
language plpgsql
security definer
as $$
begin
    perform graphile_worker.add_job('say_hello', json_build_object('id', new.id));
    return new;
end;
$$;

create trigger _00_say_hello
    after insert
    on api.users
    for each row execute procedure tasks.say_hello();

-- API Functions

create function api.create_user
(
    _name     text,
    _password text
)
returns api.jwt_token_pair
language plpgsql
security definer
as $$
declare
    _new_user api.users;
begin
    if exists(select * from api.users where name = _name)
    then
        raise 'User already exists';
    end if;

    insert into api.users(name) values (_name) returning * into _new_user;

    insert into auth.user_passwords(user_id, hashed_password) values
    (
        _new_user.id,
        crypt(_password, gen_salt('bf'))
    );

    return auth.make_jwt_token_pair(_user => _new_user);
end
$$;

grant execute on function api.create_user to anonymous_user;

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
    _user api.users;
begin

    select u.* into _user
    from api.users as u
    join auth.user_passwords as p on p.user_id = u.id
    where u.name = _name
    and p.hashed_password = crypt(_password, p.hashed_password);

    if not found
    then
        raise 'Invalid name or password';
    end if;

    return auth.make_jwt_token_pair(_user => _user);
end
$$;

grant execute on function api.login_user to anonymous_user;
