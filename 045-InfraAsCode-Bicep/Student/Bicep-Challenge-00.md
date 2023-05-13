# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Bicep-Challenge-01.md)

## Introduction

A smart cloud solution architect always has the right tools in their toolbox. "Challenge Zero" is all about ensuring you have the right tools for this hack.

### Local Workstation vs Azure Cloud Shell

If you are going to be managing Azure resources on a regular basis and developing infrastructure-as-code with Bicep templates, we strongly recommend you take the time to install the pre-requisite tools listed below on your workstation (Windows, Mac, or Linux).  This will give you a better understanding of how they work.  

However, we understand that some users may not have the ability to install software tools on their workstation.

This hack can be completed using the [Azure Cloud Shell](https://shell.azure.com).  Azure Cloud Shell is an interactive, authenticated, browser-accessible terminal for managing Azure resources. It provides the flexibility of choosing the shell experience that best suits the way you work, either Bash or PowerShell.

The Azure Cloud Shell has all of the CLI tools you need to complete this hack's challenges pre-instaled. It also has a GUI text editor, `code`, that is a slimmed down version of Visual Studio Code. There are some caveats to using the Azure Cloud Shell:
- The `code` editor in Azure Cloud Shell does not have the Bicep extension, which provides rich Intellisense and error/warning messages as you develop.
- Cloud Shell runs on a temporary host provided on a per-session, per-user basis. Your Cloud Shell session times out after 20 minutes without interactive activity, which you may find disruptive as you work through this hack. 

### Azure CLI vs Azure PowerShell

Azure can be managed using either the cross-platform Azure Command Line Interface (CLI) or the Azure PowerShell commandlets. You can accomplish virtually any management task, including deploying Bicep templates, using either option.  This hack encourages students to get familiar with using both tools.

In the real world, most companies will standardize on one or the other.  Use whichever one you are most comfortable with. We have found that when doing Internet searches for various Azure management tasks, Azure CLI examples seem to show up more often in the results.

## Description

In this challenge, we'll be setting up all the tools we will need to complete our challenges on your local workstation.  

- An [Azure Subscription](https://azure.microsoft.com/free/)
- [Windows Subsystem for Linux (Windows only)](https://learn.microsoft.com/windows/wsl/install)
  - WSL is optional for Windows users, but highly recommended for this hack. 
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  - Must be at least version 2.20.x
  - **NOTE:** If installing on a Windows workstation, install into the Windows Subsystem for Linux environment using the installation instructions for Linux.
  - **NOTE:** If you’re running into issues running Azure CLI command on Windows, you may need to disable your vpn
- [PowerShell 7](https://learn.microsoft.com/powershell/scripting/install/installing-powershell)
  - [Azure PowerShell Cmdlets for Azure](https://learn.microsoft.com/powershell/azure/install-az-ps)
- [Visual Studio Code](https://code.visualstudio.com/)
  - Bicep plugins for VS Code
   - [Bicep VS Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
   - [Azure Resource Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureresourcegroups) _optional, but very useful_
- [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install) - AzureCLI version 2.20 and higher should include the Bicep CLI tools. If you are using PowerShell, you must follow the instructions at this link to install the Bicep CLI.

**NOTE:** You can complete all of the challenges with the Azure Cloud Shell! However, be a good cloud architect and make sure you have experience installing the tools locally.  Also, it's your choice whether to use the Azure CLI or the Azure Powershell Cmdlets.

## Success Criteria

1. Running `az --version` shows the version of your Azure CLI
1. Visual Studio Code and Bicep tools are installed.
