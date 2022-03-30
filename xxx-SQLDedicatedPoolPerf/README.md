# What The Hack - xxx-Synapse Dedicated SQL Pool - Performance best practices

## Introduction
This OpenHack enables attendees to understand best practices developing, maintaining, and optimizing performance for their Synapse Dedicated SQL Pool. This OpenHack simulates a real-world scenario where a cycle manufacturer company develops its new Datawarehouse leveraging Synapse Dedicated Sql pool. The goal is to apply all best practices to avoid performance bottlenecks during daily activities once in production. During the hack, attendees will focus on:

Database Design – Best Practices
- Query Design – Best practices and optimization
- Performance Troubleshooting
- Performance Monitoring

## Learning Objectives
By the end of the OpenHack, attendees will have a good understanding of:
- Tables architecture, database design and how to avoid data-skew
- T-SQL Best practice 
- Query performance troubleshooting
- Impact of table partitioning
- Monitor workload

## Challenges
1. Challenge 01: **[Ingest data from blob storage](Student/Challenge-01.md)**
	 - In this challenge, you will import several parquet files from your Blob Storage into your Datawarehouse; you will move data from the staging area to the production one.
	 - Learning objectives:
    	 - Get understanding about table architecture in Dedicated Sql Pool
        	 - Distributed
        	 - Round Robin
        	 - Replicated
    	 - How to identify Data Skew and how to fix it
2. Challenge 02: **[Queries best practice](Student/Challenge-02.md)**
	 - In this challenge, you will dig into best practices you have to consider when writing a query for your Datawarehouse.
	 - Learning objectives:
    	 - The importance of Statistics
    	 - How to Join distributed/replicated tables
    	 - Incompatible and compatible Join
1. Challenge 03: **[Queries behavior](Student/Challenge-03.md)**
	 - In this challenge, you will troubleshoot queries in stuck, not running queries and optimize query executions.
	 - Learning objectives:
    	 - Understand locking behaviour
    	 - Understand concurrency behaviour
      	 - Optimize query with the 
        	 - result set caching
        	 -  materialized views  
1. Challenge 04: **[Partitioned table and Clustered Columnstore Indexes](Student/Challenge-04.md)**
	 - In this challenge, you will dig into the table partitioning strategy and its impact on performance. You will also get a deeper understanding of Columnstore Indexes behaviour
	 - Learning objectives:
    	 - How partitioning affects performance
    	 - Columnstore Indexes health
1. Challenge 05: **[Monitoring workload](Student/Challenge-05.md)**
	 - In this challenge, you will understand how to monitor your workload to identify poor performing and failed queries
	 - Learning objectives:
    	 - How to monitor workload with T-SQL DMVs
    	 - Store and query historical data using Azure Monitor
2. Challenge 06: **[Description of challenge](Student/Challenge-06.md)**
	 - Description of challenge
1. Challenge 07: **[Description of challenge](Student/Challenge-07.md)**
	 - Description of challenge

## Prerequisites
- Your own Azure subscription with Owner access
- Your choice of database management tool:
  - SQL Server Management Studio (SSMS) (Windows)
  - Azure Data Studio (Windows, Mac OS, and Linux


## Repository Contents (Optional)
- `./Coach/Guides`
  - Coach's Guide and related files
- `./SteamShovel`
  - Image files and code for steam shovel microservice
- `./images`
  - Generic image files needed
- `./Student/Guides`
  - Student's Challenge Guide

## Contributors
- Luca Ferrari
