# Challenge 01 - Building Out the Bronze - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

For this section, there are 2 main concepts that the particpants need to be able to showcase and articulate:

1. __Proper setup of the environment__<br>
   a. They should decide on a Resource Group within one user's subscription.<br>
   b. Be able to setup proper user access for all resources needed, including workspace access for both Dtabricks and Azure Synapse.<br>
   c. Articulate the reasons for their setup choices.<br>

2. __Hydration of the Bronze Data Lake__ - For this section they can use either Databricks or Synapse.  The key here is that they only copy in either Customer/Address information or Product/Sales Order information.  

For guidance on this we recommend only the following tables for each database.  

### Customer/Address Data

#### AdventureWorks
- SalesLT.Address
- SalesLT.CustomerAddress
- SalesLT.Customer

#### WideWorldImporters
- Application.Cities
- Application.StateProvinces
- Application.Countries
- Sales.Customers

### Product/Sales Order Data

#### AdventureWorks
- SalesLT.SalesOrderDetail
- SalesLT.SalesOrderHeader
- SalesLT.Product

#### WideWorldImporters
- Sales.Orders
- Sales.Orderlines
- Warehouse.StockItems

It is also imperative to share the Azure SQL database connection information to the teams so that they can connect successfully to the AdventureWorks and WideWorldImporters databases.


