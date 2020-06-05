# Challenge 0 -- Setup

[Next Challenge>](../Challenge1/readme.md)

## Description
The objective of this lab is to setup your on-premise data warehouse environment for the hack.  This will be your reference point for the migration.  Additionally, we want you to plan out and size your Azure Synapse Analytics environment.

## Success Criteria
1. Complete setup of your environment
2. Determine which SQL database offering is the best fit for the hack
3. Estimate how many DWU units you will require and the overall # of compute and storage nodes (No precision just concepts)

## Learning Resources
1. [Decision Tree for Synapse Analytics.](/images/decisiontree.png)
1. [Patterns & Anti-patterns](https://docs.microsoft.com/en-us/archive/blogs/sqlcat/azure-sql-data-warehouse-workload-patterns-and-anti-patterns)
1. [ISV Patterns](https://docs.microsoft.com/en-us/archive/blogs/sqlcat/common-isv-application-patterns-using-azure-sql-data-warehouse)
1. [DWU Units](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/what-is-a-data-warehouse-unit-dwu-cdwu)
1. [Capacity Settings](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits#data-warehouse-capacity-settings)
1. [DWU Architecture](https://www.databasejournal.com/features/mssql/getting-started-with-azure-sql-data-warehouse-part-2.html)
1. [DWU Configuration](/images/dwuconfig.png)


## Pre-requisites
1. Laptop computer as Development environment
2. Azure Subscription
3. Azure SQL Server 2017 Virtual Machine
4. Azure Synapse Analytics
5. Azure Data Factory SSIS Integration Runtime


### Setup your Development Environment on your Laptop
1. [SQL Server Management Studion (Version 18.x or higher)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
2. [Visual Studio 2017 with Integration Services](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-server-provision#1-configure-basic-settings) 
3. [Power BI Desktop](https://www.microsoft.com/en-us/download/details.aspx?id=58494)


### Setup Azure Tenant with Services for What the Hack

WWI runs their existing database platforms on-premise with SQL Server 2017.  There are two databases samples for WWI.  The first one is for their Line of Business application (OLTP) and the second
is for their data warehouse (OLAP).  You will need to setup both environments as our starting point in the migration.

1. If you do not have a on-premise SQL Server 2017, you can provision a Azure Virtual Machine running SQL Server 2017 using this [Step by step guidance](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-server-provision) Recommended size is DS12
    * Turn off IE Enhanced Security Configon VM in [Server Manager](https://medium.com/tensult/disable-internet-explorer-enhanced-security-configuration-in-windows-server-2019-a9cf5528be65)
    * Go to Windows Firewall internal to the VM and open a inbound port to 1433. This is required for SSIS Runtime to access the database.
    * Go to Network Security Group (Azure) and setup inbound ports with 1433
2. Download both WWI databases to your on-premise SQL server or Azure VM you have just provisioned. [Download Link](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0). Go to the section called, "SQL Server 2016 SP1 (or later) Any Edition aside from LocalDB; SQL Server 2016 RTM (or later) Evaluation/Developer/Enterprise Edition" and download the two bullets under this heading.
>The file names are WideWorldImporters-Full.bak and WideWorldImportersDW-Full.bak.  
>These two files are the OLTP and OLAP databases respectively.
> Copy these two files to this directory on the Virtual machine C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup
3. Follow this [Install and Configuration Instrution for the OLTP database](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-oltp-install-configure?view=sql-server-ver15)
4. Follow this [Install and Configuration Instrution for the OLAP database](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-dw-install-configure?view=sql-server-ver15)
5. Review the database catalog on the data warehouse for familiarity of the schema [Reference document](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-dw-database-catalog?view=sql-server-ver15)
6. Review ETL workflow to understand the data flow and architecture [Reference document](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-perform-etl?view=sql-server-ver15)
7. Create an Azure Synapse Analytics Data Warehouse with the lowest DWU [Step by step guidance](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/create-data-warehouse-portal) Recommended size of Azure Synapse is DW100.
    * Add your client IP address to the firewall for Synapse
    * Ensure you are leveraging SQL Server Management STudio 18.x or higher

## On-premise Architecture
![The Solution diagram is described in the text following this diagram.](/images/current.png)