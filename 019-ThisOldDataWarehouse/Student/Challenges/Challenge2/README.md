# 	Challenge 2 -- Data Lake integration

[< Previous Challenge](../Challenge1/readme.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](../Challenge3/README.md)

## Introduction
WWI importers realize they need to further modernize their data warehouse and wants to proceed to the second stage.  They are starting to reach capacity constraints on their data warehouse and need to offload data files from the relational database.  Likewise, they are receiving more data in json and csv file formats.  They've been discussing re-engineering their data warehouse to accomodate larger data sets, semi-structured data and real-time ingestion of data.  They like to conduct a POC on the Data Lake and see how to best to design it for integration into the Data Warehouse.  For this challenge, WWI wants us to build out the data lake and show how to load data into the lake from an on-premise data source. 

## Description
The objective of this challenge is to build a Data Lake with Azure Data Lake Store (ADLS) Gen 2.  The Data Lake will be a staging area where all our source system data files reside. We need to ensure this Data Lake is well organized and doesn't turn into a swamp. This challenge will help us organize the folder sturcture and setup security to prevent unauthorized access.  Lastly, we will extract data from the WWI OLTP platform and store it in the Data Lake.  The OLTP platform is on-premise so you will need to build a hybrid archtiecture to integrate it into Azure.  Keep in mind that the pipeline that you build will become the EXTRACT portion of the new E-L-T process. The first requirement is to build a functional POC that is able to move a single dataset to the new ADLS Gen 2 data lake. Ideally, it would be nice to make the process table driven so that new pipelines do not need to be created for each additional table that needs to be copied. (Optional, sharing to give insights on end-state.)

Note: This challenge is intended to build upon challenge 1, and you should try to reuse content wherever possible.

## Setup
Prior to starting this challenge, you should ensure that there are changes in the City data captured from Wide World Importers OLTP Database.  Execute the script below to insert/change data in the source, and update necessary configuration values.

1. Execute queries below in the Wide World Importers Database to update 10 existing records and insert 1 new record. 
~~~~
UPDATE T
SET [LatestRecordedPopulation] = LatestRecordedPopulation + 1000
FROM (SELECT TOP 10 * from [Application].[Cities]) T

INSERT INTO [Application].[Cities]
	(
        [CityName]
        ,[StateProvinceID]
        ,[Location]
        ,[LatestRecordedPopulation]
        ,[LastEditedBy]
	)
    VALUES
    (
		'NewCity' + CONVERT(char(19), getdate(), 121)
        ,1
        ,NULL
        , 1000
        ,1
	)
;

2. Modify the [Integration].[GetCityUpdates] stored procedure in the same OLTP database to remove the Location field from the result set returned.  
~~~~
SELECT [WWI City ID], City, [State Province], Country, Continent, [Sales Territory],
           Region, Subregion,

		   -- [Location] geography,                       -->Remove due to data type compatibility issues

		   [Latest Recorded Population], [Valid From],
           [Valid To]
    FROM #CityChanges
    ORDER BY [Valid From];

2. Execute the query below in the Azure Synapse DW database to update the parameter used as the upper bound for the ELT process:

UPDATE INTEGRATION.LOAD_CONTROL
SET LOAD_DATE = getdate()

## Success Criteria
1. Deploy a new storage account resource.
2. Define directory structure to support data lake use cases as follows:
    - .\IN\WWIDB\ [TABLE]\ - This will be the sink location used as the landing zone for staging your data.
    - .\RAW\WWIDB\ [TABLE]\{YY}\{MM}\{DD}\ - This will be the location for downstream systems to consume the data once it has been processed.
    - .\STAGED\WWIDB\ [TABLE]\{YY}\{MM}\{DD}\ 
    - .\CURATED\WWIDB\ [TABLE]\{YY}\{MM}\{DD}\
3. Configure folder level security in your new data lake storage 
    - only your ETL job should be able to write to your \IN directory
    - you should be able to grant individual access to users who may want to access your \RAW directory based on AAD credentials
4. Deploy Azure Data Factory 
5. Create a pipeline to copy data into ADLS.  Your pipeline will need the following components:
    - Lookup Activity that queries the [Integration].[ETL Cutoff Table] in your Synapse DW to get the last refresh date for the City data. This result will be used as the @LastCutoff parameter in your copy activity.  The LastCutoff is similar to your Start Date in a range query.
    - Lookup activity that queries [Integration].[Load Control] table in your Synapse DW to get the current refresh date. This result will be used as the @NewCutoff parameter in your copy activity. The NewCutoff is similar to your End Date in a range query.
    - Copy Data activity that uses the [Integration].[GetCityUpdates] stored procedure in your WideWorldImporters OLTP database as your source, and the .\IN\WWIDB\City\ directory as the sink 
    <br><b>Note: You will need to modify this stored procedure to ensure that the [Location] field is excluded from the results.  Otherwise this data will cause errors due to incompatibility with Azure Data Factory</b>
6. Once you have executed your new pipeline, there should be a .txt file with the 11 updated records from the City table in the \In\WWIDB\City\ folder of your data lake.
<br><b>Note: you can execute your new pipeline by clicking the "Debug" button or adding a trigger from the UI designer.</b>

## Stage 2 Architecture
![The Solution diagram is described in the text following this diagram.](../../../images/Challenge2.png)

## Learning Resources
1. [Begin by creating a new Azure Storage account](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&tabs=azure-portal).
1. [Data Lake Storage Best Practices](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-best-practices)
1. [Azure Data Factory Copy Activity](https://docs.microsoft.com/en-us/azure/data-factory/copy-activity-overview)
1. [Copy data from local on-premise SQL Server into cloud storage](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-hybrid-copy-portal)
1. [Incremental Loads Design Pattern in Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-incremental-copy-multiple-tables-portal)
1. [Service Principal in Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/data-factory-service-identity)
1. [Access Control in Azure Data Lake Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control)
1. [Data Lake Planning](https://www.sqlchick.com/entries/2016/7/31/data-lake-use-cases-and-planning)
1. [Naming Conventions](https://www.sqlchick.com/entries/2019/1/20/faqs-about-organizing-a-data-lake)

## Tips
1. Things to consider when creating new data lake storage account:
    - What type of storage account should you leverage? (Gen 1 or Gen2)
    - How can you setup a hierarchical folder structure? Why?
    - What are your SLAs for data retrievals?  (Access Tier)
1. Things to consider when creating new data lake folder structure:
    - What types of data will you need to be able to support?
    - What types of processes will you need to be able to support?
    - How will you secure access to directories?
1. In addition to using the azure portal directly, you can view and manage your new storage account using the [Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/) 
1. Be sure to review the [Integration].[ETL Cutoff] and [Integration].[Load Control] tables in your Synapse DW prior to executing this task.  If dates are not set correctly, the source stored procedure will not return any data.
1. Additional information on using Lookup Tasks and expressions in Azure Data Factory can be found [here](https://www.cathrinewilhelmsen.net/2019/12/23/lookups-azure-data-factory/)

## Additional Challenges
1. Parameterize the source and sink properties in your pipeline where possible so that you can re-use the same pipeline for all additional tables being copied
1. Develop an incremental load pattern for each copy activity to extract the data from the source table.  This will prevent us from doing a full load each night and large load times.
1. [Deploy Azure Databricks workspace, mount your new storage and enable interactive queries and analytics!](https://docs.microsoft.com/en-us/azure/azure-databricks/databricks-extract-load-sql-data-warehouse?toc=/azure/databricks/toc.json&bc=/azure/databricks/breadcrumb/toc.json)