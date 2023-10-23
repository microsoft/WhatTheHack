# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the OpenAIOnAzure What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Windows Subsystem for Linux](../../000-HowToHack/WTH-Common-Prerequisites.md#windows-subsystem-for-linux)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
- [Azure Storage Explorer](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specific to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Please install these additional tools:

- [Node v18.18.2](https://nodejs.org/en/download) or later
- Make sure [NPM 9.8.1](https://nodejs.org/en/download) or later is installed
- Install [Angular CLI](https://angular.io/cli#installing-angular-cli) globally

In the `/Challenge00/` folder of the Resources.zip file, you will find provides the initial hack environment you will work with in subsequent challenges.

You fill find the following folders:
- ContosoAIAppsBackend (contains an Azure function app that provides capabilities of processing data and interacting with Cognitive Services like OpenAI and Azure Document Intelligence)
- ContosoAIAppsFrontend (contains an Angular App that provides a user interface to some example virtual assistants)

### Setting up the Backend Azure Function App Locally

We will need to provision the following Azure resources that will be used to power the apps.

````bash

````

### Setting up the Frontend User Interface

This assumes that the UI is already set up and we just need to boot up the Angular app


```
az group create --name OpenAI-rg --location eastus
az group deployment create -g OpenAI-rg --name HackEnvironment -f setupIoTEnvironment.json
```

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a bash shell with the Azure CLI available.
- Verify that the ARM template has deployed the following resources in Azure inside the OpenAI-rg resource group:
  - Azure OpenAI Service
  - Azure Virtual Network
  - Azure Cognitive Search
  - Azure Cosmos DB service with databases and containers
  - Azure Service Bus with the queues set up
  - Azure Redis Cache Instance
  - Azure Storage Account with Blob Storage
  - An Azure Function App

## Learning Resources

Here are some resources that should provide you with background information and educational content on the resources you have just deployed

- [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/)

