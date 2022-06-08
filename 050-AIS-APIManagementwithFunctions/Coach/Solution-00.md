# Challenge 00 - Preparing your Development Environment - Coach's Guide

**[Home](./README.md)** - [Next Solution>](./Solution-01.md)

## Description

You need to ensure that the students have prepared all the required tools such as:

- [Azure Subscription](https://azure.microsoft.com/en-us/free/) with at least Contributor access 
- [Access to the Azure Portal](https://portal.azure.com/)
- [Visual Studio Code](https://code.visualstudio.com/) - As of writing, the version used is **1.63**.
    - [Bicep CLI Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) - As of writing, the version used is **0.4.1124**.
    - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/update-azure-cli) - As of writing, the Azure CLI version used is **2.32.0**.
    - Set default Azure subscription and resource group
        - Open VS Code Terminal
        - Sign-in by running ```az login``` 
        - Set default subscription by running ```az account set --subscription "<subscription name or subscription id>"```
        - Set default resource group by running ```az configure --defaults group=<resource group name>```

[Back to Top](#challenge-00---preparing-your-development-environment---coachs-guide)