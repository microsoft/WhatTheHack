# Challenge 5: Online migration

[< Previous Challenge](./04-offline-cutover-validation.md) - **[Home](../README.md)** - [Next Challenge >](./06-online-cutover-validation.md)

## Introduction

Perform an online migration using the Azure Database Migration Service

## Description
In this challenge you will do a schema only dump of the on-premises databases, create Azure database servers for PostgreSQL/MySQL (if required), create the WTH database in Azure DB for PostgreSQL/MySQL(if required), deploy an instance of the Azure Database Migration Service and setup continuous sync to the Azure DB for Postgres/MySQL databases. In an actual production environment on-premises, you would need to have connectivity to your source databases to Azure using either a Site To Site VPN or Azure ExpressRoute. It's suggested to use VNet Peering but it's your choice. 

Hints:
* Use the Premium version of the Azure Database Migration Service
* Put the Database Migration Service in its own virtual network
* You may have to drop open database connections if you are coming from a prior challenge where you ran the application. Alternatively, you could uninstall the web application(s) using helm, drop the database(s) and redeploy the application using helm. 


## Success Criteria

1. 

## References

* Minimal-downtime migration to Azure Database for PostgreSQL - Single Server: https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-online 
* Migrate PostgreSQL to Azure DB for PostgreSQL online using DMS via the Azure Portal: https://docs.microsoft.com/en-us/azure/dms/tutorial-postgresql-azure-postgresql-online-portal
* Migrate PostgreSQL to Azure DB for PostgreSQL online using DMS via the Azure CLI: https://docs.microsoft.com/en-us/azure/dms/tutorial-postgresql-azure-postgresql-online 
* Create, change, or delete a virtual network peering: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering
* Drop open database connections for Postgres: https://dba.stackexchange.com/questions/11893/force-drop-db-while-others-may-be-connected
* Setup SSL for PostgreSQL: https://www.postgresql.org/docs/9.1/ssl-tcp.html


