# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)


## Introduction

Thank you for participating in the Fabric Real-time Intelligence What The Hack. Before you can hack, you will need to set up some prerequisites.

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

- [Azure IoT Tools](https://learn.microsoft.com/en-us/azure/iot-hub/reference-iot-hub-extension#install-from-the-visual-studio-code-marketplace) extension for Visual Studio Code
- .NET SDK 6.0 or later installed on your development machine. This can be downloaded from [here](https://www.microsoft.com/net/download/all) for multiple platforms.

In the `/Challenge00/` folder of the Resources.zip file, you will find an ARM template, `setupIoTEnvironment.json` that sets up the initial hack environment in Azure you will work with in subsequent challenges.

Please deploy the template by running the following Azure CLI commands from the location of the template file:
```
az group create --name myIoT-rg --location eastus
az group deployment create -g myIoT-rg --name HackEnvironment -f setupIoTEnvironment.json
```

After deploying the ARM template, navigate to the resource group and create a Fabric capacity in the Azure portal. F4 SKU is more than enough for this WTH.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that the ARM template has deployed the following resources in Azure:
  - Event Hub Namespace
  - Event Hub (verify it is ingesting data from the container)
  - Azure Container Instance (verify that it is running the Docker container and data is streaming out, go to logs to verify this)
- Fabric instance created and running (F4)
