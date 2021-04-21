# Challenge 6: Coach's Guide

[< Previous Challenge](./05-TransformLoad.md) - **[Home](README.md)**

Now that the team has established the bulk loads and conformed the data, it is time to build the Data Warehouse and perform the necessary calculations. 

### Creating and populating the star schema

In this WhatTheHack, we recommend using Azure Synapse Analytics (formerly Azure SQL Data Warehouse). The team will create the dimension and fact tables. They may [work with the data in the data lake](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-vnet-service-endpoint-rule-overview?toc=%2fazure%2fstorage%2fblobs%2ftoc.json#azure-sql-data-warehouse-polybase)
using [external tables
functionality](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-table-transact-sql?view=sql-server-2017).


- [Guidance for designing distributed tables in Azure Synapse Analytics (formerly Azure SQL Data Warehouse)](https://docs.microsoft.com/en-us/azure/sql-data-warehouse/sql-data-warehouse-tables-distribute)
- [Design guidance for using replicated tables in Azure Synapse Analytics (formerly Azure SQL Data Warehouse)](https://docs.microsoft.com/en-us/azure/sql-data-warehouse/design-guidance-for-replicated-tables)

### Alternative Approaches

A team that is more familiar with Scala or Python could connect to Azure
Synapse Analytics (or other technology chosen for the serving layer),
using code in their notebook to populate the star schema.

### Unit testing Scala or Python code

The takeaway concept here is that any business logic or transformation code
in the notebook can be extracted to jars or pip packages. Having done this,
it can all be tested in the same ways that any application or service code
could be tested. The jar or pip package can later be attached to the
cluster, and the notebook becomes a driver or host process that orchestrates
calls to the tested units of code.

- [Unit testing in data pipelines](https://medium.com/@GeekTrainer/unit-testing-in-data-a711d2053f7e)
- [Social Posts Pipeline sample - Integration Tests](https://github.com/ricardoserradas/twitter-databricks-analyzer-cicd#integration-tests)

Based on what path the team has taken, they may also find value in these more targeted references:

- [The Hitchhiker's Guide to Python: Testing Your Code](https://docs.python-guide.org/writing/tests/)
- [The philosophy and design of ScalaTest](http://www.scalatest.org/user_guide/philosophy_and_design)
- [sbt Reference Manual](https://www.scala-sbt.org/1.x/docs/index.html)

#### Alternative Approaches

While extracting the code into jars or pip packages is the strongly
recommend approach, a team could choose to [use notebook
workflows](https://docs.databricks.com/user-guide/notebooks/notebook-workflows.html)
to isolate units of work. This approach is not ideal, as it becomes
difficult to manage return values, handle errors, or leverage shared
business logic with processes that exist outside of Databricks.

#### Including tests in code review / pull request processes

If the team has extracted the business logic to standard Scala or Python
projects, the tests can be run in Azure DevOps Pipelines, Travis, etc.
If the team is using separate notebooks, the Databricks Jobs API could be
used to automate test runs.

### Gotchas and Pitfalls

#### Connecting SQL DW and ADLS Gen2

Teams have historically struggled with this.
There are a few things that need to happen here.
Most are covered in the linked reference for [Azure Synapse Analytics PolyBase](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-vnet-service-endpoint-rule-overview?toc=/azure/storage/blobs/toc.json#azure-sql-data-warehouse-polybase),
but this link is often missed due to "reference link overload".

- Assign an identity to the SQL Server, e.g.,
`Set-AzSqlServer
-ResourceGroupName your-database-server-resourceGroup
-ServerName your-database-servername
-AssignIdentity`
- Add the `Storage Blob Data Contributor` RBAC role assignment for this new identity
to access the ADLS Gen2 storage account.
This is very similar to what the team has likely done before to establish access
from Databricks via a service principal
- [Allow Azure services to access the server](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-vnet-service-endpoint-rule-overview?toc=/azure/storage/blobs/toc.json#impact-of-removing-allow-azure-services-to-access-server)
    - This can be found in the Azure Portal by navigating to the
    "Firewalls and Virutal Networks" blade of the storage account resource
    and choosing "Selected networks"
    - After doing this, teams will need to add their public IP address
- Create the external data source, e.g.,

```sql
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'change_me_123';

-- 'Managed Service Identity' is a literal string which produces magic, so don't change it
CREATE DATABASE SCOPED CREDENTIAL msi_cred WITH IDENTITY = 'Managed Service Identity';

-- Change the filesys and stoacct in the LOCATION below, such that they are
-- the file system and storage account established by the team
CREATE EXTERNAL DATA SOURCE ABFS
WITH
(
    TYPE=HADOOP,
    LOCATION='abfss://filesys@stoacct.dfs.core.windows.net',
    CREDENTIAL=msi_cred
);
GO

CREATE EXTERNAL FILE FORMAT [ParquetFormat]
WITH (  
    FORMAT_TYPE = PARQUET,  
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'  
);  

CREATE SCHEMA [external]
GO

CREATE EXTERNAL TABLE [external].[tablename] 
    (
        
    )
WITH
    (
        LOCATION = '/Conformed/table',  
        DATA_SOURCE = ABFS,  
        FILE_FORMAT = [ParquetFormat]  
    )  
GO
```

### Targeted Reference Links

#### Azure Synapse Analytics (formerly Azure SQL Data Warehouse)

- [Loading Data into Azure Synapse Analytics (formerly Azure SQL Data Warehouse)](https://channel9.msdn.com/Series/Azure-SQL-DW/Part-3Loading-Data-into-Azure-SQL-Data-Warehouse)
- [Azure Synapse Analytics (formerly Azure SQL Data Warehouse) PolyBase](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-vnet-service-endpoint-rule-overview?toc=/azure/storage/blobs/toc.json#azure-sql-data-warehouse-polybase)
- [Azure Databricks - Azure Synapse Analytics (formerly Azure SQL Data Warehouse)](https://docs.azuredatabricks.net/spark/latest/data-sources/azure/sql-data-warehouse.html)
- [SQL Server Data Warehouse Cribsheet](https://www.red-gate.com/simple-talk/sql/learn-sql-server/sql-server-data-warehouse-cribsheet/)
- [Secure a database in Azure Synapse Analytics (formerly Azure SQL Data Warehouse)](https://docs.microsoft.com/en-us/azure/sql-data-warehouse/sql-data-warehouse-overview-manage-security)


#### Testing Python

- [Python unit tests in Visual Studio Code](https://code.visualstudio.com/docs/python/unit-testing)
- [Python mock object library](https://docs.python.org/3/library/unittest.mock.html)

#### Testing Scala

- [Scalatest: Writing your first test](http://www.scalatest.org/user_guide/writing_your_first_test)
- [ScalaMock Quick Start](http://scalamock.org/quick-start/)
- [Integration with testing frameworks](http://scalamock.org/user-guide/integration/)
- [Getting started with sbt](https://www.scala-sbt.org/1.x/docs/Getting-Started.html)

#### Testing SQL

- [Creating and running a SQL Server Unit Test](https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-data-tools/jj851212(v=vs.103))
- [SSIS 2016: Building and Deploying a Simple Test Project](https://andyleonard.blog/2016/06/ssis-2016-building-and-deploying-a-simple-test-project/)

#### Automating tests in Azure DevOps

- [Pipelines: Test Python code](https://docs.microsoft.com/en-us/azure/devops/pipelines/languages/python?view=vsts&tabs=ubuntu-16-04#test)
- [Pipelines: Build Java apps in Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/languages/java?view=vsts#build-your-code-with-maven)

#### Automating tests in GitHub

- [Build and test with Azure Pipelines](https://github.com/marketplace/azure-pipelines)
- [Build and test with Travis CI](https://github.com/marketplace/travis-ci)
- [Build and test with CircleCI](https://github.com/marketplace/circleci)
