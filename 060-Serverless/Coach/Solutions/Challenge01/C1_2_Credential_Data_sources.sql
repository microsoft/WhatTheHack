/*****************************************************************************************************************************
What the hack - Serverless - How to work with it
CHALLENGE 01 - Excercise 02 - CREDENTIALS, EXTERNAL DATA SOURCE 

https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-openrowset#security
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-storage-files-storage-access-control?tabs=shared-access-signature#supported-storage-authorization-types
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-storage-files-overview?tabs=impersonation#permissions
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/tutorial-logical-data-warehouse
https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/create-a-database-master-key?view=sql-server-ver15
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-database-scoped-credential-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=azure-sqldw-latest&preserve-view=true&tabs=serverless

Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/

/****************************************************************************************
STEP 1 of 2 - How to use different authentication methods using external data source
OpenRowSet doesn't allow you to explicitly specify the auth methods you want to use, only AAD
You have to define credentials and data source to leverage different auth types
****************************************************************************************/

USE Serverless
GO

--CREATE THE MASTER ENC USING THIS SYNTAX
--https://learn.microsoft.com/en-us/sql/t-sql/statements/create-master-key-transact-sql?view=sql-server-ver16
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<strong password>'
GO

--Configuring Database Scoped Credential, it specify the authentication you want to use, in this case "Shared Access Signature"
--https://learn.microsoft.com/en-us/sql/t-sql/statements/create-database-scoped-credential-transact-sql?view=sql-server-ver16#examples
CREATE DATABASE SCOPED CREDENTIAL [SasToken]
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'
, SECRET = 'sp=rl&st=2022-11-29T09:18:13Z&se=2022-11-29T17:18:13Z&spr=https&sv=2021-06-08&sr=c&sig=IbtG5aSxazifKo5gGwJQ802IvC0c3%2BpWtnf5qNr8FCw%3D'
GO

--Data source defines the location and the credentials you wwant to use
CREATE EXTERNAL DATA SOURCE [SasFastHack_DataSource]
WITH (    LOCATION   = 'https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolders/',
          CREDENTIAL = SasToken
)
GO

SELECT * FROM OPENROWSET(BULK 'Parquet/Dimaccount/', 
                DATA_SOURCE = 'SasFastHack_DataSource', --SAS Auth
                FORMAT = 'PARQUET') as a
GO


-- Configuring Managed Identity
CREATE DATABASE SCOPED CREDENTIAL [MSIToken]
WITH IDENTITY = 'Managed Identity'
GO


CREATE EXTERNAL DATA SOURCE [MSIFastHack_DataSource]
WITH (    LOCATION   = 'https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolders/',
          CREDENTIAL = [MSIToken]
)
GO


-- Make sure you granted "Storage Blob Reader" to your synapse workspace (MSI)
SELECT * FROM OPENROWSET(BULK '/Parquet/Dimaccount/', 
                DATA_SOURCE = 'MSIFastHack_DataSource',
                FORMAT = 'PARQUET') as a
GO


-- No credentials, this way it will use AAD pass-through
CREATE EXTERNAL DATA SOURCE [FastHack_DataSource_NoCred]
WITH (    LOCATION   = 'https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolders/')
GO

SELECT * FROM OPENROWSET(BULK '/Parquet/Dimaccount/', 
                DATA_SOURCE = 'FastHack_DataSource_NoCred',
                FORMAT = 'PARQUET') as a
GO


/****************************************************************************************
STEP 2 of 2 - How to use different authentication methods using external data source
-- What if we're using SQL Auth ?
****************************************************************************************/


USE master
GO 

--CREATE SQL LOGIN 
--https://learn.microsoft.com/en-us/sql/t-sql/statements/create-login-transact-sql?view=azure-sqldw-latest&preserve-view=true
CREATE LOGIN mySQLLogin WITH PASSWORD = '<strong password>'
GO

USE Serverless
GO

CREATE USER mySQLUser FOR LOGIN mySQLLogin
GO

ALTER ROLE db_datareader ADD MEMBER mySQLUser
GO

GRANT ADMINISTER DATABASE BULK OPERATIONS TO mySQLUser
GO


GRANT REFERENCES ON DATABASE SCOPED CREDENTIAL::SASToken TO mySQLUser;
GO

GRANT REFERENCES ON DATABASE SCOPED CREDENTIAL::MSIToken TO mySQLUser;
GO


--Open a new session using the mySQLLogin and run commands below.

--It works with MSI
SELECT * FROM OPENROWSET(BULK '/Parquet/Dimaccount/', 
            DATA_SOURCE = 'MSIFastHack_DataSource',
            FORMAT = 'PARQUET') as a
GO

-- it works with SAS
SELECT * FROM OPENROWSET(BULK '/Parquet/Dimaccount/', 
            DATA_SOURCE = 'SasFastHack_DataSource',
            FORMAT = 'PARQUET') as a
GO

-- It fails with AAD
SELECT * FROM OPENROWSET(BULK '/Parquet/Dimaccount/', 
            DATA_SOURCE = 'FastHack_DataSource_NoCred',
            FORMAT = 'PARQUET') as a
GO

