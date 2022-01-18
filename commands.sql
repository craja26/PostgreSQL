# connect to postgresql
psql -Upostgres

#list databases
\list

#connect to a database
\c <db-name>

#list tables
\dt

#get the list of users
\du or \du+

#exit from postgresql
\q

# find hba conf file
SHOW hba_file;

#backup hba file
cp pg_hba.conf pg_hba.conf`date +%Y%m%d`

# create a user and grant read-only access.
CREATE USER <user_name> WITH PASSWORD '<password>';
GRANT USAGE ON SCHEMA public TO <user_name>;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO <user_name>;

# grant access to connect Postgresql remotely
We need to whitelist the ip address in pg_hba.conf file.
Ex: add host info like below.
# TYPE  DATABASE        USER            ADDRESS        IP-MASK                 METHOD
host   all             all              <ip address>   255.255.255.255         password

We need to reload the configuration file to effect changes.(Note: No need to restart services.)
SELECT pg_reload_conf();

-- Create extension
CREATE EXTENSION pgstattuple WITH schema <schema_name>;

------- Create read-only user account --------------
## create read_only user
CREATE ROLE <read_only_user> WITH LOGIN PASSWORD '<pwd>' 
NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION VALID UNTIL 'infinity';

GRANT CONNECT ON DATABASE <db_name> TO <read_only_user>;
GRANT USAGE ON SCHEMA public TO <read_only_user>;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO <read_only_user>;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO <read_only_user>;
--Assign permissions to read all newly tables created in the future
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO <read_only_user>;

/****** Copy SELECT results into csv file ******/
\copy (SELECT col1, col2 from schemaname.tablename where col3 = '') to '/var/lib/pgsql/11/backups/filename.csv' with CSV DELIMITER ',' HEADER

/*******blocked processes and blocking queries********/
SELECT
    activity.pid,
    activity.usename,
    activity.query,
    blocking.pid AS blocking_id,
    blocking.query AS blocking_query
FROM pg_stat_activity AS activity
JOIN pg_stat_activity AS blocking ON blocking.pid = ANY(pg_blocking_pids(activity.pid));

--https://www.shanelynn.ie/postgresql-find-slow-long-running-and-blocked-queries/


/*****Postgres current running queries****/
SELECT datname, pid, state, query, age(clock_timestamp(), query_start) AS age 
FROM pg_stat_activity
WHERE state <> 'idle' 
    AND query NOT LIKE '% FROM pg_stat_activity%' 
ORDER BY age;


/***** Postgresql pid details from linux machine *****/
# su - postgres
$ ps -elf --forest



/***** ## List the database privileges using psql  ******/
SELECT grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name='mytable'

SELECT grantor, grantee, table_schema, table_name, privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'myuser'

SELECT grantee AS user, CONCAT(table_schema, '.', table_name) AS table, 
    CASE 
        WHEN COUNT(privilege_type) = 7 THEN 'ALL'
        ELSE ARRAY_TO_STRING(ARRAY_AGG(privilege_type), ', ')
    END AS grants
FROM information_schema.role_table_grants
GROUP BY table_name, table_schema, grantee;


/********** Each table size, tuples, autovacuum and autoanalysiz ***********/
SELECT
  schema_name,
  t.relname,
  pg_size_pretty(table_size) AS table_size,
  pg_size_pretty(total_relation_size) AS occupied_size,
  pg_size_pretty(index_size) as index_size,
  pg_size_pretty(unused_space) as unused_space,
  ps.n_live_tup, 
  ps.n_dead_tup, last_vacuum, last_autovacuum, last_analyze, last_autoanalyze 
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
	--and relname in ('tablename')
    ) t left join pg_stat_user_tables ps on ps.relname = t.relname and ps.schemaname = t.schema_name
ORDER BY total_relation_size - table_size DESC;  


/**** Size of a schema ****/
select pg_size_pretty(sum(pg_total_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)))::bigint) from pg_tables where schemaname ='reporting_bak'


/******* Get index information for table ********/
SELECT 
	tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'schema_name' and tablename = 'table_name'
ORDER BY tablename, indexname;
-- # Note: tablename and schemaname are case-sensitive.



