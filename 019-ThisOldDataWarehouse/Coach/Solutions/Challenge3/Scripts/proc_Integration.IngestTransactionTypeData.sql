CREATE Procedure Integration.[IngestTransactionTypeData]
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)


--Populate layout from staging table (Note: ignore any identity columns and change dates to nvarchar)

SET @SQL = '
IF OBJECT_ID(''[Integration].[DimTransactionType_external]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[DimTransactionType_external]

CREATE EXTERNAL TABLE [Integration].[DimTransactionType_external] (

	[WWI Transaction Type ID] [int] NOT NULL,
	[Transaction Type] [nvarchar](50) NOT NULL,
	[Valid From] nvarchar(50) NOT NULL,
	[Valid To] nvarchar(50) NOT NULL
)
WITH
(
    LOCATION=''/Transaction Type''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[TransactionType_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[TransactionType_Staging]

CREATE TABLE [Integration].[TransactionType_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT * FROM [Integration].[DimTransactionType_external]
OPTION (LABEL = ''CTAS : Load [Integration].[TransactionType_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

