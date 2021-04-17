# Challenge 3: Offline migration of database

[< Previous Challenge](./02-size-analysis.md) - **[Home](../README.md)** - [Next Challenge >](./04-offline-cutover-validation.md)

## Introduction

Create an appropriate PaaS database service based on previous challenge in Azure and copy the Pizzeria application data to Azure. 
You are not required to reconfigure the application to Azure DB for PostgreSQL/MySQL in this challenge as you will do that in the next one. 

## Description

In the offline migration approach, your application can tolerate some downtime to move to Azure. You can assume that the application is down and no changes are being made to the database. Once you create your "target" Azure PaaS database service, keep in mind that being a PaaS it may not be fully customizable - and that is ok, as long as you can point the application to Azure database later and it performs. You will need to take into account the size analysis you performed in Challenge 2 and choose the appropriate database server tier and deployment option. **Do not use the Basic tier. It does not support features that are required in later challenges like replication and private endpoints.**

## Success Criteria

* You have chosen the proper PaaS database service at an appropriate service tier based on sizing analysis
* Demonstrate to your coach that the "on-premises" Pizzeria application data has migrated successfully to Azure

## Hints

* You can do the import/export from within the containers for PostgreSQL and MySQL that you created in the prereqs. Alternatively, if the database copy tools are installed on your machine, you can connect to the database from your computer as well. 
* You can install the editor of your choice in the container (e.g.`apt update` and `apt install vim`) in case you need to make changes to the MySQL dump file
* For both MySQL and PostgreSQL, you can use Azure Data Factory to copy the data.
* You are free to choose other 3rd party tools like MySQLWorkbench, dbeaver for this challenge

## References
* [Migrate your PostgreSQL database using export and import](https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-using-export-and-import)
* [Migrate your MySQL database to Azure Database for MySQL using dump and restore](https://docs.microsoft.com/en-us/azure/mysql/concepts-migrate-dump-restore)
* [Create an Azure Database for MySQL server](https://docs.microsoft.com/en-us/azure/mysql/quickstart-create-mysql-server-database-using-azure-portal)
* [Create an Azure Database for PostgreSQL server](https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-server-database-portal)
* [Firewall rules in Azure Database for PostgreSQL - Single Server](https://docs.microsoft.com/en-us/azure/postgresql/concepts-firewall-rules)
* [Firewall rules in Azure Database for MySQL](https://docs.microsoft.com/en-us/azure/mysql/concepts-firewall-rules)
* [Copy using Azure Data Factory for PostgreSQL](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-database-for-postgresql)
* [Copy using Azure Data Factory for MySQL](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-database-for-mysql)
 
