CREATE  Procedure Integration.IngestSaleData 
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)


--This should match Staging table layout EXCEPT do NOT include identity and change dates to nvarchar
--***Note: for fact tables, exclude NULL foreign keys from external table

SET @SQL = '
IF OBJECT_ID(''[Integration].[FactSale_external]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[FactSale_external]

CREATE EXTERNAL TABLE [Integration].[FactSale_external] (

      [Invoice Date Key] nvarchar(50),
        [Delivery Date Key] nvarchar(50),
        [WWI Invoice ID] int,
        [Description] nvarchar(100),
        [Package] nvarchar(50),
        [Quantity] int,
        [Unit Price] decimal(18,2),
        [Tax Rate] decimal(18,3),
        [Total Excluding Tax] decimal(18,2),
        [Tax Amount] decimal(18,2),
        [Profit] decimal(18,2),
        [Total Including Tax] decimal(18,2),
        [Total Dry Items] int,
        [Total Chiller Items] int,
        [WWI City ID] int,
        [WWI Customer ID] int,
        [WWI Bill To Customer ID] int,
        [WWI Stock Item ID] int,
        [WWI Salesperson ID] int,
        [Last Modified When] nvarchar(50)
)
WITH
(
    LOCATION=''/Sale''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[Sale_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[Sale_Staging]

CREATE TABLE [Integration].[Sale_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT NULL as [City Key]
      , NULL as [Customer Key]
      , NULL as [Bill To Customer Key]
      , NULL as [Stock Item Key]
      ,[Invoice Date Key]
      ,[Delivery Date Key]
      ,NULL [Salesperson Key]
      ,[WWI Invoice ID]
      ,[Description]
      ,[Package]
      ,[Quantity]
      ,[Unit Price]
      ,[Tax Rate]
      ,[Total Excluding Tax]
      ,[Tax Amount]
      ,[Profit]
      ,[Total Including Tax]
      ,[Total Dry Items]
      ,[Total Chiller Items]
      ,[WWI City ID]
      ,[WWI Customer ID]
      ,[WWI Bill To Customer ID]
      ,[WWI Stock Item ID]
      ,[WWI Salesperson ID]
      ,[Last Modified When]

FROM [Integration].[FactSale_external]
OPTION (LABEL = ''CTAS : Load [Integration].[Sale_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

