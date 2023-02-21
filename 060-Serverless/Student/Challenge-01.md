# Challenge 0 - OpenRowset, Credentials, External tables

[< Previous Solution](./Challenge-00.md) - **[Home](./README.md)** - [Next Solution >](./Challenge-02.md)

## Pre-requisites
- You have to complete **Challenge-00**
- Relevant permissions according to the documentation: [Azure Synapse RBAC roles](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-synapse-rbac-roles)


## Introduction
In this challenge, you will explore several parquet, csv and Json files from Blob Storage using the Synapse built-in Sql pool;  

**Learning objectives:**
- Get understand about file formats and how to query them using built-in T-SQL commands
- Clear understanding about different authentication methods
- Leverage File format and External table to process and "export" data using Serverless

### Query storage files with serverless SQL pool

> [TIP]
> You can leverage Synapse Studio to automatically create the required T-SQL command  

**Data Exploration**

You need to explore the content of the Dimaccount folder using T-SQL query and OPENROWSET and:
- Retrieve data and schema for all the parquet and (optional) Csv files in the"./Csv/Dimaccount_csv" folder
- (Optional) Read and translate JSON documents you'll find in the "./Json/Dimaccount_Json" folder
 
**Data Virtualization**

> [TIP]
> You can leverage Synapse Studio to automatically create the required T-SQL command  

You do not want your collegues to deal with storage account path, file formats and with difficult T-SQL syntax to explore data, so you decided to provide them with a new database called "Serverless" and a set of table to speed-up data analysis:
  
- Try to query the storage using a "Shared Access Signature" 
- Define External table to easily deal with txt files in "./Csv/Dimaccount_formattedcsv" folder
	- First row in the file represents the Header
	- Field terminator = ';' (semicolon)
	- String delimiter = " (double quote)
- Create one External Table for each folder with Parquet files except for the "Factinternetsales_partitioned". As table name use the folder name with the prefix "EXT_"
- Export into a new external table all values for AccountCodeAlternateKey,ParentAccountCodeAlternateKey,AccountDescription and AccountType columns from the "EXT_Dimaccount" table using "|" as field terminator and "&" as string delimiter.

## Success Criteria
- Properly understand how to leverage OPENROWSET, JSON_VALUES T-SQL functions to read data from different files and formats
- Good understanding about authentication methods available with Serveless
- How to leverage Serverless to expose and "export" data in different formats using external tables
  
## Learning Resources

[Query storage files with serverless SQL pool](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/query-data-storage)  
[How to use OPENROWSET](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-openrowset)  
[Control storage account access for serverless SQL pool in Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-storage-files-storage-access-control?tabs=user-identity)  
[Query JSON files using serverless SQL pool in Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-json-files)  
[OPENJSON](https://docs.microsoft.com/en-us/sql/t-sql/functions/openjson-transact-sql?view=sql-server-ver15)  
[JSON_VALUE ](https://docs.microsoft.com/en-us/sql/t-sql/functions/json-value-transact-sql?view=sql-server-ver15)  
[Create database](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-database-transact-sql?view=azure-sqldw-latest&preserve-view=true&tabs=sqlod)
[Create a Database Master Key](https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/create-a-database-master-key?view=sql-server-ver15)  
[CREATE DATABASE SCOPED CREDENTIAL](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-database-scoped-credential-transact-sql?view=sql-server-ver15)  
[CREATE EXTERNAL DATA SOURCE](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=azure-sqldw-latest&preserve-view=true&tabs=serverless)  
[Use external tables with Synapse SQL](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-external-tables?tabs=hadoop)  
[CREATE EXTERNAL FILE FORMAT](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-file-format-transact-sql)  
[CETAS with Synapse SQL](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-cetas)  
