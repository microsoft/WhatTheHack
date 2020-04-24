# Challenge 1 - Setup

## Prerequisities

1. Your laptop: Win, MacOS or Linux
1. Your GitHub account, if not yet it's time to create one! ;)
1. Your Azure Subscription
1. Your Azure DevOps account, if not yet it's time to create one! ;)

## Introduction 

### Set up your *local* environment.

The first challenge is to setup an environment that will help you build the Rock Paper Scissors Boom! Game Server and deploy it locally. We need to make sure everything is working before bringing it to Azure.

 To *really* do this locally, you would need the app platform (.NET Core, SQL Server, IIS, etc) running locally. We probably do not have enough time for that. Enter Azure! We can set up server in Azure to replicate a local environment where we can build our application and test deploying it. All we need running on that server is Docker and we can leverage containers for building and deploying the application; even hosting the database!
 
 But, even in that case, we need some tools locally to manage Azure and that can take a while to setup. The good news is that by using the Azure Shell - we have all the tools we need.  All we really need is a browser and an Azure subscription.

> The use of Azure Cloud Shell is our recommendation to simplify your experience. But if you prefer using your local machine to do the lab, feel free to do it. Based on our experience, the setup of Docker on local machine (which is required for the challenges) could take some time and could have some issues.*

 **Setting up this mock *local* environment is important. We will be using this environment for future challenges.**

## Challenges

1. [Fork](https://help.github.com/articles/fork-a-repo/) this repo in your GitHub account. We want you to create your own fork so that if you have suggestions or fixes, you can issue a pull-request and submit them back to the main repo.
1. [Clone](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) your repo in [Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview)
    * cloning the entire WhatTheHack repo will take several minutes. 
    * Make sure you clone your OWN fork of the repo, not the Microsoft/WhatTheHack repo.
    * We recommend using [Bash (Linux) mode](https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart) in the cloud shell for this Hack
    * Have limited screen real estate? Try the [full screen shell](https://shell.azure.com/)
1. Setup a VM in Azure that will be your Docker Host. This is the VM where you will build the application, deploy it and test it. Azure Cloud Shell has the Docker client installed. You will be able to connect the Docker Client in Azure Cloud Shell to your VM. ([instructions here](./helpers/CreateDockerHostVM.md)).

### Optional Challenges
1. Create a new Private project in [Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=vsts&tabs=new-nav) (with Git and Agile under advanced options)
   1. The source code will be in GitHub, but the rest (backlog, build, release and tests) will be in Azure DevOps.
1. Populate your Azure DevOps (Boards) backlog with user stories (work items). One user story per challenge. ([List of challenges in the ReadMe](../README.md))

## Success criteria

1. In Azure Cloud Shell, make sure `git status` is showing you the proper branch
1. In Azure Cloud Shell, make sure `docker images` command runs successfuly (without error).
1. In Azure Cloud Shell, let's play with the following commands: `ls -la`, `git version`, `az --version`, `docker images`, `code .`, etc.

## Tips

1. In Azure Cloud Shell, you will leverage the `Bash (Linux)` mode, we all love Linux! <3
1. To create the Docker Host VM in Azure and connect to it, follow [these instructions](./helpers/CreateDockerHostVM.md).


## Advanced challenges

Too comfortable? Eager to do more? Here you are:

1. Instead of leveraging Azure Cloud Shell and a Docker Host VM in Azure to build your images and run them, you could do that locally on your laptop by installing Docker CE and Docker-compose.
1. Instead of leveraging GitHub to host your source code, you could leverage Azure Repos (Git) in Azure DevOps.

## Learning resources

- [Visual Studio Code embedded in Azure Cloud Shell](https://azure.microsoft.com/en-us/blog/cloudshelleditor/)
- [Visual Studio Team Services (VSTS) became Azure DevOps](https://azure.microsoft.com/en-us/blog/introducing-azure-devops/)
- [Microsoft acquired GitHub](https://news.microsoft.com/2018/06/04/microsoft-to-acquire-github-for-7-5-billion/)
- [Microsoft Azure + Open Source (OSS)](https://open.microsoft.com/)

[Next challenge (Run the App) >](./RunTheApp.md)
