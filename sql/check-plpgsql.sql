set client_min_messages to warning;

create extension if not exists plpgsql_check;

-- checks all functions and trigger functions with defined triggers

select
    (r).functionid::regprocedure as "Function",
    (r).lineno                   as "Line Num",
    (r).statement                as "Statement",
    (r).sqlstate                 as "Sql State",
    (r).message                  as "Message",
    (r).detail                   as "Detail",
    (r).hint                     as "Hint",
    (r).level                    as "Level",
    (r).position                 as "Position",
    (r).query                    as "Query",
    (r).context                  as "Context"
from (
    select
        plpgsql_check_function_tb(pg_proc.oid, coalesce(pg_trigger.tgrelid, 0)) as r
    from
        pg_proc
    left join
        pg_trigger on (pg_trigger.tgfoid = pg_proc.oid)
    where
        -- only plpgsql functions
        prolang = (select oid from pg_language where lanname = 'plpgsql')
        -- only from relevant namespaces
        and pronamespace <> (select oid from pg_namespace where nspname = 'pg_catalog')
        -- ignore unused triggers
        and (
            pg_proc.prorettype <> (select oid from pg_type where typname = 'trigger')
            or pg_trigger.tgfoid is not null
        )
    offset 0
) c
order by (r).functionid::regprocedure::text, (r).lineno;
