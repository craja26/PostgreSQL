# table size and unused space
SELECT
  schema_name,
  relname,
  pg_size_pretty(table_size) AS table_size,
  pg_size_pretty(total_relation_size) AS occupied_size,
  pg_size_pretty(index_size) as index_size,
  pg_size_pretty(unused_space) as unused_space
FROM (
    select pg_catalog.pg_class.reltype ,
        pg_catalog.pg_namespace.nspname           AS schema_name,
        relname,
        pg_relation_size(pg_catalog.pg_class.oid) AS table_size,
            pg_total_relation_size(pg_catalog.pg_class.oid) AS total_relation_size,
            pg_indexes_size(pg_catalog.pg_class.oid) as index_size,
            (pg_total_relation_size(pg_catalog.pg_class.oid) - pg_relation_size(pg_catalog.pg_class.oid)) as unused_space
    FROM pg_catalog.pg_class
    JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
    WHERE  pg_catalog.pg_class.reltype not in (0,16614,16755) and pg_catalog.pg_namespace.nspname NOT in ('information_schema','sqlj') and pg_catalog.pg_namespace.nspname  not LIKE 'pg_%'
    ) t
ORDER BY total_relation_size - table_size DESC;  

