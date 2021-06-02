# Challenge 5 - High Availability & Disaster Recovery

[< Previous Challenge](./Challenge04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge06.md)

## Introduction

One of the big benefits of running in the cloud is the ability to deploy resources to many locations based on business need. With your company having performed several migrations, it's time to look at implementing some high availability and disaster recovery.

## Description

AdventureWorks and WWI (OLTP) would like to implement a BCDR plan so the company can meet an RPO/RTO of 5 minutes (RPO is the Recovery Point Objective and RTO is the Recovery Time Objective).

When disaster happens on the primary region, business requires the databases automatically failover to the disaster recovery region. Your company needs to use the readable secondary databases to offload read-only query workloads. After failover, your application can continue connect to the database by using the same connection string.

AdventureWorks has asked about the possibility of recovering data accidentally deleted. If time permits, your team can investigate how Temporal Tables can be configured to help recover lost data.

## Success Criteria

* Meet your company's RPO/RTO goals on either AdventureWorks or WWI. 

## Tips

* [Best practices for SQL Managed Instance](https://docs.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell#best-practices-for-sql-managed-instance)
* [Best practices for SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell#best-practices-for-sql-database)
* [Temporal tables](https://docs.microsoft.com/en-us/azure/azure-sql/temporal-tables)
* [Recover using automated database backups - Azure SQL Database & SQL Managed Instance](https://docs.microsoft.com/en-us/azure/azure-sql/database/recovery-using-backups#deleted-database-restore)

## Advanced Challenges (Optional)

* Develop a POC demonstrating how Temporal Tables can recover data when a user accidentaly deletes rows.

## Learning Resources

* [Use auto-failover groups to enable transparent and coordinated failover of multiple databases](https://docs.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell)
* [Configure failover group](https://docs.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-configure?tabs=azure-portal)
* [Configure active geo-replication and failover in the Azure portal (Azure SQL Database)](https://docs.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-configure-portal)
* [Overview of business continuity with Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview)
* [High availability for Azure SQL Database and SQL Managed Instance](https://docs.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla)
