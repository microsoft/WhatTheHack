# Challenge 3  - Wildcard, use it. But with moderation.

[< Previous Challenge>](Challenge-02.md) - **[Home](../README.md)** - [Next Challenge> ](Challenge-04.md) 

## Pre-requisites
- You have to complete **Challenge-02**
- Relevant permissions according to the documentation: [Azure Synapse RBAC roles - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-synapse-rbac-roles)

#
# Introduction

In this challenge you will understand the performance penalty in use too much wildcard. 
And how to improve performance with filepath and leverage it to benefit from partitions elimination.

You can find all the detail files for this challenge into the Zip file provided by your coach at [this path](./Resources/Challenge-03/)


You can freely use a wildcard in serverless queries which will take this into consideration to optimize the query execution. However, the lack of precision in terms of the filter can lead to the queries spending a long time looking for a file. 

For example, consider in a query the usage of star wildcards happening in different levels at the same time,  the engine will take a longer time to scan the folder content in different levels to find the matching filter.  Though, as better files are partitioned and organize in different folders and precise filters are used,so leaving the wildcard to be used in a precise way, better will be the query execution time.

**Learning objectives:**

- Understand Synapse how to better use the wildcard filter
- Understand the options to query file paths and names
- Get benefit from Partition elimination
- Query partioned table created with Spark

**Run SQL Serverless query using Wildcards.**

 You need to explore the content of all sqlserverlessanalitics\Fact*  folders, using T-SQL query:

- Open [C3_1_Wildcard.sql](./Student/../Resources/Challenge-03/C3_1_wildcard.sql)
- Replace the storage and container name path according to your configuration.
- Compare the execution time when the level of wildcard is increase while searching for a specific filter.
  - The script provided has basically 2 queries, the different between them are the levels of the wildcard start usage.
  - Compare the execution time of both of them.

 **Run SQL Serverless query using File Path and File Name Function.**

- Open [C3_2_Filepath_name.sql](./Student/Resources/../../Resources/Challenge-03/C3_2_Filepath_name.sql)
- Replace the storage and container name path according to your configuration.
- Evaluate how the function works and how it make it  easy the query while using it

  
 > [!TIP] 
 >  Take sometime to check how the files and folder are organized on the storage as these functions are used to optimize search in partitioned files structure

  
**Partition elimination in Serverless SQL Pool**

Execute the query below and verify the amount of data processed

```sql
SELECT Top 10 *
FROM
    OPENROWSET(
        BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/factinternetsales_partitioned/*/*/*.parquet',
        FORMAT = 'PARQUET'
    ) r
WHERE ORDERDATEKEY = 20211025
``` 

> [TIP] 
>  Info about data processed are available in the message tab in Sql management studio and Synapse Studio

Consider the filepath to avoid unesfull partitions.


> [OPTIONAL CHALLENGE] 
> Implement partitions elimination also for External tables. You have to leverage Spark notebook and Shared metadata. 

## Success Criteria

- Be able to precisely define when it is necessary to filter the different levels of the storage account with wildcard.
- Organize your storage account in a way to make easier to filter the files.
- Understand what partition elimination means and the benefit in terms of performance and cost per query


## Learning Resources

[Best practices for serverless SQL pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool#push-wildcards-to-lower-levels-in-the-path)  
[Filename function](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-data-storage#filename-function)  
[Filter optimization](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool#filter-optimization)  
[External Table - PArtition elimination](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-external-tables?tabs=hadoop#folder-partition-elimination)  
[Lake database](https://learn.microsoft.com/en-us/azure/synapse-analytics/metadata/database)  
[Shared tables](https://learn.microsoft.com/en-us/azure/synapse-analytics/metadata/table)  
