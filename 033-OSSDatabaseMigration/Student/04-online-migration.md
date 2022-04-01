# Challenge 4: Online migration

[< Previous Challenge](./03-offline-cutover-validation.md) - **[Home](../README.md)** - [Next Challenge >](./05-online-cutover-validation.md)

## Introduction

Perform an online migration using the Azure Database Migration Service

## Description
In this challenge you will do a migration of the database by setting up a replication from the on-premises database to Azure DB.

For PostgreSQL, you will use Azure Data Migration Serice Tool to do this. 
For MySQL, you will not use Azure DMS and will use MySQL replication instead.
Note: Online migration from Oracle to Azure DB for PostgreSQL is not supported.

In an actual production environment on-premises, you would need to have connectivity to your source databases to Azure using either a Site To Site VPN or Azure ExpressRoute. To simplify the DMS experience, you can choose to deploy Azure DMS in the same VNet as the on-premises PostgreSQL database and the private IP address of the database container(s). Alternatively, you can create a separate virtual network for Azure DMS and then establish a VNet peering to the source databases' VNet. 

To simplify MySQL data-in replication, you can use the public IP of the MySQL database container. 

## Success Criteria

* Demonstrate that all tables have been migrated successfully to Azure DB for PostgreSQL/MySQL 

## Hints -- PostgreSQL

* Use the Premium version of the Azure Database Migration Service for migrating PostgreSQL.
* Put the Azure Database Migration Service in its own subnet inside the same VNet that "on-prem" AKS uses: "OSSDBMigrationNet". This way it can connect to the source database using the database container(s) private IP address.
* To find out the private IP address for the PostgreSQL running in the database container:

```bash

kubectl describe service -n postgresql postgres-external | grep Endpoints

```

* You may have to drop open database connections if you are coming from a prior challenge where you ran the application. Alternatively, you could uninstall the web application(s) using helm, drop the database(s) and redeploy the application using helm. 

## Hints -- MySQL


* For MySQL, use data-in [replication](https://docs.microsoft.com/en-us/azure/mysql/concepts-data-in-replication)
* This is a "pull" replication where Azure DB for MySQL connects to the source to copy data
* Use the public IP address for Azure DB for MySQL for the replication
* "GTID Mode" parameters have 4 possible values and can only be changed from one to its adjacent value on either side (OFF <---> OFF_PERMISSIVE <---> ON_PERMISSIVE <--> ON)
* "GTID Mode" - it is easier to change on the source side to match with Azure DB for MySQL
* SSL is not required for this hackathon for the data-in replication
* To find out the private IP address for the MySQL running in the database container:


```bash

kubectl describe service -n mysql  mysql-external | grep Endpoints

```


## References

* [Minimal-downtime migration to Azure Database for PostgreSQL - Single Server](https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-online)
* [Migrate PostgreSQL to Azure DB for PostgreSQL online using DMS via the Azure Portal](https://docs.microsoft.com/en-us/azure/dms/tutorial-postgresql-azure-postgresql-online-portal)
* [Migrate PostgreSQL to Azure DB for PostgreSQL online using DMS via the Azure CLI](https://docs.microsoft.com/en-us/azure/dms/tutorial-postgresql-azure-postgresql-online)
* [Create, change, or delete a virtual network peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering)   
* [Add a subnet to a Virtual Network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-subnet#add-a-subnet)
* [Configure Azure MySQL data-in replication](https://docs.microsoft.com/en-us/azure/mysql/howto-data-in-replication)



