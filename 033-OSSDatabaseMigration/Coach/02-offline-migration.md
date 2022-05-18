# Challenge 2: Offline migration

[< Previous Challenge](./01-discovery.md) - **[Home](./README.md)** - [Next Challenge >](./03-offline-cutover-validation.md)

## Coach Tips

* When creating Azure DB for PostgreSQL/MySQL, create it in the GP or MO tier since the Basic tier does not support Private Link which is required in a future challenge. Note that Flexible Server does not currently support Private Link.

* If the attendees want to connect to Azure DB for PostgreSQL/MySQL from within the AKS PostgreSQL/MySQL database containers, they have two options.

     a)  Either under connection security, check the box for "Allow access to Azure services" 

                   or

    b) Add the public IP address of the container to the DB firewall.  This is the IP address the container is using for egress to connect to Azure DB. 
    In order to find that IP address, they can try to connect to the Azure DB from the container and the error message will tell them the IP address.  
    
### MySQL -- Important 
 
* Participants using Azure Cloud Shell and using the mysql client tool are using the MariaDB mysql client, not the one from Oracle.  To connect to your Azure MySQL database, you have to add the flag "--ssl" at the end. If they are running it on WSL/Ubuntu or Mac Terminal and using the Oracle MySQL client, the "--ssl" flag is not required.

```bash

 mysql -h <server-name>.mysql.database.azure.com -P 3306 -u contosoapp@<server-name> -pOCPHack8 --ssl            
 
 ```
 

```bash

kubectl -n mysql exec deploy/mysql -it -- bash

root@mysql-78cf679f8f-5f6xz:/# mysql -h <your-server>.mysql.database.azure.com -P 3306 -u <username>@<your-server> -p
....
Client with IP address '104.42.36.255' is not allowed to connect to this MySQL server.

```

Similarly for PostgreSQL

```bash
 kubectl -n postgresql exec deploy/postgres -it -- bash
root@postgres-64786b846-shnm9:/# psql -h <your-server>.postgres.database.azure.com -p 5432 -U <username>@<your-server> -d postgres
psql: FATAL:  no pg_hba.conf entry for host "104.42.36.255", user "serveradmin", database "postgres", SSL on

```

Another way to find the container egress IP address is to run this from the container.


```bash
apt update
apt install curl
curl ifconfig.me
```

* There are other 3rd party tools similar to MySQL Workbench, pgAdmin and dbeaver which the attendees may choose to migrate the data if they are familiar with them. There is also [mydumper/myloader](https://centminmod.com/mydumper.html) to use for MySQL.


* Before migrating the data, they need to create an empty database and create the application user. The SQL command to create the database is given below if they are using the CLI



```sql
create database wth ;
```

* After creating the database they need to create the database user "contosoapp" that will own the database objects. Connect using the dba account and then create the user and grant it privileges:

PostgreSQL Command -->

```sql
CREATE ROLE CONTOSOAPP WITH LOGIN NOSUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION PASSWORD 'OCPHack8';
```

alternatively, from bash use pg_dumpall binary:

```sh
pg_dumpall -r | psql -h pgtarget.postgres.database.azure.com -p 5432 -U serveradmin@pgtarget postgres
```

MySQL command --->

```sql

create user if not exists 'contosoapp'   identified by 'OCPHack8' ;

grant ALL PRIVILEGES ON wth.* TO contosoapp ;
grant process, select on *.*  to contosoapp ;

-- check privileges already granted

show grants for contosoapp ;

```


Grants for contosoapp should report


```sql
GRANT SELECT, PROCESS ON *.* TO 'contosoapp'@'%'
GRANT ALL PRIVILEGES ON `wth`.* TO 'contosoapp'@'%'
```


* The next step is to run a database export from the source database and import into Azure DB. 

**PostgreSQL Export Import Commands**

* PostgreSQL command to do offline export to exportdir directory and import offline to Azure DB for PostgreSQL. First bash into the PostgreSQL container and then use these two commands.

*Make sure to run the data import using the contosoapp database account*

```bash
 kubectl -n postgresql exec deploy/postgres -it -- bash
 su - postgres
 pg_dump wth | psql -h pgtarget.postgres.database.azure.com -p 5432 -U contosoapp@pgtarget wth
```

**MySQL Export Import Commands**

 Alternatively, do this from command prompt of the MySQL container

*Make sure to run the data import using the contosoapp database account*


 ```bash
 kubectl -n mysql exec deploy/mysql -it -- bash
 mysqldump -h localhost -u root -p --set-gtid-purged=off  --databases wth >dump_data.sql
 
 mysql  -h mytarget2.mysql.database.azure.com -P 3306 -u contosoapp@mytarget2 -pOCPHack8  <dump_data.sql
 ```
 
 It is possible to use the MySQL Workbench tool to run the export with proper settings. The MySQL Workbench version (8.0.23 as of Jan 2021) being different from MySQL version 5.7 is not a factor for this challenge. The MySQL export runs a series of exports for each table. If you do not want to see the warnings about `--set-gtid-purged`, use the flag  `--set-gtid-purged`.
 
 * For MySQL the database the import file may contain references to @@SESSION and @@GLOBAL that will need to be removed prior to importing.

Azure Database Migration Service supports migrating PostgreSQL to Azure Database for PostgreSQL and MySQL to Azure Database for MySQL. The service does not support Oracle migrations. Here is a link to the documentation with supported source and targets for both offline and online migration scenarios.  https://docs.microsoft.com/en-us/azure/dms/resource-scenario-status 

 
If the student would like to use Azure Data Factory (ADF) to move the data. Here is a link to the ADF documentation. The Copy Activity is the most direct way to use ADF. https://docs.microsoft.com/en-us/azure/data-factory/introduction 


* For Oracle, the students can use either ora2pg in the CLI or the Visualate Web UI which will generate the required SQL files for them in the web interface. It's definitely easier to use Visualate although in real life, it's more likely a DBA would use the ora2pg tool. In Visualate, the setting for "Type" should be set to Insert under Export. If they use the ora2pg CLI tool, they will need to get into the ora2pg container first using `kubectl exec`, configure the ora2pg.conf file and then run something like `/usr/local/bin/ora2pg -c /express/../project/default/config/ora2pg.conf`. Either way this will generate both the `insert.sql` and `table.sql` files. The students will then need to run these queries in Azure DB for PostgreSQL. They can load them into a container that has psql or use something like Azure Data Studio

