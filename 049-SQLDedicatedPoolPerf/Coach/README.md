# What The Hack - Synapse Dedicated SQL Pool - Performance Best Practices - Coach Guide

## Introduction
Welcome to the coach's guide for the SQL Dedicated Pool Performance What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

NOTE: If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Student Resources
Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

**NOTE:** Students should not be given a link to the What The Hack repo before or during a hack. The student guide does NOT have any links to the Coach's guide or the What The Hack repo on GitHub.

## Coach's Guides
- Challenge 01: **[Ingest Data From Blob Storage](./Solution-01.md)**
	 - In this challenge, attendees will import several parquet files from Blob Storage into their Dedicated SQL pool; 
- Challenge 02: **[Queries Best Practice](./Solution-02.md)**
	 - In this challenge, attendees will dig into best practices to consider writing a query for your data warehouse.
- Challenge 03: **[Queries Behavior](./Solution-03.md)**
	 - In this challenge, attendees will troubleshoot queries in stuck, not running queries and optimize query executions.
- Challenge 04: **[Partitioned Table And Clustered Columnstore Indexes](./Solution-04.md)**
	 - In this challenge, attendees will dig into the table partitioning strategy and its impact on performance. You will also get a deeper understanding of Columnstore Indexes behaviour
- Challenge 05: **[Monitoring Workload](./Solution-05.md)**
	 - In this challenge, attendees will understand how to monitor your workload to identify poor performing and failed queries

## Coach Prerequisites 
This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event.

These pre-reqs should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- Azure subscription with Owner access
- An already in-place [Dedicated SQL pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/create-data-warehouse-portal#:~:text=Create%20a%20SQL%20pool%201%20Select%20Create%20a,Notifications%20to%20monitor%20the%20deployment%20process.%20See%20More.). **Configure it using SLO = DW500c**
- Your choice of database management tool:
  - [SQL Server Management Studio (SSMS) (Windows)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
  - [Azure Data Studio (Windows, Mac OS, and Linux](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)

### How to prepare the Data-set

Before start the hack you need to create the dataset and make it available to all attendees.
It's a very time consuming steps so it's recommended to run it a couple of days before the hack.
Here the steps:
1. [Create a new Dedicated SQL pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/create-data-warehouse-portal)
   1. Choose **DW500c** as performance level [(SLO)](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits)
   2. Check the **"Additional settings"** tab and make sure you selected **"Sample"**
2. Once the Dedicated SQL pool is online, open your preferred query editor ([Sql Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15) or [Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)) and connect to your Dedicated SQL pool, then run all the T-SQL scripts available [here](./Solutions/Dataset%20-%20Scripts/) from 1 to 11. **Do not change the order**
   1. This step can take up to 9 hours to complete since we're generating consistend data and thousands of query will run against your Dedicated SQL pool
3. Create a valid [Data Lake Gen2 Storage Account](https://docs.microsoft.com/en-us/azure/storage/blobs/create-data-lake-storage-account)]
4. Create a new container and make it public, it will be used by attendees to ingest parquet files
5. Run [12_Export all - External Tables.sql](./Solutions/Dataset%20-%20Scripts/../Dataset%20-%20Scripts/12_Export%20all%20-%20External%20Tables.sql) and follow provided steps and instructions
6. Provide the path to your public container to attendees, they will use it to ingest parquet files.

