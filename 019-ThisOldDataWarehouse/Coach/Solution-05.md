# Challenge 05 - Analytics Migration - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Introduction

WWI leadership team wants to leverage Power BI to create rich semantic models to promote self-service BI using Azure Synapse Analytics (ASA). Additionally, they want to empower different analysts from different organizations to use Power BI reporting capability and build out analytics reports and dashboards from those data models. The final solution needs to consider both report design as well as optimal response times.  Dashboards need to return in less 5 seconds.

## Description
The objective of this lab is to have the Power BI report "WWI_Sales.pbix" to return in less than 5 seconds.  This will require you to optimize the Power BI data model and report.  Secondly, you will need to tune the Azure Synapse database to ensure your table design is setup properly and you have setup statistics and results-set cache.  After completion, review your results with the coach to determine optimal design.

## Coach's notes
1. This Challenge will be reusing existing assets to determine optimal performance of their Power BI Report and Azure Synapse Analytics SQL Pools
1. Please share the student.zip file in the student_share directory in the solutions for Challenge 5
1. There will be four success criteria in this challenge.  First one will be with Power BI Data model and remaining with tuning Synapse ANalytics SQL Pools
1. Azure Synapse Analytics tuning
    1. Leverage WWI_Sales.pbix during this part of the exercise.
    1. First success criteria is to review the skew of the tables.  THis will be different for each team depending on how they setup the previous challenges. It is recommended to review the skew and fix it by using the CTAS statement.  This will give them a similar baseline to everyone else.
    1. The next success criteria is to run the CTAS simulations to break the optimal design and compare the explain plans for the best one.  The replicated table with clustered index is the most efficient query.  This will not improve substianlly the response times in Power BI.
    1. The last success criteria is to setup statistics and results-set cache.  Perform these sequentially and compare the runtimes in Performacne Analyzer in Power BI.  The statistics will have a marginal improvement and should be ran first.  The second step will be to setup result-set cache which will give you the best performance.
1. Power BI Model Optimization
    1. Review WWI_Sales_Composite.pbix file for final results.  The original file use DirectQuery to connect to Azure Synapse Analytics. 
    1. The current file uses a composite model and setups all dimension tables in DUAL for quick in-memory responses
    1. Don't share this file with the students until the end of the Challenge.  Also advise them when performing the next three success criteria to use the old PBIX file
    1. This will ensure you will not mix Composite models with performance tuning until the end of the challenge

## Learning resources

1. [Performance Tuning](https://medium.com/@ian.shchoy/azure-sql-data-warehouse-deep-dive-into-data-distribution-f4cf8f1e340a)
1. [Azure Synapse Analytics & Power BI performance](https://www.jamesserra.com/archive/2019/12/azure-synapse-analytics-power-bi/)
1. [Power BI Composite Model](https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-composite-models)
1. [Power BI change table storage mode](https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-storage-mode)
1. [Table skew](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute?context=%2Fazure%2Fsynapse-analytics%2Fcontext%2Fcontext)
1. [Table skew workflow](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/azure-synapse-analyzer-report-to-monitor-and-improve-azure/ba-p/3276960)
1. [Explain Plan](https://docs.microsoft.com/en-us/sql/t-sql/queries/explain-transact-sql?view=azure-sqldw-latest)
1. [Result-set cache](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching)
1. [Statistics](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics)

## Additional Challenges
1. [Add Indexes and Partitions to your table structures](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-design-guidance?view=sql-server-ver15)
1. [Ordered vs. Nonordered CCI](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-ordered-cci)
1. Setup [Aggregate Tables](https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-aggregations) in Power BI Report to see if this improves response times
1. Setup Power BI Embed application "App Owns Data" for users to access data
1. Setup RLS in Power BI Embed and Azure Synapse Analytics
1. Setup workload management to run ETL and run Reports in parallel to see performance impact.