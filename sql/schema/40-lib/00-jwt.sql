/*
    Use this file to setup JWT related functionality.
*/

drop function if exists auth.make_jwt_token_pair cascade;

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
