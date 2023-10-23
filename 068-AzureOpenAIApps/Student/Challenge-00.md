# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the OpenAIOnAzure What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Windows Subsystem for Linux](../../000-HowToHack/WTH-Common-Prerequisites.md#windows-subsystem-for-linux)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
- [Azure Storage Explorer](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specific to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Please install these additional tools:

- [Node v18.18.2](https://nodejs.org/en/download) or later
- Make sure [NPM 9.8.1](https://nodejs.org/en/download) or later is installed
- Install [Angular CLI](https://angular.io/cli#installing-angular-cli) globally

In the `/Challenge-00/` folder of the Resources.zip file, you will find sample apps provide the initial hack environment you will work with in subsequent challenges.

The sample applications were developed using Typescript/Javascript. 

If you are more comfortable with Python, Java or C#, you may follow the examples to create equivalent apps using your programming language of choice.

Azure OpenAI and its suite of sister Cognitive Services as well as frameworks such as Langchain have support for both Typescript and Python.

You fill find the following folders containing the sample front end and backend API application to help you get started:
- ContosoAIAppsBackend (contains an Azure function app that provides capabilities of processing data and interacting with Cognitive Services like OpenAI and Azure Document Intelligence)
- ContosoAIAppsFrontend (contains an Angular App that provides a user interface to some example virtual assistants)

The apps also contain helper utilities, functions and tools to help you speed up development as well as hints to the challenges you will be taking on:

### Provisioning Azure Resources

##### Resource 1: Create an Azure Service Bus instance 

Set up the resource following the steps available here

https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-quickstart-cli

##### Resource 2: Create two Azure Storage Accounts 

These are the storage accounts that will be used by the Function App as well as storing some documents and images

````bash
export RESOURCE_GROUP_NAME=""
export FORMS_STORAGE_ACCOUNT_NAME="contoso"
export WEBJOBS_STORAGE_ACCOUNT_NAME="contosojobs"
export REGION="eastus"
export FORMS_STORAGE_CONTAINER_NAME="contosodocuments"

# WEBJOBS_STORAGE_ACCOUNT_NAME
az storage account create --name $WEBJOBS_STORAGE_ACCOUNT_NAME --location $REGION --resource-group $RESOURCE_GROUP_NAME --sku Standard_LRS

# Create a Storage account for the Form Uploads and Downloads
az storage account create --name $FORMS_STORAGE_ACCOUNT_NAME --location $REGION --resource-group $RESOURCE_GROUP_NAME --sku Standard_LRS

# Create Storage Container for Forms Faxes
az storage container create --account-name $FORMS_STORAGE_ACCOUNT_NAME --name $FORMS_STORAGE_CONTAINER_NAME

````

https://learn.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-cli

##### Resource 3: Create a Cosmos DB Account

Create a database called contoso and then create the customers and yachts containers (collections) that will store the information for yachts and tourists.

https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/quickstart-portal


##### Resource 4: Create an Azure Cognitive Search Instance

Once the resource has been set up, use the Postman collection in the artifacts folder to set up the index

https://learn.microsoft.com/en-us/azure/search/search-create-service-portal

##### Resource 5: Create the Redis Cache instance

This redis cache instance could be used to track usage and consumption quotas and also keep track of chat message histories between the users and the virtual assistants.

https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/quickstart-create-redis

##### Resource 6: Create the Azure OpenAI Resources

Create an Azure OpenAI resource and then deploy an LLM model (gpt35-16k) as well as an embedding model (text-embedding-ada-002)

Please keep track of their deployment names because you will need this for configuring the Azure Function App

https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal

##### Setting up the Backend Azure Function App Locally

We will need to provision the above-mentioned Azure resources that will be used to power the apps.

Once the resources have been provisioned, please ensure that you set up the environment variables needed to power the back end Azure function app

The local.settings.json file is where all the environment variables used locally by the function app are defined.

````bash
# Navigate to the directory
cd ContosoAIAppsBackend

# Install dependencies
npm install

# Start up the function app
npm start 

````

### Setting up the Frontend User Interface

This assumes that the UI is already set up and we just need to boot up the Angular app

Navigate into the ContosoAIAppsFrontend folder and install the application dependencies

If your function app is running on a different port or machine, please update the src/environments/environment.ts config file accordingly

```
# Navigates into the folder 
cd ContosoAIAppsFrontend

# Installs the dependencies
npm install

# Starts up the web application on your local machine
npm start
```

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a bash shell with the Azure CLI available.
- Verify that you have deployed the following resources in Azure:

  - Azure OpenAI Service
  - Azure Cognitive Search
  - Two Azure Storage Accounts with Azure Blob Storage
  - Azure Cosmos DB service with databases and containers
  - Azure Service Bus with at least one queue set up
  - Azure Redis Cache Instance
  - Azure Document Intelligence Service (formerly Azure Form Recognizer)

## Learning Resources

Here are some resources that should provide you with background information and educational content on the resources you have just deployed

- [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/)

