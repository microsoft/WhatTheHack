# Challenge 0: Pre-requisites - Ready, Set, Go! 

**[Home](../README.md)** - [Next Challenge >](./01-HubNSpoke-basic.md)

## Introduction

A smart Azure engineer always has the right tools in their toolbox.

## Description

In this challenge we'll be setting up all the tools we will need to complete our challenges.

- Make sure that you have joined the Teams group for this track. Please ask your coach about the correct Teams channel to join.
- Ask your coach about the subscription you are going to use to fulfill the challenges
- Install the recommended toolset, being one of this:
    - The Powershell way (same tooling for Windows, Linux or Mac):
        - [Powershell core (7.x)](https://docs.microsoft.com/en-us/powershell/scripting/overview)
        - [Azure Powershell modules](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az)
        - [Visual Studio Code](https://code.visualstudio.com/): the Windows Powershell ISE might be an option here for Windows users, but VS Code is far, far better
        - [vscode Powershell extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
    - The Azure CLI way:
        - [Windows Subsystem for Linux](https://docs.microsoft.com/windows/wsl/install-win10), if you are running Windows and want to install the Azure CLI under a Linux shell like bash or zsh
        - [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
        - [Visual Studio Code](https://code.visualstudio.com/): the Windows Powershell ISE might be an option here for Windows users, but VS Code is far, far better
        - [VScode Azure CLI extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azurecli)
    - The Azure Portal way: not really recommended, but you can still the portal to fulfill most of the challenges. Do not complain about having to do more than once the same task across the challenges :)

**NOTE:** You can use Azure Powershell and CLI on the Azure Cloud Shell, but running the commands locally along Visual Studio Code will give you a much better experience

## Success Criteria

1. You have an Azure shell at your disposal (Powershell, WSL(2), Mac, Linux or Azure Cloud Shell)
1. Visual Studio Code is installed.
1. Running `az login` or `Connect-AzAccount` allows to authenticate to Azure
