/*****************************************************************************************************************************
What the hack - Serverless - Wildcard
CHALLENGE 03 - Exercise 02 
---Wildcard use wisely.
	--Serverless need to fetch all data before can apply filters.
	--Using more star wildcards at different levels, Serverless needs to scan each folder content and then apply the filter. 
	--Wildcard it is a option to be used, however better ans specific filters will be logically faster to get the information

	--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool#push-wildcards-to-lower-levels-in-the-path

Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/
USE Serverless
GO

/****************************************************************************************
--STEP 1 of 3
-- Multilevel wildcard search
****************************************************************************************/

SELECT
 *
FROM
    OPENROWSET(-----------Replace the storage path where the files were created 
        BULK  'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/*/*/*/part-00070-f15597b8-9dec-4a0c-a269-4f0fa421aa25.c000.snappy.parquet',
        FORMAT = 'PARQUET'
    ) AS [result]


/****************************************************************************************
--STEP 2 of 3
-- Restricting a little wildcard search
****************************************************************************************/

SELECT
 *
FROM
    OPENROWSET(-----------Replace the storage path where the files were created 
             BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/Factinternetsales_partitioned/*/*/part-00070-f15597b8-9dec-4a0c-a269-4f0fa421aa25.c000.snappy.parquet',
        FORMAT = 'PARQUET'
    ) AS [result]


/****************************************************************************************
--STEP 3 of 3
-- Not using wildcard
****************************************************************************************/
SELECT
 *
FROM
    OPENROWSET(-----------Replace the storage path where the files were created 
             BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/Factinternetsales_partitioned/year=2016/month=12/part-00070-f15597b8-9dec-4a0c-a269-4f0fa421aa25.c000.snappy.parquet',
        FORMAT = 'PARQUET'
    ) AS [result]


--- Serverless need to fetch all data before can apply filters.
--Using more star wildcards at different levels, Serverless needs to scan each folder content and then apply the filter. 
--Wildcard it is a option to be used, however better ans specific filters will be logically faster to get the information

