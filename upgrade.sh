# Example: upgrade postgresql from version 13 to 14

# Step-1: Backup all the database or take vm snapshot

# Step-2: Install postgresql-14 and initiate db (but don't start it)
yum install postgresql14-server

# Step-3: Stop postgresql
systemctl stop postgresql-13

# Step-4: Check the upgrade
/usr/pgsql-14/bin/pg_upgrade \
--old-datadir=/var/lib/pgsql/13/data \
--new-datadir=/var/lib/pgsql/14/data \
--old-bindir=/usr/pgsql-13/bin \
--new-bindir=/usr/pgsql-14/bin \
--old-options '-c config_file=/var/lib/pgsql/14/data/postgresql.conf' \
--new-options '-c config_file=/var/lib/pgsql/14/data/postgresql.conf' \
--check

Note: upgrade should pass all the check.

# Step-5: Run upgrade
/usr/pgsql-14/bin/pg_upgrade \
--old-datadir=/var/lib/pgsql/13/data \
--new-datadir=/var/lib/pgsql/14/data \
--old-bindir=/usr/pgsql-13/bin \
--new-bindir=/usr/pgsql-14/bin \
--old-options '-c config_file=/var/lib/pgsql/14/data/postgresql.conf' \
--new-options '-c config_file=/var/lib/pgsql/14/data/postgresql.conf' \

# Step-6: Compare and update postgresql-14 postgresql.config file and pg_hba.conf file with postgresql-13 version

# Step-7: Enable and Start postgresql-14
systemctl enable postgresql-14
systemctl start postgresql-14

# Step-8: run vacuumdb script. You find this command end of pg_upgrade log(# Step-5)
/usr/pgsql-14/bin/vacuumdb --all --analyze-in-stages

# Step-9: Check the application team. If application is passed QA, then run the below delete cluster file. You can find this end of pg_upgrade log
./delete_old_cluster.sh

Note: We can also use -k parameter to symbolic the physical files instead exporting data.
