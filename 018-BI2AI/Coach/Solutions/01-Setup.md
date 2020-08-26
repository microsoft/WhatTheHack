# Challenge 1 - Setup

## Prerequisites

1. Your laptop: Windows (VM or Parallels is fine, sorry MacOS or Linux users, Power BI Desktop only runs on Windows).
1. Your Azure Subscription


## Introduction 

The primary objective of this activity is to just setup resources that will be used for subsequent challenges.  It will also familiarize students with creating Power BI Capacity in Azure.


## Hackflow

1. Create a new blob storage account with a new container 
1. A backup of the AdventureWorksDW has been provided for you in the following location.  Download the file and upload it to your newly created blob container. <https://cgmaiadjacent.blob.core.windows.net/backup/AdventureWorksDW.bacpac>
1. Create an Azure SQL Database server in the Azure Portal.  (Note:  Make sure you setup the database to allow access from other Azure services.)
1. Import the AdventureWorksDW database from the blob where you uploaded the .bacpac file
1.  In the Azure Portal create a new Power BI Embedded Capacity of size A2
1.  Login to PowerBI.com and create a new Application Workspace, and assign the created Power BI Embedded capacity to the workspace.  (Note:  It is important to login to Power BI with the same user that is set as the admin on the Power BI Embedded capacity

## Alternate Hackflow

In the Azure CLI, run the following series of commands to create and restore the AdventureWorksDW.  <em>Note:  we intentionally chose the Azure CLI because it's integrated into the Azure portal, and therefore requires no installation to use.</em>  The series of steps has placeholders for things like Resource Group and Server Name.  It's important to replace the same values in each location.  Also, we've preset the admin login and password in these scripts, but feel free to override them and use different values if you like.   The items that cannot be changed are the storage key and storage uri.

1. Create a new resource group
    ```
    az group create -l eastus2 -n <resource group name>
    ```
2. Create a new Azure SQL Server
    ```
    az sql server create -l eastus2 -g <resource group name> -n <sql server name> -u sqladmin -p AzureR0cksNow
    ```
3. Set the firewall rules on the Azure SQL Server to allow access to Azure Services (this includes Power BI)
    ```
    az sql server firewall-rule create -g <resource group name> -s <sql server name> -n allowazureaccess --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
    ```
4. Create a new Azure SQL Databse as the target to restore
    ```
    az sql db create -n AdventureWorksDW -s <sql server name> -g <resource group name> --service-objective S2
    ```
5. Import the database bacpac from a blob storage container

    ```
    az sql db import -s <sql server name> -n AdventureWorksDW -g <resource group name> -u sqladmin -p AzureR0cksNow --storage-key "?st=2020-02-20T17%3A37%3A51Z&se=2021-02-21T17%3A37%3A00Z&sp=rl&sv=2018-03-28&sr=b&sig=FPqvfQMJdy5pjB6tWSs9Iw2UmtTeWLDzH1ESO3Rhc4c%3D" --storage-key-type SharedAccessKey --storage-uri "https://cgmaiadjacent.blob.core.windows.net/backup/AdventureWorksDW.bacpac"

    ```

## Hints

1. If you're having trouble accessing your database, try checking the firewall configuration.


[Next challenge (Working with Data in Power BI) >](./02-Dataflows.md)