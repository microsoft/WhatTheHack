/****************************************************************************************
--Why is this query so slow ?
--Could you optimize it ?

--Tips:

https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-request-steps-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-sql-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/it-it/sql/t-sql/database-console-commands/dbcc-pdw-showspaceused-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute#how-to-tell-if-your-distribution-column-is-a-good-choice
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute

****************************************************************************************/

/****************************************************************************************
STEP 1 of 7 - Run this simple Select
****************************************************************************************/

SELECT  
	[CustomerKey]
	, COUNT(distinct [ProductKey]) Distinct_Prod_Count
	, SUM([OrderQuantity])[OrderQuantity_SUM]
	, SUM([SalesAmount]) [SalesAmount_SUM]
FROM [Sales].[FactSales]
	WHERE [OrderDateKey] >= 20120101 and [OrderDateKey] <= 20201231
GROUP BY [CustomerKey]
OPTION(LABEL = 'FactSales - Slow Query')
GO


/****************************************************************************************
STEP 2 of 7 - check its MPP execution plan
change the request_id using the proper-one. The most expensive step is step2 which is ShuffleMoveOperation
This table has been created distributed=Hash(RevisionNumber)
RevisionNumber shouldn't be used as distribution column since it only has 1 valu (Very dense and not selectine) 
Rows with same value land into the same distribution (Distribution 16 in this case) and using below queries you should be able to demonstrate
the slowest distribution is the 16th.
****************************************************************************************/

SELECT * FROM SYS.Dm_pdw_exec_requests where [LABEL] = 'FactSales - Slow Query'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'request_id'
SELECT * FROM sys.dm_pdw_sql_requests WHERE request_id = 'request_id' and Step_index = 2

/****************************************************************************************
STEP 3 of 7 - check how many rows are in each distribution and how to tell if the table has data skew
All rows belong to distribution 16
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute?context=/azure/synapse-analytics/context/context#how-to-tell-if-your-distribution-column-is-a-good-choice
****************************************************************************************/

DBCC PDW_SHOWSPACEUSED('[Sales].[FactSales]')
GO

/****************************************************************************************
STEP 4 of 7 - To fix it you need to redistribute all the data. It means you have to re-create the table specifying a different distribution column.
Customer Key might be considered a good candidate since it will be used in the group by , this should avoid unnecessary data movement
****************************************************************************************/

RENAME OBJECT [Sales].[FactSales] TO [FactSales_Skewed]
GO

CREATE TABLE [Sales].[FactSales]
WITH
(
	DISTRIBUTION = HASH ( [CustomerKey] ),
	CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT  
	*
FROM [Sales].[FactSales_Skewed]
GO


/****************************************************************************************
STEP 5 of 7 - Run again the same query.
Table is now evenly distributed, this should ensure good performance
Bear in mind, First execution might not be fast, it's due to missing statistics, we will take care later
****************************************************************************************/

SELECT  
	[CustomerKey]
	, COUNT(distinct [ProductKey]) Distinct_Prod_Count
	, SUM([OrderQuantity])[OrderQuantity_SUM]
	, SUM([SalesAmount]) [SalesAmount_SUM]
FROM [Sales].[FactSales]
	WHERE [OrderDateKey] >= 20120101 and [OrderDateKey] <= 20201231
GROUP BY [CustomerKey]
OPTION(LABEL = 'FactSales - Fast query')
GO

/****************************************************************************************
STEP 6 of 7 - check its MPP execution plan
change the request_id using the proper-one. 
Its MPP plan is a single-step plan (Returnoperation) and no data movement required
All distributions apprix take the same amount of time to complete their task
****************************************************************************************/

SELECT * FROM SYS.Dm_pdw_exec_requests where [LABEL] = 'FactSales - Fast query'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'request_id'
SELECT * FROM sys.dm_pdw_sql_requests WHERE request_id = 'request_id' and Step_index = 0

/****************************************************************************************
STEP 7 of 7 - check how many rows are in each distribution and how to tell if the table has data skew
No data skew at all
****************************************************************************************/
DBCC PDW_SHOWSPACEUSED('[Sales].[FactSales]')
GO