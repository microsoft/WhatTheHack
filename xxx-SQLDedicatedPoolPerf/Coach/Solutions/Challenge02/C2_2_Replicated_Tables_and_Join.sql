/****************************************************************************************
--Despite query is using Replicated tables is incurring in some data movement.
--Could you explain why ?
--How can you avoid it ?

--Tips:

https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-request-steps-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables
https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-pdw-replicated-table-cache-state-transact-sql?toc=/azure/synapse-analytics/sql-data-warehouse/toc.json&bc=/azure/synapse-analytics/sql-data-warehouse/breadcrumb/toc.json&view=azure-sqldw-latest&preserve-view=true
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-dms-workers-transact-sql?view=aps-pdw-2016-au7

****************************************************************************************/

/****************************************************************************************
STEP 1 of 7 - Invalidating the replicated table cache
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables#what-is-a-replicated-table

****************************************************************************************/

IF EXISTS
(
	SELECT * FROM sys.pdw_replicated_table_cache_state 
		WHERE OBJECT_NAME(object_id) IN('DimProduct','DimCustomer','DimSalesTerritory') 
			and State = 'Ready'
)
BEGIN
	--Invalidate Cache (if any)
	UPDATE Sales.DimCustomer Set EmailAddress = '___' + EmailAddress
	UPDATE Sales.DimCustomer Set EmailAddress = REPLACE(EmailAddress,'___','')
	UPDATE Sales.DimProduct SET [DaysToManufacture] = [DaysToManufacture] + 1
	UPDATE Sales.DimProduct SET [DaysToManufacture] = [DaysToManufacture] - 1
	UPDATE Sales.DimSalesTerritory Set SalesTerritoryRegion = '___' + SalesTerritoryRegion
	UPDATE Sales.DimSalesTerritory Set SalesTerritoryRegion = REPLACE(SalesTerritoryRegion,'___','')
	--UPDATE Sales.DimSalesReason Set SalesReasonName = '___' + SalesReasonName
	--UPDATE Sales.DimSalesReason Set SalesReasonName = REPLACE(SalesReasonName,'___','')
END
GO


/****************************************************************************************
STEP 2 of 7 - Run this query 
****************************************************************************************/

SELECT
	Dc.CustomerKey
	, Dc.FirstName + ' ' + Dc.LastName
	, Dp.ProductAlternateKey
	, Dst.SalesTerritoryRegion
	, COUNT_BIG(distinct Fis.SalesOrderNumber) SalesOrderNumber_COUNT
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Sales.FactInternetSales Fis
	INNER JOIN Sales.DimProduct Dp
		ON Fis.ProductKey = Dp.ProductKey
			And CAST(CAST(Fis.OrderDateKey AS CHAR(8)) AS DATETIME2) between Dp.StartDate and Dp.EndDate
	INNER JOIN Sales.DimCustomer Dc
		ON Fis.CustomerKey = Dc.CustomerKey
	INNER JOIN Sales.DimSalesTerritory Dst
		ON Dst.SalesTerritoryKey = Fis.SalesTerritoryKey
WHERE Fis.OrderDateKey >= '20210101' and Fis.OrderDateKey < '20211231' 
GROUP BY Dc.CustomerKey
	, Dc.FirstName + ' ' + Dc.LastName
	, Dp.ProductAlternateKey
	,  Dst.SalesTerritoryRegion
OPTION(LABEL = 'FactInternetSales - No Replicate Table Cache')
GO

/****************************************************************************************
STEP 3 of 7 - Identify the request_id for the query and its MPP execution plan
Multiple Broadcastmove operations are affecting performances due to Replicate table cache not available yet
*****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'FactInternetSales - No Replicate Table Cache'
SELECT * FROM Sys.dm_pdw_request_steps WHERE request_id = 'request_id'

--collecting information about moved bytes and rows. Change step_id with the Broadcastmove step_id
SELECT * FROM sys.dm_pdw_dms_workers WHERE request_id = 'request_id' and step_index = step_id
GO


/****************************************************************************************
STEP 4 of 7 - Compare this execution and its MPP plan wih the previous one
*****************************************************************************************/

DBCC DROPCLEANBUFFERS()
DBCC FREEPROCCACHE()
GO

SELECT
	Dc.CustomerKey
	, Dc.FirstName + ' ' + Dc.LastName
	, Dp.ProductAlternateKey
	, Dst.SalesTerritoryRegion
	, COUNT_BIG(distinct Fis.SalesOrderNumber) SalesOrderNumber_COUNT
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Sales.FactInternetSales Fis
	INNER JOIN Sales.DimProduct Dp
		ON Fis.ProductKey = Dp.ProductKey
			And CAST(CAST(Fis.OrderDateKey AS CHAR(8)) AS DATETIME2) between Dp.StartDate and Dp.EndDate
	INNER JOIN Sales.DimCustomer Dc
		ON Fis.CustomerKey = Dc.CustomerKey
	INNER JOIN Sales.DimSalesTerritory Dst
		ON Dst.SalesTerritoryKey = Fis.SalesTerritoryKey
WHERE Fis.OrderDateKey >= '20210101' and Fis.OrderDateKey < '20211231' 
GROUP BY Dc.CustomerKey
	, Dc.FirstName + ' ' + Dc.LastName
	, Dp.ProductAlternateKey
	,  Dst.SalesTerritoryRegion
OPTION(LABEL = 'FactInternetSales - With Replicate Table Cache')
GO


/****************************************************************************************
STEP 5 of 7 - this execution doesn't need BroadcastMove, replicate table is in place
*****************************************************************************************/

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'FactInternetSales - With Replicate Table Cache'
SELECT * FROM Sys.dm_pdw_request_steps WHERE request_id = 'request_id'



/****************************************************************************************
STEP 6 of 7 - How to check if the cache is available or not
https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-pdw-replicated-table-cache-state-transact-sql?view=azure-sqldw-latest
*****************************************************************************************/

SELECT OBJECT_NAME(object_id) table_name, [state] FROM sys.pdw_replicated_table_cache_state
WHERE OBJECT_NAME(object_id) IN('DimProduct','DimCustomer','DimSalesTerritory') 
GO

/****************************************************************************************
STEP 7 of 7 - How to train replicate table cache
*****************************************************************************************/

SELECT OBJECT_NAME(object_id) table_name, [state] FROM sys.pdw_replicated_table_cache_state
WHERE OBJECT_NAME(object_id) = 'DimEmployee'
GO

--this trains the cache
SELECT TOP 50 * FROM Sales.DimEmployee
GO

--Wait few seconds
SELECT OBJECT_NAME(object_id) table_name, [state] FROM sys.pdw_replicated_table_cache_state
WHERE OBJECT_NAME(object_id) = 'DimEmployee'
GO