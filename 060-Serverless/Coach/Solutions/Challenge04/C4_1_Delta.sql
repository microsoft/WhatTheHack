/*****************************************************************************************************************************
What the hack - Serverless - Delta file
CHALLENGE 04 
---Queriyng delta 
	--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/resources-self-help-sql-on-demand?tabs=x80070002

Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/
USE Serverless
GO
/****************************************************************************************
--STEP 1 of 2
-- Checking the JSON if there is permission on the folder. If there is no permission it will fail
Goal here is checking the delta_log file used during the query execution.
****************************************************************************************/

SELECT 
		TOP  10 *
FROM OPENROWSET(BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Delta/Factinternetsales/_delta_log/*.json',FORMAT='csv', FIELDQUOTE = '0x0b', FIELDTERMINATOR ='0x0b',ROWTERMINATOR = '0x0b') 
WITH (line VARCHAR(MAX)) as logs


-----------------------------------------------------------------------------------------------
--STEP 2 of 2
--2)Check out storage partitioned structure and the query time execution
--Querying  Partitioned files according to a filter. The filter is the partition itself.
--Goal here is query FactInternetSales_Delta which is partitioned by  OrderDateKey
-----------------------------------------------------------------------------------------------
SELECT
 *
FROM
    OPENROWSET(
        BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Delta/Factinternetsales/',
        FORMAT = 'Delta'
    ) AS [result]
WHERE [OrderDateKey] =  20120307





