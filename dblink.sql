# as postgres user 

CREATE EXTENSION dblink; 

CREATE SERVER <Remote Server> FOREIGN DATA WRAPPER dblink_fdw OPTIONS (host '<Remote Server fully qualified name or ip>', dbname '<db_name>', port '5432'); 
CREATE USER MAPPING FOR <Local User> SERVER <Remote Server> OPTIONS(user '<remote user>',password '<pwd>'); 
GRANT USAGE ON FOREIGN SERVER <Remote Server> TO <Local User>;  

# as local user 
SELECT dblink_connect('conn_db_link','<Remote Server>'); 

# testing
SELECT * from dblink('conn_db_link','select * from public.table_name limit 10')
