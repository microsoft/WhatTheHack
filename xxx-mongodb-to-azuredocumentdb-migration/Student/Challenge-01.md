# Challenge 01 - Install the Azure DocumentDB migration extension for VS Code and Deploy Azure Document DB

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Now that you've gotten your source MongoDB application and database working, you will next be installing the Azure Document DB Migration Extension in Visual Studio Code so that you can migrate the data from your source MongoDB to Azure Document DB in the next challenge. You will also be trying out the Azure DocumentDB extension for MongoDB. 

## Prerequisites

You should have already completed the steps in [Challenge 0]()./Challenge-00.md) to set up your source MongoDB database and the sample application. 

## Description

First, you will install the Azure Document Migration extension in Visual Studio Code. 

- Install the [Azure DocumentDB migration extension](https://aka.ms/azure-documentdb-migration-extension). It will also install the DocumentDB for VS Code extension which we will use prior to migration.

Next, you will deploy Azure Document DB. 

**NOTE:** If you are using GitHub Codespaces, the `az login` command will use a Device Code to login. If your organization's Azure policy prevents this, follow these steps first before you run the deployment:
- Open your [Codespace in Visual Studio Code Desktop](https://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-in-visual-studio-code)
- From the terminal in Visual Studio Code, run these commands to login:
```
CODESPACES=false
az login
```
- Perform the following steps to create an instance of Azure DocumentDB in your Azure subscription
    - Open a New Terminal window in VS Code
    - Type the following commands to deploy Azure Document DB. 
    
    ```
    cd infra 
    ./deploy.sh --administratorLogin mflixadmin --administratorPassword <password>
    ```

    Optional: you can specify the `resourceGroupName` and `location` if you need to as arguments to the `deploy.sh` script as follows. ***Note***: It defaults to `rg-mflix-documentdb` and `eastus2` for those, respectively:
    ```
    cd infra 
    ./deploy.sh --resourceGroupName <your_resource_group_name> --location westus --administratorLogin mflixadmin --administratorPassword <password>
    ```

The deployment will take some time. While this is deploying, use the DocumentDB for VS Code extension to connect to your source MongoDB and explore the data. 

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that you have the Azure DocumentDB migration extension installed
- Verify that you have Azure DocumentDB deployed into your Azure subscription

## Learning Resources

- [What is Azure DocumentDB (with MongoDB compatibility)?](https://learn.microsoft.com/en-us/azure/documentdb/overview)
- [Azure DocumentDB documentation home](https://learn.microsoft.com/en-us/azure/documentdb/)
- [Connect to Azure DocumentDB using MongoDB Shell](https://learn.microsoft.com/en-us/azure/documentdb/how-to-connect-mongo-shell)
- [Azure DocumentDB migration extension](https://aka.ms/azure-documentdb-migration-extension)

