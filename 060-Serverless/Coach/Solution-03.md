# Challenge 3  - Wildcard, use it. But with moderation.

[< Previous Solution](./Solution-02.md) - **[Home](../README.md)** - [Next Solution>](./Solution-04.md)



# Notes & Guidance

In this challenge you will understand the performance penalty in use too much wildcard. You can freely use a wildcard in serverless queries which will take this into consideration to optimize the query execution. However, the lack of precision in terms of the filter can lead to the queries spending a long time looking for a file. 

**Learning objectives:**

- Understand Synapse  how to better use the wildcard filter
- Understand the options to query file paths and names

**Condition of sucess:**

- Be able to precisely define when it is necessary to filter the different levels of the storage account with wildcard.
- Organize your storage account in a way to make easier to filter the files.

### Run SQL Serverless query using Wildcards.

Open [C3_1_Wildcard.sql](./Solutions/Challenge03/C3_1_wildcard.sql) and follow provided steps and instructions. Show attendee how to: 
Compare the execution time when the level of wildcard is increase while searching for a specific filter.
- The script provided has basically 2 queries, the different between them are the levels of the wildcard start usage.
- Compare the execution time of both of them.

### Run SQL Serverless query using File Path and File Name Function.

Open [C3_2_Filepath_name.sql](./solutions/Challenge03/C3_2_Filepath_name.sql) and follow provided steps and instructions. Show attendee how to: 
- Evaluate how the function works and how it make it easy the query while using it
> [TIP] 
> Take sometime to check how the files and folder are organized on the storage as these functions are used to optimize search in partitioned files structure
> 
### Run SQL Serverless Partitions Elimination.

Open [C3_3_Partitions_elimination.sql](./solutions/Challenge03/C3_3_Partitions_elimination.sql) and follow provided steps and instructions. Show attendee how to:
- Benefit from the filepath() fn to avoid unuseful partitions
- Leverage filepath and Create Views and leverage partition eliminations
> [TIP] 
> Take sometime to check how the files and folder are organized on the storage: YEAR=2022->MONTH=10

### Use SQL Serverless to query SparkDB and Spark tables.

Using Synapse Studio, open [C3_4_A_Create_SparkDB.ipynb](./solutions/Challenge03/C3_4_A_Create_SparkDB.ipynb) and follow provided steps and instructions. Show attendee how to:
- Create a Spark Database
- Create a Spark Table

Open [C3_4_B_Query_SparkDB.sql](./solutions/Challenge03/C3_4_B_Query_SparkDB.sql) and follow provided steps and instructions. Show attendee how to:
- Query spark table

> [TIP] 
> No need to provide the folder name to benefit from Partitions elimination, just specify column [YEAR] and [MONTH], inherited by the original folders name and used by spark as regular columns. 

## Learning Resources

[Best practices for serverless SQL pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool#push-wildcards-to-lower-levels-in-the-path)  
[File metadata functions](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/query-data-storage#file-metadata-functions)  
[Azure Synapse Analytics shared metadata tables](https://learn.microsoft.com/en-us/azure/synapse-analytics/metadata/table)  
[Create and connect to Spark database with serverless SQL pool](https://learn.microsoft.com/en-us/azure/synapse-analytics/metadata/database#create-and-connect-to-spark-database-with-serverless-sql-pool)  
[Synchronize Apache Spark for Azure Synapse external table definitions in serverless SQL pool](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-storage-files-spark-tables)  