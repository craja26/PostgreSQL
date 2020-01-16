# connect to postgresql
psql -Upostgres

#list databases
\list

#connect to a database
\c <db-name>

#list tables
\dt

#exit from postgresql
\q


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

