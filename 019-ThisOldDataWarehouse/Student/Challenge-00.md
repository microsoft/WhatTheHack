# Challenge 00 - Setup

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

The objective of this lab is to setup your on-premise data warehouse environment for the hack.  This will be your reference point for the migration.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
- [Azure Storage Explorer](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Student Resources
Your coach will provide you with a `Resources.zip` file that contains resource files you will use to complete some of the challenges for this hack.

If you have installed all of the tools listed above on your local workstation, you should unpack the `Resources.zip` file there too.

If you plan to use the Azure Cloud Shell, you should upload the `Resources.zip` file to your cloud shell first and then unpack it there.

## Description

### Setup your Development Environment on your Laptop

For your local PC, ensure the following tools are installed.
1. [SQL Server Management Studion (Version 18.x or higher)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
2. [Visual Studio Code](https://code.visualstudio.com/Download) 
3. [Power BI Desktop](https://www.microsoft.com/en-us/download/details.aspx?id=58494)

### Setup Azure Tenant with Services for What the Hack

WWI runs their existing database platforms on-premise with SQL Server 2017.  There are two databases samples for WWI.  The first one is for their Line of Business application (OLTP) and the second is for their data warehouse (OLAP).  You will need to setup both environments as our starting point in the migration.

1. Open your browser and login to your Azure Tenant.  We plan to setup the Azure Services required for the What the Hack (WTH).  In your portal, open the [Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview)

2. Go into the cloud shell and select the subscription you plan to use for this WTH.

```
az account set --subscription {"Subscription Name"}
az account show
```

3. Create a resource group to store the Modern Data Warehouse What the Hack.  This will be the services for your source systems/environments.  In Cloudshell, run this command

```
az group create --location eastus2 --name {"Resource Group Name"}
```

4. In the Cloudshell, run this command to create a SQL Server instance and restore the databases.  This will create an Azure Container Instance and restore the WideWorldImporters and WideWorldImoprtersDW databases.  These two databases are your LOB databases for this hack.

```
az container create -g {Resource Group Name} --name mdwhackdb --image alexk002/sqlserver2019_demo:1  --cpu 2 --memory 7 --ports 1433 --ip-address Public
```

5. At the start of Challenge 1, reach out to your coach and they will share username and password for the LOB databases for this hack.

6. [Upload](https://docs.microsoft.com/en-us/azure/cloud-shell/persisting-shell-storage#upload-files) your ARM templates into Azure CloudShell. 


    /Student/Challenges/Challenge0/ARM.  
    The files are parametersFile.json and template.json.
    Edit the parmeters file and replace any {} with information requested.  


7. Run the last command to setup Azure Data Factory, Azure SQL Server Instance and SSIS Runtime.  This will build out for Challenge 1 the SSIS environment in Azure Data Factory.

```
az deployment group create --name final --resource-group {ENTER RESOURCE GROUP NAME} --template-file template.json --parameters parametersFile.json
```

8. Last step is to start your Azure Data Factory SSIS Runtime Service.  Go to [Connection pane](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-deploy-ssis-packages-azure#connections-pane) in your Azure Data Factory service.  The startup time is approximately 5 minutes.


9. Review the database catalog on the data warehouse for familiarity of the schema [Reference document](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-dw-database-catalog?view=sql-server-ver15)


10. Review ETL workflow to understand the data flow and architecture [Reference document](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-perform-etl?view=sql-server-ver15)

![The Solution diagram is described in the text following this diagram.](../Coach/images/current.png)

## Success Criteria

- Complete setup of your environment
- Determine which SQL database offering is the best fit for the hack
- Estimate the size of your environment and the overall # of compute and storage nodes (No precision just concepts)

## Learning Resources

- [Decision Tree for Analytics](../Coach/images/decisiontree.png)
- [DWU Units](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/resource-consumption-models)
- [Capacity Settings](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits?context=%2Fazure%2Fsynapse-analytics%2Fcontext%2Fcontext#data-warehouse-capacity-settings)
- [Capacity Limits SQL Dedicated Pools](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-service-capacity-limits?context=%2Fazure%2Fsynapse-analytics%2Fcontext%2Fcontext)
- [Synapse Analytics Best Practices & Field Guidance](https://github.com/microsoft/DataMigrationTeam/blob/master/Whitepapers/Azure%20Synapse%20DW%20%20Pool%20Best%20Practices%20%26%20Field%20Guidance.pdf)
- [Azure Synapse Analytics Migration Guides](https://docs.microsoft.com/en-us/azure/synapse-analytics/migration-guides/)
- [Reference Architecture for Lambda Big Data Platforms](https://github.com/microsoft/DataMigrationTeam/blob/master/Whitepapers/Reference%20Lambda%20Architecture%20for%20Big%20Data%20Platform%20in%20Azure.pdf)
