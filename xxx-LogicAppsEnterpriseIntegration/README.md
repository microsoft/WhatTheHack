# What The Hack - Logic Apps Enterprise Integration

## Introduction

This hack will help you understand how to use Logic Apps to integrate your enterprise systems with other systems and services.  You will learn how to use Logic Apps to connect to other Azure services.  You will also learn how to use Logic Apps to orchestrate complex workflows and business processes.

## Learning Objectives

In this hack you will learn how to:

- Expose a REST API endpoint for users to call
- Ingest data from a JSON file into Azure Storage
- Write data to Azure SQL
- Modularize & add validation to your Logic App
- Integrate with Service Bus
- Monitor end-to-end workflows
- Authenticate with AzureAD when calling a custom API
- Author Logic Apps in Visual Studio Code

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Process JSON input data & write to Storage](Student/Challenge-01.md)**
	 - Create a Logic App workflow to process JSON input data & write it to Blob Storage
- Challenge 02: **[Write to SQL](Student/Challenge-02.md)**
	 - Add the ability to write data to SQL
- Challenge 03: **[Modularize & integrate with Service Bus](Student/Challenge-03.md)**
	 - Break up the Logic App into smaller pieces & integrate with Service Bus
- Challenge 04: **[Monitor end-to-end workflow](Student/Challenge-04.md)**
	 - Use correlation ID & Application Insights to monitor the end-to-end workflow
- Challenge 05: **[Validation & custom response](Student/Challenge-05.md)**
	 - Add validation & custom responses to the Logic App
- Challenge 06: **[Parameterize with app settings](Student/Challenge-06.md)**
	 - Parameterize the Logic App with app settings instead of hard-coding values
- Challenge 07: **[Authenticate with AzureAD when calling custom API](Student/Challenge-07.md)**
	 - Call a custom API protected via OAuth2 & AzureAD
- Challenge 08: **[Visual Studio Code authoring](Student/Challenge-08.md)**
	 - Author Logic Apps in Visual Studio Code

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

## Contributors

- Jordan Bean
