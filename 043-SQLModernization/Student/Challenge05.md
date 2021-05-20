# Challenge 5 - High Availability & Disaster Recovery

[< Previous Challenge](./Challenge04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge06.md)

## Introduction 
Your company has databases running on Azure SQL database and Azure SQL Managed instance. AdventureWorks and Wide World Importers (OLTP). The Recovery Time Objective (RTO) for these two databases are 5 minutes. The Recovery Pont Objective (RPO) is 5 minutes. Your fledgling company disaster recovery site is on different region with the primary Azure region. 

## Description
When disaster happens on the primary region, business requires the databases automatically failover to the disaster recovery region. Your company needs to use the readable secondary databases to offload read-only query workloads. After failover, your application can continue connect to the database by using the same connection string.

## Success Criteria
Meet Your company RTO and RPO. You can connect to the secondary database after it fails over to Disaster recovery site by using the same users or logins. 

## Learning Resources
Use auto-failover groups to enable transparent and coordinated failover of multiple databases 

https://docs.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell

Configure failover group  

https://docs.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-configure?tabs=azure-portal

Configure active geo-replication and failover in the Azure portal (Azure SQL Database) 

https://docs.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-configure-portal

Overview of business continuity with Azure SQL Database

https://docs.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview

High availability for Azure SQL Database and SQL Managed Instance

https://docs.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla

## Tips
Best practices for SQL Managed Instance

https://docs.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell#best-practices-for-sql-managed-instance

Best practices for SQL Database 

https://docs.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell#best-practices-for-sql-database

## Advanced Challenges (Optional)

User accidentally deleted a row in a table, you need recovery the row. 

Temporal tables

https://docs.microsoft.com/en-us/azure/azure-sql/temporal-tables

Recover using automated database backups - Azure SQL Database & SQL Managed Instance

https://docs.microsoft.com/en-us/azure/azure-sql/database/recovery-using-backups#deleted-database-restore


