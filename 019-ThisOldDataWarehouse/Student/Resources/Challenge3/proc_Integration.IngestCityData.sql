CREATE Procedure Integration.IngestCityData 
AS
BEGIN

DECLARE @SQL nvarchar(max) = N''

DECLARE @timestamp char(8) = convert(char(8), getdate(), 112)

SET @SQL = '
IF OBJECT_ID(''[Integration].[DimCity_external]'') IS NOT NULL
DROP EXTERNAL TABLE [Integration].[DimCity_external]

CREATE EXTERNAL TABLE [Integration].[DimCity_external] (

	        [WWI City ID] int,
        City nvarchar(50),
        [State Province] nvarchar(50),
        Country nvarchar(50),
        Continent nvarchar(30),
        [Sales Territory] nvarchar(50),
        Region nvarchar(30),
        Subregion nvarchar(30),
        --[Location] varchar(max),
        [Latest Recorded Population] bigint,
        [Valid From] nvarchar(50),
        [Valid To] NVARCHAR(50)
)
WITH
(
    LOCATION=''/City''
,   DATA_SOURCE = AzureDataLakeStorage
,   FILE_FORMAT = TextFileFormat
,   REJECT_TYPE = VALUE
,   REJECT_VALUE = 0
);'

EXECUTE sp_executesql @SQL   --Create External Table
--print @sql

SET @SQL = N'
IF OBJECT_ID(''[Integration].[City_Staging]'') IS NOT NULL
DROP TABLE  [Integration].[City_Staging]

CREATE TABLE [Integration].[City_Staging]
WITH (DISTRIBUTION = ROUND_ROBIN )
AS
SELECT * FROM [Integration].[DimCity_external]
OPTION (LABEL = ''CTAS : Load [Integration].[City_Staging]'');
'

EXECUTE sp_executesql @SQL   --Load data from external table into staging table
--print @sql




END

