# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Azure Open AI Apps What The Hack. Before you can hack, you will need to set up some prerequisites.

## Description

In this challenge, you will setup the necessary pre-requisites and environment to complete the rest of the hack, including:

- [Access Azure OpenAI](#access-azure-openai)
- [Setup Development Environment](#setup-development-environment)
  - [Use GitHub Codespaces](#use-github-codespaces)
  - [Use Local Workstation](#use-local-workstation)
- [Setup Sample Application](#setup-sample-application)
  - [Deploy Azure Resources](#deploy-azure-resources)
  - [Setup App Backend](#setup-app-backend)
  - [Setup App Frontend](#setup-app-frontend)

### Access Azure OpenAI 

You will need an Azure subscription to complete this hack. If you don't have one, get a free trial here...
- [Azure Subscription](https://azure.microsoft.com/en-us/free/)

Before you can start the hack, you will also need to apply for access to Azure OpenAI as it is currently in high-demand.

An Azure subscription is necessary to [apply for Azure OpenAI access](https://aka.ms/oaiapply). We recommend applying as early as possible as processing times will vary, sometimes taking more than several business days.

### Setup Development Environment 

You will need a set of developer tools to work with the sample application for this hack. 

You can use GitHub Codespaces where we have a pre-configured development environment set up and ready to go for you, or you can setup the developer tools on your local workstation.

A GitHub Codespace is a development environment that is hosted in the cloud that you access via a browser. All of the pre-requisite developer tools for this hack are pre-installed and available in the codespace.

- [Use GitHub Codespaces](#use-github-codespaces)
- [Use Local Workstation](#use-local-workstation)

**NOTE:** We highly recommend using GitHub Codespaces to make it easier to complete this hack.

#### Use Github Codespaces

You must have a GitHub account to use GitHub Codespaces. If you do not have a GitHub account, you can [Sign Up Here](https://github.com/signup).

GitHub Codespaces is available for developers in every organization. All personal GitHub.com accounts include a monthly quota of free usage each month. GitHub will provide users in the Free plan 120 core hours, or 60 hours of run time on a 2 core codespace, plus 15 GB of storage each month.

You can see your balance of available codespace hours on the [GitHub billing page](https://github.com/settings/billing/summary).

The GitHub Codespace for this hack will host the developer tools, sample application code, configuration files, and other data files needed for this hack. Here are the steps you will need to follow:

- A GitHub repo containing the student resources and Codespace for this hack is hosted here:
  - [WTH Azure OpenAI Apps Codespace Repo](https://github.com/devanshithakar12/wth-aiapps-codespace/)
  - Please open this link and sign in with your personal Github account. 

**NOTE:** Make sure you do not sign in with your enterprise managed Github account.

- Once you are signed in, click on the green "Code" button. Then click on "Codespaces". Finally, hit "Create codespace on main".

Your Codespace environment should load in a new browser tab. It will take approximately 3-5 minutes the first time you create the codespace for it to load.

- When the codespace completes loading, you should find an instance of Visual Studio Code running in your browser with the files needed for this hackathon.

Your developer environment is ready, hooray! Skip to section: [Deploy Azure Resources](#deploy-azure-resources)

**NOTE:** GitHub Codespaces time out after 20 minutes if you are not actively interacting with it in the browser. If your codespace times out, you can restart it and the developer environment and its files will return with its state intact within seconds. Codespaces expire after 30 days unless you extend the expiration date. When a Codespace expires, the state of all files in it will be lost.

#### Use Local Workstation

**NOTE:** You can skip this section if are using GitHub Codespaces!

If you want to setup your environment on your local workstation, expand the section below and follow the requirements listed. 

<details>
<summary>Click to expand/collapse Local Workstation Requirements</summary>

To work on your local workstation, please ensure you have the following tools and resources before hacking:
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
- [Node v20.11.0](https://nodejs.org/en/download) - Only v20.11.0
- Make sure [NPM 10.2.4](https://nodejs.org/en/download) - Comes with Node Installation
- Install [Angular CLI](https://angular.io/cli#installing-angular-cli) globally
- Install the [Azure Functions Core Tools](https://www.npmjs.com/package/azure-functions-core-tools#installing) V4 Globally Using NPM
- Install [Python 3.11](https://www.python.org/downloads/)
- Install [Python Package Install PIP](https://pypi.org/project/pip/) 

#### Student Resources

The sample application code, Azure deployment scripts, and sample data sources for this hack are available in a Student Resources package.

- [Download and unpack the Resources.zip](<INSERT LINK HERE>) package to your local workstation.

The rest of the challenges will refer to the relative paths inside the `Resources.zip` file where you can find the various resources to complete the challenges.

</details>

### Setup Sample Application

**TODO:** Add overview of the sample application here and the Azure architecture that will support it in the cloud.

The sample application for this hack was developed using Python and Typescript/Javascript. 

Azure OpenAI and its suite of sister Cognitive Services as well as frameworks such as Langchain have support for both Typescript and Python.

In your codespace, or student `Resources.zip` package, you fill find the following folders containing the frontend and backend API of the sample application to help you get started:
- `/ContosoAIAppsBackend` (contains an Azure function app that provides capabilities of processing data and interacting with Cognitive Services like OpenAI and Azure Document Intelligence)
- `/ContosoAIAppsFrontend` (contains an Angular App that provides a user interface to some example virtual assistants)

The apps also contain helper utilities, functions and tools to help you speed up development as well as hints to the challenges you will be taking on.

#### Deploy Azure Resources

We have provided a deployment script and a set of Bicep templates which will deploy and configure the Azure resources required to run the sample application in the cloud. You can find these files in the `/infra` folder.

The deployment script uses the Azure PowerShell Commandlets to log into your Azure subscription. The script can be run from the terminal in your Codespace, or the terminal on your local workstation.

**NOTE:** Logging into your Azure subscription with PowerShell or the Azure CLI from a GitHub Codespace requires a Device Login Code. Some Azure subscriptions may block this method of authentication. For subscriptions where authentication with a Device Login Code is not permitted, you will need to create and use an Azure Service Principal to login from GitHub Codespaces.

##### Setup Service Principal

If your Azure subscription does not allow authentication with a Device Login Code, expand the hidden section below to learn how to create an Azure Service Principal.

**NOTE:** Microsoft FTE's with an Azure subscription in the FDPO Entra ID tenant will need to use a Service Principal so that they can log in to the Azure CLI.

<details>
<summary>Click to expand/collapse SP Requirements </summary>

To create an Azure Service Principal, we recommend using the [Azure Cloud Shell](https://shell.azure.com) in your browser. You will then collect the login details and use them to run the sample application's deployment script.

Run the following command to create a service principal with the Contributor role on the subscription. Replace the `<NAME>` with a meaningful name.  Replace the subscription ID (`00000000-0000-0000-0000-000000000000`) with your Azure subscription ID.

  ````bash
  az ad sp create-for-rbac --name <NAME> --role contributor --scopes /subscriptions/00000000-0000-0000-0000-000000000000
  ````
  Your output should look something like this:

  ![Service Principal](/068-AzureOpenAIApps/images/service-principle.png)

<b>Make sure you save the output of the above command as you will need it later.</b>

</details>

##### Provisioning Azure Resources

In the codespace, the terminal will default to be visible so you can execute the following comamnds:

```bash
cd infra
pwsh deploy.ps1 -SubscriptionId "" -ResourceGroupName ""
```

- `SubscriptionId`: The Azure Subscription ID where you want to deploy the resources
- `ResourceGroupName`: The name of the resource group where you want to deploy the resources

**NOTE:** Additional parameters are required if you are using a service principal to deploy the resources.  Expand the hidden section below for instructions.

<details>
<summary>Click to expand/collapse Service Principal Login </summary>

```bash
cd infra
pwsh deploy.ps1 -SubscriptionId "" -ResourceGroupName "" -UseServicePrincipal -ServicePrincipalId "" -ServicePrincipalPassword "" -TenantId ""
```
- `ServicePrincipalId`: The App ID
- `ServicePrincipalPassword`: The Service Principal Password
- `TenantId`: The Azure Tenant ID where you want to deploy the resources

</details>

The deployment process takes about 30 minutes to complete.

###### Capacity Issues

At the time this hack was authored (June 2024), the Azure AI resources required for the solution are not all available in the same region. By default, the deployment script above will attempt to deploy most Azure resources in `East US 2` and the Azure Document Intelligence resource in `East US`.

If you have any errors with capacity or quota issues, you may need to re-deploy the solution using one or more of the optional location parameters below. Note the resource type and region that failed to deploy in any error messages, and choose a different region based on the information below.

- `Location`: The Azure region where you want to deploy the resources. (Default value is `eastus2`)
- `OpenAILocation`: The Azure region where the Azure OpenAI resource will be deployed. (Default value is `eastus2`)
- `DocumentIntelligenceLocation`: The Azure region where the Azure Document Intelligence resource will be deployed. (Default value is `eastus`)
 
As of June 2024, Azure OpenAI is available in the following regions: `eastus2`, `australiaeast`, `canadaeast`, `francecentral`, `northcentralus`, `southindia`, `swedencentral`, `uksouth`, `westus`

As of June 2024, Azure Document Intelligence is available in the following regions: `eastus`, `westus2`, `westeurope`

#### Setup App Backend

Open a new terminal in VScode and then 

Navigate to the `/ContosoAIAppsBackend` folder and Start up the function app

```
cd ContosoAIAppsBackend
pip install -r requirements.txt
func start 
```

#### Setup App Frontend

This assumes that the UI is already set up and we just need to boot up the Angular app

Open another new terminal in VScode and then 

Navigate into the `/ContosoAIAppsFrontend` folder and install the application dependencies

If your function app is running on a different port or machine, please update the src/environments/environment.ts config file accordingly
**TODO:** Add Instructions on how to grab the codespace port forwarding URL into environment.ts
**TODO:** Add instruction to open a new terminal window. Give explanation of how to open a 2nd terminal in Codespace.

```
# Navigates into the folder 
cd ContosoAIAppsFrontend

# Installs the node packages required for the frontend
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
 
Your Azure Function Backend and Front End applications should be up and running and reachable via HTTP (Browser)

You should also be able to ask each assistant for their name from the front-end and each assistant should respond correctly with the correct name configured in the app's system prompts.

## Learning Resources

Here are some resources that should provide you with background information and educational content on the resources you have just deployed

- [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/)
- [Document Intelligence Region/API Version Availability](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/overview?view=doc-intel-4.0.0)

