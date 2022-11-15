-- Run the following scripts in the Master Database of the Azure SQL Server
CREATE LOGIN [HackathonUser] WITH PASSWORD = 'H@ck@th0n!';
GO

CREATE USER [HackathonUser] FOR LOGIN [HackathonUser] WITH DEFAULT_SCHEMA=[dbo]
GO

ALTER ROLE db_datareader
	ADD MEMBER [HackathonUser];
GO

-- Run the following scripts in the AdventureWorksLT Database
CREATE USER [HackathonUser] FOR LOGIN [HackathonUser] WITH DEFAULT_SCHEMA=[SalesLT]
GO

ALTER ROLE db_datawriter 
	ADD MEMBER [HackathonUser];
GO

GRANT SELECT ON "SalesLT"."Address" TO [HackathonUser]
GRANT UPDATE ON "SalesLT"."Address" TO [HackathonUser]

GRANT SELECT ON "SalesLT"."Customer" TO [HackathonUser]
GRANT UPDATE ON "SalesLT"."Customer" TO [HackathonUser]

GRANT SELECT ON "SalesLT"."CustomerAddress" TO [HackathonUser]
GRANT UPDATE ON "SalesLT"."CustomerAddress" TO [HackathonUser]

GRANT SELECT ON "SalesLT"."Product" TO [HackathonUser]
GRANT UPDATE ON "SalesLT"."Product" TO [HackathonUser]

GRANT SELECT ON "SalesLT"."ProductCategory" TO [HackathonUser]
GRANT UPDATE ON "SalesLT"."ProductCategory" TO [HackathonUser]

GRANT SELECT ON "SalesLT"."ProductDescription" TO [HackathonUser]
GRANT UPDATE ON "SalesLT"."ProductDescription" TO [HackathonUser]

GRANT SELECT ON "SalesLT"."ProductModel" TO [HackathonUser]
GRANT UPDATE ON "SalesLT"."ProductModel" TO [HackathonUser]

GRANT SELECT ON "SalesLT"."ProductModelProductDescription" TO [HackathonUser]
GRANT UPDATE ON "SalesLT"."ProductModelProductDescription" TO [HackathonUser]

GRANT SELECT ON "SalesLT"."SalesOrderDetail" TO [HackathonUser]
GRANT UPDATE ON "SalesLT"."SalesOrderDetail" TO [HackathonUser]

GRANT SELECT ON "SalesLT"."SalesOrderHeader" TO [HackathonUser]
GRANT UPDATE ON "SalesLT"."SalesOrderHeader" TO [HackathonUser]


-- Run the following scripts in the WideWorldImporters Database
CREATE USER [HackathonUser] FOR LOGIN [HackathonUser] WITH DEFAULT_SCHEMA=[Sales]
GO

ALTER ROLE db_datawriter 
	ADD MEMBER [HackathonUser];
GO

GRANT SELECT ON "Application"."Cities" TO [HackathonUser]
GRANT UPDATE ON "Application"."Cities" TO [HackathonUser]

GRANT SELECT ON "Application"."Countries" TO [HackathonUser]
GRANT UPDATE ON "Application"."Countries" TO [HackathonUser]

GRANT SELECT ON "Application"."StateProvinces" TO [HackathonUser]
GRANT UPDATE ON "Application"."StateProvinces" TO [HackathonUser]

GRANT SELECT ON "Sales"."Customers" TO [HackathonUser]
GRANT UPDATE ON "Sales"."Customers" TO [HackathonUser]

GRANT SELECT ON "Sales"."OrderLines" TO [HackathonUser]
GRANT UPDATE ON "Sales"."OrderLines" TO [HackathonUser]

GRANT SELECT ON "Sales"."Orders" TO [HackathonUser]
GRANT UPDATE ON "Sales"."Orders" TO [HackathonUser]

GRANT SELECT ON "Warehouse"."StockItems" TO [HackathonUser]
GRANT UPDATE ON "Warehouse"."StockItems" TO [HackathonUser]
