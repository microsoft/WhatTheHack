/****************************************************************************************
--Why this query is taking so long to complete ? using DW100c should complete in approx 1 minute.
--How can you increase concurrency ?
--How can you scale your Dedicated Pool by T-SQL
--How can you monitor this operation ?

--Tips:
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/what-is-a-data-warehouse-unit-dwu-cdwu
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/quickstart-scale-compute-tsql
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-waits-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/kill-transact-sql?view=sql-server-ver15

****************************************************************************************/

/****************************************************************************************
STEP 1 of 4 - BEFORE RUN THIS SCALE YOUR DEDICATED SQL POOL TO DW100c

This command should never complete
Run this select after you run C3_B_Simulate_Queries.ps1 powershell script.
While PS1 script is still running (it should take hours to complete) run below query

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
OPTION(LABEL = 'Test Concurrency DW100')
GO

/****************************************************************************************
STEP 2 of 4 - Checking what is going on
You should find 4 session with status = 'running' and one with status = 'suspended' 
DW1000 allows max 4 running concurrent query. New submitted queries will be queued and their status will be 'Suspended'

https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits

****************************************************************************************/

SELECT * FROM sys.dm_pdw_exec_requests WHERE STATUS NOT IN ('Completed','Failed','Cancelled')
SELECT * FROM sys.dm_pdw_exec_requests WHERE [label] = 'Test Concurrency DW100'
SELECT * FROM sys.dm_pdw_waits WHERE session_id = 'sessions_id'
GO

/****************************************************************************************
STEP 3 of 4 - to increase the number of available concurrent queries you have to chose an higher SLO
Customer's workload can do it programmatically via Powershell, T-SQL, REST API

In this example we will leverage T-SQL code to scale to DW500c.

YOU CAN NOW STOP C3_B_Simulate_Queries.ps1 SCRIPT USING C3_C_Force_Stop_Queries.ps1

****************************************************************************************/

--Point MASTER db, your app can invoke this T/SQL and auto/scale the Dedicated Sql pool
ALTER DATABASE fasthack_performance
MODIFY (SERVICE_OBJECTIVE = 'DW500c');
GO

--It returns the current status for the scale request
SELECT TOP 1 state_desc
FROM sys.dm_operation_status
WHERE
    resource_type_desc = 'Database'
    AND major_resource_id = 'fasthack_performance'
    AND operation = 'ALTER DATABASE'
ORDER BY
    start_time DESC
GO


--How to check the scale status
DECLARE @db sysname = 'fasthack_performance'
WHILE
(
    SELECT TOP 1 state_desc
    FROM sys.dm_operation_status
    WHERE
        1=1
        AND resource_type_desc = 'Database'
        AND major_resource_id = @db
        AND operation = 'ALTER DATABASE'
    ORDER BY
        start_time DESC
) = 'IN_PROGRESS'
BEGIN
    RAISERROR('Scale operation in progress',0,0) WITH NOWAIT;
    WAITFOR DELAY '00:00:05';
END
PRINT 'Complete';
GO



/****************************************************************************************
STEP 4 of 4 - Run this select after you triggered again the C3_B_Simulate_Queries.ps1 powershell script.
While PS1 script is still running (it should take hours to complete) run below query
It should complete in few seconds
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
OPTION(LABEL = 'Test Concurrency DW500')
GO
