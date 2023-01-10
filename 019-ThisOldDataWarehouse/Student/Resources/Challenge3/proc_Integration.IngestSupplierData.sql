CREATE  Procedure Integration.IngestSupplierData 
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)


--This should match Staging table layout EXCEPT do NOT include identity and change dates to nvarchar

SET @SQL = '
IF OBJECT_ID(''[Integration].[DimSupplier_external]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[DimSupplier_external]

CREATE EXTERNAL TABLE [Integration].[DimSupplier_external] (

	[WWI Supplier ID] [int] NOT NULL,
	[Supplier] [nvarchar](100) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[Primary Contact] [nvarchar](50) NOT NULL,
	[Supplier Reference] [nvarchar](20) NULL,
	[Payment Days] [int] NOT NULL,
	[Postal Code] [nvarchar](10) NOT NULL,
	[Valid From] nvarchar(50) NOT NULL,
	[Valid To] nvarchar(50) NOT NULL
)
WITH
(
    LOCATION=''/Supplier''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[Supplier_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[Supplier_Staging]

CREATE TABLE [Integration].[Supplier_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT * FROM [Integration].[DimSupplier_external]
OPTION (LABEL = ''CTAS : Load [Integration].[Supplier_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

