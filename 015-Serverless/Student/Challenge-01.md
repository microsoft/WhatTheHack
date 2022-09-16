# Challenge 01 - Setup

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites

- Your laptop: Win, MacOS or Linux OR A development machine that you have **administrator rights**.
- Active Azure Subscription with **contributor level access or equivalent** to create or modify resources.

## Introduction

The first challenge is to setup an environment that will help you build the Tollbooth application and deploy it locally. We need to make sure everything is working before bringing it to Azure.

## Description

Set up your *local* environment:

- Visual Studio or Visual Studio Code
    - Azure development workload for Visual Studio 2022 or 2019
    - Azure Functions and Azure Functions Core Tools
    - [Node.js 8+](https://nodejs.org/en/download/): Install latest long-term support (LTS) runtime environment for local workstation development. A package manager is also required. Node.js installs NPM in the 8.x version. The Azure SDK generally requires a minimum version of Node.js of 8.x. Azure hosting services, such as Azure App service, provides runtimes with more recent versions of Node.js. If you target a minimum of 8.x for local and remove development, your code should run successfully.
    - .NET 6 SDK
    - [VS Code Todo Tree Extension](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree)
    - Any extentions required by your language of choice

*To setup Azure Functions on Visual Studio Code, [follow this guide.](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=csharp)*
 
Your coach will provide you with a `Resources.zip` file containing the source code and supporting files for this hack.  Uncompress the file on your local workstation.

**NOTE:** What The Hacks are normally run as live events where coaches advise small groups of 3-5 people as they try to solve the hack's challenges. For the [#ServerlessSeptember](https://azure.github.io/Cloud-Native/serverless-september/) event, the Microsoft Reactor team is challenging folks to complete the Azure Serverless hack on their own and share their solutions. 

To support this event, we are making the [`Resources.zip`](https://aka.ms/serverless-september/wth/resources) file available for download [here](https://aka.ms/serverless-september/wth/resources).

## Success Criteria

1. Verify your Visual Studio or Visual Studio Code installation has all of the necessary developer tools installed and available.
1. Verify you have the following folders locally wherever you unpacked the `Resources.zip` file:
    - `/Tollbooth`
    - `/license plates`
