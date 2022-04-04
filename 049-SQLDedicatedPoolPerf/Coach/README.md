# What The Hack - Dedicated SQL Pool performance best practices - Coach Guide

## Introduction
This "What the Hack" enables attendees to understand best practices developing, maintaining, and optimizing performance for their Synapse Dedicated SQL Pool. This hack simulates a real-world scenario where a cycle manufacturer company develops its new Datawarehouse leveraging Synapse Dedicated Sql pool. The goal is to apply all best practices to avoid performance bottlenecks during daily activities once in production. During the hack, attendees will focus on:

Database Design – Best Practices
- Query Design – Best practices and optimization
- Performance Troubleshooting
- Performance Monitoring

## How to prepare the Data-set

Before start the fasthack you need to create the dataset and make it available to all attendees.
It's a very time consuming steps so it's recommended to run it a couple of days before the fasthack.
Here the steps:
1. [Create a new Dedicated SQL pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/create-data-warehouse-portal)
   1. Choose **DW500c** as performance level
   2. Check the **"Additional settings"** tab and make sure you selected **"Sample"**
2. Once the Dedicated SQL pool is online, open your preferred query editor ([Sql Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15) or [Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)) and connect to your Dedicated SQL pool, then run all the T-SQL scripts available [here](./Dataset%20-%20Scripts/) from 1 to 11. **Do not change the order**
   1. Scripts [8_FactInternetSales.sql](./Dataset%20-%20Scripts/../Dataset%20-%20Scripts/8_FactInternetSales.sql) and [9_FactResellersSales.sql](./Dataset%20-%20Scripts/../Dataset%20-%20Scripts/9_FactResellersSales.sql) can run at the same time
   2. This step can take up 8 hour to complete since we're generating consistend data and thousands of query will run against your Dedicated SQL pool
3. Create a valid [Data Lake Gen2 Storage Account(https://docs.microsoft.com/en-us/azure/storage/blobs/create-data-lake-storage-account)]
4. Create a new container and make it public, it will be used by attendees to ingest parquet files
5. Run [12_Export all - External Tables.sql](./Dataset%20-%20Scripts/../Dataset%20-%20Scripts/12_Export%20all%20-%20External%20Tables.sql) and follow provided steps and instructions
6. Provide the path to your public container to attendees, they will use it to ingest parquet files.




## Coach's Guides
1. Challenge 01: **[Ingest data from blob storage](./Solution-01.md)**
	 - In this challenge, attendees will import several parquet files from Blob Storage into their Dedicated SQL pool; 
	 - Learning objectives:
    	 - Get understanding about table architecture in Dedicated Sql Pool 
    	 - Distributed
    	 - Round Robin
    	 - Replicated 123
  	 - How to identify Data Skew and how to fix it
1. Challenge 02: **[Queries best practice](./Solution-02.md)**
	 - In this challenge, attendees will dig into best practices to consider writing a query for your Datawarehouse.
	 - Learning objectives:
    	 - The importance of Statistics
    	 - How to Join distributed/replicated tables
    	 - Incompatible and compatible Join
1. Challenge 03: **[Queries behavior](./Solution-03.md)**
	 - In this challenge, attendees will troubleshoot queries in stuck, not running queries and optimize query executions.
	 - Learning objectives:
    	 - Understand locking behaviour
    	 - Understand concurrency behaviour
    	 - Optimize query with the result set caching and materialized views  
1. Challenge 04: **[Partitioned table and Clustered Columnstore Indexes](./Solution-04.md)**
	 - In this challenge, attendees will dig into the table partitioning strategy and its impact on performance. You will also get a deeper understanding of Columnstore Indexes behaviour
	 - Learning objectives:
    	 - How partitioning affects performance
    	 - Columnstore Indexes health
1. Challenge 05: **[Monitoring workload](./Solution-05.md)**
	 - In this challenge, attendees will understand how to monitor your workload to identify poor performing and failed queries
	 - Learning objectives:
	 - How to monitor workload with T-SQL DMVs
	 - Store and query historical data using Azure Monitor
1. Challenge 06: **[Description of challenge](./Solution-06.md)**
	 - Description of challenge
1. Challenge 07: **[Description of challenge](./Solution-07.md)**
	 - Description of challenge


## Prerequisites
- Your own Azure subscription with Owner access
- Your choice of database management tool:
  - [SQL Server Management Studio (SSMS) (Windows)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
  - [Azure Data Studio (Windows, Mac OS, and Linux](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)