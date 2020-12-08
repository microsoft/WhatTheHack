# Challenge 1 - Setup

## Prerequisities

- Your laptop: Win, MacOS or Linux OR A development machine that you have **administrator rights**.
- Active Azure Subscription with **contributor level access or equivalent** to create or modify resources.

## Introduction 

### Set up your *local* environment.

The first challenge is to setup an environment that will help you build the Tollbooth application and deploy it locally. We need to make sure everything is working before bringing it to Azure.

- Visual Studio or Visual Studio Code
    - Azure development workload for Visual Studio 2017 or 2019
    - Azure Functions and Web jobs tools
    - [Node.js 8+](https://nodejs.org/en/download/): Install latest long-term support (LTS) runtime environment for local workstation development. A package manager is also required. Node.js installs NPM in the 8.x version. The Azure SDK generally requires a minimum version of Node.js of 8.x. Azure hosting services, such as Azure App service, provides runtimes with more recent versions of Node.js. If you target a minimum of 8.x for local and remove development, your code should run successfully.
    - .NET Core 3.1
    - Any extentions required by your language of choice

*To setup Azure Functions on Visual studio Code, [follow this guide.](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=csharp)*
 
## Challenges

1. [Download](https://minhaskamal.github.io/DownGit/#/home?url=https:%2F%2Fgithub.com%2Fmicrosoft%2FWhatTheHack%2Ftree%2Fmaster%2F015-Serverless%2FStudent%2FResources) the source code needed for this hack.
1. Uncompress the file.


## Success criteria

1. You have 2 folders locally.  One named Tollbooth and the other named license plates.


[Next challenge (Create a Hello World Function) >](./02-FunctionIntro.md)
