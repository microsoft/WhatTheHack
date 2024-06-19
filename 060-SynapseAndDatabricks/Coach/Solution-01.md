# Challenge 01 - Building Out the Bronze - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

For this section, there are 2 main concepts that the participants need to be able to showcase and articulate:

1. __Proper setup of the environment__<br>
   - They should decide on a Resource Group within one user's subscription.<br>
   - Be able to setup proper user access for all resources needed, including workspace access for both Databricks and Azure Synapse.<br>
   - Articulate the reasons for their setup choices.  

   More details on these steps have already been shared in the Coach's ReadMe section.  
   It would be a good idea to nominate one person from each team to host the solution in a new Resource Group in their subscription and then provide the rest of the team full [access](https://learn.microsoft.com/en-us/azure/role-based-access-control/quickstart-assign-role-user-portal) to that Resource Group. This way each person in the team can take turns to lead the hack and just in case one person has to drop, the rest of the team are not bottlenecked.  

   It is the Coach's responsibilty to setup these databases ahead of time and test their connectivity.  Samples are located at:  
   - [AdventureWorks sample databases](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)  
   - [World-Wide-Importers sample databases](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers)  
         
   We recommend to make these Azure SQL databases so everyone can connect to them.  
   
   Please remember to share the Azure SQL database connection information to the teams so that they can connect successfully to the AdventureWorks and WideWorldImporters databases.  
  
2. __Hydration of the Bronze Data Lake__  
   For this section they can use either Databricks or Synapse.  Due to time constraints, it is important that they only copy in either Customer/Address information or Product/Sales Order information.  

   For guidance on this we recommend only the following tables for each of the SQL databases.  

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
  
  
  
Most students will probably use Azure Synapse to bring in the data to Bronze.  
In that case, the most common steps needed would be to learn about:
- Linked Services, and create and LS for the source SQL DBs and the target ADLS locations  
   [Linked services in Azure Data Factory and Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/data-factory/concepts-linked-services?context=%2Fazure%2Fsynapse-analytics%2Fcontext%2Fcontext&tabs=synapse-analytics)
- Dataflows, to bring in the data  
   [Data flows in Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/concepts-data-flow-overview)
  
  
For the Databricks crew, this link could provide some info on the steps that are needed to pull data out from our Azure SQL sample databases.  
[Using Azure Databricks to Query Azure SQL Database](https://www.mssqltips.com/sqlservertip/6151/using-azure-databricks-to-query-azure-sql-database/)
