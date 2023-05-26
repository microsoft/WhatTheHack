CREATE  Procedure Integration.IngestTransactionData 
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)


--This should match Staging table layout EXCEPT do NOT include identity and change dates to nvarchar
--***Note: for fact tables, exclude NULL foreign keys from external table

SET @SQL = '
IF OBJECT_ID(''[Integration].[FactTransaction_external]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[FactTransaction_external]

CREATE EXTERNAL TABLE [Integration].[FactTransaction_external] (

        [Date Key] nvarchar(50),
        [WWI Customer Transaction ID] int,
        [WWI Supplier Transaction ID] int,
        [WWI Invoice ID] int,
        [WWI Purchase Order ID] int,
        [Supplier Invoice Number] nvarchar(20),
        [Total Excluding Tax] decimal(18,2),
        [Tax Amount] decimal(18,2),
        [Total Including Tax] decimal(18,2),
        [Outstanding Balance] decimal(18,2),
        [Is Finalized] bit,
        [WWI Customer ID] int,
        [WWI Bill To Customer ID] int,
        [WWI Supplier ID] int,
        [WWI Transaction Type ID] int,
        [WWI Payment Method ID] int,
        [Last Modified When] nvarchar(50)

)
WITH
(
    LOCATION=''/Transaction''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[Transaction_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[Transaction_Staging]

CREATE TABLE [Integration].[Transaction_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT [Date Key]
      ,NULL as [Customer Key]
      ,NULL as [Bill To Customer Key]
      ,NULL as [Supplier Key]
      ,NULL as [Transaction Type Key]
      ,NULL as [Payment Method Key]
      ,[WWI Customer Transaction ID]
      ,[WWI Supplier Transaction ID]
      ,[WWI Invoice ID]
      ,[WWI Purchase Order ID]
      ,[Supplier Invoice Number]
      ,[Total Excluding Tax]
      ,[Tax Amount]
      ,[Total Including Tax]
      ,[Outstanding Balance]
      ,[Is Finalized]
      ,[WWI Customer ID]
      ,[WWI Bill To Customer ID]
      ,[WWI Supplier ID]
      ,[WWI Transaction Type ID]
      ,[WWI Payment Method ID]
      ,[Last Modified When]

FROM [Integration].[FactTransaction_external]
OPTION (LABEL = ''CTAS : Load [Integration].[Transaction_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

