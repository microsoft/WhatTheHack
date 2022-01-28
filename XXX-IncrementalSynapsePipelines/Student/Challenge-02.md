# Challenge #2 - Create Incremental Load Pipelines

[< Previous Challenge](Challenge-01.md) - **[Home](../README.md)** - [Next Challenge>](Challenge-03.md)

## Pre-requisites

*Complete the [Previous Challenge](Challenge-01.md).*

## Description

Now we are getting to the fun part.  This will be the hardest challenge of the Hackathon, but don't worry we have the utmost confidence in you.
<br>&nbsp;<br>
For this section we need to add Change Data Catpure functionality to our source database and then create an incremental synapse pipeline to look for those changes and push them to the dedicated pool.  We also need to employ a proper design in the dedicated pools so that it does not impact performance.  Finally let's visualize this data in Power BI.
<br>&nbsp;<br>
<B>Do not setup a trigger in this challenge</B>


## Success Criteria

1. Implement Change Data Capture on the Azure SQL Database and be able to articulate on the cdc tables and functions and their purpose.

2. Create an incremental synapse pipeline that accounts for the following...
    a. For each time a pipeline is executed, it will only update the SQL Dedicated Pool with new row inserts, updates and deletions since the last time it was executed.  
    b. You only need to do 2-3 tables so make sure your pipeline has a lookup to determine which tables to copy and where to land them in the Dedicated Pool.  Please choose related tables so modifications can easily be viewed in the target Dedicated Pool and Power BI.

3. Implement Staging and Production Tables in the Dedicated Pool and an automated methodology to update data from staging to production.

4. Create a Power BI report that queries the production tables in the Dedicated Pool.

5. Be able to show the data pipleine, meaning you can demonstrate executing the change in the SQL Database and see it flow through the dedicated pool to Power BI.


## Learning Resources

*The following links may be useful to achieving the success crieria listed above.*

- [What is change data capture (CDC)?](https://docs.microsoft.com/en-us/sql/relational-databases/track-changes/about-change-data-capture-sql-server?view=sql-server-ver15)

- [Incrementally load data from a source data store to a destination data store](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-incremental-copy-overview)

- [Incrementally load data from Azure SQL Managed Instance to Azure Storage using change data capture (CDC)](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-incremental-copy-change-data-capture-feature-portal)

- [Using stored procedures for dedicated SQL pools in Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-develop-stored-procedures)


## Tips

*The following document was used in a Customer PoC and may be helpful with this challenge.  Just keep in mind that the scenario in the PoC was a bit different so some sections of the document may not be relevant to this challenge.*

- [SQLMI to Dedicated Pool Proof of Concept](./Resources/SQLMItoDedicatedPoolProofofConcept.docx)

*There are also some SQL scripts to help you get started with inserting, updating and deleting records in the Azure SQL database to evaluate the Change Data Capture functionality and for the stored procedures needed for the SQL Dedicated Pool.  They are located in the [Resources Folder](https://github.com/jcbendernh/WhatTheHack/tree/IncrementalSynapsePipelines/XXX-IncrementalSynapsePipelines/Student/Resources).*