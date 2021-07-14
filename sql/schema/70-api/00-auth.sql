/*
    Use this file to define authentication-related functions.
*/

drop function if exists api.create_user;

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

drop function if exists api.login_user;

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
