# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the RockPaperScissorsBoom What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
- [Logic Apps CLI extension](https://learn.microsoft.com/en-us/azure/logic-apps/quickstart-logic-apps-azure-cli#prerequisites)
- [Docker](https://docs.docker.com/engine/install/)
- [.NET 6.0 SDK](https://dotnet.microsoft.com/download/dotnet/6.0)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specific to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Create an Azure Resource Group to deploy your resources into.

```shell
az group create --name rg-rpsb-<team-name> --location <location>
```

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a shell with the Azure CLI or Azure PowerShell available.
- Verify you can create an Azure Resource Group.
