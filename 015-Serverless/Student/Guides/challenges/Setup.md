# Challenge 1 - Setup

## Prerequisities

1. Your laptop: Win, MacOS or Linux
1. Your GitHub account, if not yet it's time to create one! ;)
1. Your Azure Subscription


## Introduction 

### Set up your *local* environment.

The first challenge is to setup an environment that will help you build the Tollbooth application and deploy it locally. We need to make sure everything is working before bringing it to Azure.

- Visual Studio or Visual Studio Code
    - Azure development workload for Visual Studio 2017
    - Azure Functions and Web jobs tools
    - .NET Framework 4.7 runtime (or higher)
    - .NET Core 2.1

> The use of Azure Cloud Shell is our recommendation to simplify your experience. But if you prefer using your local machine to do the hack, feel free to do it. You would then need to install the Azure CLI.

 
## Challenges

1. [Fork](https://help.github.com/articles/fork-a-repo/) this repo in your GitHub account. We want you to create your own fork so that if you have suggestions or fixes, you can issue a pull-request and submit them back to the main repo.
1. [Clone](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) your repo in [Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview)
    * cloning the entire WhatTheHack repo will take several minutes. 
    * Make sure you clone your OWN fork of the repo, not the Microsoft/WhatTheHack repo.



## Success criteria

1. In Azure Cloud Shell, make sure `git status` is showing you the proper branch successfuly (without error).
1. In Azure Cloud Shell, let's play with the following commands: `ls -la`, `git version`, `az --version`, `docker images`, `code .`, etc.

[Next challenge (Create Resources) >](./CreateResources.md)