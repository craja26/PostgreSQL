## backup database
pg_dump <db_name> | gzip > /var/lib/pgsql/11/backups/20210609/<db_name>_<env>_full_06092021.gz

## restore database
gunzip -c <db_name>_<env>_full_06092021.gz | psql -U postgres -d <db_name>

