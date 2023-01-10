CREATE  Procedure Integration.IngestPurchaseData 
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)


--This should match Staging table layout EXCEPT do NOT include identity and change dates to nvarchar
--***Note: for fact tables, exclude NULL foreign keys from external table

SET @SQL = '
IF OBJECT_ID(''[Integration].[FactPurchase]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[FactPurchase]

CREATE EXTERNAL TABLE [Integration].[FactPurchase] (

  [Date Key] nvarchar(50),
        [WWI Purchase Order ID] int,
        [Ordered Outers] int,
        [Ordered Quantity] int,
        [Received Outers] int,
        [Package] nvarchar(50),
        [Is Order Line Finalized] bit,
        [WWI Supplier ID] int,
        [WWI Stock Item ID] int,
        [Last Modified When] nvarchar(50)
)
WITH
(
    LOCATION=''/Purchase''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[Purchase_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[Purchase_Staging]

CREATE TABLE [Integration].[Purchase_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT [Date Key]
      , NULL as [Supplier Key]
      , NULL as [Stock Item Key]
      ,[WWI Purchase Order ID]
      ,[Ordered Outers]
      ,[Ordered Quantity]
      ,[Received Outers]
      ,[Package]
      ,[Is Order Line Finalized] as [Is Order Finalized]
      ,[WWI Supplier ID]
      ,[WWI Stock Item ID]
      ,[Last Modified When]

FROM [Integration].[FactPurchase]
OPTION (LABEL = ''CTAS : Load [Integration].[Purchase_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

