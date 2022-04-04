/****************************************************************************************
--Why is the query "slow" ?
--Is this query using "compatible" or "incompatible" Join ?
--Is there a way to optimize further this query ?

--Tips:
--Investigate for Incompatible Join 
--Can you avoid unnecessary data movement ?

https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-request-steps-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-sql-requests-transact-sql?view=aps-pdw-2016-au7

https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute#what-is-a-distributed-table
https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/how-to-minimize-data-movements-compatible-and-incompatible-joins/ba-p/1807104#:~:text=Incompatible%20Joins%20is%20a%20join,can%20negatively%20impact%20query%20performance.&text=Incompatible%20%E2%80%93%20requires%20data%20movement%20before%20the%20join.
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute#choose-a-distribution-column

****************************************************************************************/

/****************************************************************************************
STEP1 - Run this query and observe its MPP plan
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
OPTION(LABEL = 'First Execution - Join - Slowest one')
GO


/****************************************************************************************
STEP2 - Identify the request_id for the query and its MPP execution plan
		Could you identify the slowest steps ?
		Is the query using a compatible join ?
*****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL]=  'First Execution - Join - Slowest one'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'request_id' 
GO




/****************************************************************************************
STEP3 - Could you improve performance avoiding un-necessary data movement ?
		(Check table distribution and compare with the Join clause from the Select)
		Do you have to re-distribute the table and choose a different Hash column ?
		If yes, what column should you consider to benefit by compatible join ?
		Can you verify if the new MPP plan has been improved ?
*****************************************************************************************/

