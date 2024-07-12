
/*****************************************************************************************************************************
What the hack - Serverless - CETAS
CHALLENGE 04
--CETAS as a performance solution
--You can use CREATE EXTERNAL TABLE AS SELECT (CETAS) in dedicated SQL pool or serverless SQL pool to complete the following tasks:
	--Create an external table
	--Export, in parallel, the results of a Transact-SQL SELECT. When using serverless SQL pool, CETAS is used to create an external table 
	  and export query results to Azure Storage Blob or Azure Data Lake Storage Gen2
--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-cetas
Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/
USE Serverless
GO

--masterkey
CREATE MASTER KEY ENCRYPTION BY PASSWORD= 'XXX!0000';

--Scope
CREATE DATABASE SCOPED CREDENTIAL scope_auth WITH IDENTITY = 'Managed Identity'


--Create an external file format for PARQUET files.  
CREATE EXTERNAL FILE FORMAT Parquet_file  
WITH (  
         FORMAT_TYPE = PARQUET  
)

--Data source
CREATE EXTERNAL DATA SOURCE Fact_FactInternet_sales_reason
WITH (
LOCATION = 'https://YourStorageAccount.blob.core.windows.net/YourFolder/Parquet/',
CREDENTIAL = [scope_auth]
)

--CETAS
CREATE EXTERNAL TABLE fact_ctas_FactInternet_sales_reason
WITH (
    LOCATION = 'FactInternet_sales_reason/',
    DATA_SOURCE = Fact_FactInternet_sales_reason,
    FILE_FORMAT  = Parquet_file

)  
AS
SELECT
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, COUNT_BIG(distinct Fis.SalesOrderNumber) SalesOrderNumber_COUNT
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM 

FROM (SELECT
		 *
		FROM
			OPENROWSET(-----------Replace the storage path \container
				BULK 'https://YourStorageAccount.blob.core.windows.net/YourFolder/Delta/Factinternetsales/',
   
				FORMAT = 'Delta'
			) AS FactInternetSales )AS FIS 

INNER JOIN 
	     (SELECT
			 *
			FROM
				OPENROWSET(-----------Replace the storage path \container
					BULK 'https://YourStorageAccount.blob.core.windows.net/YourFolder/Delta/Factinternetsalesreasons/',
   
					FORMAT = 'Delta'
				) AS FactInternetSalesReason )AS Fisr 

ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
INNER JOIN
   (SELECT
			 *
			FROM
				OPENROWSET(-----------Replace the storage path \container
					BULK 'https://YourStorageAccount.blob.core.windows.net/YourFolder/Delta/Dimsalesreasons/',
   
					FORMAT = 'Delta'
				) AS DimSalesReason )AS Dsr 
ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName



