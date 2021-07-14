/*
    Use this file to setup the role hierarchy.
*/

drop role if exists
    anonymous_user,
    registered_user;

create role anonymous_user;

create role registered_user;
