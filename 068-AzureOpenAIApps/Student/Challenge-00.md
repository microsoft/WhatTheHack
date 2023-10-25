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

### Student Resources

Your coach will provide you with a `Resources.zip` file that contains resource files you will use to complete the challenges for this hack.  

These resources include Azure Functions, Angular Apps, starter code, and sample data sources. 

You should download and unpack the `Resources.zip` file there to your local workstation.  The rest of the challenges will refer to the relative paths inside the `Resources.zip` file where you can find the various resources to complete the challenges.

For the hack event October 23 - November 3, 2023, you can download the file here: [`Resources.zip`](https://aka.ms/wthopenaiappsresources)

### Installing Additonal Tools

Please install these additional tools:

- [Node v18.18.2](https://nodejs.org/en/download) or later
- Make sure [NPM 9.8.1](https://nodejs.org/en/download) or later is installed
- Install [Angular CLI](https://angular.io/cli#installing-angular-cli) globally

In the `/Challenge-00/` folder of the `Resources.zip` file, you will find sample apps provide the initial hack environment you will work with in subsequent challenges.

The sample applications were developed using Typescript/Javascript. 

If you are more comfortable with Python, Java or C#, you may follow the examples to create equivalent apps using your programming language of choice.

Azure OpenAI and its suite of sister Cognitive Services as well as frameworks such as Langchain have support for both Typescript and Python.

You fill find the following folders containing the sample front end and backend API application to help you get started:
- ContosoAIAppsBackend (contains an Azure function app that provides capabilities of processing data and interacting with Cognitive Services like OpenAI and Azure Document Intelligence)
- ContosoAIAppsFrontend (contains an Angular App that provides a user interface to some example virtual assistants)

The apps also contain helper utilities, functions and tools to help you speed up development as well as hints to the challenges you will be taking on:

### Provisioning Azure Resources

The examples below shows how to deploy the ARM template using Powershell or Bash

These are the variables:

- Deployment Name: rollout01
- Resource Group Name: contosoizzygroup
- Template File: ai-apps-wth-resources.json
- Parameter Files with Values: ai-apps-wth-resources.parameters.json

Please run the validation steps first before you deploy the resources to ensure that the values are valid before your proceed with your deployment.

The deployment process takes about 30 minutes to complete.

### Deploying the Resources with Powershell

````Powershell

# Command to Create a Resource Group
New-AzResourceGroup -Name contosoizzygroup -Location "East US"

# Validate the ARM template and the Parameter file
Test-AzResourceGroupDeployment -ResourceGroupName contosoizzygroup -TemplateFile ai-apps-wth-resources.json -TemplateParameterFile ai-apps-wth-resources.parameters.json

# Deploy the Resources with Parameter File
New-AzResourceGroupDeployment -Mode Incremental -Name rollout01 -ResourceGroupName contosoizzygroup -TemplateFile ai-apps-wth-resources.json -TemplateParameterFile ai-apps-wth-resources.parameters.json

````

### Deploying the Resources with Bash

````bash

# Create a resource group
az group create --name contosoizzygroup --location eastus

# Validate the ARM template and Parameter Files
az deployment group validate --resource-group contosoizzygroup --name rollout01 --template-file ai-apps-wth-resources.json  --parameters @ai-apps-wth-resources.parameters.json

# Deploy the resources
az deployment group create --mode Incremental --resource-group contosoizzygroup --name rollout01 --template-file ai-apps-wth-resources.json  --parameters @ai-apps-wth-resources.parameters.json

````

##### Setting up the Cognitive Search Indices

Use the Postman script to set up the index using the following variables for Postman

Make sure you use the service name for your Cognitive Search Instance as well as its admin key

| Variable Name  | Variable Value     |
|----------------|--------------------|
| apiVersion     | 2023-10-01-Preview |
| serviceName    | contosoizzysearch1 |
| indexName      | yachts             |
| adminKey       | YourAdminKeyHere   |

You will need to set up an index for the yachts and contosoIslands indices

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

