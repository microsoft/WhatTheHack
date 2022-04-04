/****************************************************************************************
--Why is the query "slow" ?
--Is there a way to optimize further this query ?


--Tips:

https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-request-steps-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-sql-requests-transact-sql?view=aps-pdw-2016-au7

https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute#what-is-a-distributed-table
https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/how-to-minimize-data-movements-compatible-and-incompatible-joins/ba-p/1807104#:~:text=Incompatible%20Joins%20is%20a%20join,can%20negatively%20impact%20query%20performance.&text=Incompatible%20%E2%80%93%20requires%20data%20movement%20before%20the%20join.
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute#choose-a-distribution-column

****************************************************************************************/


/****************************************************************************************
STEP 1 of 6 - Training Replicated Table Cache for DimSalesReason to avoid Broadcastmove
****************************************************************************************/
IF EXISTS
(
	SELECT * FROM sys.pdw_replicated_table_cache_state 
		WHERE OBJECT_NAME(object_id) = 'DimSalesReason' 
			and State = 'NotReady'
)
BEGIN
	--Training the cache
	SELECT * FROM Sales.DimSalesReason
END
GO

SELECT * FROM sys.pdw_replicated_table_cache_state 
WHERE OBJECT_NAME(object_id) = 'DimSalesReason' 
GO


/****************************************************************************************
STEP 2 of 6 - Execute this query
****************************************************************************************/
SELECT 
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, COUNT_BIG(distinct Fis.SalesOrderNumber) SalesOrderNumber_COUNT
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Sales.FactInternetSales Fis
	INNER JOIN Sales.FactInternetSalesReason Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Sales.DimSalesReason Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
WHERE Fis.OrderDateKey >= 20120101 and Fis.OrderDateKey < 20211231
		AND Fis.SalesTerritoryKey BETWEEN 5 and 10
		AND Dsr.SalesReasonName = 'Demo Event'
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'Incompatible Join')
GO

/****************************************************************************************
STEP 3 of 6 - Check generated MPP plan
most expensive step is ShuffleMoveOperation (step_index = 2) which moves approx 73.569.026
****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Incompatible Join'
SELECT * FROM Sys.dm_pdw_request_steps WHERE request_id = 'request_id'
GO


/****************************************************************************************
STEP 4 of 6 - fixing the issue changing the distribution column
Original Sales.FactInternetSales has been created using HASH(ProductKey) which is not good for this query
Sales.FactInternetSales and Sales.FactInternetSalesReason use SalesOrderNumber and this caused the biggest Shufflemove 
Which move all the rows that meet Where clauses from Sales.FactInternetSales to perform subsequent joins and aggregation

Redistribute Sales.FactInternetSales using SalesOrderNumber remove the first Shufflemove and improve performance.


****************************************************************************************/

RENAME OBJECT Sales.FactInternetSales TO FactInternetSales_ByProduct
GO


CREATE TABLE [Sales].[FactInternetSales]
WITH
(
	DISTRIBUTION = HASH ( [SalesOrderNumber] ),
	CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM [Sales].[FactInternetSales_ByProduct]
GO

CREATE STATISTICS [OrderDateKey] ON [Sales].[FactInternetSales]([OrderDateKey]);
CREATE STATISTICS [SalesTerritoryKey] ON [Sales].[FactInternetSales]([SalesTerritoryKey]);
CREATE STATISTICS [SalesOrderNumber] ON [Sales].[FactInternetSales]([SalesOrderNumber]);
CREATE STATISTICS [SalesOrderLineNumber] ON [Sales].[FactInternetSales]([SalesOrderLineNumber]);
GO


/****************************************************************************************
STEP 5 of 6 - Run the query again and Check generated MPP plan
****************************************************************************************/

SELECT 
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, COUNT_BIG(distinct Fis.SalesOrderNumber) SalesOrderNumber_COUNT
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Sales.FactInternetSales Fis
	INNER JOIN Sales.FactInternetSalesReason Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Sales.DimSalesReason Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
WHERE Fis.OrderDateKey >= 20120101 and Fis.OrderDateKey < 20211231
		AND Fis.SalesTerritoryKey BETWEEN 5 and 10
		AND Dsr.SalesReasonName = 'Demo Event'
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'Compatible Join')
GO

/****************************************************************************************
STEP 6 of 6 - Check generated MPP plan
ShuffleMoveOperation which moved approx 73.569.026 disappeared.
Still there is 1 shufflemove but it doesn't affect performance and it's related to aggregations
****************************************************************************************/

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Incompatible Join'
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] =  'Compatible Join'
SELECT * FROM Sys.dm_pdw_request_steps WHERE request_id = 'request_id'
SELECT * FROM Sys.dm_pdw_request_steps WHERE request_id = 'request_id'
GO
