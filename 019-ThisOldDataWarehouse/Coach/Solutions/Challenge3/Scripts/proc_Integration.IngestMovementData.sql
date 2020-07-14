CREATE  Procedure Integration.IngestMovementData 
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)


--This should match Staging table layout EXCEPT do NOT include identity and change dates to nvarchar

SET @SQL = '
IF OBJECT_ID(''[Integration].[FactMovement_external]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[FactMovement_external]

CREATE EXTERNAL TABLE [Integration].[FactMovement_external] (

[Date Key] nvarchar (50) NULL,
	[WWI Stock Item Transaction ID] [int] NULL,
	[WWI Invoice ID] [int] NULL,
	[WWI Purchase Order ID] [int] NULL,
	[Quantity] [int] NULL,
	[WWI Stock Item ID] [int] NULL,
	[WWI Customer ID] [int] NULL,
	[WWI Supplier ID] [int] NULL,
	[WWI Transaction Type ID] [int] NULL,
	[Last Modifed When] nvarchar(50) NULL
)
WITH
(
    LOCATION=''/Movement''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[Movement_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[Movement_Staging]

CREATE TABLE [Integration].[Movement_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT  [Date Key]
		, NULL as [Stock Item Key]
		, NULL as [Customer Key]
		, NULL as [Supplier Key]
		, NULL as [Transaction Type Key]
		, [WWI Stock Item Transaction ID]
		, [WWI Invoice ID]
		, [WWI Purchase Order ID]
		, [Quantity]
		, [WWI Stock Item ID]
		, [WWI Customer ID]
		, [WWI Supplier ID]
		, [WWI Transaction Type ID]
		, [Last Modifed When]

FROM [Integration].[FactMovement_external]
OPTION (LABEL = ''CTAS : Load [Integration].[Movement_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

