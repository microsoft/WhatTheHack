/****************************************************************************************
--Why is this query so slow ?
--Could you optimize it ?

--What is table Skew ?
--How can you fix it ?

--Tips:
--Investigate for Data skew
--Unnecessary data movement


https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-request-steps-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-sql-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/it-it/sql/t-sql/database-console-commands/dbcc-pdw-showspaceused-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute#how-to-tell-if-your-distribution-column-is-a-good-choice
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute

****************************************************************************************/

/****************************************************************************************
STEP1 - Run the following query 
*****************************************************************************************/


DBCC DROPCLEANBUFFERS()
DBCC FREEPROCCACHE()
GO

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
STEP2 - Identify the request_id for the query and its MPP execution plan
		Where is the bottleneck ?
*****************************************************************************************/
SELECT * FROM SYS.Dm_pdw_exec_requests where [LABEL] = 'FactSales - Slow Query'

--Copy/Paste the request_id from the previus result and identify the slowes step
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'Request_id'

--Copy/Paste the request_id from the previus result and the slowes step_id
SELECT * FROM sys.dm_pdw_sql_requests WHERE request_id = 'Request_id' and Step_index = step_id


/****************************************************************************************
STEP3 - How to investigate Skewness
*****************************************************************************************/
--Are data even distributed ?
DBCC PDW_SHOWSPACEUSED('[Sales].[FactSales]')
GO


/****************************************************************************************
STEP4 - How would you fix the skewness ?
*****************************************************************************************/