/*Create a new database to house the Serverless Views*/
CREATE DATABASE DataLakeSilverLayer;


/*Create a master key to protect your credentials*/
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<EnterAPassword>'


/*Create a credential to access containers in your demo storage account*/
CREATE DATABASE SCOPED CREDENTIAL WorkspaceIdentity WITH IDENTITY = 'Managed Identity'


/*Create and external data source connected to that credential*/
CREATE EXTERNAL DATA SOURCE SqlOnDemandMI WITH (
    LOCATION = 'https://<storageaccountname>.blob.core.windows.net',
    CREDENTIAL = WorkspaceIdentity
);


/*Creating logins and users and granting them the proper permissions*/
CREATE LOGIN SilverDataReader WITH PASSWORD = '<EnterAPassword>'; --Does not have to be the same as the master key--
CREATE USER SilverDataReader FROM LOGIN SilverDataReader;
ALTER ROLE db_datareader ADD MEMBER SilverDataReader;
GRANT REFERENCES ON DATABASE SCOPED CREDENTIAL::[WorkspaceIdentity] TO [SilverDataReader];


/*Create the Serverless Views*/
--If your SilverLake is based on Delta--
CREATE VIEW vwSilverSalesOrderDetail AS
SELECT *
FROM
    OPENROWSET(
        BULK 'contailer/path',
        DATA_SOURCE = 'SqlOnDemandMI',
        FORMAT = 'delta'    

    ) AS SalesOrderDetail;

--If your SilverLake is based on CSV--
CREATE VIEW vwSilverCustomerMaster AS
SELECT *
FROM
    OPENROWSET(
        BULK 'container/path/',
        DATA_SOURCE = 'SqlOnDemandMI',
        FORMAT = 'csv',
        PARSER_VERSION = '2.0',
        FIRSTROW = 1,
        HEADER_ROW = TRUE     
    ) AS Customers;


/*Query as normal SQL views now*/
SELECT * FROM vwSilverCustomerMaster;
SELECT * FROM vwSilverAddressMaster;
