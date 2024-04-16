# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Azure Open AI Apps What The Hack. Before you can hack, you will need to set up some prerequisites.

## Description

In this challenge, you will setup the necessary pre-requisites and environment to complete the rest of the hack, including:

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

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


### Access Azure OpenAI 

You will need an Azure subscription to complete this hack. If you don't have one, get a free trial here...
- [Azure Subscription](https://azure.microsoft.com/en-us/free/)

Before you can start the hack, you will also need to apply for access to Azure OpenAI as it is currently in high-demand.

An Azure subscription is necessary to [apply for Azure OpenAI access](https://aka.ms/oaiapply). We recommend applying as early as possible as processing times will vary, sometimes taking more than several business days.

## Setup environment 

You can either use Github Codespaces or your local workstation. 

- [Use GitHub Codespaces](#use-github-codespaces)
- [Use Local Workstation](#use-local-workstation)

### Github Codespaces

We will be using Github Codespaces for this hack. A GitHub Codespace is a development environment that is hosted in the cloud that you access via a browser. All of the pre-requisite developer tools for this hack are pre-installed and available in the codespace.

You must have a GitHub account to use GitHub Codespaces. If you do not have a GitHub account, you can [Sign Up Here](https://github.com/signup).

GitHub Codespaces is available for developers in every organization. All personal GitHub.com accounts include a monthly quota of free usage each month. GitHub will provide users in the Free plan 120 core hours, or 60 hours of run time on a 2 core codespace, plus 15 GB of storage each month.

You can see your balance of available codespace hours on the [GitHub billing page](https://github.com/settings/billing/summary).

The GitHub Codespace for this hack will host the Jupyter Notebook files, configuration files, and other data files needed for this event. Here are the steps you will need to follow:

- A GitHub repo containing the student resources and Codespace for this hack is hosted here:
  - [WTH OpenAI Fundamentals Codespace Repo](https://github.com/devanshithakar12/wth-aiapps-codespace/tree/main)
  - Please open this link and sign in with your personal Github account. 

**NOTE:** Make sure you do not sign in with your enterprise managed Github account.

- Once you are signed in, click on the green "Code" button. Then click on "Codespaces". Finally, hit "Create codespace on main".

Your Codespace environment should load in a new browser tab. It will take approximately 3-5 minutes the first time you create the codespace for it to load.

- When the codespace completes loading, you should find an instance of Visual Studio Code running in your browser with the files needed for this hackathon.


### Use Local Workstation
**NOTE:** You can skip this section if are using GitHub Codespaces!

If you want to setup your environment on your local workstation, expand the section below and follow the requirements listed. 

<details>
<summary>Click to expand/collapse Local Workstation Requirements</summary>


To work on your local workstation, please ensure you have the following tools and resources before hacking:

- [Node v20.11.0](https://nodejs.org/en/download) - Only v20.11.0
- Make sure [NPM 10.2.4](https://nodejs.org/en/download) - Comes with Node Installation
- Install [Angular CLI](https://angular.io/cli#installing-angular-cli) globally
- Install the [Azure Functions Core Tools](https://www.npmjs.com/package/azure-functions-core-tools#installing) V4 Globally Using NPM
- Install [Python 3.11](https://www.python.org/downloads/)
- Install [Python Package Install PIP](https://pypi.org/project/pip/) 

## Student Resources
The sample applications were developed using Python/Typescript/Javascript. 

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

Copy over the example local.settings.json.example file and rename it to local.settings.json

The local.settings.json file is where all the environment variables used locally by the function app are defined.

You will need Python 3.11 running locally. If this is not available in your environment, please install Python 3.11

Install PIP (The Python Package Installer)
https://pypi.org/project/pip/

Install version 4 of the Azure Function Core Tools
https://www.npmjs.com/package/azure-functions-core-tools

````bash
# Navigate to the directory
cd ContosoAIAppsBackend

# Install dependencies
pip install -r requirements.txt

# Start up the function app
func start 

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

