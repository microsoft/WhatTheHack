/*****************************************************************************************************************************
What the hack - Serverless - How to work with it
CHALLENGE 01 - Excercise 03 - FILE FORMAT and EXTERNEAL TABLES 

https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-external-tables?tabs=hadoop
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-file-format-transact-sql
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-cetas

Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/


/****************************************************************************************
STEP 1 of 2 - How to create External File format and tables to read data from Data Lake
With OPENROWSET you can specify a limited number of format options, 
in case of needs you can create an external file format
****************************************************************************************/

USE Serverless
GO

--OPENROWSET allows you to specify a limited numbers of Format options for csv files
SELECT * FROM OPENROWSET
	(
		BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/Yourfolders/Csv/Dimaccount_formattedcsv/'
		, FORMAT = 'CSV'
		, FIELDTERMINATOR  = ';'
		, FIELDQUOTE = '"'
	) 
WITH
(
	AccountKey int
	,ParentAccountKey int
	,AccountCodeAlternateKey int
	,ParentAccountCodeAlternateKey int
	,AccountDescription nvarchar(50)
	,AccountType nvarchar(50)
	,Operator nvarchar(50)
	,CustomMembers nvarchar(500)
	,ValueType nvarchar(50)
	,CustomMemberOptions nvarchar(50)
) A


--Or you can create a File format and external table to make it easier
--Defining the file format, this is mandatory when using external tables
CREATE EXTERNAL FILE FORMAT Csv_FileFormat  
WITH (  
    FORMAT_TYPE = DELIMITEDTEXT
	, FORMAT_OPTIONS (
		, FIELD_TERMINATOR = N';'
		, STRING_DELIMITER = N'"'
		, USE_TYPE_DEFAULT = TRUE
	)
);  


--Creating the external table
CREATE EXTERNAL TABLE EXTERNAL_CSV
(
	AccountKey int
	,ParentAccountKey int
	,AccountCodeAlternateKey int
	,ParentAccountCodeAlternateKey int
	,AccountDescription nvarchar(50)
	,AccountType nvarchar(50)
	,Operator nvarchar(50)
	,CustomMembers nvarchar(500)
	,ValueType nvarchar(50)
	,CustomMemberOptions nvarchar(50)
) 
WITH (
    LOCATION = 'Csv/Dimaccount_formattedcsv/',
    DATA_SOURCE = [MSIFastHack_DataSource],  
    FILE_FORMAT = Csv_FileFormat
)
GO

SELECT * FROM EXTERNAL_CSV
GO

/****************************************************************************************
STEP 2 of 2 - How to "export" data in a different format using CREATE TABLE AS SELECT syntax
****************************************************************************************/

CREATE EXTERNAL FILE FORMAT Parquet_FileFormat
WITH (  
    FORMAT_TYPE = PARQUET
);  
GO

--Creating the new external table 
CREATE EXTERNAL TABLE EXPORT_DIMACCOUNT_FORMATTED_PARQUET
WITH
(
	LOCATION = 'Parquet/export_dimaccount_formatted_parquet/'
	, DATA_SOURCE = [MSIFastHack_DataSource]
	, FILE_FORMAT = Parquet_FileFormat
)
AS
SELECT * FROM EXTERNAL_CSV
GO


SELECT * FROM EXPORT_DIMACCOUNT_FORMATTED_PARQUET
GO