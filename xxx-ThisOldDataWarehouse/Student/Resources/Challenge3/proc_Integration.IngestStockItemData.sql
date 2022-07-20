CREATE Procedure Integration.[IngestStockItemData]
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)

SET @SQL = '
IF OBJECT_ID(''[Integration].[DimStockItem_external]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[DimStockItem_external]

CREATE EXTERNAL TABLE [Integration].[DimStockItem_external] (

	[WWI Stock Item ID] [int] NOT NULL,
	[Stock Item] [nvarchar](100) NOT NULL,
	[Color] [nvarchar](20) NOT NULL,
	[Selling Package] [nvarchar](50) NOT NULL,
	[Buying Package] [nvarchar](50) NOT NULL,
	[Brand] [nvarchar](50) NOT NULL,
	[Size] [nvarchar](20) NOT NULL,
	[Lead Time Days] [int] NOT NULL,
	[Quantity Per Outer] [int] NOT NULL,
	[Is Chiller Stock] [bit] NOT NULL,
	[Barcode] [nvarchar](50) NULL,
	[Tax Rate] [decimal](18, 3) NOT NULL,
	[Unit Price] [decimal](18, 2) NOT NULL,
	[Recommended Retail Price] [decimal](18, 2) NULL,
	[Typical Weight Per Unit] [decimal](18, 3) NOT NULL,
	[Photo] [varbinary](8000) NULL,
	[Valid From] nvarchar(50) NOT NULL,
	[Valid To] nvarchar(50) NOT NULL
)
WITH
(
    LOCATION=''/Stock Item''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[StockItem_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[StockItem_Staging]

CREATE TABLE [Integration].[StockItem_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT * FROM [Integration].[DimStockItem_external]
OPTION (LABEL = ''CTAS : Load [Integration].[StockItem_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

