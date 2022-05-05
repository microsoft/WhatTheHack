/****************************************************************************************
--Why first execution is considerably slower than other ones ?
--How can you avoid this behavior?

--Tips:
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics
https://docs.microsoft.com/it-it/sql/t-sql/statements/create-statistics-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/it-it/sql/t-sql/database-console-commands/dbcc-show-statistics-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-statistics-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-dedicated-sql-pool#maintain-statistics
https://docs.microsoft.com/it-it/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/it-it/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-request-steps-transact-sql?view=aps-pdw-2016-au7

****************************************************************************************/

/****************************************************************************************
STEP1 - Run this query and observe its MPP Execution plan
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


/****************************************************************************************
STEP2 - Identify the request_id for the query and its MPP execution plan
		Could you explain what statistics are and why the first execution is slow ?
		What are _WA_Sys_* statistics ?
*****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL]=  'First Execution - Slowest one'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id >= 'request_id' AND command LIKE '%CREATE STA%'


/****************************************************************************************
STEP3 - Second execution.
	Why is it faster than the previous attempt ?
*****************************************************************************************/

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


/****************************************************************************************
STEP4 - Did it need Automatic Statistics to be created ?
	Could you explain why ?
*****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL]=  'Second Execution - Stats available'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id >= 'request_id' AND command LIKE '%CREATE STA%'


/****************************************************************************************
STEP5 - Can you recognize Auto created Statistics ?
	Which columns have statistics and Why ? 
*****************************************************************************************/
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
    sm.[name] = 'Sales' 
	and tb.[name] = 'FactInternetSales'
	and st.[name] not like	'Clustered%';
GO


/****************************************************************************************
STEP6 - Is there a way to manually create needed statistics and 
		avoid the overhead while executing the query the first time ?
		Create needed statistics manually and check if the query still need Auto Create Stats
*****************************************************************************************/

