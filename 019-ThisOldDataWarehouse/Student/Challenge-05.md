# Challenge 05 - Analytics Migration

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

WWI leadership team wants to leverage Power BI to create rich semantic models to promote self-service BI using Azure Synapse Analytics (ASA). Additionally, they want to empower different analysts from different organizations to use Power BI reporting capability and build out analytics reports and dashboards from those data models. The final solution needs to consider both report design as well as optimal response times.  Dashboards need to return in less 5 seconds.

## Description

The objective of this lab is to have the Power BI report "WWI_Sales.pbix" to return in less than 5 seconds.  This will require you to optimize the Power BI data model and report.  Secondly, you will need to tune the Azure Synapse SQL Pool to ensure your table design is setup properly and you have setup statistics and results-set cache.  After completion, review your results with the coach to determine optimal design.

- Remove skew in Azure Synapse Analytics tables
    1. Run `skew.pbix` in the `Resources.zip` file under the `/Challenge05/` directory to review skew in your Azure Synapse Analytics.  
    1. Review each table distribution to ensure you have the right type for each schema.  
- Review the Explain plan.    
    1. Capture the runtimes for the visual "Total Sales by State Province" in the "High Level Dashboard". (Lower right hand corner)  Open Performance analyzer and look for the visual and record the response time for your baseline.  You will need to also open the "+" icon to expand the section to see "Copy query".  Please copy this query into SSMS.
    1. This query joins date, city and sale tables to visualize.
    1. After you run each distribution type, execute `explain.sql` in the `Resources.zip` file under the `/Challenge05/` directory.  The query in the explain plan is from the step above.
    1. Copy the explain plan into VS Code and format the XML file to read it.  Review explain plan for total cost and see if there is any "Shuffle Move" that is increasing the Cost.  Pick the best distribution that reduces the cost and eliminates any shuffles.
    1. Fix skew in any table leveraging Create Table as Select.
    1. After you pick the optimal distribution, rerun your query in Performance Analyzer to see if response time improved.
- Run statistics and set up result-set cache
    1. Capture baseline runtimes from the performance analyzer for all visuals in "High Level Dashboard".
    1. Run statistics on all tables in Synapse.  Rerun performance analyzer and compare them with Step 1 to see gains.
    1. Turn on Result-set cache. The first run of performance analyzer will be high but the second run should be a big improvement from the baseline from the first step.
- Optimize the Power BI Data Model.
    1. Experiment with DirectQuery and Composite model in Power BI Desktop for optimal performance. Determine which table(s) are best in dual mode.  Open Performance Analyzer in Power BI Desktop to capture the runtimes.

## Success Criteria
- Reduce Power BI report refresh times to less than 5 seconds

## Learning Resources

- [Performance Tuning](https://medium.com/@ian.shchoy/azure-sql-data-warehouse-deep-dive-into-data-distribution-f4cf8f1e340a)
- [Azure Synapse Analytics & Power BI performance](https://www.jamesserra.com/archive/2019/12/azure-synapse-analytics-power-bi/)
- [Power BI Composite Model](https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-composite-models)
- [Power BI change table storage mode](https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-storage-mode)
- [Table skew](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute?context=%2Fazure%2Fsynapse-analytics%2Fcontext%2Fcontext)
- [Table skew workflow](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/azure-synapse-analyzer-report-to-monitor-and-improve-azure/ba-p/3276960)
- [Explain Plan](https://docs.microsoft.com/en-us/sql/t-sql/queries/explain-transact-sql?view=azure-sqldw-latest)
- [Result-set cache](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching)
- [Statistics](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics)

## Tips

- Create direct query mode data model first because you can convert direct query mode to imported mode but not vice versa 
- Use Power BI Perforamance Analyzer to check power bi query time and performance

## Advanced Challenges (Optional)

Too comfortable?  Eager to do more?  Try these additional challenges!

- [Add Indexes and Partitions to your table structures](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-design-guidance?view=sql-server-ver15)
- [Ordered vs. Nonordered CCI](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-ordered-cci)
- Setup [Aggregate Tables](https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-aggregations) in Power BI Report to see if this improves response times
- Setup Power BI Embed application "App Owns Data" for users to access data
- Setup RLS in Power BI Embed and Azure Synapse Analytics
- Setup workload management to run ETL and run Reports in parallel to see performance impact.
