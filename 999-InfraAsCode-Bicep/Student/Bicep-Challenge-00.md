# Challenge 0: Pre-requisites - Ready, Set, GO! 

**[Home](../README.md)** - [Next Challenge >](./Bicep-Challenge-01.md)

## Introduction

A smart cloud solution architect always has the right tools in their toolbox. 

## Description

In this challenge we'll be setting up all the tools we will need to complete our challenges.

- Install the recommended toolset:
  - An [Azure Subscription](https://azure.microsoft.com/en-us/free/)
  - [Windows Subsystem for Linux (Windows only)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
  - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
    - Must be at least version 2.20.x
    - **NOTE:** If installing on a Windows workstation, install into the Windows Subsystem for Linux environment using the installation instructions for Linux.
    - **NOTE:** If you’re running into issues running Azure CLI command on Windows, disable Global Protect (VPN)
  - [PowerShell Cmdlets for Azure](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-6.4.0)
  - [Visual Studio Code](https://code.visualstudio.com/)
  - Bicep plugins for VS Code
    - [Bicep VS Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
   - [Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) - AzureCLI version 2.20 & higher should include the Bicep CLI tools.  If you are using PowerShell, you must follow the instructions at this link to install the Bicep CLI.


**NOTE:** You can complete all of the challenges with the Azure Cloud Shell!  However, be a good cloud architect and make sure you have experience installing the tools locally.

## Success Criteria

1. You have a bash shell at your disposal (WSL, Mac, Linux or Azure Cloud Shell)
1. Running `az --version` shows the version of your Azure CLI
1. Visual Studio Code and Bicep tools are installed.