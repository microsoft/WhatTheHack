# 	Challenge 2 -- Data Lake integration

[< Previous Challenge](../Challenge1/readme.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](../Challenge3/Readme.md)

## Introduction
WWI importers realizes they need to further modernize their data warehouse and wants to proceed to the second stage.  They are starting to reach capacity constraints on their data warehouse and need to offload data files from the relational database.  Likewise, they are receiving more data in json and csv file formats.  They've been discussing re-engineering their data warehouse to accomodate larger data sets, semi-structured data and real-time ingestion of data.  They would like to conduct a POC on the Data Lake and see how to best to design it for integration into the Data Warehouse.  For this challenge, WWI wants us to build out the data lake and show how to load data into the lake from an on-premise data source. 

## Description
The objective of this challenge is to build a Data Lake with Azure Data Lake Store (ADLS) Gen 2.  The Data Lake will be a staging area where all our source system data files reside. We need to ensure this Data Lake is well organized and doesn't turn into a swamp. This challenge will help us organize the folder sturcture and setup security to prevent unauthorized access.  Lastly, we will extract data from the WWI OLTP platform and store it in the Data Lake.  The OLTP platform is on-premise so you will need to build a hybrid archtiecture to integrate it into Azure.  Keep in mind that the pipeline that you build will become the <b>EXTRACT</b> portion of the new E-L-T process.  Based on requirements for this new process, you will need to be sure that changes can be captured on a daily basis.  Stored procedures have already been compiled in the source OLTP database, but they will require data parameters in order to be executed.  This means that the new pipeline will need to be able to generate and pass those parameters to the source.  The first requirement is to build a functional POC that is able to move a single dataset to the new ADLS Gen 2 data lake. Ideally, it would be nice to make the process table driven so that new pipelines do not need to be created for each additional table that needs to be copied. (Optional, sharing to give insights on end-state.


## Environment Setup
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

Modify the [Integration].[GetCityUpdates] stored procedure in the same OLTP database to remove the Location field from the result set returned.  

SELECT [WWI City ID], City, [State Province], Country, Continent, [Sales Territory],
           Region, Subregion,

		   -- [Location] geography,                       -->Remove due to data type compatibility issues

		   [Latest Recorded Population], [Valid From],
           [Valid To]
    FROM #CityChanges
    ORDER BY [Valid From];
~~~~
2. Execute the query below in the Azure Synapse DW database to update the parameter used as the upper bound for the ELT process:
~~~~
UPDATE INTEGRATION.LOAD_CONTROL
SET LOAD_DATE = getdate()
~~~~

3. Deploy a new storage account resource.
    - Create a new Azure Storage Account and enable Data Lake Storage Gen 2 (Note: set Hierarchical namespace property to Enabled).  Step by step directions can be found [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&tabs=azure-portal)

4. Define directory structure to support data lake use cases.  [This document](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-best-practices#batch-jobs-structure) describes this concept in more detail.

    - .\IN\WWIDB\ [TABLE]\ - This will the sink location used as the landing zone for staging your data.
    - .\RAW\WWIDB\ [TABLE]\{YY}\{MM}\{DD}\ - This will be the location for downstream systems to consume the data once it has been processed.
    - .\STAGED\WWIDB\ [TABLE]\{YY}\{MM}\{DD}\ 
    - .\CURATED\WWIDB\ [TABLE]\{YY}\{MM}\{DD}\

5. Configure folder level security in your new data lake storage.  Supporting documentation for securing ADLS Gen 2 can be found [here](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control). 

6. Deploy a new Azure Data Factory resource in your subscription.  You can find a similar sample explained [here](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-hybrid-copy-data-tool).  
<br><b>Note: steps below explain how to create applicable pipelines and activities in more detail.</b>

7. Create a pipeline to copy data into ADLS. Keep in mind that this pipeline will serve as the <b>EXTRACT</b> portion of WWI's new ELT process.  There are stored procedures already present in the OLTP database that can be used to query the source data, but they will require start and end date parameters in order to be executed.

    - Using instructions found in [here](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-incremental-copy-multiple-tables-portal#create-a-data-factory), access the Azure Data Factory UI and create necessary linked services, datasets, pipelines, and activities (Note: JSON for each of the objects below can be found in the resources folder).  
        - Linked Services:
            - SQL Server connection for WideWorldImporters database  
            <br><b>NOTE: you will need to create a new Self Hosted Integration Runtime IF your source SQL server is not open to the public. This is an advanced topic and not required for Challenge 2</b>
            - Azure Data Lake Gen 2
        - Datasets:
            - WideWorldImporters 
            - Azure Data Lake
        - Pipeline 1:
            - Activities:<br>
                    1. Create LOOKUP activities to query the DW and assign values for the last refresh time of the [City] table. Instructions can be found [here](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-incremental-copy-portal)<br>
                    2. Create a COPY acitvity with properties below. Guide can be found [here](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-hybrid-copy-portal<br>
                        - > Source Dataset: WideWorldImporters - Stored Procedure [Integration].[GetCityUpdates]
                        <br><b>Note: You will need to modify this stored procedure to ensure that the [Location] field is excluded from the results.  Otherwise this data will cause errors due to incompatibility with Azure Data Factory.  You can find the updated procedure in the Scripts folder in the attached Solution Guide.</b><br>
                        - > Sink Dataset: ADLS Gen2 - IN\WWIDB\CITY\<br>
                NOTE: by using expressions and parameters in Linked Services, Datasets, and source query, you can make this pipeline dynamic and reuse for all tables.  See example of this pattern [here](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-incremental-copy-portal)
                
        - Create a 2nd pipeline with a ForEach Loop activity to iterate through the list of tables and execute Pipeline created above for each table.  A Guide describing how to implement this pattern can be found [here](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-bulk-copy-portal).<br>
            - Activities:<br>
                - LOOKUP Activity
                    - query [Integration].[ETL Cutoff] table in Azure Synapse DW to return list of tables<br>
                - FOREACH Activity
                    - iterate over list of tables
                    - Execute Pipeline task to execute pipeline create above (Note: you will need to pass in table name as parameter)