# What The Hack - Synapse Dedicated SQL Pool - Performance Best Practices

## Introduction
This "What the Hack" enables attendees to understand best practices developing, maintaining, and optimizing performance for their Synapse Dedicated SQL Pool. It simulates a real-world scenario where a cycle manufacturer company develops its new data warehouse leveraging Synapse Dedicated Sql pool. The goal is to apply all best practices to avoid performance bottlenecks during day by day activities. 

During the hack, attendees will focus on:
- Database Design – Best Practices
- Query Design – Best practices and optimization
- Performance Troubleshooting
- Performance Monitoring

## Learning Objectives
By the end of the "Synapse Dedicated SQL Pool - Performance Best Practices", attendees will have a good understanding of:
- Tables architecture, database design and how to avoid data-skew
- T-SQL Best practice 
- Query performance troubleshooting
- Impact of table partitioning
- Monitor workload

## Challenges
- Challenge 01: **[Ingest Data From Blob Storage](Student/Challenge-01.md)**
	 - In this challenge, you will import several parquet files from your Blob Storage into your data warehouse; you will move data from the staging area to the production one.
- Challenge 02: **[Queries Best Practice](Student/Challenge-02.md)**
	 - In this challenge, you will dig into best practices you have to consider when writing a query for your data warehouse.
- Challenge 03: **[Queries Behavior](Student/Challenge-03.md)**
	 - In this challenge, you will troubleshoot queries in stuck, not running queries and optimize query executions.
- Challenge 04: **[Partitioned Table And Clustered Columnstore Indexes](Student/Challenge-04.md)**
	 - In this challenge, you will dig into the table partitioning strategy and its impact on performance. You will also get a deeper understanding of Columnstore Indexes behaviour
- Challenge 05: **[Monitoring Workload](Student/Challenge-05.md)**
	 - In this challenge, you will understand how to monitor your workload to identify poor performing and failed queries


## Prerequisites
- Your own Azure subscription with Owner access
- An already in-place [Dedicated SQL pool](file:///C:/Users/lferrari/OneDrive%20-%20Microsoft/Desktop/FastHack%20Dedicated%20Pool%20-%20Performance/WhatTheHack/Setup.md). **Configure it using SLO = DW500c**
- Your choice of database management tool:
  - [SQL Server Management Studio (SSMS) (Windows)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
  - [Azure Data Studio (Windows, Mac OS, and Linux](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)


## Contributors
- Luca Ferrari
