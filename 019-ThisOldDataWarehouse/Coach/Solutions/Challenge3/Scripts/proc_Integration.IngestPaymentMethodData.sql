CREATE Procedure Integration.[IngestPaymentMethodData]
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)

SET @SQL = '
IF OBJECT_ID(''[Integration].[DimPaymentMethod]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[DimPaymentMethod]

CREATE EXTERNAL TABLE [Integration].[DimPaymentMethod] (

	       [WWI Payment Method ID] [int] NOT NULL,
	[Payment Method] [nvarchar](50) NOT NULL,
	[Valid From] nvarchar(50) NOT NULL,
	[Valid To] nvarchar(50) NOT NULL
)
WITH
(
    LOCATION=''/Payment Method''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[PaymentMethod_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[PaymentMethod_Staging]

CREATE TABLE [Integration].[PaymentMethod_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT * FROM [Integration].[DimPaymentMethod]
OPTION (LABEL = ''CTAS : Load [Integration].[PaymentMethod_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

