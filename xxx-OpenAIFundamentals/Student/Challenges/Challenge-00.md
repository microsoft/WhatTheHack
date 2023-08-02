# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the OpenAIFundamentals What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
- [Visual Studio Code](../../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
- [Azure Storage Explorer](../../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specifc to this hack. 

### Deploying Azure OpenAI models

Please ensure that you have [Azure OpenAI access](https://aka.ms/oaiapply). This hack is self-paced and you will primarily be working with jupyter notebooks.

[Create an Azure OpenAI Resource](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/overview)

Deploy the following models in your Azure OpenAI resource. A couple of challenges may require a few additional prereqs so be sure to checkout the pre-reqs for the respective challenges: 
  - gpt-35-turbo
  - text-embedding-ada-002

### Downloading project files

Download the project files to your device locally using a [download directory tool](https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdownload-directory.github.io%2F&data=05%7C01%7Cdthakar%40microsoft.com%7Ce1ad618c61714eb1c91e08db70fe6ed1%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C638228010310811612%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3FzX8QP%2F4KZopjJty1tNZ%2BMExIhyOaRGPdsxj62oceE%3D&reserved=0). Extract the contents of the .zip file. 

Add required credentials of Azure resources in the ``.env`` file. You will find the file within the student/resources path of the hack file and you can edit it with any text editor. The model names are the names you give your model endpoints at deployment, NOT the generic model names.
  - **NOTE:** Additional Azure resources such as Azure Form Recognizer and Azure Cognitive Search will be required for later challenges. Make sure to update ``.env`` file with credentials as needed. If running the notebooks on AML, also re-upload the file after any updates. 

This hack is delivered on Python Notebooks (.ipynb). Before continuing the set up, choose whether you want to complete the challenges on an Azure Machine Learning notebook or locally on your device. Using Azure will incurr a small hourly cost to spin up a virtual machine but it will allow you to complete this hack without the need to download additional tools and software to your device. If you choose to complete the notebook locally you can use your preferred IDE as long as you ensure that you have the correct dependencies. Below are step by step instructions to use Anaconda and Jupyter Notebook.

### Option 1: Completing the challenges locally on your device:

- Python Installation: version at least \>= 3.6, the minimum requirement for using OpenAI's GPT-3.5-based models, such as ChatGPT.
  - [Python](https://www.python.org/downloads)
- Conda Installation: for project environment management and package management. Anaconda distribution is a popular Python distribution, while Miniconda is the lightweight version of Anaconda.
  - [Anaconda](https://docs.anaconda.com/anaconda/install) OR [Miniconda](https://docs.conda.io/en/latest/miniconda.html) Remove?
  - Follow instructions to install Anaconda Navigator on your device. This will install all the dependencies as well as a GUI tool to access them. [Direct link for Windows](https://docs.anaconda.com/free/anaconda/install/windows/) --  [Direct link for Mac](https://docs.anaconda.com/free/anaconda/install/mac-os/)
- Environment setup:
  - Open Anaconda Prompt or your favourite terminal and verify Python and Conda installations using ``python --version`` and ``conda --version``. You can use your windows search bar to either open Anaconda Prompt or the Anaconda Navigator. Within Anaconda Navigator you can open the CMD.exe Prompt application, which launches a prompt window with your current Anaconda Environment activated.
  - Enter the following commands choosing adeuqate names for your WTH project: 
    - Create a project environment using conda - ``conda create --name <env_name>``. This will ensure you can access your .env folder. 
    - Activate conda environment - ``conda activate <env_name>``
    - Navigate (using the dir and cd commands) to your downloaded and unzipped folder you downloaded and reach the student/resources folder. Install the required libraries listed in the requirements.txt file via ``pip install -r requirements.txt``
- Opening and running the notbebooks:
  - Launch the Jupyter Notebook app from within Anaconda Navigator. This should open a new browser window where you can launch notebooks from the file system. Rarely, it can instead open a .html file in your text editor. If this is the case, find the paragraph near the bottom that mentions the link to the Jupyter notebook and open that link in your browser.
  - Navigate to the project folder and then to the student/resources/Notebooks folder. Click on the challenge you will be working on and it will open in a new tab.
  - Any 'No module named' error, which indicates a missing library, can be fixed by inserting a '!pip install <library name>' command above the failing statement. This will download the library files.  


### Option 2: Completing the challenges on Azure Machine Learning notebooks:

  - Create an Azure Machine Learning studio resource [Microsoft Learn](https://learn.microsoft.com/en-us/training/modules/create-workspace-resources-getting-started-azure-machine-learning/5-create-azure-machine-learning-workspace)
  - Create an Azure Machine Learning workspace and a compute instance. Use a Standard_DS11_v2 type of VM. [Microsoft Learn](https://learn.microsoft.com/en-us/azure/machine-learning/quickstart-create-resources?view=azureml-api-2)
  - On the top left of your screen, click on the plus (add files) symbol. Choose 'Upload a folder' (the option at the bottom). Browse for your unzipped hack folder and upload it.
  - Open the terminal and wait for the compute to create. Once it has created, navigate to the student/resources directory by using the 'cd' command, make sure you are in the directory of the folder you uploaded to the workspace. Install the requirement files by running the command 'pip install requirments.txt -r'
  - Once the libraries have loaded, navigate the folder system on the left hand side of the screen to open the notebooks at the student/resources directory and open the notebook for the challenge you will be working on.
  -  Any 'No module named' error, which indicates a missing library, can be fixed by inserting a '!pip install <library name>' command above the failing statement. This will download the library files.

    
## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have Python and Conda installed.
- Verify that you can run Jupyter Notebooks locally or on AML.
- Verify that you have created the AOAI resource and deployed the necessary deployments.

