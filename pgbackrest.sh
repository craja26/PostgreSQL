## Installation:
# connect as a root
yum install pgbackrest --nogpgcheck
mkdir -p /var/log/pgbackrest
chown postgres:postgres /var/log/pgbackrest
mkdir /etc/pgbackrest
bash -c 'cat << EOF > /etc/pgbackrest/pgbackrest.conf
[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2
 
[pg0app]
pg1-path=/var/lib/pgsql/11/data
pg1-port=5432
EOF'

chown postgres:postgres /etc/pgbackrest/pgbackrest.conf

# create backup directory and grant permissions for backup directory
mkdir /var/lib/pgbackrest
chmod 750 /var/lib/pgbackrest
chown -R postgres:postgres /var/lib/pgbackrest/

# Update postgres conf file for archiving.
archive_mode = on
archive_command = 'pgbackrest --stanza=pg0app archive-push %p'
# Restart postgres
systemctl restart postgresql-11

# create the Stanza
su - postgres
pgbackrest stanza-create --stanza=pg0app --log-level-console=info 

# check the configurations
su - postgres
pgbackrest --stanza=pg0app --log-level-console=info check

# Perform a Backup
# By default pgBackRest will attemp to perform an incremental backup. However, an incremental backup must be based on a full backup and 
# since no full backup existed pgBackRest ran a full backup instead.
pgbackrest backup --type=full --stanza=pg0app --log-level-console=info 


# information about the backup
pgbackrest --stanza=pg0app --set=20210801-033002F_20210801-123001I info  

# restore database required data folder to be empty.
# here is the command to restore database without delete files in data folder
pgbackrest --stanza=pg0app --delta --log-level-console=detail restore --type=immediate --target-action=promote --set=20210801-033002F_20210801-123001I

# restore command.
pgbackrest --stanza=pg0app --delta --log-level-console=detail restore --type=immediate --target-action=promote --set=20210801-033002F

