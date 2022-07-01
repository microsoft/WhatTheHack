/****************************************************************************************
--Is there a way to increase performance for this query ?
--And what if your Dataset is bigger than 10GB ?


--Tips:
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-result-set-caching-transact-sql?toc=/azure/synapse-analytics/sql-data-warehouse/toc.json&bc=/azure/synapse-analytics/sql-data-warehouse/breadcrumb/toc.json&view=azure-sqldw-latest&preserve-view=true
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-materialized-views
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-materialized-view-as-select-transact-sql?view=azure-sqldw-latest&preserve-view=true
****************************************************************************************/

/****************************************************************************************
STEP 1 of 7 - Enable Result_Set_Cache and run the query which will "train" the cache with its outcome
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching

****************************************************************************************/
--Pointing Master and enable the result cache
ALTER DATABASE Fasthack_performance SET RESULT_SET_CACHING ON;
GO


--Pointing your Dedicated SQL Pool
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
OPTION(LABEL = 'Result Set Cache - First execution')
GO

/****************************************************************************************
STEP 2 of 7 - Check the MPP plan.
Slowest step should be a ShuffleMoveOperation (Step_index = 2)
****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Result Set Cache - First execution'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'request_id'
GO


/****************************************************************************************
STEP 3 of 7 - Run the query again, it should faster than previous execution
****************************************************************************************/
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
OPTION(LABEL = 'Result Set Cache - Second execution')
GO

/****************************************************************************************
STEP 4 of 7 - Check the MPP plan.
Requests:	
checking sys.dm_pdw_exec_requests, result_cache_hit should be 1 

Steps:
It should be a one step MPP plan and should use 1 ReturnOperation step

****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Result Set Cache - Second execution'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'request_id'
GO


/****************************************************************************************
STEP 5 of 7 - What if the resultset exceed the maximum allowed size for each result-set ? (10GB)
You might want to use materialized view.
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-materialized-view-performance-tuning

****************************************************************************************/


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



/****************************************************************************************
STEP 6 of 7 - Disabling the cache and create Materialized view (it should take few minutes)

No need to specify the Name of the Materialized view, 
the query optimizer will automatically consider it, so Cx doesn't need to change their code to benefit from MV.

****************************************************************************************/

SET RESULT_SET_CACHING OFF
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

/****************************************************************************************
STEP 7 of 7 - Check the MPP plan.
It will use the new MV without specifying the name in t-SQL code
****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Materialized view'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'request_id'

GO
