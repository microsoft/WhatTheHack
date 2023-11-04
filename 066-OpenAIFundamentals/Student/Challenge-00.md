# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the OpenAI Fundamentals What The Hack. Before you can hack, you will need to set up some prerequisites.

## Description
In this challenge, you will set up the necessary prerequisites and environment to complete the rest of the hack, including:

- [Student Resources](#student-resources)
- [Access Azure OpenAI](#access-azure-openai)
- [Setup Jupyter Notebook Environment](#setup-jupyter-notebook-environment)
- [Setup Azure OpenAI](#setup-azure-openai)
- [Additional Prerequisites](#additional-common-prerequisites)

### Student Resources

Your coach will provide you with a `Resources.zip` file that contains resource files you will use to complete the challenges for this hack.  

These resources include Jupyter notebooks, starter code, and sample data sources. 

You should download and unpack the `Resources.zip` file there to your local workstation.  The rest of the challenges will refer to the relative paths inside the `Resources.zip` file where you can find the various resources to complete the challenges.

For the hack event September 18 - 29, 2023, you can download the file here: [`Resources.zip`](https://aka.ms/wthopenaifundamentalsresources)

### Access Azure OpenAI 

You will need an Azure subscription to complete this hack. If you don't have one, get a free trial here...
- [Azure Subscription](https://azure.microsoft.com/en-us/free/)

Before you can start the hack, you will also need to apply for access to Azure OpenAI as it is currently in high-demand.

An Azure subscription is necessary to [apply for Azure OpenAI access](https://aka.ms/oaiapply). We recommend applying as early as possible as processing times will vary, sometimes taking more than several business days.

### Setup Jupyter Notebook Environment

You will be working with Jupyter Notebooks and Python to interact with Azure OpenAI.

[Jupyter Notebook](https://jupyter.org/) is an open-source web application that allows you to create and share documents containing live code, equations, visualizations, and narrative text. It's useful for a wide range of tasks, such as data cleaning and transformation, numerical simulation, statistical modeling, data visualization, and machine learning.

Jupyter notebooks require an environment to run in. You can setup an environment on your local workstation or you can use the Azure Machine Learning Workspace to run them in the cloud.

#### Local Workstation Environment

If you plan to work on your local workstation, please ensure you have the following tools and resources before hacking:
- [Python Installation](https://www.python.org/downloads), version at least \>= 3.6, the minimum requirement for using OpenAI's GPT-3.5-based models, such as ChatGPT.
- Conda Installation, for project environment management and package management, version \>= conda 4.1.6. Anaconda distribution is a popular Python distribution, while Miniconda is the lightweight version of Anaconda.
  - [Anaconda](https://docs.anaconda.com/anaconda/install) OR [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- Environment setup:
  - Open Anaconda Prompt or your favourite terminal and verify Python and Conda installations using `python --version` and `conda --version`
  - Create a project environment using Conda - `conda create --name <env_name>`
  - Activate Conda environment - `conda activate <env_name>`
  - Install required libraries and packages, provided in the form of a `requirements.txt` file in the `Resources/Notebooks` section of the zip folder. We recommend using pip or Conda in a virtual environment to do so. For example, you can run `pip install -r requirements.txt`
  - Open the project in VS Code using `code .`
  - If you are using Visual Studio Code, make sure you change your Python interpreter (CTRL+SHIFT+P) to select the project/virtual environment that you just created.

For more information, see [Jupyter Notebooks in VS Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)

#### Cloud Environment

If you are not interested or able to set up a Jupyter Notebook environment on your local workstation, you can set one up in the cloud with Azure Machine Learning Studio and take advantage of Azure Compute power. 

For more information, see: [Run Jupyter Notebooks in your Workspace](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-run-jupyter-notebooks?view=azureml-api-2)

Once you have an Azure Machine Learning Studio Workspace set up, you can upload the contents of the `/Notebooks` folder in your `Resources.zip` file to it. For more information on this, see: [How to create and manage files in your workspace](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-files?view=azureml-api-2)

### Setup Azure OpenAI

Once you have set up a Jupyter notebook environment, you create an Azure OpenAI resource and do some initial configuration.

- [Create an Azure OpenAI Resource](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal) 
- Deploy the following models in your Azure OpenAI resource.
  - `gpt-35-turbo`
  - `text-embedding-ada-002`
    - **NOTE:** A couple of challenges may require a few additional prerequisites so be sure to check those out in the respective challenges. 
- Add required credentials of Azure resources in the sample `.env` file, which we have provided as `sample-env.txt` in the `Resources` folder. You can get these credentials through the Azure Portal within your AOAI resource. Click on Keys and Endpoint from the dropdown menu on the left side. After entering your credentials and environment variables in the provided fields, rename the file to `.env`. Learn more about using `.env` files [here](https://dev.to/edgar_montano/how-to-setup-env-in-python-4a83#:~:text=How%20to%20setup%20a%20.env%20file%201%201.To,file%20using%20the%20following%20format%3A%20...%20More%20items).
  - **NOTE:** Additional Azure resources such as Azure Form Recognizer and Azure Cognitive Search will be required for later challenges. 

## Additional Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for this hack you are participating in. However, if you work with Azure on a regular basis, we suggest considering having the following in your developer toolkit.

- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have Python and Conda installed
- Verify that you can run Jupyter Notebooks in Visual Studio Code or Azure Machine Learning Studio
- Verify that you have created the AOAI resource and deployed the necessary deployments

## Learning Resources

- [Jupyter Notebooks in VS Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)
- [Jupyter Notebooks](https://jupyter.org/)
- [Project Jupyter](https://en.wikipedia.org/wiki/Project_Jupyter)
- [Run Jupyter Notebooks In Your (Azure Machine Learning) Workspace](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-run-jupyter-notebooks?view=azureml-api-2)
