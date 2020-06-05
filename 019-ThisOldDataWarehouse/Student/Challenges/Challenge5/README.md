# 	Challenge 5 -- Analytics Migration

[<Previous Challenge](../Challenge4/README.md)

## Introduction

WWI leadership team wants to leverage Power BI to create rich semantic models to promote self-service BI using Azure Synapse Analytics (ASA). Additionally, they want to empower different analysts from different organizations to use Power BI reporting capability and build out analytics reports and dashboards from those data models. The final solution needs to consider both report design as well as optimal response times.  Dashboards need to return in less 5 seconds.

## Description
The objective of this lab is to have the Power BI report "WWI_Sales.pbix" to return in less than 5 seconds.  This will require you to optimize the Power BI data model and report.  Secondly, you will need to tune the Azure Synapse database to ensure your table design is setup properly and you have setup statistics and results-set cache.  After completion, review your results with the coach to determine optimal design.

## Success Criteria
* Reduce Response time to less than 10 seconds thru changes to the Power BI Data Model.
    1. Experiment with DirectQuery and Composite model in Power BI Desktop for optimal performance. Determine which table(s) are best in dual mode.  Open Performance Analyzer in Power BI Desktop to capture the runtimes.
* Reduce Response time to less than 10 seconds thru removing SKU in Azure Synapse Analytics tables.
    1. Run "skew.pbix" in student directory to review skew in your Azure Synapse Analytics platform.  
    1. Review each table distribution to ensure you have the right type for each schema.  
    1. Fix skew in any table leveraging Create Table as Select.
* Reduce Response time to less than 10 seconds by reviewing the Explain plan.    
    1. Capture the runtimes for the visual "Total Quantity by Stock Item" in the "High Level Dashboard". (Lower left hand corner)  Open Performance analyzer and look for the visual and record the response time for your baseline.  You will need to also open the "+" icon to expand the section to see "Copy query".  Please copy this query into SSMS.
    1. This query joins date, stock item and sale tables to visualize.  Simulate skew on the Stock Item table by running the T-SQL statments "ctas.sql".
    1. After you run each distribution type, execute "explain.sql".  The query in the explain plan is from the step above.
    1. Copy the explain plan into VS Code and format the XML file to read it.  Review explain plan for total cost and see if there is any "Shuffle Move" that is increasing the Cost.  Pick the best distribution that reduces the cost and eliminates any shuffles.
    1. After you pick the optimal distribution, rerun your query in Performance Analyzer to see if response time improved.
* Reduce Response time to less than 5 seconds by running statistics and setting up result-set cache
    1. Capture baseline runtimes from the performance analyzer for all visuals in "High Level Dashboard".
    1. Run statistics on all tables in Synapse.  Rerun performance analyzer and compare them with Step 1 to see gains.
    1. Turn on Result-set cache. The first run of performance analyzer will be high but the second run should be a big improvement from the baseline from the first step.
    
## Learning resources

|                                            |                                                                                                                                                       |
| ------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------: |
| **Description**                            |                                                                       **Links**                                                                       |
| Performance Tuning | https://medium.com/@ian.shchoy/azure-sql-data-warehouse-deep-dive-into-data-distribution-f4cf8f1e340a |
| Azure Synapse Analytics & Power BI performance| <https://www.jamesserra.com/archive/2019/12/azure-synapse-analytics-power-bi/> |
| Power BI Composite Model |<https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-composite-models>|
| Power BI change table storage mode| <https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-storage-mode>|
| Table skew | <https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute#how-to-tell-if-your-distribution-column-is-a-good-choice> |
| Explain Plan | <https://docs.microsoft.com/en-us/sql/t-sql/queries/explain-transact-sql?view=azure-sqldw-latest> |
| Result-set cache | <https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching> |
| Statistics | <https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-statistics#use-a-stored-procedure-to-create-statistics-on-all-columns-in-a-database> |



## Tips
1. Request from the coach the student zip file
1. Use SQL Credential when connecting to the Azure Synapse Analytics database
1. Make sure the ASA service is running in Azure Portal since it might pause based on your settings
1. Create direct query mode data model first because you can convert direct query mode to imported mode but not vice versa 
1. Use Power BI Perforamance Analyzer to check power bi query time and performance


## Additional Challenges
1. [Add Indexes and Partitions to your table structures](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-design-guidance?view=sql-server-ver15)
1. [Ordered vs. Nonordered CCI](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-ordered-cci)
1. Setup [Aggregate Tables](https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-aggregations) in Power BI Report to see if this improves response times
1. Setup Power BI Embed application "App Owns Data" for users to access data
1. Setup RLS in Power BI Embed and Azure Synapse Analytics
1. Setup workload management to run ETL and run Reports in parallel to see performance impact.