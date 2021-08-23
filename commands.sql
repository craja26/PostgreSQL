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
CREATE EXTENSION pgstattuple WITH schema reporting;

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


