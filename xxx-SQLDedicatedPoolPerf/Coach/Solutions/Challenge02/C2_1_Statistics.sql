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


/***************************************************************************************
STEP 1 of 8 - First time you execute this query will take a while to complete.
Statistics are not in place and since AUTO_CREATE_STATISTICS is ON by default first execution triggers stats creation
before run the query

Ensure you're using DW500

--https://docs.microsoft.com/en-us/sql/analytics-platform-system/configure-auto-statistics?view=aps-pdw-2016-au7&viewFallbackFrom=azure-sqldw-latest
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
WHERE Fis.OrderDateKey >= '20120101' and Fis.OrderDateKey < '20211231'
		AND Fis.SalesTerritoryKey BETWEEN 5 and 10
		AND Dsr.SalesReasonName = 'Demo Event'
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'First Execution - Slowest one')
GO


/***************************************************************************************
STEP 2 of 8 - How to check if Auto create stats has been triggered by the user query
Multiple statistics have been created before user query started.
****************************************************************************************/

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'First Execution - Slowest one'

--There will be 9 CREATE STATS T-SQL command triggered by the query
SELECT * FROM sys.dm_pdw_exec_requests WHERE request_id > 'request_id' and Command like '%CREATE STAT%'
GO

/***************************************************************************************
STEP 3 of 8 - If you run the query again it will run faster than previous execution 
even cleaning buffers and procedure cache
****************************************************************************************/

DBCC DROPCLEANBUFFERS()
DBCC FREEPROCCACHE()

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

/***************************************************************************************
STEP 4 of 8 - 0 CREATE STATS T-SQL command
****************************************************************************************/

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Second Execution - Stats available'
SELECT * FROM sys.dm_pdw_exec_requests WHERE request_id > 'request_id' and Command like '%CREATE STAT%'
GO


/***************************************************************************************
STEP 4 of 8 - Manually investigate statistics create/Last update date for Sales.FactInternetSales
and columns with statistics
****************************************************************************************/
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
WHERE st.[name] not like 'ClusteredIndex_%'
   AND sm.[name] = 'Sales' and tb.[name] = 'FactInternetSales';
GO




/***************************************************************************************
STEP 5 of 8 - Manually drop statistics from FactInternetSales
Change "_WA_Sys_xxxxxxx_xxxxxxx" with the proper names from the previous query
****************************************************************************************/

DROP STATISTICS [Sales].[FactInternetSales]._WA_Sys_00000002_0D44F85C
DROP STATISTICS [Sales].[FactInternetSales]._WA_Sys_00000008_0D44F85C
DROP STATISTICS [Sales].[FactInternetSales]._WA_Sys_00000009_0D44F85C
DROP STATISTICS [Sales].[FactInternetSales]._WA_Sys_0000000A_0D44F85C

/***************************************************************************************
STEP 6 of 8 - Manually drop statistics from FactInternetSales
Change "_WA_Sys_xxxxxxx_xxxxxxx" with the proper names from the previous query
--https://docs.microsoft.com/en-us/sql/t-sql/statements/create-statistics-transact-sql?view=sql-server-ver15

Highlight Auto create stats only creates single columns statistics

****************************************************************************************/

CREATE STATISTICS [OrderDateKey] ON [Sales].[FactInternetSales]([OrderDateKey]);
CREATE STATISTICS [SalesTerritoryKey] ON [Sales].[FactInternetSales]([SalesTerritoryKey]);
CREATE STATISTICS [SalesOrderNumber] ON [Sales].[FactInternetSales]([SalesOrderNumber]);
CREATE STATISTICS [SalesOrderLineNumber] ON [Sales].[FactInternetSales]([SalesOrderLineNumber]);

/***************************************************************************************
STEP 7 of 8 - Query is fast, Stats have been manually created
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
WHERE Fis.OrderDateKey >= '20120101' and Fis.OrderDateKey < '20211231' 
		AND Fis.SalesTerritoryKey BETWEEN 5 and 10
		AND Dsr.SalesReasonName = 'Demo Event'
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'Third Execution - Manually created Stats available')
GO

/***************************************************************************************
STEP 8 of 8 - Query is fast, Stats have been manually created
****************************************************************************************/

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Third Execution - Manually created Stats available'
SELECT * FROM sys.dm_pdw_exec_requests WHERE request_id > 'request_id' and Command like '%CREATE STAT%'