# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the OpenAI Fundamentals What The Hack. Before you can hack, you will need to set up some prerequisites.

## Description
In this challenge, you will set up the necessary prerequisites and environment to complete the rest of the hack.

All of the files containing starter code, information, and resources will be shared with you in the Teams Channel created for the hosted event.

To **access this hack's resources**, navigate to the Teams Channel (named similarly to "WTH - Azure OpenAI Fundamentals") > General subchannel > Files tab. The zip file containing the resources will be stored there. Download and extract the zip file to access the Jupyter Notebooks, challenge descriptions, and provided data.

You can [upload the folder to an Azure Machine Learning Workspace](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-manage-files?view=azureml-api-2) to take advantage of Azure Compute. Or open the files in your preferred code editor.

## Prerequisites

There are several prerequisites specific to this hack. You will primarily be working with Jupyter Notebooks and Python. 

**Heads up!**: An Azure subscription is necessary to [apply for Azure OpenAI access](https://aka.ms/oaiapply). We recommend applying as early as possible as processing times will vary, sometimes taking more than several business days.

Please ensure you have the following tools and resources before hacking:
- [Azure Subscription](../../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Python Installation](https://www.python.org/downloads), version at least \>= 3.6, the minimum requirement for using OpenAI's GPT-3.5-based models, such as ChatGPT.
- Conda Installation, for project environment management and package management, version \>= conda 4.1.6. Anaconda distribution is a popular Python distribution, while Miniconda is the lightweight version of Anaconda.
  - [Anaconda](https://docs.anaconda.com/anaconda/install) OR [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- Environment setup:
  - Open Anaconda Prompt or your favourite terminal and verify Python and Conda installations using `python --version` and `conda --version`
  - Create a project environment using Conda - `conda create --name <env_name>`
  - Activate Conda environment - `conda activate <env_name>`
  - Install the required libraries listed in the `requirements.txt` file via `pip install -r requirements.txt`
  - Open the project in VS Code using `code .`
  - If you are using Visual Studio Code, make sure you change your Python interpreter (CTRL+SHIFT+P) to select the project/virtual environment that you just created.
- [Create an Azure OpenAI Resource](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal) 
- Deploy the following models in your Azure OpenAI resource.
  - `gpt-35-turbo`
  - `text-embedding-ada-002`
    - **NOTE:** A couple of challenges may require a few additional prerequisites so be sure to check those out in the respective challenges. 
- Add required credentials of Azure resources in the sample `.env` file, which we have provided as `sample-env.txt` in the `Resources` folder. You can get these credentials through the Azure Portal within your AOAI resource. Click on Keys and Endpoint from the dropdown menu on the left side. After entering your credentials and environment variables in the provided fields, rename the file to `.env`. Learn more about using `.env` files [here](https://dev.to/edgar_montano/how-to-setup-env-in-python-4a83#:~:text=How%20to%20setup%20a%20.env%20file%201%201.To,file%20using%20the%20following%20format%3A%20...%20More%20items).
  - **NOTE:** Additional Azure resources such as Azure Form Recognizer and Azure Cognitive Search will be required for later challenges. 
- Install required libraries and packages, provided in the form of a `requirements.txt` file in the `Resources/Notebooks` section of the zip folder. We recommend using pip or Conda in a virtual environment to do so. 

## Additional Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, we suggest considering having the following  in your developer toolkit.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Visual Studio Code](../../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
- [Managing Cloud Resources](../../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)




## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have Python and Conda installed
- Verify that you can run Jupyter Notebooks in Visual Studio Code
- Verify that you have created the AOAI resource and deployed the necessary deployments

