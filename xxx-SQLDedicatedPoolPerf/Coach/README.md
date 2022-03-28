# What The Hack - Dedicated SQL Pool performance best practices - Coach Guide

## Introduction
Welcome to the coach's guide for the "Dedicated SQL Pool performance best practices - What The Hack". Here you will find links to specific guidance for coaches for each of the challenges.

Also remember that this hack includes a optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

## How to prepare the Data set



## Coach's Guides
1. Challenge 01: **[Ingest data from blob storage](./Solution-01.md)**
	 - In this challenge, you will import several parquet files from your Blob Storage into your Datawarehouse; you will move data from the staging area to the production one. 
	 - Learning objectives:
    	 - Get understanding about table architecture in Dedicated Sql Pool 
    	 - Distributed
    	 - Round Robin
    	 - Replicated
  	 - How to identify Data Skew and how to fix it
1. Challenge 02: **[Queries best practice](./Solution-02.md)**
	 - In this challenge, you will dig into best practices to consider writing a query for your Datawarehouse.
	 - Learning objectives:
    	 - The importance of Statistics
    	 - How to Join distributed/replicated tables
    	 - Incompatible and compatible Join
1. Challenge 03: **[Queries behavior](./Solution-03.md)**
	 - In this challenge, you will troubleshoot queries in stuck, not running queries and optimize query executions.
	 - Learning objectives:
    	 - Understand locking behaviour
    	 - Understand concurrency behaviour
    	 - Optimize query with the result set caching and materialized views  
1. Challenge 04: **[Partitioned table and Clustered Columnstore Indexes](./Solution-04.md)**
	 - In this challenge, you will dig into the table partitioning strategy and its impact on performance. You will also get a deeper understanding of Columnstore Indexes behaviour
	 - Learning objectives:
    	 - How partitioning affects performance
    	 - Columnstore Indexes health
1. Challenge 05: **[Monitoring workload](./Solution-05.md)**
	 - In this challenge, you will understand how to monitor your workload to identify poor performing and failed queries
	 - Learning objectives:
	 - How to monitor workload with T-SQL DMVs
	 - Store and query historical data using Azure Monitor
1. Challenge 06: **[Description of challenge](./Solution-06.md)**
	 - Description of challenge
1. Challenge 07: **[Description of challenge](./Solution-07.md)**
	 - Description of challenge
