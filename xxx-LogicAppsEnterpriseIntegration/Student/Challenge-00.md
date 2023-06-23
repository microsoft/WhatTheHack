# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Logic Apps What The Hack. Before you can hack, you will need to set up some prerequisites.

## Prerequisites

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
  - You will need _Owner_ permissions on the subscription to complete the hack (due to needing to grant RBAC access to the managed identity of the Logic App)
  - This hack can be run in a [Visual Studio subscription with Azure credits](https://azure.microsoft.com/en-us/pricing/member-offers/credit-for-visual-studio-subscribers/)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
  - [Azure Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-cli)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [PowerShell Core](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3)
  - This is needed to run the Azure Developer CLI correctly. If you don't have PowerShell Core, you can use [Option 2](./Challenge-00.md#option-2-deploying-using-azure-cli) below.
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [Logic Apps Standard extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurelogicapps)
- [.NET 6](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)
- [Azure Functions Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v4%2Cwindows%2Ccsharp%2Cportal%2Cbash)
- [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd?tabs=winget-windows%2Cbrew-mac%2Cscript-linux&pivots=os-windows)
- [Azure Storage Emulator](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azurite?tabs=visual-studio-code)

## Description

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Choose 1 of the options below to deploy the resources to your Azure subscription.

### Option 1: Deploying using Azure Developer CLI

1.  Login to Azure with the ID you wish to use for the workshop by running the following Azure Developer CLI command:

    ```shell
    azd auth login
    ```

1.  Deploy the Azure infrastructure & code by running the following Azure Developer CLI command:

    ```shell
    azd up
    ```

If any part of this script fails (missing dependencies, network issues, etc), you can use [Option 2](./Challenge-00.md#option-2-deploying-using-azure-cli) below instead.

### Option 2: Deploying using Azure CLI

1.  Login to Azure with the ID you wish to use for the workshop by running the following Azure CLI command:

    ```shell
    az login
    ```

1.  Modify the `infra/main.parameters.json` file with unique values for your deployment. Replace the `${VALUE}` placeholders with your own values.

    - **AZURE_ENV_NAME** - a unique name for your deployment (i.e. use your name or initials)
    - **AZURE_LOCATION** - the Azure region to deploy to (i.e. `SouthCentralUS`)
    - **AZURE_PRINCIPAL_NAME** - the name of the Azure AD SQL admin account (your User Principal Name _in this tenant_)
    - **AZURE_PRINCIPAL_ID** - the object ID of the Azure AD SQL admin account (your User Principal Name Object Id _in this tenant_)
    - **MY_IP** - the public IP address of your workstation

    You can run the following command to find out your `UPN`.

    ```shell
    az ad signed-in-user show --query userPrincipalName -o tsv
    ```

    You can run the following command to find out your `object ID`.

    ```shell
    az ad signed-in-user show --query id -o tsv
    ```

    You can run the following command to find out your `IP address` (or search for "what is my ip" in your favorite search engine)

    ```shell
    $(Invoke-WebRequest -Uri "https://api.ipify.org").Content
    ```

1.  Deploy the Bicep files by running the following Azure CLI commands

    ```shell
    cd infra
    ```

    ```shell
    az deployment sub create --location <azure-region-name> --template-file ./main.bicep --parameters ./main.parameters.json
    ```

1.  Deploy the Function App code.

    ```shell
    cd ../src/api
    ```

    ```shell
    func azure functionapp publish <function-app-name> --nozip
    ```

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a shell with the Azure CLI available.
- Verify that the ARM template has deployed the following resources in Azure:
  - Azure Logic Apps
  - Azure Functions
  - Azure SQL Database
  - Azure Storage Account
  - Azure Key Vault
  - Azure Application Insights
  - Azure Log Analytics Workspace
  - Azure Managed Identity
