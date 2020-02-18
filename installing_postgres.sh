Installing PostgreSQL:
----------------------
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


#3. Moving the PostgreSQL Data Directory.
-> find data directory.
SHOW data_directory;
 data_directory
-----------------------------
 /var/lib/postgresql/10/main


-> stop postgres service
sudo systemctl stop postgresql

-> check status
sudo systemctl status postgresql

->Copy existing data directory to new directory
Note: -a flag preserves permissions and other directoy properties, -v provides verbose output

-> copying files and permissions to new location.
sudo rsync -av /var/lib/postgresql /<new mount pint directory>
Exapmle: sudo rsync -av /var/lib/postgresql /data

-> rename current folder with ".bak" extension
sudo mv /var/lib/postgresql/10/main /var/lib/postgresql/10/main.bak

-> Pointing to the New Data Location
Edit config file
vim /etc/postgresql/10/main/postgresql.conf

change data directory.
data_directory = '/data/postgresql/10/main'
save and start postgresql services.

service postgresql start
service postgresql status


------------------ Cron Scheduler ----------------
find / -name *cron*
-> check schedule
crontab -l

-> edit schedule
crontab -e

Example:
***** echo "Testing..!!" >> /temp/testfile



