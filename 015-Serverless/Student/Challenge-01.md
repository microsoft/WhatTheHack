# Challenge 01 - Setup

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites

- An active Azure Subscription with **owner** access or equivalent to create or modify resources and add RBAC roles and Event Grid subscriptions.
- Windows, MacOS, or Linux development machine that you have **administrator rights**.
OR
- A GitHub account with access to [GitHub Codespaces](https://github.com/features/codespaces)

## Introduction

The first challenge is to setup an environment that will help you build, run, and test the Tollbooth application locally. We need to make sure everything is working before bringing it to Azure.

## Description

To complete this hack, you can set up the pre-requisite developer tools on your local workstation, or you can use GitHub Codespaces.

A GitHub Codespace is a development environment that is hosted in the cloud that you access via a browser. All of the pre-requisite developer tools are pre-installed and available in the codespace.

- [Setup GitHub Codespace](#setup-github-codespace)
- [Setup Local Workstation](#setup-local-workstation)

### Setup GitHub Codespace

You must have a GitHub account to use GitHub Codespaces. If you do not have a GitHub account, you can [Sign Up Here](https://github.com/signup)!

GitHub Codespaces is available for developers in every organization. All personal GitHub.com accounts include a monthly quota of free usage each month. GitHub will provide users in the Free plan 120 core hours, or 60 hours of run time on a 2 core codespace, plus 15 GB of storage each month.

You can see your balance of available codespace hours on the [GitHub billing page](https://github.com/settings/billing/summary).

- Your coach will provide you with a link to the Github Repo for this hack. Please open this link and sign in with your personal Github account. 

**NOTE:** Make sure you do not sign in with your enterprise managed Github account.

- Once you are signed in, click on the green "Code" button. Then click on "Codespaces". Finally, hit "Create codespace on main". 

Your Codespace environment should load in a new browser tab. It will take approximately 3-5 minutes the first time you create the codespace for it to load.

- When the codespace completes loading, you should find an instance of Visual Studio Code running in your browser with the files for the TollBooth application.

**NOTE:** It is recommended to enable the suggested C# development extensions when prompted by VSCode after the environment fully loads.

### Setup Local Workstation

**NOTE:** If you are planning to use GitHub Codespaces, skip this section as all pre-reqs will be setup in the Codespace environment.

If you want to set up the developer environment on your local workstation, expand the section below and follow the requirements listed.

<details markdown=1>
<summary markdown="span"><strong>Click to expand/collapse Local Workstation Requirements</strong></summary>

Set up your *local* environment:
- Visual Studio Code (or Visual Studio with Azure development workload)
- Azure CLI
- Azure Functions Core Tools
- [Node.js 18+](https://nodejs.org/en/download/): Install latest long-term support (LTS) runtime environment for local workstation development. A package manager is also required (NPM, installed by default with Node.js) The Azure SDK generally requires a minimum version of Node.js of 18.x. Azure hosting services, such as Azure App service, provides runtimes with more recent versions of Node.js. If you target a minimum of 18.x for local and remove development, your code should run successfully.
- .NET 8 SDK
- [VS Code Todo Tree Extension](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree)
- Any extensions required by your language of choice

*To setup Azure Functions on Visual Studio Code, [follow this guide.](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=csharp)*
 
[Download the student `Resources.zip` file here](https://aka.ms/wth/serverless/resources), containing the source code and supporting files for this hack.  Uncompress the file on your local workstation.

**NOTE:** What The Hacks are normally run as live events where coaches advise small groups of 3-5 people as they try to solve the hack's challenges. For the [`#ServerlessSeptember`](https://azure.github.io/Cloud-Native/serverless-september/) event, the Microsoft Reactor team is challenging folks to complete the Azure Serverless hack on their own and share their solutions. 

</details>
<br/>

## Success Criteria

If working on a local workstation: 

- Verify your local workstation's Visual Studio or Visual Studio Code installation has all of the necessary developer tools installed and available.
- Verify you have the following folders locally wherever you unpacked the `Resources.zip` file:
    - `/App`
        - `TollBooth`
        - `UploadImages`
    - `/Events`
    - `/license plates`

If using GitHub Codespaces:

- Verify you have the following folders available in the Codespace's VS Code window:
    - `/App`
        - `TollBooth`
        - `UploadImages`
    - `/Events`
    - `/HelloWorld`
    - `/license plates`
