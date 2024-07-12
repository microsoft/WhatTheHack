/*****************************************************************************************************************************
What the hack - Serverless - How to work with it
CHALLENGE 01 - Excercise 01 - OPENROWSET

https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-openrowset
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-storage-files-storage-access-control?tabs=user-identity
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-json-files
https://docs.microsoft.com/en-us/sql/t-sql/functions/openjson-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/en-us/sql/t-sql/functions/json-value-transact-sql?view=sql-server-ver15

Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/

/****************************************************************************************
STEP 1 of 3 - How to read Parquet files from Data Lake V2
Note you do not need to specify any schema
****************************************************************************************/


USE Serverless
GO

-- Read parquet files using AAD -> No need to specify table schema with parquet
SELECT * FROM OPENROWSET
	(
		BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolders/Parquet/Dimaccount/'
		, FORMAT = 'PARQUET'
	) A
GO

-- Wildcard: It reads all parquet files using AAD
SELECT * FROM OPENROWSET
	(
		BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolders/Parquet/Dimaccount/*.parq'
		, FORMAT = 'PARQUET'
	) A
GO

/****************************************************************************************
STEP 2 of 3 - How to read CSV from Data Lake V2
****************************************************************************************/

-- This fails
SELECT * FROM OPENROWSET
	(
		BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolders/Csv/Dimaccount_csv/', FORMAT = 'CSV'
		, HEADER_ROW = TRUE
	) A
GO

-- With CSV files schema must be specified
SELECT * FROM OPENROWSET(BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolders/Csv/Dimaccount_csv/', FORMAT = 'CSV'
							, HEADER_ROW = TRUE
							, FIRSTROW = 2)
WITH
(
	AccountKey INT,
	ParentAccountKey INT,
	AccountCodeAlternateKey INT,	
	ParentAccountCodeAlternateKey INT,
	AccountDescription VARCHAR(256),
	AccountType	VARCHAR(256),
	Operator VARCHAR(256),
	CustomMembers VARCHAR(256),
	ValueType VARCHAR(256),
	CustomMemberOptions VARCHAR(256)
) A
GO

-- Using PARSER_VERSION = '1.0' or '2.0' you can read Delimited CSV files without specifying schema
SELECT * FROM OPENROWSET
	(
		BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolders/Csv/Dimaccount_csv/*.txt'
		, FORMAT = 'CSV'
		, PARSER_VERSION = '2.0'
		, HEADER_ROW = TRUE
	) A
GO


/****************************************************************************************
STEP 3 of 3 - JSON document and files
****************************************************************************************/

/*
FORMAT = JSON is not supported but CSV can contains Json documents
this csv files contains 1188 Jsons in this format:

{Json1}
{Json2}
{Json3}
...
{Json1188}
*/

--reading values using the JSON_VALUE fn
--Notice you have to define the schema for the CSV file, it's 1 column only, nvarchar(max)
SELECT doc, JSON_VALUE(doc, '$.AccountKey') AccountKey
	, JSON_VALUE(doc, '$.ParentAccountKey') ParentAccountKey
	, JSON_VALUE(doc, '$.AccountKeyAlternateKey') AccountKeyAlternateKey
	, JSON_VALUE(doc, '$.ParentAccountCodeAlternateKey') ParentAccountCodeAlternateKey
	, JSON_VALUE(doc, '$.AccountDescription') AccountDescription
	, JSON_VALUE(doc, '$.AccountType') AccountType
	, JSON_VALUE(doc, '$.Operator') Operator
	, JSON_VALUE(doc, '$.CustomMembers') CustomMembers
	, JSON_VALUE(doc, '$.ValueType') ValueType
	, JSON_VALUE(doc, '$.CustomMemberOptions') CustomMemberOptions
FROM OPENROWSET
(
	BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolders/Json/Dimaccount_Json/', FORMAT = 'CSV'
	, FIELDTERMINATOR ='0x0b'
	, FIELDQUOTE = '0x0b'
) WITH (doc NVARCHAR(max)) AS RawJson


-- OPENJSON and Fields definition (usefull with nested lists)
SELECT * FROM OPENROWSET
(
	BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolders/Json/Dimaccount_Json/', FORMAT = 'CSV'
	, FIELDTERMINATOR ='0x0b'
	, FIELDQUOTE = '0x0b'
) WITH (doc NVARCHAR(max)) AS RawJson --raw json doc
CROSS APPLY OPENJSON(doc) 
WITH
(
	AccountKey int
	,ParentAccountKey int
	,AccountCodeAlternateKey int
	,ParentAccountCodeAlternateKey int
	,AccountDescription nvarchar(50)
	,AccountType nvarchar(50)
	,Operator nvarchar(50)
	,CustomMembers nvarchar(50)
	,ValueType nvarchar(50)
	,CustomMemberOptions nvarchar(50)
)


--Multiple Nested lists
DECLARE @rawjson NVARCHAR(MAX) = '{
	"Level1": 1,
	"List1": [
		{
			"Level2": 1,
			"List2": [
				{
					"Level3": 1
				},
				{
					"Level3": 2
				}
			]
		},
		{
			"Level2": 2,
			"List2": [
				{
					"Level3": 3
				},
				{
					"Level3": 4
				}
			]
		}
	]
}'

--This sintax doesn't work with multiple nested levels
SELECT JSON_VALUE(rawjson, '$.Level1')Level1
	,JSON_VALUE(rawjson, '$.Level2') Level2
	,JSON_VALUE(rawjson, '$.Level3') Level3
FROM (Select @rawjson rawjson) A

--Need to use OPENJSON to pass through nested levels
SELECT JSON_VALUE(rawjson, '$.Level1')Level1
	,JSON_VALUE(List1.value, '$.Level2') Level2
	,JSON_VALUE(List2.value, '$.Level3') Level3
FROM (Select @rawjson rawjson) A
	CROSS APPLY OPENJSON(rawjson, '$.List1') List1
	CROSS APPLY OPENJSON(List1.value, '$.List2') List2


--This works with a Standard JSON files where multiple JSON documents are stored as a JSON array.
SELECT JSON_VALUE(rawjson, '$.Level1')Level1
	,JSON_VALUE(List1.value, '$.Level2') Level2
	,JSON_VALUE(List2.value, '$.Level3') Level3
FROM (
	SELECT * FROM OPENROWSET(BULK 'https://YourStorageAccount.dfs.core.windows.net/YourContainer/YourFolders/Json/Nested_Json/NestedJSON.txt'
			, FORMAT = 'CSV' 
			, FIELDTERMINATOR ='0x0b'
			, FIELDQUOTE = '0x0b')
	WITH
	(
		rawjson NVARCHAR(MAX)
	) A
)A
	CROSS APPLY OPENJSON(rawjson, '$.List1') List1
	CROSS APPLY OPENJSON(List1.value, '$.List2') List2
GO