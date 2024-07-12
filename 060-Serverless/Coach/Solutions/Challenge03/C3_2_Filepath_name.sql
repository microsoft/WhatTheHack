/*****************************************************************************************************************************
What the hack - Serverless - File Functions
CHALLENGE 03 - Exercise 02 
-- Review file functions usage as alternative to wildcards.

--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-data-storage#filename-function
Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/
USE Serverless
GO

--===================================================================================================================
--Group by number of rows on the file
-- the goal here is show how useful can those functions are:
--this query will list the number for rows per filename. This can be used as a validation of an ETL Load for example:
--===================================================================================================================
SELECT
    cto.filename() AS [filename]
    ,COUNT_BIG(*) AS [rows]
FROM  
    OPENROWSET(
        BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/Factinternetsales_partitioned/year=2016/*/*.parquet',
        FORMAT='PARQUET'
    ) cto
GROUP BY cto.filename();


--===================================================================================================================
--Query per filename. File function do partition elimnation as if the data was partioned.
--Note how the function organizes the path and helps to filter the filename
--If your stored data isn't partitioned, consider partitioning it. 
--That way you can use these functions to optimize queries that target those files

--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-data-storage#filename-function
--===================================================================================================================

SELECT
 *
 , cto_name.filepath(), cto_name.filepath(1) AS [part_1]   -- ,cto_name.filepath(2) AS [part_2]
FROM OPENROWSET(
BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/Factinternetsales_partitioned/year=2016/*/*.parquet',
    FORMAT='PARQUET')cto_name
 WHERE
     --  cto_name.filepath() like ('%OrderDateKey=20010707%') --> you can use this as alternative to filter the folder in case someeone ask. It takes around 3.30
     ---BULK 'https://administrators.blob.core.windows.net/filesystemdatalake/sqlserverlessanalitics/FactInternetSales_Delta/*/*.parquet',
    --AND 
    cto_name.filename() IN ('part-00147-f15597b8-9dec-4a0c-a269-4f0fa421aa25.c000.snappy.parquet')
