# Challenge 4: Online migration

[< Previous Challenge](./03-offline-cutover-validation.md) - **[Home](./README.md)** - [Next Challenge >](./05-online-cutover-validation.md)

## Coach Tips

The intent of this WTH is not to focus on networking so if the attendee has trouble configuring VPN/VNet peering, feel free to help them through it. 

## Introduction

Perform an online migration using the Azure Database Migration Service

## Steps -- PostgreSQL

Connect to the *source* database container and run the export on the source database :

```bash
kubectl -n postgresql exec deploy/postgres -it -- bash

pg_dump -o -h localhost -U contosoapp -d wth -s >dump_wth.sql
```

This creates a psql dump text file. We need to import it to the *target*. We import the schema only. It is suggested to create a separate database for online migration - wth2. 

Alternatively, you can drop all the tables and indices and re-create just the tables.

To drop all the tables with indexes, the following SQL script creates a file called drop_tables.sql which you can run in the next step to execute in SQL to drop the tables and indices. Then execute the drop_tables.sql script.

```bash

psql -h pgtarget.postgres.database.azure.com -U contosoapp@pgtarget -d wth 

\t
\out drop_tables.sql

select 'drop table ' || tablename || ' cascade;'  from pg_tables where tableowner = 'contosoapp' and schemaname = 'public' ;

\i drop_tables.sql

```

Another option to dropping and recreating all the tables is simply drop the database and re-create the database

```sql

drop database wth ;

create database wth ;

```

Next, import the schema to target

```bash
psql -h pgtarget.postgres.database.azure.com -U contosoapp@pgtarget -d wth < dump_wth.sql
```

Verify count of tables and indexes created on the target database from psql. 26 tables, 39 indices.

```bash
\dt+

\di+

```

[Disabling Foreign Keys in Azure DMS](https://docs.microsoft.com/en-us/azure/dms/tutorial-postgresql-azure-postgresql-online-portal) shows more results than needed. It can be simplified by saving the output of a SQL command that just drops the constraints. From psql, do this:

```bash
\t
\out drop_fk.sql
```

```sql

SELECT CONCAT('ALTER TABLE ', table_schema, '.', table_name, STRING_AGG(DISTINCT CONCAT(' DROP CONSTRAINT ', foreignkey), ','), ';') as DropQuery
FROM
    (SELECT
    S.table_schema,
    S.foreignkey,
    S.table_name,
    STRING_AGG(DISTINCT S.column_name, ',') AS column_name,
    S.foreign_table_schema,
    S.foreign_table_name,
    STRING_AGG(DISTINCT S.foreign_column_name, ',') AS foreign_column_name
FROM
    (SELECT DISTINCT
    tc.table_schema,
    tc.constraint_name AS foreignkey,
    tc.table_name,
    kcu.column_name,
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
    FROM information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = tc.table_schema
WHERE constraint_type = 'FOREIGN KEY'
    ) S
    GROUP BY S.table_schema, S.foreignkey, S.table_name, S.foreign_table_schema, S.foreign_table_name
    ) Q
    GROUP BY Q.table_schema, Q.table_name;

```

Edit the file drop_fk.sql to clean up to run as a SQL statement
Run the file:

```bash
\i  drop_fk.sql
```

There is no trigger in the application schema. It is still a best practice to check for it:

```sql
\t
\out drop_trigger.sql
SELECT DISTINCT CONCAT('ALTER TABLE ', event_object_schema, '.', event_object_table, ' DISABLE TRIGGER ', trigger_name, ';')
FROM information_schema.triggers
```

* For Azure DMS, the attendee needs to create a migration project in the DMS wizard. When they connect to the source, they will need the external IP which the attendee can get using the `kubectl -n postgresql get svc` command. 
* Make sure the radio buttons are checked for "Trust Server Certificate" and "Encrypt Connection"
* The user contosoapp does not have replication role enabled. They should get an error (Insufficient permission on server. 'userepl' permission is required to perform migration). To resolve this, connect to psql as superuser

```bash 
postgres=# alter role contosoapp with replication ;
```

* In DMS, if the attendee gets a connection error when trying to connect to the target service, check "Allow access to Azure Services" in the Azure Portal for the database. After migration, do a cutover and re-enable the foreign keys. Run the following on the source and run it on the target after cleaning the header:

```sql
\t
\out enable_fk.sql

SELECT CONCAT('ALTER TABLE ', table_schema, '.', table_name, STRING_AGG(DISTINCT CONCAT(' ADD CONSTRAINT ', foreignkey, ' FOREIGN KEY (', column_name, ')', ' REFERENCES ', foreign_table_schema, '.', foreign_table_name, '(', foreign_column_name, ')' ), ','), ';') as AddQuery
FROM
    (SELECT
    S.table_schema,
    S.foreignkey,
    S.table_name,
    STRING_AGG(DISTINCT S.column_name, ',') AS column_name,
    S.foreign_table_schema,
    S.foreign_table_name,
    STRING_AGG(DISTINCT S.foreign_column_name, ',') AS foreign_column_name
FROM
    (SELECT DISTINCT
    tc.table_schema,
    tc.constraint_name AS foreignkey,
    tc.table_name,
    kcu.column_name,
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
    FROM information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = tc.table_schema
WHERE constraint_type = 'FOREIGN KEY'
    ) S
    GROUP BY S.table_schema, S.foreignkey, S.table_name, S.foreign_table_schema, S.foreign_table_name
    ) Q
    GROUP BY Q.table_schema, Q.table_name;
```


## Steps -- MySQL

The MySQL data-in replication is initiated from Azure DB for MySQL and pulls data from on-premises. As such the source database's public IP address needs to be whitelisted. 

The database tier has to be standard or memory optimized for the replication to work.

The attendees have to login to MySQL with the user they created when they set up Azure DB for MySQL to setup the replication using the mysql.az_replication_change_master stored procedure. 

The values for master_log_file and master_log_pos need to be retrieved using `show master status` on the source server not on Azure DB for MySQL. 

The default gtid_mode in the source database is ON and in Azure DB for MySQL it is Off. Both sides have to match before starting replication.
Since the wth database used for the challenges is not seeing a lot of transactions, the attendees can follow the MySQL [documentation](https://dev.mysql.com/doc/refman/5.7/en/replication-mode-change-online-disable-gtids.html) to change the parameter without stopping replication.





