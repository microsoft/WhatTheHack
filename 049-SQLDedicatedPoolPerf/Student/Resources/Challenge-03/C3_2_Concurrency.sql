/****************************************************************************************
--Why this query is taking so long to complete ? using DW100c should complete in approx 1 minute.
--How can you increase concurrency ?
--How can you scale your Dedicated Pool by T-SQL
--How can you monitor this operation ?

--Tips:
--Investigate concurrency
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/what-is-a-data-warehouse-unit-dwu-cdwu
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/quickstart-scale-compute-tsql
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-waits-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/kill-transact-sql?view=sql-server-ver15
****************************************************************************************/

/****************************************************************************************
STEP1 - Run this select and observe its behaviour
****************************************************************************************/
DBCC DROPCLEANBUFFERS()
DBCC FREEPROCCACHE()
GO

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
OPTION(LABEL = 'Test Concurrency DW100')
GO

/****************************************************************************************
STEP2 - Run diagnostic SELECT from a different session and explain why:
	. only few user's queries are "Running"
	. what does "suspended" mean ?
****************************************************************************************/

SELECT * FROM sys.dm_pdw_exec_requests WHERE STATUS NOT IN ('Completed','Failed','Cancelled')
SELECT * FROM sys.dm_pdw_exec_requests WHERE [label] = 'Test Concurrency DW100'
SELECT * FROM sys.dm_pdw_waits WHERE session_id = 'SID19244'
GO

/****************************************************************************************
STEP3 - Is there a way to fix this behavior and increase concurrency allowing more than 4 user's queries ?
		Can you do it using T-SQL code ?
****************************************************************************************/
