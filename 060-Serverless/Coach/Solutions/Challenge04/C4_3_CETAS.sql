
/*****************************************************************************************************************************
What the hack - Serverless - CETAS
CHALLENGE 04
--CETAS as a performance solution
--You can use CREATE EXTERNAL TABLE AS SELECT (CETAS) in dedicated SQL pool or serverless SQL pool to complete the following tasks:
	--Create an external table
	--Export, in parallel, the results of a Transact-SQL SELECT. When using serverless SQL pool, CETAS is used to create an external table 
	  and export query results to Azure Storage Blob or Azure Data Lake Storage Gen2
--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-cetas
Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/
CREATE EXTERNAL TABLE Factinternetsalesreasons_Consolidated
WITH (
    LOCATION = 'Parquet/Factinternetsalesreasons_Consolidated/',
    DATA_SOURCE = MSIFastHack_DataSource,
    FILE_FORMAT  = Parquet_FileFormat

)  
AS
SELECT
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, COUNT_BIG(distinct Fis.SalesOrderNumber) SalesOrderNumber_COUNT
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM 

FROM (SELECT
		 *
		FROM
			OPENROWSET(-----------Replace the storage path \container
				BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Delta/Factinternetsales/',
   
				FORMAT = 'Delta'
			) AS FactInternetSales )AS FIS 

INNER JOIN 
	     (SELECT
			 *
			FROM
				OPENROWSET(-----------Replace the storage path \container
					BULK 'hhttps://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Delta/Factinternetsalesreasons',
   
					FORMAT = 'Delta'
				) AS FactInternetSalesReason )AS Fisr 

ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
INNER JOIN
   (SELECT
			 *
			FROM
				OPENROWSET(-----------Replace the storage path \container
					BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Delta/Dimsalesreasons/',
   
					FORMAT = 'Delta'
				) AS DimSalesReason )AS Dsr 
ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName



