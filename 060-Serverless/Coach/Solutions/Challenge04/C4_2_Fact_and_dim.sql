/*****************************************************************************************************************************
What the hack - Serverless - Delta
CHALLENGE 04
--Delta
--Data is partitioned by OrderDateKey for the files of FactInternetSales.
--The query bellow intents to simulate a join between fact and dimension.
--Run more than once. Serveless cache temporarily the query after the first run
--it will take around 1 minute to execute. Review on the storage side how the partition physically works for serverless
Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/

SELECT
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, COUNT_BIG(distinct Fis.SalesOrderNumber) SalesOrderNumber_COUNT
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM (SELECT * FROM
				OPENROWSET(-----------Replace the storage path \container
				BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Delta/Factinternetsales/',
   				FORMAT = 'Delta'
			) AS FactInternetSales )AS FIS 
INNER JOIN 
	     (SELECT *FROM
					OPENROWSET(-----------Replace the storage path \container
					BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Delta/Factinternetsalesreasons',
   					FORMAT = 'Delta'
				) AS FactInternetSalesReason )AS Fisr 
ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
INNER JOIN
   (SELECT * FROM
				OPENROWSET(-----------Replace the storage path \container
					BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Delta/Dimsalesreasons/',
   					FORMAT = 'Delta'
				) AS DimSalesReason )AS Dsr 
ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
WHERE Fis.OrderDateKey >= 20120307 and Fis.OrderDateKey < 20120510
		AND Fis.SalesTerritoryKey BETWEEN 5 and 10
		AND Dsr.SalesReasonName = 'Demo Event'
GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName


