# Challenge 3: Offline migration

[< Previous Challenge](./02-size-analysis.md) - **[Home](../README.md)** - [Next Challenge >](./04-offline-cutover-validation.md)

## Introduction
Dump the on-premises databases, create Azure databases for PostgreSQL/MySQL and restore the on-premises databases 

## Description
In this challenge you will dump the on-premises databases, create Azure database servers for PostgreSQL/MySQL, create the WTH database in Azure DB for PostgreSQL/MySQL and restore the databases. Once you've exported your existing database to a sql script file, you will create your Azure DB server for PostgreSQL/MySQL and then import the data. You will need to take into account the size analysis you performed in Challenge 2 and choose the appropriate database server tier and deployment option. 

Hints: 
* You can do the import/export from within the containers for PostgreSQL and MySQL that you created in the prereqs. 
* Azure DB for PostgreSQL has a default database called "postgres". You won't use it except to initially connect with psql so you can create the wth database. 
* Your MySQL database script file may contain references to @@SESSION and @@GLOBAL that will need to be removed prior to importing. You can install the editor of your choice in the container (e.g.'apt update' and 'apt install vim')

## Success Criteria

1. You have a copy of the on-premises databases running in Azure DB for PostgreSQL/MySQL
1. Demonstrate to your proctor that the data has migrated successfully

## References
* Migrate your PostgreSQL database using export and import: https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-using-export-and-import
* Migrate your MySQL database to Azure Database for MySQL using dump and restore: https://docs.microsoft.com/en-us/azure/mysql/concepts-migrate-dump-restore
* Create an Azure Database for MySQL server: https://docs.microsoft.com/en-us/azure/mysql/quickstart-create-mysql-server-database-using-azure-portal
* Create an Azure Database for PostgreSQL server: https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-server-database-portal
* Firewall rules in Azure Database for PostgreSQL - Single Server: https://docs.microsoft.com/en-us/azure/postgresql/concepts-firewall-rules 
* Firewall rules in Azure Database for MySQL: https://docs.microsoft.com/en-us/azure/mysql/concepts-firewall-rules 
