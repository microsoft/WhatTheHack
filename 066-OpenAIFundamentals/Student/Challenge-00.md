# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the OpenAI Fundamentals What The Hack. Before you can hack, you will need to set up some prerequisites.

## Description
In this challenge, you will set up the necessary prerequisites and environment to complete the rest of the hack, including:
- [Access Azure OpenAI](#access-azure-openai)
- [Setup Jupyter Notebook Environment](#setup-jupyter-notebook-environment)
  - [GitHub Codespaces](#setup-github-codespace)
  - [Local Workstation](#setup-local-workstation)
- [Setup Azure OpenAI](#setup-azure-openai)

### Access Azure OpenAI 

You will need an Azure subscription to complete this hack. If you don't have one, get a free trial here...
- [Azure Subscription](https://azure.microsoft.com/en-us/free/)

Before you can start the hack, you will also need to apply for access to Azure OpenAI as it is currently in high-demand.

An Azure subscription is necessary to [apply for Azure OpenAI access](https://aka.ms/oaiapply). We recommend applying as early as possible as processing times will vary, sometimes taking more than several business days.

### Setup Jupyter Notebook Environment

You will be working with Jupyter Notebooks and Python to interact with Azure OpenAI for the hack.

[Jupyter Notebooks](https://jupyter.org/) are an open-source web application that allows you to create and share documents containing live code, equations, visualizations, and narrative text. It's useful for a wide range of tasks, such as data cleaning and transformation, numerical simulation, statistical modeling, data visualization, and machine learning.

Jupyter notebooks require an environment to run in.

You can use [GitHub Codespaces](https://docs.github.com/en/codespaces/overview) where we have a pre-configured Jupyter lab environment set up and ready to go for you, or you can setup a Jupyter lab environment on your local workstation.

A GitHub Codespace is a development environment that is hosted in the cloud that you access via a browser. All of the pre-requisite developer tools for this hack are pre-installed and available in the codespace.

- [Use GitHub Codespaces](#use-github-codespaces)
- [Use Local Workstation](#use-local-workstation)

We highly recommend using GitHub Codespaces to make it easier complete this hack.

#### Use GitHub Codespaces

You must have a GitHub account to use GitHub Codespaces. If you do not have a GitHub account, you can [Sign Up Here](https://github.com/signup).

GitHub Codespaces is available for developers in every organization. All personal GitHub.com accounts include a monthly quota of free usage each month. GitHub will provide users in the Free plan 120 core hours, or 60 hours of run time on a 2 core codespace, plus 15 GB of storage each month.

You can see your balance of available codespace hours on the [GitHub billing page](https://github.com/settings/billing/summary).

The GitHub Codespace for this hack will host the Jupyter Notebook files, configuration files, and other data files needed for this event. Here are the steps you will need to follow:

- A GitHub repo containing the student resources and Codespace for this hack is hosted here:
  - [WTH OpenAI Fundamentals Codespace Repo](https://aka.ms/wth/openaifundamentals/codespace)
  - Please open this link and sign in with your personal Github account. 

**NOTE:** Make sure you do not sign in with your enterprise managed Github account.

- Once you are signed in, click on the green "Code" button. Then click on "Codespaces". Finally, hit "Create codespace on main".

Your Codespace environment should load in a new browser tab. It will take approximately 3-5 minutes the first time you create the codespace for it to load.

- When the codespace completes loading, you should find an instance of Visual Studio Code running in your browser with the files needed for this hackathon.

You are ready to run the Jupyter Notebook files, hooray! Skip to section: [Setup Azure OpenAI](#setup-azure-openai)

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

- [Download and unpack the `Resources.zip`](https://aka.ms/wthopenaifundamentalsresources) package to your local workstation. 

The rest of the challenges will refer to the relative paths inside the `Resources.zip` file where you can find the various resources to complete the challenges.

##### Visual Studio Code

Visual Studio Code is a code editor which you will work with Jupyter notebooks.

- [Install VS Code](https://getvisualstudiocode.com)

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

### Setup Azure OpenAI

Once you have set up a Jupyter notebook environment, create an Azure OpenAI resource in your Azure Subscription and do some initial configuration.

- [Create an Azure OpenAI Resource](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal) 
- Deploy the following models in your Azure OpenAI resource.
  - `gpt-4`
  - `gpt-35-turbo`
  - `text-embedding-ada-002`

#### Setup Jupyter Notebooks Configuration File

The code in the Jupyter notebooks retrieve their configuration values from environment variables configured in a `.env` file. Some of these configuration values are secrets (such as the key to access your Azure OpenAI resource). 

**NOTE:** A `.env` file should never be stored in a Git repo.  Therefore, we have provided a sample file named `.env.sample` that contains a list of environment variables required by the Jupyter notebooks.

You will find the `.env.sample` file in the root of the codespace. If you are working on your local workstation, you will find the `.env.sample` file in the root of the folder where you have unpacked the student `Resources.zip` file.

- Rename the file from `.env.sample` to `.env`.
- Add required credentials of Azure resources in the `.env` file.  

  **HINT:** You can get these credentials through the Azure Portal within your AOAI resource. Click on `Keys and Endpoint` from the dropdown menu on the left side.
   
  **TIP:** Learn more about using `.env` files [here](https://dev.to/edgar_montano/how-to-setup-env-in-python-4a83#:~:text=How%20to%20setup%20a%20.env%20file%201%201.To,file%20using%20the%20following%20format%3A%20...%20More%20items).
  
**NOTE:** Additional Azure resources such as Azure Form Recognizer (a.k.a. Azure Document Intelligence) and Azure Cognitive Search (a.k.a. Azure AI Search) will be required for later challenges. You can add these values to the `.env` file later as you progress through the challenges.

**NOTE:** We have also provided a `.gitignore` file that should prevent you from accidentally committing your renamed `.env` file to a Git repo during this hack.

**NOTE:** On MacOS, files that start with a `.` are hidden files and are not viewable in Finder when browsing the file system. They will be visible in both VS Code or GitHub Codespaces.

## Success Criteria

To complete this challenge successfully, you should be able to:

If using GitHub Codespaces:

- Verify you have the following files & folders available in the Codespace:
    - `/data`
    - `/notebooks`
    - `.env` <= Renamed from `.env.sample`
    - `.gitignore`
    - `requirements.txt`
- Verify that you have created the Azure OpenAI resource and deployed the necessary models in your Azure Subscription

If working on a local workstation: 

- Verify that you have Python and Conda installed
- Verify that you can run Jupyter Notebooks in Visual Studio Code or Azure Machine Learning Studio
- Verify you have the following files & folders locally wherever you unpacked the `Resources.zip` file:
    - `/data`
    - `/notebooks`
    - `.env` <= Renamed from `.env.sample`
    - `.gitignore`
    - `requirements.txt`
- Verify that you have created the Azure OpenAI resource and deployed the necessary models in your Azure Subscription

## Learning Resources

- [GitHub Codespaces Overview](https://docs.github.com/en/codespaces/overview)
- [Jupyter Notebooks in VS Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)
- [Jupyter Notebooks](https://jupyter.org/)
- [Project Jupyter](https://en.wikipedia.org/wiki/Project_Jupyter)
- [Run Jupyter Notebooks In Your (Azure Machine Learning) Workspace](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-run-jupyter-notebooks?view=azureml-api-2)
- [How to setup .env in Python](https://dev.to/edgar_montano/how-to-setup-env-in-python-4a83#:~:text=How%20to%20setup%20a%20.env%20file%201%201.To,file%20using%20the%20following%20format%3A%20...%20More%20items)
