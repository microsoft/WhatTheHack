# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Cosmic Troubleshooting What The Hack. Before you can hack, you will need to set up some prerequisites.

:warning: **NOTE:** This is not an Introduction to Cosmos DB hack. This hack assumes you already have a solid understanding on Azure Cosmos DB (and more specifically the Core API). If you need to skill-up with enough knowledge to get through this What The Hack, please have a look at the following resources:

- [Work with NoSQL data in Azure Cosmos DB](https://docs.microsoft.com/en-us/learn/paths/work-with-nosql-data-in-azure-cosmos-db/)
- [Azure Cosmos DB Labs - .NET (V3)](https://azurecosmosdb.github.io/labs/dotnet/labs/00-account_setup.html)

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Windows Subsystem for Linux](../../000-HowToHack/WTH-Common-Prerequisites.md#windows-subsystem-for-linux)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell) - v7.2 or newer required
    - [Azure PowerShell Cmdlets](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-8.2.0)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell Cmdlets](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-8.2.0)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
  - [VS Code plugin for Bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
- [Azure Storage Explorer](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Description

Now that you have the common prerequisites installed on your workstation, there are prerequisites specific to this hack.

Your Azure Subscription should have a quota of at least 4 instances for Azure Load Testing. Please also ensure you have the `Microsoft.LoadTestService` Resource provider registered ([How-To register a Resource provider](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types))

Your coach will provide you with a `Resources.zip` file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Please install these additional tools:

- .NET SDK 6.0 or later installed on your development machine. This can be downloaded from [here](https://www.microsoft.com/net/download/all) for multiple platforms.

In the `/Challenge00/` folder of the `Resources.zip` file given by your coach, you will find two deployment scripts that deploy a bicep template with the required services for the challenge, as well as building and deploying our sample web application.

Please deploy the infrastructure by running one of the following scripts in the `/Challenge00/` folder:

- Powershell: 
  ``` 
  # Update your Az Powershell commandlets
  Update-Module Az

  # Connect to your Azure Account
  Connect-AzAccount

  # Deploy the infrastructure
  # Please make sure you are using Powershell v7.2 or newer
  # You might need to unblock the file
  .\deploy.ps1 
  ```
- Bash:
  ```
  # Make sure your machine has the prerequisites
  # Also does an "az login"
  ./setup-machine.sh

  # Deploy the infrastructure
  ./deploy.sh
  ```

## Success Criteria


To complete this challenge successfully, you should check:

- The deployment script (either Powershell or Bash) has completed successfully
- The deployment script has deployed in your subscription under a Resource Group called `rg-wth-azurecosmosdb` (if left at the default value) and it contains the following resources:
  - Azure App Service Plan
  - Azure Application Insights
  - Azure App Service
  - Azure Cosmos DB Account
  - Azure Load Testing
  - A Managed Identity
  - Azure Function App
- You should have a web application running in your Azure Web App.
