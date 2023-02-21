/*****************************************************************************************************************************
What the hack - Serverless - How to work with it
CHALLENGE 02 - Excercise 01 - Data types

https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/query-parquet-files#automatic-schema-inference
https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool#data-types

Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/

/****************************************************************************************
STEP 1 of 2 - How to get inferred data type
****************************************************************************************/

--Just check inferred data types with no reading data
EXEC sp_describe_first_result_set N'
 SELECT
        *
    FROM  
        OPENROWSET(
            BULK ''https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolders/Parquet/Factinternetsales/'',
            FORMAT=''PARQUET''
        ) AS Rows';
GO

--No predicate pushdown
SELECT TOP 10
    PRODUCTKEY
	,DUEDATEKEY
	,CUSTOMERKEY
FROM  
    OPENROWSET(
        BULK 'https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolders/Parquet/Factinternetsales/',
        FORMAT='PARQUET'
    ) AS Rows
WHERE SALESORDERNUMBER = 'SO23532017081857'
GO

--Predicate pushdown
SELECT TOP 10
    PRODUCTKEY
	,DUEDATEKEY
	,CUSTOMERKEY
FROM  
    OPENROWSET(
        BULK 'https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolders/Parquet/Factinternetsales/',
        FORMAT='PARQUET'
    ) 
WITH (
    PRODUCTKEY INT
	,DUEDATEKEY INT
	,CUSTOMERKEY INT 
	,SALESORDERNUMBER VARCHAR(20) COLLATE Latin1_General_100_BIN2_UTF8 
    ) AS ManualInferred
WHERE SALESORDERNUMBER = 'SO23532017081857'


