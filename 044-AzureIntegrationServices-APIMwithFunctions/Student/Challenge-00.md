# Challenge 00 - Preparing your Development Environment

**[Home](./README.md)** - [Next Challenge>](./Challenge-01.md)

## Introduction

A cloud engineer should be have the right set of tools in order to be successful in deploying an integration solution in Azure.

## Description

In this challenge we'll be setting up all the tools we will need to complete our challenges.

  - Install the recommended toolset as follows:
    - [Azure Subscription](#azure-subscription)
    - [Visual Studio Code](#visual-studio-code)
      - [Bicep CLI Extension](#bicep-cli-extension)
      - [Azure CLI](#azure-cli)
      - [Set default Azure subscription and resource group](#set-default-azure-subscription-and-resource-group)
    - [Managing Cloud Resources](#managing-cloud-resources)
      - [Azure Portal](#azure-portal)
    - [DownGit](#downgit)

## Azure Subscription

You will need an Azure subscription to complete this hackathon. If you don't have one, [sign up for a free Azure subscription by clicking this link](https://azure.microsoft.com/en-us/free/).

If you are using Azure for the first time, this subscription comes with:

- \$200 free credits for use for up to 30 days
- 12 months of popular free services (includes API Management, Azure Functions, Virtual Machines, etc.)
- Then there are services that are free up to a certain quota

Details can be found here on [free services](https://azure.microsoft.com/en-us/free/).

If you have used Azure before, we will still try to limit cost of services by suspending, shutting down services, or destroy services before the end of the hackathon. You will still be able to use the free services up to their quotas.

## Visual Studio Code

Visual Studio Code is a lightweight but powerful source code editor which runs on your desktop and is available for Windows, macOS and Linux. It comes with built-in support for JavaScript, TypeScript and Node.js and has a rich ecosystem of extensions for other languages (such as C++, C#, Java, Python, PHP, Go) and runtimes (such as .NET and Unity).

[Install Visual Studio Code](https://code.visualstudio.com/)

VS Code runs on Windows, Mac, and Linux. It's a quick install, NOT a 2 hour install like its namesake full-fledged IDE on Windows. 

As of writing, the version used is **1.63**.

### Azure CLI

You also need to make sure that you have [installed the latest version of Azure CLI](https://docs.microsoft.com/en-us/cli/azure/update-azure-cli). To do so, open [Visual Studio Code Terminal window](https://code.visualstudio.com/docs/editor/integrated-terminal) and run ```az upgrade```.

As of writing, the Azure CLI version used is **2.32.0**.

### Bicep CLI Extension

Visual Studio Code with the Bicep extension provides language support and resource autocompletion. The extension helps you create and validate Bicep files.

To install the extension, search for bicep in the Extensions tab or in the [Visual Studio marketplace](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep).  Alternatively, you can open the VS Code Terminal window and run ```az bicep install && az bicep upgrade``` to get the latest version.

As of writing, the version used is **0.4.1124**.

### Set default Azure subscription and resource group

You can set your default Azure subscription and resource group by: 

- Sign-in by running ```az login``` in the VS Code Terminal
- Set default subscription by running ```az account set --subscription "<subscription name or subscription id>"```
- Set default resource group by running ```az configure --defaults group=<resource group name>```

## Managing Cloud Resources

We can manage cloud resources via the following ways:

- Web Interface/Dashboard
  - [Azure Portal](https://portal.azure.com/)

### Azure Portal

Build, manage, and monitor everything from simple web apps to complex cloud applications in a single, unified console.

Manage your resources via a web interface (i.e. GUI) at [https://portal.azure.com/](https://portal.azure.com/)

The Azure Portal is a great tool for quick prototyping, proof of concepts, and testing things out in Azure by deploying resources manually. However, when deploying production resources to Azure, it is highly recommended that you use an automation tool, templates, or scripts instead of the portal.

## DownGit

One recommended way to enable attendees to easily download hack resources is using DownGit. DownGit is a clever utility that lets you create a download link to any GitHub public directory or file. 

You can view the DownGit project on GitHub here: <https://github.com/MinhasKamal/DownGit>

And you can use DownGit from its website here: <https://minhaskamal.github.io/DownGit/#/home>

