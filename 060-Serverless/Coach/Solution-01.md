# Challenge 01 - OpenRowset, Credentials, External tables - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

# Notes & Guidance

In this challenge you will access your Data Lake and will read data and schema from Parquet, Csv and json files.
Then you'll leverage external table to run basic data transformations and to easily access and query your folders. 

**Learning objectives:**

- Get understanding about T-SQL syntax and features you can leverage-on to explore data from your data lake using Synapse Serverless. 
- Authentication methods and differences	
- File format
- Create External Table (CET) and Create External Table as (CETAS)

**Condition of success**

- Read data from parquet, csv and json file 
- Properly create 
  - Data sources
  - Credentials
  - External file format
  - External tables with proper destination
  
### Openrowset, schema and file formats

Open [C1_1_Openrowset.sql](./Solutions/Challenge01/C1_1_Openrowset.sql) and follow provided steps and instructions. 
Show attendee how to:
-   Read data from 
    -   Parquet 
        -   No need to specify schema, schema is automatically inferred from parquet structure
    -   Csv
        -   CSV needs schema definition using "WITH()" T-SQL syntax within select 
        -   Or you have to use "PARSER_VERSION ='2.0'" when specifying bulk options with OPENROWSET
    -   Json
        -   This format is not supported, but csv/text files can contain Json documents in multiple formats
        -   You have to use JSON_VALUE function and/or OPENJSON table fn to properly read Json documents from file

### Credentials, Data Sources 

Open [C1_2_Credential_Data_sources.sql](./Solutions/Challenge01/C1_2_Credential_Data_sources.sql) and follow provided steps and instructions. 
Show attendees:
- How to query Data Lake using different auth methods:
  - SAS 
    - Bear in mind, need to change the SAS Key in the T-SQL script with a valid one
    - Create a new one with "Read" and "List" permissions
  - MSI 
    - Ensure Synapse MSI has proper permissions (Storage blob data contributor)
  - AAD  
    - this is the default
  - What if I log into my Serverless using SQL Auth and try to access data Lake ?

### Create External File Format and Tables 

Open [C1_3_ExternalTables.sql](./Solutions/Challenge01/C1_3_ExternalTables.sql) and follow provided steps and instructions. 
Show attendees:
- How to specify Format options using OPENROWSET
- How to create an External File format and leverage it to create an External Table
- How to "export" data changing the destination format

### Learning Resources

[How to use OPENROWSET](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-openrowset)
[Control storage account access for serverless SQL pool in Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-storage-files-storage-access-control?tabs=user-identity)
[Query JSON files using serverless SQL pool in Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-json-files)
[OPENJSON](https://docs.microsoft.com/en-us/sql/t-sql/functions/openjson-transact-sql?view=sql-server-ver15)
[JSON_VALUE ](https://docs.microsoft.com/en-us/sql/t-sql/functions/json-value-transact-sql?view=sql-server-ver15)
[Create a Database Master Key](https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/create-a-database-master-key?view=sql-server-ver15)
[CREATE DATABASE SCOPED CREDENTIAL](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-database-scoped-credential-transact-sql?view=sql-server-ver15)
[CREATE EXTERNAL DATA SOURCE](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=azure-sqldw-latest&preserve-view=true&tabs=serverless)
[Use external tables with Synapse SQL](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-external-tables?tabs=hadoop)
[CREATE EXTERNAL FILE FORMAT](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-file-format-transact-sql)
[CETAS with Synapse SQL](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-cetas)
