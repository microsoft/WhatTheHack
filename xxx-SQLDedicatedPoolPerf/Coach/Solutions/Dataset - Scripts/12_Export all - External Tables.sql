
/**************************************************************************************************************************************
STEP 1 of 5 - Create the Master Key and change this <ENTERSTRONGPASSWORDHERE> specifying a valid password 
https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/create-a-database-master-key?view=sql-server-ver15#:~:text=1%20Choose%20a%20password%20for%20encrypting%20the%20copy,encrypted%20using%20the%20password%20%2223987hxJ%23KL95234nl0zBe%22.%20...%20See%20More.
**************************************************************************************************************************************/
CREATE MASTER KEY ENCRYPTION BY PASSWORD='<ENTERSTRONGPASSWORDHERE>';
GO


/**************************************************************************************************************************************
STEP 2 of 5 - Create database scoped credential
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-database-scoped-credential-transact-sql?view=sql-server-ver15
**************************************************************************************************************************************/


CREATE DATABASE SCOPED CREDENTIAL [MYCREDENTIAL]
WITH IDENTITY='MANAGED SERVICE IDENTITY'
GO


/**************************************************************************************************************************************
STEP 3 of 5 - Create the external data source by changing the LOCATION value (YourContainerName@YourDataLakeGen2StorageAccount.DFS.CORE.WINDOWS.NET) 
specifying the proper container and Data Lake Gen2 Storage account name
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=sql-server-ver15&tabs=dedicated
**************************************************************************************************************************************/

CREATE EXTERNAL DATA SOURCE [MYEXTERNALDATASOURCE] 
WITH (TYPE = HADOOP, LOCATION = N'ABFSS://YourContainerName@YourDataLakeGen2StorageAccount.DFS.CORE.WINDOWS.NET', 
CREDENTIAL = [MYCREDENTIAL])
GO

/**************************************************************************************************************************************
STEP 4 of 5 - Create the Parquet external file format
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-file-format-transact-sql?view=sql-server-ver15&tabs=delimited
**************************************************************************************************************************************/

CREATE EXTERNAL FILE FORMAT [PARQUETFILE] WITH (FORMAT_TYPE = PARQUET)
GO

/**************************************************************************************************************************************
STEP 5 of 5 - Exporting data using CETAS syntaz
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-table-as-select-transact-sql?view=aps-pdw-2016-au7

Make sure you specify the proper value for the root folder in your container
**************************************************************************************************************************************/

CREATE EXTERNAL TABLE EXTDIMACCOUNT  
WITH  (   LOCATION = '/YourRootFolder/DIMACCOUNT/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMACCOUNT  
GO

CREATE EXTERNAL TABLE EXTDIMCURRENCY  
WITH  (   LOCATION = '/YourRootFolder/DIMCURRENCY/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS  
SELECT * FROM DIMCURRENCY  
GO

CREATE EXTERNAL TABLE EXTDIMCUSTOMER  
WITH  (   LOCATION = '/YourRootFolder/DIMCUSTOMER/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMCUSTOMER  
GO

CREATE EXTERNAL TABLE EXTDIMDATE  
WITH  (   LOCATION = '/YourRootFolder/DIMDATE/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMDATE  
GO

CREATE EXTERNAL TABLE EXTDIMDEPARTMENTGROUP  
WITH  (   LOCATION = '/YourRootFolder/DIMDEPARTMENTGROUP/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMDEPARTMENTGROUP  
GO

CREATE EXTERNAL TABLE EXTDIMEMPLOYEE  
WITH  (   LOCATION = '/YourRootFolder/DIMEMPLOYEE/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMEMPLOYEE  
GO

CREATE EXTERNAL TABLE EXTDIMGEOGRAPHY  
WITH  (   LOCATION = '/YourRootFolder/DIMGEOGRAPHY/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMGEOGRAPHY  
GO

CREATE EXTERNAL TABLE EXTDIMORGANIZATION  
WITH  (   LOCATION = '/YourRootFolder/DIMORGANIZATION/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMORGANIZATION  
GO


CREATE EXTERNAL TABLE EXTDIMPRODUCT  
WITH  (   LOCATION = '/YourRootFolder/DIMPRODUCT/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMPRODUCT  
GO

CREATE EXTERNAL TABLE EXTDIMPRODUCTCATEGORY  
WITH  (   LOCATION = '/YourRootFolder/DIMPRODUCTCATEGORY/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMPRODUCTCATEGORY  
GO

CREATE EXTERNAL TABLE EXTDIMPRODUCTSUBCATEGORY  
WITH  (   LOCATION = '/YourRootFolder/DIMPRODUCTSUBCATEGORY/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMPRODUCTSUBCATEGORY  
GO

CREATE EXTERNAL TABLE EXTDIMPROMOTION  
WITH  (   LOCATION = '/YourRootFolder/DIMPROMOTION/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMPROMOTION  
GO

CREATE EXTERNAL TABLE EXTDIMRESELLER  
WITH  (   LOCATION = '/YourRootFolder/DIMRESELLER/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMRESELLER  
GO

CREATE EXTERNAL TABLE EXTDIMSALESREASON  
WITH  (   LOCATION = '/YourRootFolder/DIMSALESREASON/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMSALESREASON  
GO

CREATE EXTERNAL TABLE EXTDIMSALESTERRITORY  
WITH  (   LOCATION = '/YourRootFolder/DIMSALESTERRITORY/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMSALESTERRITORY  
GO

CREATE EXTERNAL TABLE EXTDIMSCENARIO  
WITH  (   LOCATION = '/YourRootFolder/DIMSCENARIO/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM DIMSCENARIO  
GO

CREATE EXTERNAL TABLE EXTFACTCURRENCYRATE  
WITH  (   LOCATION = '/YourRootFolder/FACTCURRENCYRATE/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM FACTCURRENCYRATE  
GO

CREATE EXTERNAL TABLE EXTFACTFINANCE  
WITH  (   LOCATION = '/YourRootFolder/FACTFINANCE/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM FACTFINANCE  
GO

CREATE EXTERNAL TABLE EXTFACTINTERNETSALES  
WITH  (   LOCATION = '/YourRootFolder/FACTINTERNETSALES/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM FACTINTERNETSALES  
GO

CREATE EXTERNAL TABLE EXTFACTINTERNETSALESREASON  
WITH  (   LOCATION = '/YourRootFolder/FACTINTERNETSALESREASON/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM FACTINTERNETSALESREASON  
GO

CREATE EXTERNAL TABLE EXTFACTRESELLERSALES  
WITH  (   LOCATION = '/YourRootFolder/FACTRESELLERSALES/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM FACTRESELLERSALES  
GO


CREATE EXTERNAL TABLE EXTFACTSALES  
WITH  (   LOCATION = '/YourRootFolder/FACTSALES/'   , DATA_SOURCE = [MYEXTERNALDATASOURCE]   , FILE_FORMAT = [PARQUETFILE]    )  
AS   
SELECT * FROM FACTSALES  
GO
