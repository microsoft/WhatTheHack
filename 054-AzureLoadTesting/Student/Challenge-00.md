# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)


## Introduction

Thank you for participating in the Azure Load Testing What The Hack. Before you can hack, you will need to set up some prerequisites.

## Prerequisites

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
- [Azure Storage Explorer](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)
- [Apache JMeter](https://jmeter.apache.org/usermanual/get-started.html) - This requires Java 8+ to be installed
- [GitHub](https://github.com/) or [Azure DevOps](https://azure.microsoft.com/en-us/services/devops/?nav=min)

## Description

Now that you have the common prerequisites installed on your workstation, there is a sample application that we will be working off of for this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unzip it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unzip it there.

### Sample WebApp with Cosmos DB 
 
 The sample app is a WebApp deployed on App Service with Cosmos DB as a database. It counts the number of visitors visiting the page and inserts the same into a sample collection in Cosmos DB.

### Installation

1. In your terminal window, log into Azure and set a subscription(subscription which would contain the webapp) :

        az login
        az account set -s mySubscriptionName

1. Deploy the sample app using the PowerShell script. (Tip: macOS users can install PowerShell [here](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7.1))

        cd nodejs-appsvc-cosmosdb-bottleneck
        .\deploymentscript.ps1

1. You will be prompted to supply a unique application name and a location (default is `eastus`). A resource group for the resources would be created with the same name.
1. Once deployment is complete, browse to the running sample application with your browser.

        https://<app_name>.azurewebsites.net

### **Clean up resources**       

You may want to delete the resources to avoid incurring additional charges at the end of this hack. Use the `az group delete` command to remove the resource group and all related resources.

        az group delete --name myResourceGroup

Similarly, you can utilize the **Delete resource group** toolbar button on the sample application's resource group to remove all the resources.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a Bash shell with the Azure CLI available.
- Apache JMeter
- Verify that your sample application is running

