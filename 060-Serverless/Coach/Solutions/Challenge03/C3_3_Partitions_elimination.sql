/*****************************************************************************************************************************
What the hack - Serverless - How to work with it
CHALLENGE 03 - Excercise 02 - Partition elimination

https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-openrowset
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-storage-files-storage-access-control?tabs=user-identity
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-json-files
https://docs.microsoft.com/en-us/sql/t-sql/functions/openjson-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/en-us/sql/t-sql/functions/json-value-transact-sql?view=sql-server-ver15

Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/

/**********************************************************************************************************
Step 1 of 4
Querying not partitioned folder and partitioned folder with simple filter
**********************************************************************************************************/
USE Serverless
GO

--Filtering the /FACTINTERNETSALES/*.parquet table, all files will be scanned increasing the I/O and the cost ($) for the execution
SELECT Top 10 *
FROM
    OPENROWSET(
        BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/Factinternetsales/*.parquet',
        FORMAT = 'PARQUET'
    ) r
WHERE ORDERDATEKEY = 20211025

--Filtering the /FACTINTERNETSALES_PARTITIONED/*.parquet table, all files will be scanned increasing the I/O and the cost ($) for the execution
SELECT Top 10 *
FROM
    OPENROWSET(
        BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/Factinternetsales_partitioned/*/*/*.parquet',
        FORMAT = 'PARQUET'
    ) r
WHERE ORDERDATEKEY = 20211025


/**********************************************************************************************************
Step 3 of 4
Metadata functions - There are functions we can leverage on to retrieve info about folders/Subfolders and files
**********************************************************************************************************/

-- but still, this query will not benefit from partition elimination
SELECT Top 10 r.filepath(1) [Year],r.filepath(2) [Month], r.filename() [FileName],*
FROM
    OPENROWSET(
        BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/Factinternetsales_partitioned/*/*/*.parquet',
        FORMAT = 'PARQUET'
    ) r
WHERE ORDERDATEKEY = 20211025

-- Adding the filters using the filepath function, this allows partition elimination and the query is saving tons of I/O and $
-- but you have to provide the folder name, not the [YEAR] and [MONTH] columns (Not available in our parquet)
SELECT Top 10 r.filepath(1) [Year],r.filepath(2) [Month], r.filename() [FileName],*
FROM
    OPENROWSET(
        BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/Factinternetsales_partitioned/*/*/*.parquet',
        FORMAT = 'PARQUET'
    ) r
WHERE ORDERDATEKEY = 20211025
	and r.filepath(1)='YEAR=2021' --(1) first level -> Year -> physical name of the folder
	AND r.filepath(2)='MONTH=10' --(2) second level -> Month -> physical name of the folder



/**********************************************************************************************************
Step 4 of 4
What about External table ?
**********************************************************************************************************/

--Columns Year and Month Are not in the List
CREATE EXTERNAL TABLE [dbo].[EXT_FACTINTERNETSALES_PARTITIONED]
(
	[PRODUCTKEY] [int],
	[ORDERDATEKEY] [int],
	[DUEDATEKEY] [int],
	[SHIPDATEKEY] [int],
	[CUSTOMERKEY] [int],
	[PROMOTIONKEY] [int],
	[CURRENCYKEY] [int],
	[SALESTERRITORYKEY] [int],
	[SALESORDERNUMBER] [varchar](8000),
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
	[CARRIERTRACKINGNUMBER] [varchar](8000),
	[CUSTOMERPONUMBER] [varchar](8000)
)
WITH (DATA_SOURCE = [MSIFastHack_DataSource],LOCATION = N'Parquet/Factinternetsales_partitioned/*/*/*.parquet',FILE_FORMAT = [ParquetFormat])
GO

--External tables prevent you to benefit from partition elimination, [YEAR] and [MONTH] fields are not available 
SELECT TOP 10 * FROM [dbo].[EXT_FACTINTERNETSALES_PARTITIONED]
WHERE ORDERDATEKEY = 20211025
GO


/**********************************************************************************************************
Step 4 of 4
What about Views + OPENROWSET + filepath
**********************************************************************************************************/

--Create External table prevents you to use partition elimination
--Views can expose partitioning folders
CREATE VIEW VW_FactInternetSales_Partitioned
AS
SELECT r.filepath(1) [Year],r.filepath(2) [Month], r.filename() [FileName],*
FROM
    OPENROWSET(
        BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolder/Parquet/Factinternetsales_partitioned/*/*/*.parquet',
        FORMAT = 'PARQUET'
    ) r
GO

--Partition elimination works, but you have to provide the folder name
SELECT top 10 * FROM VW_FactInternetSales_Partitioned
WHERE ORDERDATEKEY = 20211025
	and year ='YEAR=2021'
	AND month ='MONTH=10'