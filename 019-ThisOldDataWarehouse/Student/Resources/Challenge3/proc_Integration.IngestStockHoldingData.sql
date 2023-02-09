CREATE  Procedure Integration.IngestStockHoldingData 
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)


--This should match Staging table layout EXCEPT do NOT include identity and change dates to nvarchar
--***Note: for fact tables, exclude NULL foreign keys from external table

SET @SQL = '
IF OBJECT_ID(''[Integration].[FactStockHolding]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[FactStockHolding]

CREATE EXTERNAL TABLE [Integration].[FactStockHolding] (

        [Quantity On Hand] int,
        [Bin Location] nvarchar(20),
        [Last Stocktake Quantity] int,
        [Last Cost Price] int,
        [Reorder Level] int,
        [Target Stock Level] int,
        [WWI Stock Item ID] int
)
WITH
(
    LOCATION=''/Stock Holding''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[StockHolding_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[StockHolding_Staging]

CREATE TABLE [Integration].[StockHolding_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT NULL as [Stock Item Key]
      ,[Quantity On Hand]
      ,[Bin Location]
      ,[Last Stocktake Quantity]
      ,[Last Cost Price]
      ,[Reorder Level]
      ,[Target Stock Level]
      ,[WWI Stock Item ID]

FROM [Integration].[FactStockHolding]
OPTION (LABEL = ''CTAS : Load [Integration].[StockHolding_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

