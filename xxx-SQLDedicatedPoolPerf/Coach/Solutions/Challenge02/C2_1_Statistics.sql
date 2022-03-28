/****************************************************************************************
--Why first execution is considerably slower than other ones ?
--How can you avoid this behavior?

--Tips:
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics
https://docs.microsoft.com/it-it/sql/t-sql/statements/create-statistics-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/it-it/sql/t-sql/database-console-commands/dbcc-show-statistics-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-statistics-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-dedicated-sql-pool#maintain-statistics

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
OPTION(LABEL = 'First Execution - Slowest one')
GO

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'First Execution - Slowest one'
SELECT * FROM sys.dm_pdw_exec_requests WHERE request_id > 'QID1408' and Command like '%CREATE STAT%'
GO

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
WHERE Fis.OrderDateKey >= '20120101' and Fis.OrderDateKey < '20211231' 
		AND Fis.SalesTerritoryKey BETWEEN 5 and 10
		AND Dsr.SalesReasonName = 'Demo Event'
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'Second Execution - Stats available')
GO

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Second Execution - Stats available'
SELECT * FROM sys.dm_pdw_exec_requests WHERE request_id > 'QID1447' and Command like '%CREATE STAT%'
GO

--Manual Statistics can help 

SELECT
    sm.[name] AS [schema_name],
    tb.[name] AS [table_name],
    co.[name] AS [stats_column_name],
    st.[name] AS [stats_name],
	st.[user_created] ,
    STATS_DATE(st.[object_id],st.[stats_id]) AS [stats_last_updated_date]
FROM
    sys.objects ob
    JOIN sys.stats st
        ON  ob.[object_id] = st.[object_id]
    JOIN sys.stats_columns sc
        ON  st.[stats_id] = sc.[stats_id]
        AND st.[object_id] = sc.[object_id]
    JOIN sys.columns co
        ON  sc.[column_id] = co.[column_id]
        AND sc.[object_id] = co.[object_id]
    JOIN sys.types  ty
        ON  co.[user_type_id] = ty.[user_type_id]
    JOIN sys.tables tb
        ON  co.[object_id] = tb.[object_id]
    JOIN sys.schemas sm
        ON  tb.[schema_id] = sm.[schema_id]
WHERE
    sm.[name] = 'Sales' and tb.[name] = 'FactInternetSales';
GO






DROP STATISTICS [Sales].[FactInternetSales]._WA_Sys_00000002_0D44F85C
DROP STATISTICS [Sales].[FactInternetSales]._WA_Sys_00000008_0D44F85C
DROP STATISTICS [Sales].[FactInternetSales]._WA_Sys_00000009_0D44F85C
DROP STATISTICS [Sales].[FactInternetSales]._WA_Sys_0000000A_0D44F85C



CREATE STATISTICS [OrderDateKey] ON [Sales].[FactInternetSales]([OrderDateKey]);
CREATE STATISTICS [SalesTerritoryKey] ON [Sales].[FactInternetSales]([SalesTerritoryKey]);
CREATE STATISTICS [SalesOrderNumber] ON [Sales].[FactInternetSales]([SalesOrderNumber]);
CREATE STATISTICS [SalesOrderLineNumber] ON [Sales].[FactInternetSales]([SalesOrderLineNumber]);



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
WHERE Fis.OrderDateKey >= '20120101' and Fis.OrderDateKey < '20211231' 
		AND Fis.SalesTerritoryKey BETWEEN 5 and 10
		AND Dsr.SalesReasonName = 'Demo Event'
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'Third Execution - Manually created Stats available')
GO


SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Third Execution - Manually created Stats available'
SELECT * FROM sys.dm_pdw_exec_requests WHERE request_id > 'QID1507' and Command like '%CREATE STAT%'