# Challenge 2: Load data into a relational database/warehouse

[< Previous Challenge](./01-data-gathering.md) - **[Home](../README.md)** - [Next Challenge >](./03-visualization.md)

## Introduction
Now data has been put into a central location, how do you work with it?

## Description
The data has been loaded into a cloud storage service. Your team's next task is to load the data to a platform where querying and reporting tools can be used.  In later challenges, you will need to visualize the data using tables/graphs/maps.  You will also need to be able to secure the data, potentially with data masking, entity and/or column level access control, and encryption.

Your method of loading should anticipate that later files with the same structure will need to be loaded to keep the database/warehouse up-to-date.  You can make the simplifying assumption that all future files will only contain new records (i.e., INSERTs).

Although the data used in the Hack is less than 10 GB in size (think of this as your test data set), you need to design for an expected data size of 20 TB or more.  Choose your tools appropriately.

## Success Criteria
- Explained and justified to your coach the choice of database/warehouse/engine for the challenge.
- Created and can describe a data model.
- Described and explained the process used to load data to your coach. Discussed what options you considered and explained the team choice.
- Shown the populated data to your coach.

## Bonus
- Explain the data distribution methodologies used and why

## Learning Resources
- [What is Azure Synapse Analytics?](https://docs.microsoft.com/en-us/azure/synapse-analytics/overview-what-is)
- [What is Azure Databricks?](https://docs.microsoft.com/en-us/azure/databricks/scenarios/what-is-azure-databricks)
- [Quickstart: Create a Synapse workspace](https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-create-workspace)
- [Load Data with the COPY statement](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/quickstart-bulk-load-copy-tsql?toc=/azure/synapse-analytics/toc.json&bc=/azure/synapse-analytics/breadcrumb/toc.json)
- [Load Data with an Integration Pipeline](https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-copy-activity-load-sql-pool)
