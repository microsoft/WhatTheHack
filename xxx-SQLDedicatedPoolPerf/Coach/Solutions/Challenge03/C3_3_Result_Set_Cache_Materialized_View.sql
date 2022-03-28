/****************************************************************************************
--Is there a way to increase performance for this query ?
--And what if your Dataset is bigger than 10GB ?


--Tips:
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-result-set-caching-transact-sql?toc=/azure/synapse-analytics/sql-data-warehouse/toc.json&bc=/azure/synapse-analytics/sql-data-warehouse/breadcrumb/toc.json&view=azure-sqldw-latest&preserve-view=true
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-materialized-views
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-materialized-view-as-select-transact-sql?view=azure-sqldw-latest&preserve-view=true
****************************************************************************************/

--Pointing Master
ALTER DATABASE Fasthack_performance SET RESULT_SET_CACHING ON;
GO



SELECT 
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Sales.FactInternetSales Fis
	INNER JOIN Sales.FactInternetSalesReason Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Sales.DimSalesReason Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'Result Set Cache OFF')
GO

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Result Set Cache OFF'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'QID2011'
GO



--Pointing DWH
SELECT 
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Sales.FactInternetSales Fis
	INNER JOIN Sales.FactInternetSalesReason Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Sales.DimSalesReason Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'Result Set Cache ON')
GO

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Result Set Cache ON'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'QID1935'

GO


SET RESULT_SET_CACHING OFF
GO

CREATE MATERIALIZED VIEW Averages
WITH
(
	Distribution = HASH(SalesOrderNumber)
	, CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT
	Fis.SalesOrderNumber
	, Fis.SalesTerritoryKey
	, Fis.OrderDateKey
	, Dsr.SalesReasonName
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Sales.FactInternetSales Fis
	INNER JOIN Sales.FactInternetSalesReason Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Sales.DimSalesReason Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
	GROUP BY Fis.SalesOrderNumber, Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
GO

DBCC DROPCLEANBUFFERS()
DBCC FREEPROCCACHE()
GO

SELECT
	Fis.SalesTerritoryKey
	, Fis.OrderDateKey
	, Dsr.SalesReasonName
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Sales.FactInternetSales Fis
	INNER JOIN Sales.FactInternetSalesReason Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Sales.DimSalesReason Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'Materialized view')
GO

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Materialized view'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'QID1981'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'QID1924'
GO
