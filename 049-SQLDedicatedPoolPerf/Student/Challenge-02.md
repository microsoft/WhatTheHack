# Challenge 02 - Queries Best Practice

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites
- You have to complete **Challenge-01: Ingest data from blob storage**

## Introduction

In this challenge you will dig into best practices you have to consider writing query for your data warehouse.

You can find all the files for this challnge into the Zip file provided by your coach at this path: _./Resources/Challenge-02/_ 

## Description

**Learning objectives:**
- The importance of Statistics
- How to Join distributed/replicated tables
- Incompatible and compatible Join

### Auto Create Statistics

Users are complaining that after importing data into a production table using CTAS the first reporting query involving it is always slow. Subsequent queries are usually faster and with good performance. Investigate why the first execution is taking longer than usual.

Open [C2_1_Statistics.sql](./Resources/Challenge-02/C2_1_Statistics.sql?raw=true) and try to understand why first execution for the proposed SELECT is much more slower than the second one. Use the suggested T-SQL commands to investigate the issue.
Were all statistics in place when you ran the first attempt ?

### Replicated Tables

Despite the query is leveraging multiple Replicated Table users are complaining about poor performance and they noticed some potentially un-necessary data movement. 
Could you help fixing it and improving the performance ? 
  - Open [C2_3_Replicated_Tables_and_Join.sql](./Resources/Challenge-02/C2_2_Replicated_Tables_and_Join.sql?raw=true) and explain why replicated Tables used by proposed query need data movement affecting performance.
    - Is the replicated table cache ready ?
    - Which factors can affect the cache ?

### Incompatible vs Compatible joins

Users are complaining an important query is taking much more than expected to complete and ask for your help. Investigate why the query is so slow and make it faster.

- Open [C2_2_Incompatible_Join.sql](./Resources/Challenge-02/C2_3_Incompatible_Join.sql?raw=true) and try to optimize the proposed query.
Use the suggested T-SQL command to investigate this issue.
  - Are tables used by the query using the same distribution column ? 
  - Is this query using a compatible join ?

## Success Criteria

- Deep understanding about Table Statistics
- Understand how to identify columns to use with statistics
- Recognize if a given query is using unnecessary data movement due to incompatible joins and how to fix it.

## Learning Resources

- [Create and update statistics using Azure Synapse SQL resources](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics)
- [Design guidance for replicated tables](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables)
- [How to minimize data movements (Compatible and Incompatible Joins)](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/how-to-minimize-data-movements-compatible-and-incompatible-joins/ba-p/1807104)