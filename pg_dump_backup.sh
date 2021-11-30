## backup database
pg_dump <db_name> | gzip > /var/lib/pgsql/11/backups/20210609/<db_name>_<env>_full_06092021.gz

## restore database
gunzip -c <db_name>_<env>_full_06092021.gz | psql -U postgres -d <db_name>

## backup specific schema
pg_dump <db_name> --schema <schema_name> | gzip > /var/lib/pgsql/11/backups/08182021/<schema_name>_<datetime>.gz

## copy schema data from one database to another
pg_dump <db1> --schema <schema_name> | psql -d <db2>

## backup a table
pg_dump -d <db_name> -t <schema_name>.<table_name> | gzip > /var/lib/pgsql/11/backups/<db_schema_table_name>_<datetime>.gz

