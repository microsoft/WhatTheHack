# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Bicep-Challenge-01.md)

## Introduction

A smart cloud solution architect always has the right tools in their toolbox. We could have just provided you with a list of links to install all the tools here, but since this hack covers Azure fundamentals, we felt it was important to provide context on what these tools are for and how they work together. 

We encourage you to read through the details of "Challenge Zero" with your fellow hackers and understand WHAT you are installing BEFORE you install it.

## Description

Here's roadmap of what you will need to hack today. You can click the links to jump to corresponding sections of this page for more details.

- An [Azure Subscription](#azure-subscription)
- [Decide: Local Workstation or Azure Cloud Shell?](#decide-local-workstation-vs-azure-cloud-shell)

If you go "local", you will be setting up all the tools you will need to complete the challenges on your local workstation:

- [Azure CLI vs Azure PowerShell](#azure-cli-vs-azure-powershell)
- [Install Azure CLI on Mac or Linux](#install-azure-cli-on-mac-or-linux)
- [Understanding Azure CLI on Windows](#understanding-azure-cli-on-windows)
  - [Install Windows Subsystem for Linux (WSL)](#install-windows-subsystem-for-linux-wsl) - Optional, but highly recommended.
- [Install PowerShell and Azure PowerShell Cmdlets](#install-powershell-and-azure-powershell-cmdlets)
  - Install Bicep CLI Manually
- Visual Studio Code
  - Bicep Extension for VS Code

Older stuff here:

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

### Azure Subscription

You will need an Azure subscription to complete this hackathon. If you don't have one...

[Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)

Our goal in the hackathon is limiting the cost of using Azure services.

If you've never used Azure, you will get:

- $200 free credits for use for up to 30 days
- 12 months of popular free services (includes storage, Linux VMs)
- Then there are services that are free up to a certain quota

Details can be found here on [free services](https://azure.microsoft.com/en-us/free/).

If you have used Azure before, we will still try to limit cost of services by suspending, shutting down services, or destroy services before end of the hackathon. You will still be able to use the free services (up to their quotas) like App Service, or Functions.

### Decide: Local Workstation vs Azure Cloud Shell

If you are going to be managing Azure resources on a regular basis and developing infrastructure-as-code with Bicep templates, we strongly recommend you take the time to install the pre-requisite tools listed below on your workstation (Windows, Mac, or Linux).  This will give you a better understanding of how they work.  

However, we understand that some users may not have the ability to install software tools on their workstation.

This hack can be completed using the [Azure Cloud Shell](https://shell.azure.com).  Azure Cloud Shell is an interactive, authenticated, browser-accessible terminal for managing Azure resources. It provides the flexibility of choosing the shell experience that best suits the way you work, either Bash or PowerShell.

The Azure Cloud Shell has all of the CLI tools you need to complete this hack's challenges pre-instaled. It also has a GUI text editor, `code`, that is a slimmed down version of Visual Studio Code. There are some caveats to using the Azure Cloud Shell:
- The `code` editor in Azure Cloud Shell does not have the Bicep extension, which provides rich Intellisense and error/warning messages as you develop.
- Cloud Shell runs on a temporary host provided on a per-session, per-user basis. Your Cloud Shell session times out after 20 minutes without interactive activity, which you may find disruptive as you work through this hack.

If you choose to use the Azure Cloud Shell, you are taking the "easy" way out. You can skip to the [Success Criteria](#success-criteria) below and move on to Challenge 1.

### Azure CLI vs Azure PowerShell

Azure can be managed using either the cross-platform Azure Command Line Interface (CLI) or the Azure PowerShell commandlets. You can accomplish virtually any management task, including deploying Bicep templates, using either option.  

In the real world, most companies will standardize on one or the other.  Use whichever one you are most comfortable with. We have found that when doing Internet searches for various Azure management tasks, Azure CLI examples seem to show up more often in the results.

This hack encourages students to get familiar with using both tools. Therefore, let's get both of them set up...

### Install Azure CLI on Mac or Linux

If you drive a Mac or Linux workstation, installing the Azure CLI is very straight forward. Follow the instructions for your OS of choice here: 
- [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

### Understanding Azure CLI on Windows

For Windows users, there is a bit of nuance. We highly recommend installing the Windows Subsystem for Linux (WSL) first and then installing the Azure CLI within it.

#### Install Windows Subsystem for Linux (WSL)

The Windows Subsystem for Linux (WSL) lets developers run an entire Linux distribution -- including most command-line tools, utilities, and applications -- directly on Windows, unmodified, without the overhead of a virtual machine.

WSL is an essential tool Azure admins should have on their workstations if they are running Windows! If you work with Linux servers in Azure (or anywhere), having access to WSL enables you to easily connect to them and use all the Bash shell tools you're used to.

- [Install the Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install)

#### Install Azure CLI on WSL

The Azure CLI can be installed locally on Windows. If you do this, you will access and use the Azure CLI from the **Windows Command Prompt** or **PowerShell Console**.

While the Azure CLI examples in the Microsoft documentation work fine locally on Windows, as you search the web for examples of how to use the Azure CLI, the examples frequently show Azure CLI commands used in Bash shell scripts. Bash shell scripts **will not run** in the Windows Command Prompt or PowerShell Console.

For this reason, we recommend using WSL for interacting with the Azure CLI. This means you should install the Azure CLI within your WSL environment by following the instructions for the Linux distro you are using:

- [Install the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

**NOTE:** If you have previously installed the Azure CLI on Windows, and then install it in WSL, you will have two installations of the Azure CLI on your workstation. You may need to restart your WSL instance so that WSL is set to use the Azure CLI instance installed in WSL, not the instance installed on Windows.

#### Install Azure CLI on Windows

If you are not able to install WSL on your Windows workstation, you can install the Azure CLI on Windows by following the instructions here:
- [Install Azure CLI on Windows](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

### Install PowerShell & Azure PowerShell Cmdlets

Azure PowerShell provides a set of cmdlets that use the Azure Resource Manager for managing your Azure resources.

[Install the Azure PowerShell Cmdlets](https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps)

The Azure PowerShell Cmdlets are functionally equivalent to the Azure CLI and can be used to complete all of the challenges instead of the Azure CLI.
- [PowerShell 7](https://learn.microsoft.com/powershell/scripting/install/installing-powershell)
  - [Azure PowerShell Cmdlets for Azure](https://learn.microsoft.com/powershell/azure/install-az-ps)

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
