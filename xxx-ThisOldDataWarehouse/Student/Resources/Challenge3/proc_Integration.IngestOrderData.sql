CREATE  Procedure Integration.IngestOrderData 
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)


--This should match Staging table layout EXCEPT do NOT include identity and change dates to nvarchar
--***Note: for fact tables, exclude NULL foreign keys from external table

SET @SQL = '
IF OBJECT_ID(''[Integration].[FactOrder_external]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[FactOrder_external]

CREATE EXTERNAL TABLE [Integration].[FactOrder_external] (

	[Order Date Key] nvarchar(50) NULL,
	[Picked Date Key] nvarchar(50) NULL,
	[WWI Order ID] [int] NULL,
	[WWI Backorder ID] [int] NULL,
	[Description] [nvarchar](100) NULL,
	[Package] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[Unit Price] [decimal](18, 2) NULL,
	[Tax Rate] [decimal](18, 3) NULL,
	[Total Excluding Tax] [decimal](18, 2) NULL,
	[Tax Amount] [decimal](18, 2) NULL,
	[Total Including Tax] [decimal](18, 2) NULL,
	[WWI City ID] [int] NULL,
	[WWI Customer ID] [int] NULL,
	[WWI Stock Item ID] [int] NULL,
	[WWI Salesperson ID] [int] NULL,
	[WWI Picker ID] [int] NULL,
	[Last Modified When] nvarchar(50) NULL
)
WITH
(
    LOCATION=''/Order''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[Order_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[Order_Staging]

CREATE TABLE [Integration].[Order_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT NULL as [Order Staging Key]
      , NULL as [City Key]
      , NULL as [Customer Key]
      , NULL as [Stock Item Key]
      , [Order Date Key]
      , [Picked Date Key]
      , NULL as[Salesperson Key]
      , NULL as [Picker Key]
      , [WWI Order ID]
      , [WWI Backorder ID]
      , [Description]
      , [Package]
      , [Quantity]
      , [Unit Price]
      , [Tax Rate]
      , [Total Excluding Tax]
      , [Tax Amount]
      , [Total Including Tax]
      ,[WWI City ID]
      ,[WWI Customer ID]
      ,[WWI Stock Item ID]
      ,[WWI Salesperson ID]
      ,[WWI Picker ID]
      ,[Last Modified When]

FROM [Integration].[FactOrder_external]
OPTION (LABEL = ''CTAS : Load [Integration].[Order_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

