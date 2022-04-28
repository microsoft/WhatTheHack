/****************************************************************************************
--How can you efficiently move data from Staging to Salses area ?
--Considering you still have to create prodution tables, could you define them using the proper distribution method?
--Consider also your query will join tables using CustomerKey, ProductKey, CurrencyKey and FinanceKey fields.

--Tips:
Check FactInternetSales table: Is it better to distribute it using CustomerKey or ProductKey column ? 
(Count distinct values for those columns - Example: SELECT COUNT(DISTINCT yourFieldName) FROM Staging.FactTableName)
Are Dimension tables (DimAccount, DimCustomer etc...) good candidates to be replicated ?

https://docs.microsoft.com/it-it/azure/synapse-analytics/sql/best-practices-dedicated-sql-pool#hash-distribute-large-tables
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute#how-to-tell-if-your-distribution-column-is-a-good-choice
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-table-as-select-azure-sql-data-warehouse?view=azure-sqldw-latest&preserve-view=true
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-overview
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/cheat-sheet


If Sales tables are already in place you might want to consider to append/merge data
https://docs.microsoft.com/en-us/sql/t-sql/statements/merge-transact-sql?view=sql-server-ver15

****************************************************************************************/


/****************************************************************************************
STEP 1 of 5 - Create destination schema
****************************************************************************************/

CREATE SCHEMA Sales
GO


/****************************************************************************************
STEP 2 of 5 - Dimension tables should be defined as Replicated since in this dataset they do not exceed 2GB.
They can improve performance avoiding un-necessary data-movement
Yet, they do not contain enought record to benefit from CCI, in this case HEAP is a valid option
--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-overview#replicated-tables
--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables?context=/azure/synapse-analytics/context/context

****************************************************************************************/

CREATE TABLE Sales.DimAccount  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimAccount]  
GO


CREATE TABLE Sales.DimCurrency  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimCurrency]  
GO

CREATE TABLE Sales.DimCustomer  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimCustomer]  
GO


CREATE TABLE Sales.DimDate  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimDate]  
GO


CREATE TABLE Sales.DimDepartmentGroup  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimDepartmentGroup]  
GO


CREATE TABLE Sales.DimEmployee  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimEmployee]  
GO


CREATE TABLE Sales.DimGeography  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimGeography]  
GO


CREATE TABLE Sales.DimOrganization  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimOrganization]  
GO


CREATE TABLE Sales.DimProduct  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimProduct]  
GO


CREATE TABLE Sales.DimProductCategory  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimProductCategory]  
GO


CREATE TABLE Sales.DimProductSubcategory  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimProductSubcategory]  
GO


CREATE TABLE Sales.DimPromotion  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimPromotion]  
GO


CREATE TABLE Sales.DimReseller  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimReseller]  
GO


CREATE TABLE Sales.DimSalesReason  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimSalesReason]  
GO


CREATE TABLE Sales.DimSalesTerritory  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimSalesTerritory]  
GO


CREATE TABLE Sales.DimScenario  
WITH  (   DISTRIBUTION = REPLICATE   ,HEAP  )  
AS  
SELECT * FROM [Staging].[DimScenario]  
GO


/****************************************************************************************
STEP 3 of 5 - How to check if a column is good enough 
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute#how-to-tell-if-your-distribution-column-is-a-good-choice
Choosing a distribution column is an important design decision since the values in this column determine how the rows 
are distributed. The best choice depends on several factors, and usually involves tradeoffs. 
Once a distribution column is chosen, you cannot change it.

- Do not choose nullable column because all null columns are hashed in th same way and thus the rows will end up in the same location. If most columns of the table are nulls then it may not be a good candidate for hash distribution.
- Any fact tables that has a default value in a column is also not a good candidate to create a hash distributed table.

Very selective columns (multiple unique values) are good candidates
****************************************************************************************/

SELECT COUNT(DISTINCT CustomerKey) FROM staging.FactInternetSales
SELECT COUNT(DISTINCT ProductKey) FROM staging.FactInternetSales
GO


/****************************************************************************************
STEP 4 of 5 - Fact tables should be defined as Hash-distributed.
--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute?context=/azure/synapse-analytics/context/context

****************************************************************************************/


CREATE TABLE Sales.FactCurrencyRate  
WITH  (   DISTRIBUTION = HASH(CurrencyKey)   ,CLUSTERED COLUMNSTORE INDEX  )  
AS  
SELECT * FROM [Staging].[FactCurrencyRate]  
GO


CREATE TABLE Sales.FactFinance  
WITH  (    DISTRIBUTION = HASH(FinanceKey)   ,CLUSTERED COLUMNSTORE INDEX  )  
AS  
SELECT * FROM [Staging].[FactFinance] 
GO


