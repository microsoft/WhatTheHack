# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the OpenAI Fundamentals What The Hack. Before you can hack, you will need to set up some prerequisites.

## Description
In this challenge, you will set up the necessary prerequisites and environment to complete the rest of the hack, including:
- [Azure Subscription](#azure-subscription)
- [Setup Jupyter Notebook Environment](#setup-jupyter-notebook-environment)
  - [GitHub Codespaces](#setup-github-codespace)
  - [Local Workstation](#setup-local-workstation)
- [Deploy Azure AI Foundry Resources](#deploy-azure-ai-foundry-resources)

### Azure Subscription

You will need an Azure subscription to complete this hack. If you don't have one, get a free trial here...
- [Azure Subscription](https://azure.microsoft.com/en-us/free/)

### Setup Jupyter Notebook Environment

You will be working with Jupyter Notebooks and Python to interact with Azure OpenAI for the hack.

[Jupyter Notebooks](https://jupyter.org/) are an open-source web application that allows you to create and share documents containing live code, equations, visualizations, and narrative text. It's useful for a wide range of tasks, such as data cleaning and transformation, numerical simulation, statistical modeling, data visualization, and machine learning.

Jupyter notebooks require an environment to run in.

You can use [GitHub Codespaces](https://docs.github.com/en/codespaces/overview) where we have a pre-configured Jupyter lab environment set up and ready to go for you, or you can setup a Jupyter lab environment on your local workstation.

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

You are ready to run the Jupyter Notebook files, hooray! Skip to section: [Setup Azure AI Foundry Project and Hub](#Setup-Azure-AI-Foundry-Project-and-Hub)

**NOTE:** If you close your Codespace window, or need to return to it later, you can go to [GitHub Codespaces](https://github.com/codespaces) and you should find your existing Codespaces listed with a link to re-launch it.

#### Use Local Workstation

**NOTE:** You can skip this section if are using GitHub Codespaces!

If you want to setup a Jupyter Notebooks environment on your local workstation, expand the section below and follow the requirements listed. 

<details markdown=1>
<summary markdown="span"><strong>Click to expand/collapse Local Workstation Requirements</strong></summary>

To work on your local workstation, please ensure you have the following tools and resources before hacking:

- [Student Resources](#student-resources)
- [Visual Studio Code](#visual-studio-code)
- [Python](#python)
- [Conda Runtime](#conda)
- [Azure CLI (Optional)](#azure-cli-optional)

##### Student Resources

The Jupyter notebooks, starter code, and sample data sources for this hack are available in a Student Resources package.

- [Download and unpack the `Resources.zip`](https://aka.ms/wth/openaifundamentals/resources) package to your local workstation. 

The rest of the challenges will refer to the relative paths inside the `Resources.zip` file where you can find the various resources to complete the challenges.

##### Visual Studio Code

Visual Studio Code is a code editor which you will work with Jupyter notebooks.

- [Install VS Code](https://getvisualstudiocode.com)

##### Setup GitHub Copilot

For parts of this hack we will be relying heavily on GitHub Copilot for coding. Please setup [VS Code with GitHub Copilot](https://code.visualstudio.com/docs/copilot/setup-simplified?wt.md_id=AZ-MVP-5004796)

##### Python

- [Python Installation](https://www.python.org/downloads), version at least \>= 3.6, the minimum requirement for using OpenAI's GPT-3.5-based models, such as ChatGPT.

##### Conda

- Conda Installation, for project environment management and package management, version \>= conda 4.1.6. Anaconda distribution is a popular Python distribution, while Miniconda is the lightweight version of Anaconda.
  - [Anaconda](https://docs.anaconda.com/anaconda/install) OR [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- Environment setup:
  - Open Anaconda Prompt or your favourite terminal and verify Python and Conda installations using `python --version` and `conda --version`
  - Create a project environment using Conda - `conda create --name <env_name>`
  - Activate Conda environment - `conda activate <env_name>`
  - Install required libraries and packages, provided in the form of a `requirements.txt` file in the root folder of the `Resources.zip` file. We recommend using pip or Conda in a virtual environment to do so. For example, you can run `pip install -r requirements.txt`
  - Open the project in VS Code using `code .`
  - If you are using Visual Studio Code, make sure you change your Python interpreter (CTRL+SHIFT+P) to select the project/virtual environment that you just created.

For more information, see [Jupyter Notebooks in VS Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)

##### Azure CLI (Optional)

While it is not necessary for this hack, you may wish to use the Azure CLI to interact with Azure in addition to the Azure Portal.

- [Install Azure CLI](https://aka.ms/installazurecli)

#### Cloud Environment

There is a *THIRD* way of setting up a Jupyter Notebook environment if you don't want to set it up on your local workstation or use GitHub Codespaces. You can set one up in the cloud with Azure Machine Learning Studio and take advantage of Azure Compute power. 

For more information, see: [Run Jupyter Notebooks in your Workspace](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-run-jupyter-notebooks?view=azureml-api-2)

Once you have an Azure Machine Learning Studio Workspace set up, you can upload the contents of the `/notebooks` folder in your `Resources.zip` file to it. For more information on this, see: [How to create and manage files in your workspace](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-files?view=azureml-api-2)

</details>
<br/>

### Deploy Azure AI Foundry Resources

Now that you have a Jupyter notebook environment setup, you need to:
- Deploy AI models and resources in Azure AI Foundry.  
- Setup Jupyter Notebooks Configuration File
  
We have provided an automation script that will perform these tasks for you. However, you may wish to complete these tasks manually to become more familiar with Azure AI Foundry.

- [Automate Azure AI Foundry Deployment](#automate-azure-ai-foundry-deployment)
- [Manual Azure AI Foundry Deployment](#manual-azure-ai-foundry-deployment)

**NOTE:** If you are limited on time, we recommend using the automation script option.

#### Automate Azure AI Foundry Deployment

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
**NOTE:** By default, the script will create an Azure resource group for you named `rg-ai-foundry-secure`. You may optionally specify a `resourceGroupName` and/or `location` parameters if you need the resources deployed to a specific resource group or region.  The default location is "`eastus`" if you don't specify one. 

```
./deploy.sh --resourceGroupName "[resource-group-name]" --location "[location]"
```

#### Manual Azure AI Foundry Deployment

**NOTE:** You can skip this section if you chose to automate the deployment.

If you want to deploy the Azure AI Foundry resources, expand the section below and follow instructions there.

<details markdown=1>
<summary markdown="span"><strong>Click to expand/collapse Manual Deployment Instructions</strong></summary>

#### Setup Azure AI Foundry Project and Hub

Navigate to [AI Foundry](https://ai.azure.com) to create your Azure AI project and the needed resources. A project is used to organize your work and allows you to collaborate with others. A hub provides the hosting environment for your projects. An Azure AI hub can be used across multiple projects.

- Click on the **+ Create Project** button.
- Give your project a name and click **Create a new hub**.
  - Fill out a name for your hub. 
  - Click the **Next** button
  - Click the **Customize** button
  - Click **Create new AI Search**.
  - Fill out a name for your Azure AI Search
  - Click the **Next** button to finish setting up your Azure AI Search
  - Click the **Next** button on the screen where it says **Create a hub for your projects**
  - On the Review and Finish page, click the **Create** button
- The hub will create an Azure Open AI, Azure Blob, and an AI Service resource for you once it is finished. Resources are different Azure services you will use within the challenges.

#### Deploy Azure OpenAI Models

Now we will deploy the needed large language models from Azure OpenAI. 

- Navigate to the [AI Foundry](https://ai.azure.com) 
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
    - For **Azure OpenAI and Model Deployments**, you can find these credentials in Azure AI Foundry:
      - Navigate to the [AI Foundry](https://ai.azure.com)
      - Navigate to your project. In the lower left corner, click on the link to Management Center. It is also under Project details.
      - Click on Connected resources under your project
      - Click the name of your Azure OpenAI Service to see its details. Copy the Target URL and API Key for `OPENAI_API_BASE` and `OPEN_API_KEY`, respectively into the `.env` file
      - From the **`Manage connect resources in this project`** screen, click the Name with the type **`AIServices`**. The AI Services deployment is a multi-service resource that allows you to access multiple Azure AI services like Document Intelligence with a single key and endpoint. Copy the Target URL and the API Key for `AZURE_DOC_INTELLIGENCE_ENDPOINT` and `AZURE_DOC_INTELLIGENCE_KEY`, respectively into the `.env` file
      - In the [Azure Portal](portal.azure.com), navigate to the resource group you made when creating your hub within the AI Foundry.
      - Locate your **AI Search** service that you created earlier
      - From the **Overview**, copy the URL for `AZURE_AI_SEARCH_ENDPOINT` in the .env file
      - Under **`Settings`** go to Keys, copy the admin key into `AZURE_AI_SEARCH_KEY` in the `.env` file      
      - Model deployment names should be the same as the ones populated in the `.env.sample` file especially if you have deployed a different model due to quota issues.
    - For **Azure Blob**, you can find these credentials in the [Azure Portal](portal.azure.com).
      - In the Azure Portal, navigate to the resource group you made when creating your hub within the AI Foundry.
      - Click on your **`Storage account`** resource
      - Click on **`Security + networking`** and find **`Access keys`**. You should be able to see the **`Storage account name`**, **`key`**, and **`Connection string`**.
   
  **TIP:** Learn more about using `.env` files [here](https://dev.to/edgar_montano/how-to-setup-env-in-python-4a83#:~:text=How%20to%20setup%20a%20.env%20file%201%201.To,file%20using%20the%20following%20format%3A%20...%20More%20items).

**NOTE:** We have also provided a `.gitignore` file that should prevent you from accidentally committing your renamed `.env` file to a Git repo during this hack.

**NOTE:** On MacOS, files that start with a `.` are hidden files and are not viewable in Finder when browsing the file system. They will be visible in both VS Code or GitHub Codespaces.

</details>
</br>

## Success Criteria

To complete this challenge successfully, you should be able to:

If using GitHub Codespaces:

- Verify you have the following files & folders available in the Codespace:
    - `/data`
    - `/notebooks`
    - `.env` <= Renamed from `.env.sample`
    - `.gitignore`
    - `requirements.txt`
- Verify that you have created the Project and Hub in your AI Foundry.
    - Verify that you have the following resources: Azure OpenAI, deployed the necessary models, AI Search, Document Intelligence, Azure Blob.

If working on a local workstation: 

- Verify that you have Python and Conda installed
- Verify that you can run Jupyter Notebooks in Visual Studio Code or Azure Machine Learning Studio
- Verify you have the following files & folders locally wherever you unpacked the `Resources.zip` file:
    - `/data`
    - `/notebooks`
    - `.env` <= Renamed from `.env.sample`
    - `.gitignore`
    - `requirements.txt`
- Verify that you have created the Project and Hub in your AI Foundry.
    - Verify that you have the following resources: Azure OpenAI, deployed the necessary models, AI Search, Document Intelligence, Azure Blob.

## Learning Resources

- [GitHub Codespaces Overview](https://docs.github.com/en/codespaces/overview)
- [Jupyter Notebooks in VS Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)
- [Jupyter Notebooks](https://jupyter.org/)
- [Project Jupyter](https://en.wikipedia.org/wiki/Project_Jupyter)
- [Run Jupyter Notebooks In Your (Azure Machine Learning) Workspace](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-run-jupyter-notebooks?view=azureml-api-2)
- [How to setup .env in Python](https://dev.to/edgar_montano/how-to-setup-env-in-python-4a83#:~:text=How%20to%20setup%20a%20.env%20file%201%201.To,file%20using%20the%20following%20format%3A%20...%20More%20items)
- [Azure OpenAI Models](https://learn.microsoft.com/en-us/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure?pivots=azure-openai&tabs=global-standard-aoai%2Cstandard-chat-completions%2Cglobal-standard)
  
