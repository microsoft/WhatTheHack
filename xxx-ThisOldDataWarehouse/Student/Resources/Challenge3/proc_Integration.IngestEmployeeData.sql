CREATE Procedure Integration.IngestEmployeeData 
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)

SET @SQL = '
IF OBJECT_ID(''[Integration].[DimEmployee_external]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[DimEmployee_external]

CREATE EXTERNAL TABLE [Integration].[DimEmployee_external] (

	[WWI Employee ID] [int] NOT NULL,
	[Employee] [nvarchar](50) NOT NULL,
	[Preferred Name] [nvarchar](50) NOT NULL,
	[Is Salesperson] [bit] NOT NULL,
	[Photo] [varbinary](8000) NULL,
	[Valid From] nvarchar(50) NOT NULL,
	[Valid To] nvarchar(50) NOT NULL
)
WITH
(
    LOCATION=''/Employee''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[Employee_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[Employee_Staging]

CREATE TABLE [Integration].[Employee_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT * FROM [Integration].[DimEmployee_external]
OPTION (LABEL = ''CTAS : Load [Integration].[Employee_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

