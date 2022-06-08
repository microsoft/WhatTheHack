# Challenge 00 - Preparing your Development Environment

**[Home](../README.md)** - [Next Challenge>](./Challenge-01.md)

## Introduction

A cloud engineer should have the right set of tools in order to be successful in deploying an integration solution in Azure.

## Description

In this challenge we will be setting up all the tools needed to complete our challenges.

  - Install the recommended toolset as follows:
    - [Azure Subscription](#azure-subscription)
    - [Azure CLI](#azure-cli)
    - [Visual Studio Code and Bicep extension](#visual-studio-code-and-bicep-extension)
      - [Set default Azure subscription and resource group](#set-default-azure-subscription-and-resource-group)
    - [Managing Cloud Resources](#managing-cloud-resources)
      - [Azure Portal](#azure-portal)
      - [Azure Cloud Shell](#azure-cloud-shell)
    - [Azure DevOps or GitHub](#azure-devops-or-github)
    - [Postman](#postman)


## Azure Subscription

You will need an Azure subscription to complete this hackathon. If you don't have one, [sign up for a free Azure subscription by clicking this link](https://azure.microsoft.com/en-us/free/).

If you are using Azure for the first time, this subscription comes with:

- \$200 free credits for use for up to 30 days
- 12 months of popular free services (includes API Management, Azure Functions, Virtual Machines, etc.)
- Then there are services that are free up to a certain quota

Details can be found here on [free services](https://azure.microsoft.com/en-us/free/).

If you have used Azure before, we will still try to limit cost of services by suspending, shutting down services, or destroy services before the end of the hackathon. You will still be able to use the free services up to their quotas.


### Azure CLI

You also need to make sure that you have [installed the latest version of Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli). To do so, open [Visual Studio Code Terminal window](https://code.visualstudio.com/docs/editor/integrated-terminal) and run ```az upgrade```.

This hack requires version **2.20.0 or higher**.


## Visual Studio Code and Bicep extension

You will need to set-up your environment using Visual Studio Code with Bicep extension to develop and deploy Azure resources using Bicep files. See [Install Bicep tools](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) for installation details.


This hack requires VS Code version **1.63 or higher**.


### Set default Azure subscription and resource group

You can set your default Azure subscription and resource group by: 

- Sign-in by running ```az login``` in the VS Code Terminal
- Set default subscription by running ```az account set --subscription "<subscription name or subscription id>"```
- Create a resource group by running ```az group create -l <location> -n <resource group name>```
- Then, set the resource group as default by running ```az configure --defaults group=<resource group name>```

## Managing Cloud Resources

We can manage cloud resources via the following ways:

### Azure Portal

Manage your resources via a web interface (i.e. GUI) at [https://portal.azure.com/](https://portal.azure.com/)

The Azure Portal is a great tool for quick prototyping, proof of concepts, and testing things out in Azure by deploying resources manually. However, when deploying production resources to Azure, it is highly recommended that you use an automation tool, templates, or scripts instead of the portal.

### Azure Cloud Shell

Build, manage, and monitor everything from simple web apps to complex cloud applications in a single, unified console via the [Azure Cloud Shell](https://shell.azure.com/).

### Azure DevOps or GitHub

You can [create an Azure DevOps project](https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=browser) to use Azure Pipelines for CI/CD.  If you prefer to use GitHub Actions instead, you must [create a new GitHub repository](https://docs.github.com/en/get-started/quickstart/create-a-repo).

### Postman

Postman is an API platform for building and using APIs. Postman simplifies each step of the API lifecycle and streamlines collaboration so you can create better APIs—faster.  [Sign up for free](https://identity.getpostman.com/signup?_ga=2.238632832.125996110.1654669428-421004685.1654669428) to get started with Postman.

[Back to Top](#challenge-00---preparing-your-development-environment)