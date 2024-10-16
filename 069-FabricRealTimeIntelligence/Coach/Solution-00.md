# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Introduction

Thank you for participating in the Fabric real time intelligence WTH. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
## Description

Here are the instructions for installing the ARM template. This will create:

- Event Hub namespace and Event Hub (EH)
- Azure Container Instance (ACI)

The EH will get created first, then the ACI. The ACI will be started with a container from the Docker Hub "cameronkahrsdocker/fabricwthdatapumpv2" which will automatically stream events to the EH created in the first step.


Here is a video link of how to go through the setup, step by step: [MAA Fabric Realtime Analytics](https://www.youtube.com/watch?v=wGox1lf0ve0)

Steps:

1. Login to the Azure portal and open the CLI (Command Line Interface)
2. Upload the "setupIoTEnvironment.json" to the storage connected to the CLI.
3. Navigate to those files in the command line.
4. Run 
    - `az group create --name <resource-group-name> --location westus3`
    - You pick a name for the resource group.
5. Run 
    - `az deployment group create --resource-group <resource-group-name> --template-file "fsetupIoTEnvironment.json"`
6. You should now have a resource group in your azure subscription with the EH and ACI resources.
8. Create a Fabric instance through the Azure portal. An F4 SKU is all that is needed.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that the ARM template has deployed the following resources in Azure:
  - Event Hub Namespace
  - Event Hub (verify it is ingesting data from the container)
  - Azure Container Instance (verify that it is running the Docker container and data is streaming out, go to logs to verify this)
- Fabric instance running
