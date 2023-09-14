# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specific to this hack. 

Please ensure that you have [Azure OpenAI access](https://aka.ms/oaiapply). This hack is self-paced and you will primarily be working with Jupyter notebooks.

Please install these additional tools and resources:

- Python Installation, version at least \>= 3.6, the minimum requirement for using OpenAI's GPT-3.5-based models, such as ChatGPT.
  - [Python](https://www.python.org/downloads). This is also available in the Microsoft Store if you are using Windows.
- Conda Installation, for project environment management and package management, version \>= conda 4.1.6. Anaconda distribution is a popular Python distribution, while Miniconda is the lightweight version of Anaconda.
  - [Anaconda](https://docs.anaconda.com/anaconda/install) OR [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- Environment setup:
  - Open Anaconda Prompt or your favourite terminal and verify Python and Conda installations using `python --version` and `conda --version`
  - Create a project environment using Conda - `conda create --name <env_name>`
  - Activate Conda environment - `conda activate <env_name>`
  - Install the required libraries listed in the `requirements.txt` file via `pip install -r requirements.txt`
  - Open the project in VS Code using `code .`
  - If you are using Visual Studio Code, make sure you change your Python interpreter (CTRL+SHIFT+P) to select the project/virtual environment that you just created.
- [Create an Azure OpenAI Resource](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/overview) 
- Deploy the following models in your Azure OpenAI resource. A couple of challenges may require a few additional prerequisites so be sure to check those out in the respective challenges. 
  - `gpt-35-turbo`
  - `text-embedding-ada-002`
- Add required credentials of Azure resources in the `.env` file
  - **NOTE:** Additional Azure resources such as Azure Form Recognizer and Azure Cognitive Search will be required for later challenges. Make sure to update ``.env`` file with credentials as needed. 
