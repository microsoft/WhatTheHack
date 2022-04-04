/****************************************************************************************
--Why is the query against partitioned table slower than the original one ?
--Is CCI for the Sales.FactInternetSales_partitioned table in a good shape ?
--Can you identify why ?

--Is CCI in good shape for the partitioned table ?
--And for the original one ?

--Tips:
--Investigate overpartitioning
--Investigate CCI Health

https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-partition
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-dedicated-sql-pool#do-not-over-partition
https://docs.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-overview?view=sql-server-ver15
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-columnstore-index-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-index
https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-pdw-nodes-column-store-row-groups-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-pdw-nodes-tables-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-pdw-table-mappings-transact-sql?view=aps-pdw-2016-au7

****************************************************************************************/

/****************************************************************************************
STEP1 - Disabling the Result_set_caching feature for this session
****************************************************************************************/
SET RESULT_SET_CACHING OFF
GO


/****************************************************************************************
STEP2 - Run this query and observe its execution plan
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
WHERE Dsr.SalesReasonName = 'Demo Event'
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'Not Partitioned Table')
GO

/****************************************************************************************
STEP3 - Check its execution plan
****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Not Partitioned Table'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'request_id'
GO


/****************************************************************************************
STEP4 - Run this query and observe its execution plan
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
FROM Sales.FactInternetSales_Partitioned Fis
	INNER JOIN Sales.FactInternetSalesReason Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Sales.DimSalesReason Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
WHERE Dsr.SalesReasonName = 'Demo Event'
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
OPTION(LABEL = 'Partitioned Table')
GO


/****************************************************************************************
STEP5 - Check its execution plan, are queries using same steps ?
****************************************************************************************/
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Partitioned Table'
SELECT * FROM sys.dm_pdw_request_steps WHERE request_id = 'request_id'
GO


/****************************************************************************************
STEP6 - Why is the query against partitioned table slower than the first one ?
		Is the clustered Columnstore index in good shape ?
		Does the table have enough records to benefit from partitioning ?
		could you improve performance optimizing Columnstore index ?
****************************************************************************************/
