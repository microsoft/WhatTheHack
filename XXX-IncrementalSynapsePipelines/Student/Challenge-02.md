# Challenge 2 - Create Incremental Load Pipelines

[< Previous Challenge](Challenge-01.md) - **[Home](../README.md)** - [Next Challenge>](Challenge-03.md)

## Prerequisite

Review the [SQL MI to Dedicated Pool Proof of Concept](./Resources/SQLMItoDedicatedPoolProofofConcept.docx?raw=true) document.

## Introduction

For this section we need to add *Change Data Catpure* functionality to our source database and then create an incremental synapse pipeline to look for those changes and push them to the dedicated pool.  We also need to employ a proper design in the dedicated pools so that it does not impact performance.  Finally let's visualize this data in Power BI.

## Description

For this challenge we need to implement the following:

- Implement Change Data Capture on the Azure SQL Database and be able to articulate on the cdc tables and functions and their purpose.
- Create an incremental synapse pipeline that accounts for the following...
    - For each time a pipeline is executed, it will only update the SQL Dedicated Pool with new row inserts, updates and deletions since the last time it was executed.  
    - You only need to do 2-3 tables so make sure your pipeline has a lookup to determine which tables to copy and where to land them in the Dedicated Pool.  Please choose related tables so modifications can easily be viewed in the target Dedicated Pool and Power BI.
- Implement Staging and Production Tables in the Dedicated Pool and an automated methodology to update data from staging to production.
- Create a Power BI report that queries the production tables in the Dedicated Pool.

<B>Do not setup a trigger in this challenge</B>  That will be addressed in the next challenge.

## Success Criteria

Be able to show the data pipleine, meaning you can demonstrate executing the change in the SQL Database, validate the CDC functionality, and showcase the data flow through the dedicated pool to the report.

## Learning Resources

*The following links may be useful to achieving the success crieria listed above.*

- [What is change data capture (CDC)?](https://docs.microsoft.com/en-us/sql/relational-databases/track-changes/about-change-data-capture-sql-server?view=sql-server-ver15)

- [Incrementally load data from a source data store to a destination data store](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-incremental-copy-overview)

- [Incrementally load data from Azure SQL Managed Instance to Azure Storage using change data capture (CDC)](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-incremental-copy-change-data-capture-feature-portal)

- [Using stored procedures for dedicated SQL pools in Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-develop-stored-procedures)


