/*****************************************************************************************************************************
What the hack - Serverless - CETAS
CHALLENGE 04
-the CETAS was consolidated in a parquet file which will be query as follow
--Show on the storage side where the CETAS and file are
Contributors: Liliam Leme - Luca Ferrari
https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/how-to-use-cetas-on-serverless-sql-pool-to-improve-performance/ba-p/3548040
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-cetas

*****************************************************************************************************************************/

--CETAS Query.
--Note data was consolidated when you use this solution and it is muh faster.
SELECT
	 CTAS.SalesTerritoryKey
	,CTAS.OrderDateKey
	,CTAS.SalesReasonName
	,CTAS.SalesOrderNumber_COUNT
	,CTAS.SalesAmount_AVG
	, CTAS.OrderQuantity_AVG
FROM  Factinternetsalesreasons_Consolidated CTAS
WHERE CTAS.OrderDateKey >= 20120307 and CTAS.OrderDateKey < 20120402
		AND CTAS.SalesTerritoryKey BETWEEN 5 and 10
		AND CTAS.SalesReasonName = 'Demo Event'