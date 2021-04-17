# Challenge 5: Online migration

[< Previous Challenge](./04-offline-cutover-validation.md) - **[Home](./README.md)** - [Next Challenge >](./06-online-cutover-validation.md)

## Coach Tips

The intent of this WTH is not to focus on networking so if the attendee has trouble configuring VPN/VNET peering, feel free to help them through it. 

## Introduction

Perform an online migration using the Azure Database Migration Service

## Steps -- PostgreSQL

Connect to the database container and run the export:

```bash
kubectl -n postgresql exec deploy/postgres -it -- bash

pg_dump -o -h localhost -U contosoapp -d wth -s >dump_wth.sql
```

This creates a psql dump text file. We need to import it to the target - schema only. It is suggested to create a separate database for online migration. Alternatively, you can drop and re-create the wth database.

To drop all the tables with indexes

```bash
\out drop_tables.sql

select 'drop table ' || tablename || ' cascade;'  from pg_tables where tableowner = 'contosoapp' and schemaname = 'public' ;
```

To import the schema only to target using psql

```bash
$ psql -h pgtarget.postgres.database.azure.com -p 5432 -U contosoapp@pgtarget  -d wth <dump_wth.sql

postgres=> create database wth
```

Import the schema to target

```bash
psql -h pgtarget.postgres.database.azure.com -U contosoapp@pgtarget -d wth2 < dump_wth.sql
```

Verify count of tables and indexes created on the target database from psql. 26 tables, 39 indices.

```bash
\dt+

\di+

```

[Disabling Foreign Keys in Azure DMS](https://docs.microsoft.com/en-us/azure/dms/tutorial-postgresql-azure-postgresql-online-portal) shows more results than needed. It can be simplified by saving the output of a SQL command that just drops the constraints. From psql, do this:

```bash
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

Run the export:

```bash

 mysqldump -h <container ip> -u contosoapp -p --set-gtid-purged=off --databases wth --no-data  --skip-column-statistics >dump_nodata.sql

```

Import with no data. Create the wth database:

```bash

mysql -h mytarget2.mysql.database.azure.com -u contosoapp@mytarget2 -p wth <dump_nodata.sql

```

Run script on the target to drop all the foreign keys:

```bash
drop_fk_query.sql
```

```sql
 SET group_concat_max_len = 8192;
 SELECT GROUP_CONCAT(DropQuery SEPARATOR ';\n') as DropQuery
    FROM
    (SELECT
            KCU.REFERENCED_TABLE_SCHEMA as SchemaName,
            KCU.TABLE_NAME,
            KCU.COLUMN_NAME,
            CONCAT('ALTER TABLE ', KCU.TABLE_NAME, ' DROP FOREIGN KEY ', KCU.CONSTRAINT_NAME) AS DropQuery
            FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU, information_schema.REFERENTIAL_CONSTRAINTS RC
            WHERE
              KCU.CONSTRAINT_NAME = RC.CONSTRAINT_NAME
              AND KCU.REFERENCED_TABLE_SCHEMA = RC.UNIQUE_CONSTRAINT_SCHEMA
          AND KCU.REFERENCED_TABLE_SCHEMA = 'wth') Queries
  GROUP BY SchemaName

```

  Run the script and store the output to a file. Running this the following way requires to format the file again:

```bash

 mysql -h mytarget2.mysql.database.azure.com -u contosoapp@mytarget2 -pOCPHack8 wth <drop_fk_query.sql >drop_fk.sql
 cat drop_fk.sql | sed 's/\\n/\n/g' | sed '/DropQuery/d' >drop.sql

 ```
 Run the sql script to drop all the FKs:

 ```sql

 source drop.sql

 ```

 Grant replication client and save to contosoapp user for DMS online migration:

 ```sql

  grant replication slave on *.* to 'contosoapp' ;
  grant replication client on *.* to 'contosoapp' ;

 ```

 If the copy fails during the DMS online copy with an error message like "Migrating data to a mysql other than Azure DB for MySQL is not supported", it is because the user connecting to the target database does not have enough privileges on MySQL. The exact minimum set of privileges is TBD but this works as a workaround. This screenshot from MySQL Workbench shows the privileges that are required:
 
 ![MySQL Workbench Privileges](./workbench.png)

