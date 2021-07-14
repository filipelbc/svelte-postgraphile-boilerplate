/*
    API entity "User"
*/

drop table if exists api.users cascade;

create table api.users
(
    id   bigint primary key generated always as identity,
    name text not null unique
);

comment on table api.users is '@omit create,delete';
comment on column api.users.id is '@omit create,update,delete';

alter table api.users enable row level security;

grant select, update on table api.users to registered_user;

create policy own_rows on api.users to registered_user
    using (id = auth.current_user_id());

-- Table: User Passwords

drop table if exists auth.user_passwords cascade;

create table auth.user_passwords
(
    user_id         bigint primary key references api.users,
    hashed_password text not null
);
