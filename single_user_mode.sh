/*******************/
We need to connect postgresql instance in single user mode when anyone of the postgresql database was down and not accepting any connection.

Step-1: Stop postgresql services.
    # systemctl stop postgresql-12.service
Step-2: Switch user to postgres
    # su - postgres
Step-3: connect postgres instance in single user mode.
    $ /usr/pgsql-12/bin/postgres --single -D /var/lib/pgsql/12/data database_name
        ## here "/var/lib/pgsql/12/data" is data directory
        ## once connect server in single user mode, we can see command prompt like "backend>"
Step-4: run vacuum full command
    backend> vacuum full;
    backend>
Step-5: Exit
    press ctrl+d to exit single user mode.
    # repeat this process for all corrupted instances.
Step-6: start postgres services
    # systemctl start postgresql-12.service

While trying to run postgres in single user mode, we may find error like "bash: postgres: command not found...". In this case you have to find binary for postgres. 
Here is command to find binary.
    # find /usr -iname 'postgres'
    
    (or)
    
you can export the path in "bash"
first open the bashrc with this command: # nano ~/.bashrc
add this line in the end: PATH="/usr/lib/postgresql/10/bin/:$PATH"
run this command. # source ~/.bashrc
the just use # postgres --single -D /usr/local/pgsql/data other-options my_database
    

