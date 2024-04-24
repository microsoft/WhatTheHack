# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Azure Open AI Apps What The Hack. Before you can hack, you will need to set up some prerequisites.

## Description

In this challenge, you will setup the necessary pre-requisites and environment to complete the rest of the hack, including:

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->


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

**NOTE:** If your codespace times out, just go ahead and restart it. You can increase the timeout of Codespace, by doing....


### Use Local Workstation
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

</details>

### Student Resources
The sample applications were developed using Python/Typescript/Javascript. 

Azure OpenAI and its suite of sister Cognitive Services as well as frameworks such as Langchain have support for both Typescript and Python.

You fill find the following folders containing the sample front end and backend API application to help you get started:
- ContosoAIAppsBackend (contains an Azure function app that provides capabilities of processing data and interacting with Cognitive Services like OpenAI and Azure Document Intelligence)
- ContosoAIAppsFrontend (contains an Angular App that provides a user interface to some example virtual assistants)

The apps also contain helper utilities, functions and tools to help you speed up development as well as hints to the challenges you will be taking on:

### Setup Service Principal (Only applicable for MFST FTE's with FDPO Subscription)
<details>
<summary>Click to expand/collapse SP Requirements </summary>

 Go to the Azure Portal and open the Cloud Shell. Run the following command to create a service principal with the Contributor role on the subscription. Replace the <NAME> with a meaningful name.  Replace the subscription ID with your subscription ID.
  ````bash
  az ad sp create-for-rbac --name <NAME> --role contributor --scopes /subscriptions/00000000-0000-0000-0000-000000000000
  ````
  Your output should look something like this:

  ![Service Principle](/068-AzureOpenAIApps/images/service-principle.png)

<b>Make sure you save the output of the above command as you will need it later.</b>

</details>


### Provisioning Azure Resources
In the codespace, the terminal will default to be visible so you can execute the following comamnds.
```bash
cd infra
pwsh deploy.ps1 -SubscriptionId "" -Location "" -ResourceGroupName ""
```

- SubscriptionId: The Azure Subscription ID where you want to deploy the resources
- Location: The Azure Region where you want to deploy the resources
- ResourceGroupName: The name of the resource group where you want to deploy the resources


**NOTE:** Additional parameters are required if you are using a service principal to deploy the resources.  Expand the hidden section below for instructions.

<details>
<summary>Click to expand/collapse Service Principal Login </summary>

```bash
cd infra
pwsh deploy.ps1 -SubscriptionId "" -Location "" -ResourceGroupName "" -UseServicePrincipal -ServicePrincipalId "" -ServicePrincipalPassword "" -TenantId ""
```
- ServicePrincipalId: The App ID
- ServicePrincipalPassword: The Service Principal Password
- TenantId: The Azure Tenant ID where you want to deploy the resources

</details>

The deployment process takes about 30 minutes to complete.

**NOTE:** If you have any errors during the deployment, there may be a conflict with the resources you are trying to deploy. In particlar, if you have capacity issue or quota issues.  You will need to re-deploy.
 - For capacity issues, you may need to try a different region in your deployment.
 - For and Open AI quota issues, you can add an otional parameter for the OpenAI region by adding the following parameter to the deployment command:
 
```bash
-OpenAILocation ""
```

  - OpenAILocation: The Azure Region where the models are available.  As of April 2024, the available regions are: australiaeast, canadaeast, francecentral, northcentralus, southindia, swedencentral, uksouth, westus.  Don't use eastus2 as it is the default in the deployment code.

 - For and Document Intelligence quota issues, you can add an otional parameters for the Document Intelligence region by adding the following parameter to the deployment command:

```bash
-DocumentIntelligenceLocation ""
```
 - DocumentIntelligenceLocation: The Azure Region where the Document Intelligence is  available.  As of April 2024, the available regions are: westus2 and westeurope.  Don't use eastus as it is the default in the deployment code.



### Install dependencies for Frontend and Backend 
Run the following command in the Terminal:
 
`npm install`

Navigate to the Backend and Install the Python Dependencies 
cd ../ContosoAIAppsBackend/
 
`pip install -r requirements.txt`

### Running the Backend Azure Function App

Navigate to the directory and Start up the function app

```
cd ContosoAIAppsBackend
func start 
```

### Setting up the Frontend User Interface

This assumes that the UI is already set up and we just need to boot up the Angular app

Navigate into the ContosoAIAppsFrontend folder and install the application dependencies

If your function app is running on a different port or machine, please update the src/environments/environment.ts config file accordingly

```
# Navigates into the folder 
cd ContosoAIAppsFrontend

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

## Learning Resources

Here are some resources that should provide you with background information and educational content on the resources you have just deployed

- [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/)
- [Document Intelligence Region/API Version Availability](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/overview?view=doc-intel-4.0.0)

