# What The Hack - Synapse Serverless - General concepts & how to

## Introduction
This "What the Hack" enables attendees to understand how to query their data lake from Synapse Serverless. 
It simulates a real-world scenario where users need to explore data in different files with different formats and the goal is to apply the most important features available in Serverless to properly read and process those data.

During the hack, attendees will focus on:
- Files, data exploration and best practices
- External tables
- Delta Tables
- Spark interaction
- Workload monitoring

## Learning Objectives
By the end of the "Synapse Serverless - Gerneral concepts & how to", attendees will have a good understanding:
- How to easily explore different files with different formats and different authentication methods
- Work with metadata informations and Spark tables 
- Work with Delta files
- Performance best practices 
- Monitor workload

## Challenges
- Challenge 00: **[Setting up the Synapse Workspace](./Student/Challenge-00.md)**
  - In this challeng you'll explore how ro configure a Synapse workspace
- Challenge 01: **[OpenRowset, External tables, Credentials](./Student/Challenge-01.md)** 
  - In this challenge, attendees will explore several parquet, csv and Json files from Blob Storage using their Synapse built-in Sql pool; 
- Challenge 02: **[Data Type and Statistics](./Student/Challenge-02.md)**
  - In this challenge, attendees will check the importance of data types and statistics 
- Challenge 03: **[Metadata exploration, Wildcard, Partitions and Spark](./Student/Challenge-03.md)**
  -  In this challenge, attendees will explore metadata, will work with wild card, partitions and spark.
- Challenge 04: **[Queriyng Delta files](./Student/Challenge-04.md)**
  - In this challenge, attendees will understand Delta queries and impact of partitioning.
- Challenge 05: **[Monitoring](./Student/Challenge-05.md)**
  - In this challenge, attendees will understand how to monitor your Synapse built-in Sql pool.



## Prerequisites 
- Your own Azure subscription with Owner access
- Your choice of database management tool:
  - [SQL Server Management Studio (SSMS) (Windows)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
  - [Azure Data Studio (Windows, Mac OS, and Linux)](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)

## Contributors
- Liliam Leme and Luca Ferrari