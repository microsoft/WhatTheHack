# Challenge 01 - OpenRowset, Credentials, External tables - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

# Notes & Guidance

In this challenge you will access your Data Lake and will see how to infer data type and how to use predicate pushdown. Then you'll dig into the importance of statistics. 

**Learning objectives:**

  - Get understanding on how auto data types infer works. 
  - Understand how to retrieve table schema from data files with no need to scan all of them
  - Statistics on Parquet and CSV table

**Condition of success**

- Get the schema from Parquet files with no need to read data
- Leverage predicate pushdown to improve performance
- Beeing able to create statistics on both Folder and External Tables in Serverless
- Retrieve statistics details related to External Tables 

### Schema infer and predicate pushdown

Open [C2_1_Openrowset.sql](./Solutions/Challenge02/C2_1_Data_types.sql) and follow provided steps and instructions. 
Show attendee how to:
- Get the inferred schema with no scanning the data.
- How to leverage predicate pushdown.


### Statistics 

Open [C1_2_Credential_Data_sources.sql](./Solutions/Challenge02/C2_2_Statistics.sql) and follow provided steps and instructions. 
Show attendees:
- How Auto create statistics work with Parquet and CSV
- How to manually create statistics

### Learning Resources

[Table data types in Synapse SQL](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-data-types)  
[Data types - Best practices](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool#data-types)  
[Get the schema using sp_describe_first_result_set](https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-describe-first-result-set-transact-sql?view=sql-server-ver16)  
[Predicate Pushdown](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool#use-proper-collation-to-utilize-predicate-pushdown-for-character-columns)  
[Statistics in Serverless SQL Pool](<https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics#statistics-in-serverless-sql-pool>)  
[Create Stats on a folder - sp_create_openrowset_statistics](https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-create-openrowset-statistics)  
[Drop Stats from a folder - sp_drop_openrowset_statistics](<https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-drop-openrowset-statistics>)  
