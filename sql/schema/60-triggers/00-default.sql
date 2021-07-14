/*
    Sample trigger to enqueue a background task.
*/

drop function if exists tasks.say_hello cascade;

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
