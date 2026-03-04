# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the OpenAI Fundamentals What The Hack. Before you can hack, you will need to set up some prerequisites.

## Description
In this challenge, you will set up the necessary prerequisites and environment to complete the rest of the hack, including:
- [Azure Subscription](#azure-subscription)
- [Setup Development Environment](#setup-development-environment)
  - [GitHub Codespaces](#setup-github-codespace)
  - [Local Workstation](#setup-local-workstation)
- [Deploy Microsoft Foundry Resources](#deploy-microsoft-foundry-resources)

### Azure Subscription

You will need an Azure subscription to complete this hack. If you don't have one, get a free trial here...
- [Azure Subscription](https://azure.microsoft.com/en-us/free/)

### Setup Development Environment

You will be working with Jupyter Notebooks and Python to interact with Azure OpenAI services for the hack.

[Jupyter Notebooks](https://jupyter.org/) are an open-source web application that allows you to create and share documents containing live code, equations, visualizations, and narrative text. It's useful for a wide range of tasks, such as data cleaning and transformation, numerical simulation, statistical modeling, data visualization, and machine learning.

Jupyter notebooks require a development environment to run in.

You can use [GitHub Codespaces](https://docs.github.com/en/codespaces/overview) where we have a pre-configured Jupyter development environment set up and ready to go for you, or you can setup a Jupyter lab environment on your local workstation using DevContainers.

A GitHub Codespace is a development environment that is hosted in the cloud that you access via a browser. All of the pre-requisite developer tools for this hack are pre-installed and available in the codespace.

- [Use GitHub Codespaces](#use-github-codespaces)
- [Use Local Workstation](#use-local-workstation)

We highly recommend using GitHub Codespaces to make it easier to complete this hack.

#### Use GitHub Codespaces

You must have a GitHub account to use GitHub Codespaces. If you do not have a GitHub account, you can [Sign Up Here](https://github.com/signup).

GitHub Codespaces is available for developers in every organization. All personal GitHub.com accounts include a monthly quota of free usage each month. GitHub will provide users in the Free plan 120 core hours, or 60 hours of run time on a 2 core codespace, plus 15 GB of storage each month.

You can see your balance of available codespace hours on the [GitHub billing page](https://github.com/settings/billing/summary).

The GitHub Codespace for this hack will host the Jupyter Notebook files, configuration files, and other data files needed for this event. Here are the steps you will need to follow:

- A GitHub repo containing the student resources and Codespace for this hack is hosted here:
  - [WTH OpenAI Fundamentals Codespace Repo](https://aka.ms/wth/openaifundamentals/codespace)
  - Please open this link and sign in with your personal Github account. 

**NOTE:** Make sure you do not sign in with your enterprise managed Github account.

Once you are signed in:
- Verify that the `Dev container configuration` drop down is set to `066-OpenAIFundamentals`
- Click on the green "Create Codespace" button.
  
Your Codespace environment should load in a new browser tab. It will take approximately 3-5 minutes the first time you create the codespace for it to load.

- When the codespace completes loading, you should find an instance of Visual Studio Code running in your browser with the files needed for this hackathon.

You are ready to run the Jupyter Notebook files, hooray! Skip to section: [Setup Microsoft Foundry Project](#Setup-Microsoft-Foundry-Project)

**NOTE:** If you close your Codespace window, or need to return to it later, you can go to [GitHub Codespaces](https://github.com/codespaces) and you should find your existing Codespaces listed with a link to re-launch it.

#### Use Local Workstation

**NOTE:** You can skip this section if are using GitHub Codespaces!

If you want to setup this environment on your local workstation, expand the section below and follow the requirements listed. We have provided a Dev Container that will load the development environment on your local workstation if you do not want to use GitHub Codespaces.  

<details markdown=1>
<summary markdown="span"><strong>Click to expand/collapse Local Workstation Setup</strong></summary>

#### Download Student Resources

The Dev Container, Jupyter notebooks, starter code, and sample data sources for this hack are available in a Student Resources package.

- [Download `Resources.zip`](https://aka.ms/wth/openaifundamentals/resources) package to your local workstation. 

The rest of the challenges will refer to the relative paths inside the Codespace or `Resources.zip` file where you can find the various resources to complete the challenges.

#### Set Up Local Dev Container

You will next be setting up your local workstation so that it can use Dev Containers. A Dev Container is a Docker-based environment designed to provide a consistent and reproducible development setup. The VS Code Dev Containers extension lets you easily open projects inside a containerized environment. 

**NOTE:** On Windows, Dev Containers run in the Windows Subsystem for Linux (WSL). 

On Windows and Mac OS (**NOTE:** only tested on Apple Silicon):
- (Windows only) Install the Windows Subsystem for Linux along with a Linux distribution such as Ubuntu. You will need to copy the `Resources.zip` to your Linux home directory and unzip it there. 
- Download and install Docker Desktop
- Open the root folder of the Student Resources package in Visual Studio Code
- You should get prompted to re-open the folder in a Dev Container. You can do that by clicking the Yes button, but if you miss it or hit no, you can also use the Command Palette in VS Code and select `Dev Containers: Reopen in Container`

</details>
<br/>

### Deploy Microsoft Foundry Resources

Now that you have a Jupyter notebook environment setup, you need to:
- Deploy AI models and resources in Microsoft Foundry.  
- Setup Jupyter Notebooks Configuration File
  
We have provided an automation script that will perform these tasks for you. However, you may wish to complete these tasks manually to become more familiar with Microsoft Foundry.

- [Automate Microsoft Foundry Deployment](#automate-microsoft-foundry-deployment)
- [Manual Microsoft Foundry Deployment](#manual-microsoft-foundry-deployment)

**NOTE:** If you are limited on time, we recommend using the automation script option.

#### Automate Microsoft Foundry Deployment

We have provided a deployment script and a set of Bicep templates which will deploy and configure the Azure AI resources which you will use for this hackathon. You can find these files in the `/infra` folder of your Codespace or the student `Resources.zip` package.

Login to the Azure CLI from the terminal in your GitHub Codespace or local workstation:

```
az login
```
**NOTE:** If you have access to multiple Azure subscriptions, you may need to switch to the subscription you want to work with.

If you are using GitHub Codespaces, the `az login` command will use a Device Code to login. If your organization's Azure policy prevents this, follow these steps as an alternative:
- Open your [Codespace in Visual Studio Code Desktop](https://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-in-visual-studio-code)
- From the terminal in Visual Studio Code, run these commands to login:
```
CODESPACES=false
az login
```
You should be prompted in the browser to authenticate to your Azure subscription using the normal authentication method.

Execute the following commands in your GitHub Codespace or local workstation terminal window to initiate the deployment:

```bash
cd infra
chmod +x deploy.sh
./deploy.sh  
```
**NOTE:** By default, the script will create an Azure resource group for you named `rg-microsoft-foundry-secure`. You may optionally specify a `resourceGroupName` and/or `location` parameters if you need the resources deployed to a specific resource group or region.  The default location is "`eastus`" if you don't specify one. 

```
./deploy.sh --resourceGroupName "[resource-group-name]" --location "[location]"
```

#### Manual Microsoft Foundry Deployment

**NOTE:** You can skip this section if you chose to automate the deployment. It is strongly recommended that you use the automated approach. If you'd like to understand more what the automated approach is doing, you can use GitHub Copilot to explain what the deployment script and associated Bicep files are doing. 

If you want to deploy the Microsoft Foundry resources, expand the section below and follow instructions there.

<details markdown=1>
<summary markdown="span"><strong>Click to expand/collapse Manual Deployment Instructions</strong></summary>

#### Setup Azure Microsoft Foundry Project 

Navigate to [Microsoft Foundry](https://ai.azure.com) to create your Microsoft Foundry project. 

- Click on the **+ Create New** button.
- Choose Microsoft Foundry resource for the resource type. Click the **Next** button
  - Fill out a name for your project. **Note:** You should not need to specify Advanced Options unless you need or want to change the region because of capacity constraints. Click the **Create** button
- From the Azure portal (or you can use an Infrastructure as Code approach if you prefer using Bicep/Terraform/ARM/CLI)
  - Create an Azure AI Search service
  - Specify a service name for your Azure AI Search. You can use the same resource group and location as the Microsoft Foundry resource. **Note:** Make sure you set the Pricing Tier to Standard (Basic/Free is not supported)


#### Deploy Azure OpenAI Models

Now we will deploy the needed large language models from Azure OpenAI. 

- Navigate to the [Microsoft Foundry](https://ai.azure.com) 
- On the left navigation bar, under My Assets, click on Models + endpoints. Click the Deploy Model button and select Deploy base model
- Deploy the following 3 models in your Azure OpenAI resource. 
  - `gpt-4o`
  - `gpt-4o-mini`
  - `text-embedding-ada-002`

#### Setup Jupyter Notebooks Configuration File

The code in the Jupyter notebooks retrieve their configuration values from environment variables configured in a `.env` file. Some of these configuration values are secrets (such as the key to access your Azure OpenAI resource). 

**NOTE:** A `.env` file should never be stored in a Git repo.  Therefore, we have provided a sample file named `.env.sample` that contains a list of environment variables required by the Jupyter notebooks.

You will find the `.env.sample` file in the root of the codespace. If you are working on your local workstation, you will find the `.env.sample` file in the root of the folder where you have unpacked the student `Resources.zip` file.

- Rename the file from `.env.sample` to `.env`.
- Add all the required Azure resource credentials in the `.env` file. This includes: Azure OpenAI, model deployments, AI Search, Azure Document Intelligence, and Azure Blob
    - For **Azure OpenAI and Model Deployments**, you can find these credentials in Azure Microsoft Foundry:
      - Navigate to the [Microsoft Foundry](https://ai.azure.com)
      - You will need the values for `OPENAI_API_BASE`, `AZURE_DOC_INTELLIGENCE_ENDPOINT`, `AZURE_AI_SEARCH_ENDPOINT`, `AZURE_AI_PROJECT_ENDPOINT`, and `AZURE_BLOB_STORAGE_ACCOUNT_NAME` to put in your `.env` file. Use your favorite search tool or Github Copilot to figure out where to retrieve these values either in the Foundry Portal, Azure Portal, or using the Azure CLI. 
   
  **TIP:** Learn more about using `.env` files [here](https://dev.to/edgar_montano/how-to-setup-env-in-python-4a83#:~:text=How%20to%20setup%20a%20.env%20file%201%201.To,file%20using%20the%20following%20format%3A%20...%20More%20items).

**NOTE:** We have also provided a `.gitignore` file that should prevent you from accidentally committing your own `.env` file to a Git repo during this hack.

**NOTE:** On MacOS, files that start with a `.` are hidden files and are not viewable in Finder when browsing the file system. They will be visible in both VS Code or GitHub Codespaces.

</details>
</br>

## Success Criteria

To complete this challenge successfully, you should be able to:

If using GitHub Codespaces:

- Verify you have the following files & folders available in the Codespace:
    - `/data`
    - `/notebooks`
    - `.env` <= Copied from `.env.sample`
    - `.gitignore`
    - `requirements.txt`

If working directly on a local workstation: 

- Verify that you have Python and Conda installed
- Verify that you can run Jupyter Notebooks in Visual Studio Code or Azure Machine Learning Studio
- Verify you have the following files & folders locally wherever you unpacked the `Resources.zip` file:
    - `/data`
    - `/notebooks`
    - `.env` <= Renamed from `.env.sample`
    - `.gitignore`
    - `requirements.txt`

## Learning Resources

- [GitHub Codespaces Overview](https://docs.github.com/en/codespaces/overview)
- [Dev Containers: Getting Started](https://microsoft.github.io/code-with-engineering-playbook/developer-experience/devcontainers-getting-started/)
- [Developing inside a Container](https://code.visualstudio.com/docs/devcontainers/containers)
- [Jupyter Notebooks in VS Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)
- [Jupyter Notebooks](https://jupyter.org/)
- [Project Jupyter](https://en.wikipedia.org/wiki/Project_Jupyter)
- [How to setup .env in Python](https://dev.to/edgar_montano/how-to-setup-env-in-python-4a83#:~:text=How%20to%20setup%20a%20.env%20file%201%201.To,file%20using%20the%20following%20format%3A%20...%20More%20items)
- [Azure OpenAI Models](https://learn.microsoft.com/en-us/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure?pivots=azure-openai&tabs=global-standard-aoai%2Cstandard-chat-completions%2Cglobal-standard)
  
