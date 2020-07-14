# 	Challenge 3 -- Redesign SSIS jobs into ELT with ADF

[< Previous Challenge](../Challenge2/README.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](../Challenge4/README.md)

## Introduction
WW Importers keep missing the SLAs for their nightly data load process.  The loads take six hours to complete and start each evening at 1:00AM.  They must complete by 8:00AM but frequenly these jobs are taking longer than planned.  In addition a few critical stakeholders are asking to provide the data even more frequently.  Since these business units are the key stakeholders, they have the funding to help replatform the data pipelines.  WW Importers realizes they need to leverage their new Data Lake to scale and load this into their Data Warehouse for Stage 3.  These data pipelines must be ELT (Extract, Load & Transform) so they can quickly write the data to the cloud and scale out the compute to transform the data.

## Description
The objective of this lab is to modernize the ETL pipeline that was originally built in SSIS.  A detailed diagram of the current workflow is included below.  We need to rebuild this pipeline in Azure leveraging scale-out architecture to transform this data.  The data flow will include steps to extract the data from the OLTP platform, store it in the Azure Data Lake and bulk ingest it into Azure Synapase Analytics.  This will be run on a nightly basis, and will need to leverage Azure Data Factory as a job orchestration and scheduling tool.

![Current SSIS Workflow](../../../images/SSISFlow.png)

<b>Below is a summary of each of the tasks in the existing SSIS package.  Note that we will be able to re-use the existing scripts for all of these tasks except for step 6.</b>

1. The first step of the pipeline is to retrieve the “ETL Cutoff Date”. This date can be found in the [Integration].[Load_Control] in Azure Synapse DW that should have been created as part of challenge 1 (This step should have already been recreated in Challenge 2)
1. The next step ensures that the [Dimension].[Date] table is current by executing the [Integration].[PopulateDateDimensionForYear] in Azure Synapse DW
1. Next the [Integration].[GetLineageKey] procedure is executed to create a record for each activity in the [Integration].[Lineage Key] table
1. This step Truncates the [Integration].[[Table]_Staging] tables to prep them for new data
1. This step retrieves the cutoff date for the last successful load of each table from the [Integration].[ETL Cutoffs] Table
1. New data is now read from the OLTP source (using [Integration].[Get[Table]Updates] procedures) and copied into the [Integration].[[Table]_Staging] tables in the target DW
1. Finally the staged data is merged into the [Dimension] and [Fact] tables in the target DW by executing the [Integration].[MigrateStaged[Table]] stored procedures in the target DW
    - <b>NOTE: As part of this step, surrogate keys are generated for new attributes in Dimension tables (tables in the [Dimension] schema), so Dimenion tables must be loaded before FACT tables to maintain data integrity</b>

Note: This challenge is intended to build upon the previous 2 challenges, and you should try to reuse content wherever possible

## Success Criteria
Create a data pipeline for the [Dimension].[City] table considering logic above.  Follow these steps for this pipeline.
1. Add a new activity to your Azure Data Factory to load data from the new Azure Data Lake into the [Integration].[City_Staging] in the Data Warehouse in Azure Synapse via Polybase (this will correlate to Step 6 in existing package described above). <b>Note: Be sure that table exists and is empty prior to loading</b>
1. Add an activity to execute the Get Lineage Key stored procedure so that the process can be logged (this will correlate to Step 3 in existing SSIS package described above)
1. Create another activity to merge the new data into the target table ([Dimension].[City]) from your staging table [Integration].[City_Staging] via existing stored procedure  (this correlates to Step 7 in existing SSIS package described above)
1. Add another new activity to move the files to the .\RAW\WWIDB\[TABLE]\{YY}\{MM}\{DD}\ directory in your data lake once they have been loaded into your DW table (this is a new task that will allow your data to be persisted in your new data lake for further exploration and integration into downstream systems)
1. Test your new Azure Data Factory Pipeline.  You can execute your pipeline by clicking on "Debug" or adding a Trigger in the design UI.  If done correctly, the 11 new records loaded into the City data should have been loaded into the [Dimension].[City] table in the Azure Synapse Analytics DW.  

## Stage 3 Architecture
![The Solution diagram is described in the text following this diagram.](../../../images/Challenge3.png)

## Learning Resources
1. [Load data into DW via Polybase](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/load-data-from-azure-blob-storage-using-polybase)
1. [Incrementally load multiple tables in Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-incremental-copy-multiple-tables-portal)
1. [Azure Data Factory Copy Activity](https://docs.microsoft.com/en-us/azure/data-factory/copy-activity-overview)

## Tips
1. There are multiple ways to load data via Polybase.  You could potentially use:
    - ["CTAS" with "External Tables"](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-table-as-select-azure-sql-data-warehouse?toc=/azure/synapse-analytics/sql-data-warehouse/toc.json&bc=/azure/synapse-analytics/sql-data-warehouse/breadcrumb/toc.json&view=azure-sqldw-latest)
    - ["Copy Command"](https://docs.microsoft.com/en-us/sql/t-sql/statements/copy-into-transact-sql?view=azure-sqldw-latest) in Azure Synapse Analytics or 
    - [Copy Data task in Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-sql-data-warehouse)
1. For MERGE process, you should reuse or replicate logic found in the Integration.MigratedStaged____Data stored procedures
1. Optimize where possible by using dynamic code, and executing tasks in parallel.
1. Additional information on using Lookup Tasks and expressions in Azure Data Factory can be found [here](https://www.cathrinewilhelmsen.net/2019/12/23/lookups-azure-data-factory/)

## Additional Challenges
1. Enhance the pipeline so that it can be used to load all tables.  Steps required for this would include:
    - Update Azure Data Factory to use expressions and parameters wherever possible
    - Add a ForEach Loop to iterate through all tables and execute your pipeline for each one (note: Dimensions need to be loaded prior to Facts)
1. Leverage [partition switching](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-partition?toc=/azure/synapse-analytics/toc.json&bc=/azure/synapse-analytics/breadcrumb/toc.json#partition-switching) for tables with large-scale modifications (UPDATES)
1. Refactor the T-SQL code in Polybase to leverage Python or Scala
1. Build out these data pipelines using Azure Mapping Data Flows

