create extension plpgsql_check;

-- checks all functions and trigger functions with defined triggers

select
    (r).functionid::regprocedure,
    (r).lineno,
    (r).statement,
    (r).sqlstate,
    (r).message,
    (r).detail,
    (r).hint,
    (r).level,
    (r).position,
    (r).query,
    (r).context
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
