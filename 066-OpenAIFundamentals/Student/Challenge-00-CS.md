# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the AI Fluency Event. Before you can hack, you will need to set up some prerequisites.

## Description
In this challenge, you will set up the necessary prerequisites and environment through Codespaces to complete the rest of the hack, including:

- [Setup Codespace](#setup-codespace)
- [Access Azure OpenAI](#access-azure-openai)
- [Jupyter Notebook Environment](#setup-jupyter-notebook-environment)
- [Student Resources](#student-resources)
- [Setup Azure OpenAI](#setup-azure-openai)
- [Additional Prerequisites](#additional-common-prerequisites)


### Access Azure OpenAI 

You will need an Azure subscription to complete this hack. If you don't have one, get a free trial here.
- [Azure Subscription](https://azure.microsoft.com/en-us/free/)

Before you can start the hack, you will also need to apply for access to Azure OpenAI as it is currently in high-demand.

An Azure subscription is necessary to [apply for Azure OpenAI access](https://aka.ms/oaiapply). We recommend applying as early as possible as processing times will vary, sometimes taking more than several business days.

### Setup Codespace

You will need to setup your codespace in order to view all the challenge descriptions, Jupyter Notebook files, and other needed files for this event. Here are the steps you will need to follow:

1. Your coach will provide you with the Github Repo for this hack. Please open this link and sign in with your personal Github account. Note: Make sure you do not sign in with your enterprise managed Github account.

2. Once you are signed in, click on the green "Code" button. Then click on "Codespaces". You should be able to click on the three dots. Then press "+ New with options". You can keep the default config and just ensure that the Machine Type is 2-core. Finally, hit "Create codespace". 

3. You should be able to view your codespace. Enter in the following command in the terminal: `pip install -r requirements.txt`. This should successfully install all the libraries you need.

4. Fill out your .env file with the Azure resource credentials. You can fill the values in this file as you go through the challenges.

5. You are ready to run the Jupyter Notebook files, hooray!

### Jupyter Notebook Environment 

You will be working with Jupyter Notebooks and Python to interact with Azure OpenAI.

[Jupyter Notebook](https://jupyter.org/) is an open-source web application that allows you to create and share documents containing live code, equations, visualizations, and narrative text. It's useful for a wide range of tasks, such as data cleaning and transformation, numerical simulation, statistical modeling, data visualization, and machine learning.

Jupyter notebooks require an environment to run in. You will be running these in your Codespace. Navigate to the notebooks folder and click on the Jupyter Notebook you would like to start working with for each future challenge. 


### Setup Azure OpenAI

Once you have set up a Jupyter notebook environment, you create an Azure OpenAI resource and do some initial configuration.

- [Create an Azure OpenAI Resource](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal) 
- Deploy the following models in your Azure OpenAI resource.
  - `gpt-4`
  - `gpt-35-turbo`
  - `text-embedding-ada-002`
    - **NOTE:** A couple of challenges may require a few additional prerequisites so be sure to check those out in the respective challenges. 
- Add required credentials of Azure resources in the  `.env` file, which should be visible in your codespace. You can get these credentials through the Azure Portal within your AOAI resource. Click on Keys and Endpoint from the dropdown menu on the left side. Learn more about using `.env` files [here](https://dev.to/edgar_montano/how-to-setup-env-in-python-4a83#:~:text=How%20to%20setup%20a%20.env%20file%201%201.To,file%20using%20the%20following%20format%3A%20...%20More%20items).
  - **NOTE:** Additional Azure resources such as Azure Form Recognizer (AKA Azure Document Intelligence) and Azure Cognitive Search (AKA AI Search) will be required for later challenges. 

## Additional Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for this hack you are participating in. However, if you work with Azure on a regular basis, we suggest considering having the following in your developer toolkit.

- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you are able to see the following in your Codespace:
  - The challenges folder with all four challenge markdown files. These .md files will contain descriptions of the challenges. Remember to open these by right clicking on the .md file and selecting "Open Preview". Alternatively, you can also do CTRL + SHIFT + V on your Windows machine.
  - The data folder with structured and unstructured folders along with the Automobile.csv and CH3-data.pdf files. This is the data the challenges will be working with.
  - The notebooks folder with seven files. These are the Jupyter Notebook files you will run in the next few challenges.
  - The `.env` file where you will store all your credentials.
  - The `requirements.txt` file which has all the libraries you will need in order to run the Jupyter Notebooks.
- Verify that you have Python and Conda installed
- Verify that you have created the AOAI resource and deployed the necessary deployments

## Learning Resources

- [Codespaces Overview](https://docs.github.com/en/codespaces/overview)
- [Jupyter Notebooks in VS Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)
- [Jupyter Notebooks](https://jupyter.org/)
- [Project Jupyter](https://en.wikipedia.org/wiki/Project_Jupyter)
- [Run Jupyter Notebooks In Your (Azure Machine Learning) Workspace](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-run-jupyter-notebooks?view=azureml-api-2)
