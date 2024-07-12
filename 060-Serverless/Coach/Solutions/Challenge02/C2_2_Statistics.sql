/*****************************************************************************************************************************
What the hack - Serverless - How to work with it
CHALLENGE 02 - Excercise 01 - Column Statistics

https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics#statistics-in-serverless-sql-pool

Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/

/***************************************************************************************
STEP 1 of 4 - Preparring environmet
****************************************************************************************/

--Creating the proper file formats
--CSV file with no strange formating
CREATE EXTERNAL FILE FORMAT CSVFormat 
WITH 
( 
	FORMAT_TYPE = DELIMITEDTEXT
	, FORMAT_OPTIONS( FIRST_ROW = 2 )
);
GO

--Parquet files
CREATE EXTERNAL FILE FORMAT ParquetFormat
WITH
(
    FORMAT_TYPE = PARQUET
)
GO

--Creating the external table using Parquet format
CREATE EXTERNAL TABLE [dbo].[EXT_FACTINTERNETSALES]
(
	[PRODUCTKEY] [int],
	[ORDERDATEKEY] [int],
	[DUEDATEKEY] [int],
	[SHIPDATEKEY] [int],
	[CUSTOMERKEY] [int],
	[PROMOTIONKEY] [int],
	[CURRENCYKEY] [int],
	[SALESTERRITORYKEY] [int],
	[SALESORDERNUMBER] [varchar](50),
	[SALESORDERLINENUMBER] [int],
	[REVISIONNUMBER] [int],
	[ORDERQUANTITY] [int],
	[UNITPRICE] [numeric](19, 4),
	[EXTENDEDAMOUNT] [numeric](19, 4),
	[UNITPRICEDISCOUNTPCT] [float],
	[DISCOUNTAMOUNT] [float],
	[PRODUCTSTANDARDCOST] [numeric](19, 4),
	[TOTALPRODUCTCOST] [numeric](19, 4),
	[SALESAMOUNT] [numeric](19, 4),
	[TAXAMT] [numeric](19, 4),
	[FREIGHT] [numeric](19, 4),
	[CARRIERTRACKINGNUMBER] [varchar](50),
	[CUSTOMERPONUMBER] [varchar](50)
)
WITH (DATA_SOURCE = [MSIFastHack_DataSource],LOCATION = N'/Parquet/Factinternetsales/',FILE_FORMAT = [ParquetFormat])
GO



--External dimention tables, all using Parquet
CREATE EXTERNAL TABLE EXT_DIMSALESREASONS 
(
	[SalesReasonKey] int,
	[SalesReasonAlternateKey] int,
	[SalesReasonName] nvarchar(25),
	[SalesReasonReasonType] nvarchar(25)
)
WITH (
	LOCATION = '/Parquet/Dimsalesreasons'
	, DATA_SOURCE = [MSIFastHack_DataSource]
	, FILE_FORMAT = ParquetFormat
	)
GO


CREATE EXTERNAL TABLE EXT_FACTINTERNETSALESREASONS 
(
	[SALESORDERNUMBER] nvarchar(20),
	[SALESORDERLINENUMBER] int,
	[SALESREASONKEY] int
)
WITH (
	LOCATION = 'Parquet/Factinternetsalesreasons'
	, DATA_SOURCE = [MSIFastHack_DataSource]
	, FILE_FORMAT = ParquetFormat
	)
GO


/****************************************************************************************
STEP 2 of 4 - How statiscs work with Synapse SQL Serverless and External tables
****************************************************************************************/

SELECT 
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Ext_FactInternetSales Fis --Will auto create statistics
	INNER JOIN Ext_FactInternetSalesReasons Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Ext_DimSalesReasons Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
WHERE OrderDateKey = 20010703
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
ORDER BY Fis.OrderDateKey
GO

/****************************************************************************************
STEP 3 of 4 - Check Auto created Stats
****************************************************************************************/
--Check stats details
SELECT
       sm.[name]                           AS [schema_name]
,       tb.[name]                           AS [table_name]
,       st.[name]                           AS [stats_name]
,       st.[filter_definition]              AS [stats_filter_definition]
,       st.[has_filter]                     AS [stats_is_filtered]
,       STATS_DATE(st.[object_id],st.[stats_id])
                                            AS [stats_last_updated_date]
,       co.[name]                           AS [stats_column_name]
,       ty.[name]                           AS [column_type]
,       co.[max_length]                     AS [column_max_length]
,       co.[precision]                      AS [column_precision]
,       co.[scale]                          AS [column_scale]
,       co.[is_nullable]                    AS [column_is_nullable]
,       co.[collation_name]                 AS [column_collation_name]
,       QUOTENAME(sm.[name])+'.'+QUOTENAME(tb.[name])
                                            AS two_part_name
,       QUOTENAME(DB_NAME())+'.'+QUOTENAME(sm.[name])+'.'+QUOTENAME(tb.[name])
                                            AS three_part_name
FROM    sys.objects                         AS ob
JOIN    sys.stats           AS st ON    ob.[object_id]      = st.[object_id]
JOIN    sys.stats_columns   AS sc ON    st.[stats_id]       = sc.[stats_id]
                            AND         st.[object_id]      = sc.[object_id]
JOIN    sys.columns         AS co ON    sc.[column_id]      = co.[column_id]
                            AND         sc.[object_id]      = co.[object_id]
JOIN    sys.types           AS ty ON    co.[user_type_id]   = ty.[user_type_id]
JOIN    sys.tables          AS tb ON    co.[object_id]      = tb.[object_id]
JOIN    sys.schemas         AS sm ON    tb.[schema_id]      = sm.[schema_id]
GO


/****************************************************************************************
STEP 4 of 4 - Manually create and drop Stats on a folder
****************************************************************************************/

EXEC sys.sp_create_openrowset_statistics N'SELECT 
    orderdatekey
FROM OPENROWSET(
    BULK ''https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolders/Parquet/Factinternetsales/'',
    FORMAT = ''PARQUET'')
AS [r]'

EXEC sys.sp_drop_openrowset_statistics N'SELECT 
    orderdatekey
FROM OPENROWSET(
    BULK ''https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolders/Parquet/Factinternetsales/'',
    FORMAT = ''PARQUET'')
AS [r]'