#1.
sudo apt update
Note: "-contrib" package that adds some additional utilities and functionality
sudo apt install postgresql postgresql-contrib
#2.
connect postgres through root.
-> find pg_hba.conf
SHOW hba_file;
-> "trust" connection by adding in pg_hba.conf file
local all postgres trust
-> reload hba.conf file.
SELECT pg_reload_conf();
