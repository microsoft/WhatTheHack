# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](../readme.md)** - [Next Challenge>](./Challenge01.md)

## Pre-requisites

**Make sure that you have joined Teams group for this track.  The first person on your team at your table should create a new channel in this Team with your team name.**

## Introduction

**Goal** is to complete all pre-requisites needed to finish all challenges.

## Description

**Install the recommended tool set:** 
- Access to an **Azure subscription** with Owner access. **[Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)**
- **[Windows Subsystem for Linux (Windows 10-only)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)**
- **[Windows PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7)** version 5.1
  - Confirm PowerShell version is **[5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)** `$PSVersionTable.PSVersion`
  - **[PowerShell modules](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7)**
    - Confirm PowerShell module versions.  Re-install the required version below (if needed):
      - Az version 4.1.0 
      - AzureAd version 2.0.2.4
        ```PowerShell
        Get-InstalledModule -Name Az -AllVersions
        Get-InstalledModule -Name AzureAd -AllVersions
        ```
- **[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)**
   - (Windows-only) Install Azure CLI on Windows Subsystem for Linux
   - Update to the latest
   - Must be at least version 2.7.x
- Alternatively, you can use the **[Azure Cloud Shell](https://shell.azure.com/)**
- **[.NET Core 3.1](https://dotnet.microsoft.com/download/dotnet-core/3.1)**
- **[Java 1.8 JDK](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)** (needed to run Synthea Patient Generator tool)
- **[Visual Studio Code](https://code.visualstudio.com/)**
- **[Node Module Extension for VS Code](https://code.visualstudio.com/docs/nodejs/extensions)**
- **[App Service extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureappservice)**
- **[Download Node.js Window Installer](https://nodejs.org/en/download/)**
- **[Download and install Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)**
- **[Postman](https://www.getpostman.com)**

## Success Criteria

- Azure Subscription is ready for use
- Powershell is installed
- Azure Ad and Az modules are installed
- Bash shell (WSL, Mac, Linux or Azure Cloud Shell) is installed
- .NET Core is installed
- Java JDK is installed
- Visual Studio Code and required extensions are installed
- Node.js and npm are installed
- Postman is installed

## Learning Resources

- **[Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)**
- **[Setting up Visual Studio Code](https://code.visualstudio.com/docs/setup/setup-overview)**
- **[VS Code Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-gallery)**
- **[NodeJS pre-built installer downloads](https://nodejs.org/en/download/)**
- **[Downloading and installing Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)**

