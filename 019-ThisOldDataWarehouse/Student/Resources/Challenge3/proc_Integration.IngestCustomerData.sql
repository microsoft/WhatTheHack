
CREATE PROC [Integration].[IngestCustomerData] AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)

SET @SQL = '
IF OBJECT_ID(''[Integration].[DimCustomer_external]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[DimCustomer_external]

CREATE EXTERNAL TABLE [Integration].[DimCustomer_external] (

	[WWI Customer ID] [int] NOT NULL,
	[Customer] [nvarchar](100) NOT NULL,
	[Bill To Customer] [nvarchar](100) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[Buying Group] [nvarchar](50) NOT NULL,
	[Primary Contact] [nvarchar](50) NOT NULL,
	[Postal Code] [nvarchar](10) NOT NULL,
	[Valid From] nvarchar(50) NOT NULL,
	[Valid To] nvarchar(50) NOT NULL--,
	--[Lineage Key] [int] NOT NULL
)
WITH
(
    LOCATION=''/Customer''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[Customer_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[Customer_Staging]

CREATE TABLE [Integration].[Customer_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT * FROM [Integration].[DimCustomer_external]
OPTION (LABEL = ''CTAS : Load [Integration].[Customer_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

