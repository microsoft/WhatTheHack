# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Data Science in Microsoft Fabric What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../Student/000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../Student/000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Azure Storage Explorer](../Student/000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specifc to this hack.

There is a Resources.zip file in this repo that contains the resources you will need to complete the hack. Please download and unzip the folder.

To begin setting up your Azure subscription for this hack, you will run a bash script that will deploy and configure a list of resources. You can find this script as the HackSetup.sh file in the resources folder. 
 - Donwnload the setup file to your computer
 - Go to the Azure portal and click on the cloud shell button on the top navigation bar, to the right of the Copilot button.
 - Once the cloud shell connects, make sure you are using a Bash shell. If you are not, click on the button on the top-right corner of the cloud shell to switch to bash.
 - Click on the Manage Files button on the shell's navigation bar and select upload. Select the setup file from your computer.
 - Run the `sh HackSetup.sh` command in your cloud shell.
 - Follow the prompts in the shell.


## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a storage account with the heart.csv data in a container
- (Optional) Verify that your Azure ML workspace has correctly deployed (if completing Challenge)
