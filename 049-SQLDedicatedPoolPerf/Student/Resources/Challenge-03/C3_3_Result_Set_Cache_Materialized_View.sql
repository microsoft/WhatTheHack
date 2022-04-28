/****************************************************************************************
--Is there a way to increase performance for this query ?
--And what if your Dataset is bigger than 10GB ?


--Tips:
--Investigate Result_set_caching and Materialized views

https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-result-set-caching-transact-sql?toc=/azure/synapse-analytics/sql-data-warehouse/toc.json&bc=/azure/synapse-analytics/sql-data-warehouse/breadcrumb/toc.json&view=azure-sqldw-latest&preserve-view=true
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-materialized-views
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-materialized-view-as-select-transact-sql?view=azure-sqldw-latest&preserve-view=true
****************************************************************************************/


/****************************************************************************************
STEP1 - Run this query and observe its execution plan
****************************************************************************************/
DBCC DROPCLEANBUFFERS()
DBCC FREEPROCCACHE()
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
OPTION (LABEL = 'Reporting query')
GO


/****************************************************************************************
STEP2 - Check its execution plan
		- Is it using unnecessary data movement ?
****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Reporting query'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'request_id'
GO

/****************************************************************************************
STEP3 - Check skewness for involved tables
****************************************************************************************/
DBCC PDW_SHOWSPACEUSED('Sales.FactInternetSales')
DBCC PDW_SHOWSPACEUSED('Sales.FactInternetSalesReason')
GO

/****************************************************************************************
STEP4 - Is replicate table cache "Ready" ?
****************************************************************************************/
SELECT * FROM sys.pdw_replicated_table_cache_state WHERE OBJECT_NAME(object_id) = 'DimSalesReason'
GO

/****************************************************************************************
STEP5 - Is there a feature you can enable to improve performance ?
	Could you activate it and make the query faster ?
****************************************************************************************/




/****************************************************************************************
STEP6 - Is there a feature you can enable to improve performance when the resultset is bigger than 10GB ?
		Could you activate it and guarantee users don't have to change their T-SQL code To benefith from ?
****************************************************************************************/


