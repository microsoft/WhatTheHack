# Challenge 1 - Initial Data Load into the Dedicated Pool

[< Previous Challenge](Challenge-00.md) - **[Home](../README.md)** - [Next Challenge>](Challenge-02.md)

## Introduction

We are now ready to begin the development of our incremental pipeline.  Our first step will be to create the metadata structure for our dedicated pool.  For this challenge, we are concerned only with the initial data copy and the design structure.

We are not looking to create any resources specific to watermark tables, etc.  That will be in the next challenge.

## Description

Now that our environment is setup, we need to populate the Dedicated Pool with all of the <b>Sales / SalesLT</b> tables from our Azure SQL Database.

## Success Criteria

1. The proper table design for a star schema has been implemented in the Dedicated Pool. 
2. Be able to discuss which tables are Distributed Hash, Round Robin, Replicated and why.

## Learning Resources

*The following links may be useful to achieving the success crieria listed above.*

- [Copy Data tool in Azure Data Factory and Synapse Analytics](https://docs.microsoft.com/en-us/azure/data-factory/copy-data-tool?tabs=data-factory)

- [Design tables using Synapse SQL in Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-overview)

- [CREATE TABLE AS SELECT (CTAS)](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-develop-ctas)