CREATE TABLE Sales.FactInternetSales  
WITH  (   DISTRIBUTION = HASH(ProductKey)   ,CLUSTERED COLUMNSTORE INDEX  )  
AS  
SELECT * FROM [Staging].[FactInternetSales]  
GO


CREATE TABLE Sales.FactInternetSalesReason  
WITH  (   DISTRIBUTION = HASH(SalesOrderNumber)   ,CLUSTERED COLUMNSTORE INDEX  )  
AS  
SELECT * FROM [Staging].[FactInternetSalesReason]  
GO


CREATE TABLE Sales.FactResellerSales 
WITH  (   DISTRIBUTION = HASH(ProductKey)   ,CLUSTERED COLUMNSTORE INDEX   )  
AS  
SELECT * FROM [Staging].[FactResellerSales]  
GO


/****************************************************************************************
STEP 5 of 5 - Run this code with no explanation, this is needed for further investigation in the next challenges

- Sales.FactSales will be created using SalesOrderNumber as distribution column
Very bad choice since it contains only 1 distinct value, all data will land into the same distribution
Table is heavilly affected by skewness

Sales.FactInternetSales_Partitioned will be created with more than 80 partitions 
but it doesn'-'t have enough record  to benefit from it
****************************************************************************************/


CREATE TABLE Sales.FactSales
WITH  (   DISTRIBUTION = HASH(RevisionNumber)   ,CLUSTERED COLUMNSTORE INDEX   )  
AS  
SELECT * FROM [Staging].[FactSales]  
GO


CREATE TABLE Sales.FactInternetSales_Partitioned
WITH 
(
	DISTRIBUTION = HASH ( [SalesOrderNumber] ),
	CLUSTERED COLUMNSTORE INDEX,
	PARTITION
	(
		[OrderDateKey] RANGE RIGHT FOR VALUES 
		(
		
			20000101, 20000401, 20000701, 20001201
			, 20010101, 20010401, 20010701, 20011201
			, 20020101, 20020401, 20020701, 20021201
			, 20030101, 20030401, 20030801, 20031201
			, 20040101, 20040401, 20040801, 20041201
			, 20050101, 20050401, 20050801, 20051201
			, 20060101, 20060401, 20060801, 20061201
			, 20070101, 20070401, 20070801, 20071201
			, 20080101, 20080401, 20080801, 20081201
			, 20090101, 20090401, 20090801, 20091201
			, 20100101, 20100401, 20100801, 20101201
			, 20110101, 20110401, 20110801, 20111201
			, 20120101, 20120401, 20120801, 20121201
			, 20130101, 20130401, 20130801, 20131201
			, 20140101, 20140401, 20140801, 20141201
			, 20150101, 20150401, 20150801, 20151201
			, 20160101, 20160401, 20160801, 20161201
			, 20170101, 20170401, 20170801, 20171201
			, 20180101, 20180401, 20180801, 20181201
			, 20190101, 20190401, 20190801, 20191201
			, 20200101, 20200401, 20200801, 20201201
			, 20210101, 20210401, 20210801, 20211201
			, 20220101, 20220401, 20220801, 20221201
			, 20230101, 20230401, 20230801, 20231201
			, 20240101, 20240401, 20240801, 20241201
			, 20250101, 20250401, 20250801, 20251201
			, 20260101, 20260401, 20260801, 20261201
			, 20270101, 20270401, 20270801, 20271201
			, 20280101, 20280401, 20280801, 20281201
			, 20290101, 20290401, 20290801, 20291201
		
		)
	)
)
AS 
SELECT * FROM Sales.FactInternetSales 
GO

CREATE STATISTICS [OrderDateKey] ON [Sales].[FactInternetSales_Partitioned]([OrderDateKey]);
CREATE STATISTICS [SalesTerritoryKey] ON [Sales].[FactInternetSales_Partitioned]([SalesTerritoryKey]);
CREATE STATISTICS [SalesOrderNumber] ON [Sales].[FactInternetSales_Partitioned]([SalesOrderNumber]);
CREATE STATISTICS [SalesOrderLineNumber] ON [Sales].[FactInternetSales_Partitioned]([SalesOrderLineNumber]);
GO

CREATE STATISTICS [OrderDateKey] ON [Sales].[FactResellerSales]([OrderDateKey]);
CREATE STATISTICS [SalesTerritoryKey] ON [Sales].[FactResellerSales]([SalesTerritoryKey]);
CREATE STATISTICS [SalesOrderNumber] ON [Sales].[FactResellerSales]([SalesOrderNumber]);
CREATE STATISTICS [SalesOrderLineNumber] ON [Sales].[FactResellerSales]([SalesOrderLineNumber]);
GO