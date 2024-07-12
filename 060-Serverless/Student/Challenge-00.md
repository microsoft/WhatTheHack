# Challenge 00 - OpenRowset, Credentials, External tables

**[Home](./README.md)** - [Next Solution >](./Challenge-01.md)

## Pre-requisites

- [ ] Your own Azure subscription with Owner access
- [ ] Your choice of database management tool:
  - [SQL Server Management Studio (SSMS) (Windows)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
  - [Azure Data Studio (Windows, Mac OS, and Linux)](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)

# Introduction

In this challenge you will create the Synapse workspace with a spark pool.
Then you will upload the provided dataset to your Synapse's default storage account.

**Learning objectives:**
- Get understanding about:
  - Synapse workspace configuration
  - Synapse's default Storage account 
  - Spark pool creation
  
  - 
### Create the Synapse workspace
You've been asked to create a new Synapse workspace with no Managed Vnet, no Dedicated SQL pool
While configuring the workspace create a new ADLS Gen 2 account.

### Copy the dataset
Using [Synapse Studio](https://learn.microsoft.com/en-us/training/modules/explore-azure-synapse-studio/1-introduction) or [Azure Storage Explorer](https://azure.microsoft.com/en-us/products/storage/storage-explorer/), copy the provided dataset onto the workspace's default storage. The dataset is available at this [path](./../Student/Resources/Challenge-00). Do not change dataset folder structure.

### Create a new database
Now you have to create a new database in your built-in SQL pool and call it "Serverless"

### Create the spark pool
Open Synapse Studio and configure a new Spark pool:
- Node size: Small (4 vCPU / 32 GB))
- Autoscale: Disabled
- Number of nodes: 5 

## Success Criteria
- Being able to create and configure Synapse workspace's components 
- Upload folders to your Data Lake

### Learning Resources

[Create a Synapse workspace](https://learn.microsoft.com/en-us/azure/synapse-analytics/quickstart-create-workspace)
[Create a new Database](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-database-transact-sql?view=azure-sqldw-latest&preserve-view=true&tabs=sqlod)
[Create a Spark pools](https://learn.microsoft.com/en-us/azure/synapse-analytics/quickstart-create-apache-spark-pool-portal)
[Azure Storage Explorer](https://azure.microsoft.com/en-us/products/storage/storage-explorer/) 
