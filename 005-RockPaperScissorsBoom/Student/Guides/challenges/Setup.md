# Challenge 1 - Setup

## Prerequisities

1. Your laptop: Win, MacOS or Linux
1. Your GitHub account, if not yet it's time to create one! ;)
1. Your Azure Subscription
1. Your Azure DevOps account, if not yet it's time to create one! ;)

## Introduction

With this first challenge you will be able to setup the environment required to run all the further challenges. You will leverage Azure Cloud Shell and an Azure Docker-machine instead of your local machine for any command you will need. In other word, you just need a web browser and an internet connection on your laptop. Furthermore, you will be able to create the associated Azure DevOps project to manage first your backlog, and your builds, releases and tests in further labs.

> The use of Azure Cloud Shell is our recommendation to simplify your experience. But if you prefer using your local machine to do the lab, feel free to do it. Based on our experience, the setup of Docker on local machine (which is required for the labs) could take some time and could have some issues.*

[Docker Machine](https://docs.docker.com/machine/overview/) is a tool that lets you install Docker Engine on virtual hosts, and manage the hosts with docker-machine commands. This will allow you to build a linux VM in Azure that will act as your development box. On this VM you will build and run your code and containers during development. However insted of SSHing into the VM to do this work, the docker machine components will install into your Azure Cloud Shell, giving you control of the docker instance in the VM from the browser. This eliminates the need to install anything locally on your machine.

![Setup](../docs/Setup.png)

## Challenges

1. [Fork](https://help.github.com/articles/fork-a-repo/) this repo in your GitHub account
1. [Clone](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) your repo in [Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview)
   1. We recommend using [Bash (Linux) mode](https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart) in the cloud shell for this Hack
   1. Have limited screen real estate? Try the [full screen shell](https://shell.azure.com/)
1. Setup an Azure Docker-machine to be used through your Azure Cloud Shell ([instructions here](./helpers/CreateDockerMachine.md))
1. Create a new Private project in [Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=vsts&tabs=new-nav) (with Git and Agile under advanced options)
   1. The source code will be in GitHub, but the rest (backlog, build, release and tests) will be in Azure DevOps.
1. Populate your Azure DevOps (Boards) backlog with user stories (work items). One user story per challenge. ([List of challenges in the ReadMe](../Readme.md))

## Success criteria

1. In Azure Cloud Shell, make sure `git status` is showing you the proper branch
1. In Azure Cloud Shell, make sure `docker images` command runs successfuly (without error).
1. In Azure Cloud Shell, make sure `docker-machine ls` is showing you your Docker-machine successfuly (without error).
1. In Azure DevOps (Boards), make sure you have your backlog populated. From the Boards view, you could now drag and drop this user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)
1. In Azure Cloud Shell, let's play with the following commands: `ls -la`, `git version`, `az --version`, `docker images`, `code .`, etc.

## Tips

1. In Azure Cloud Shell, you will leverage the `Bash (Linux)` mode, we all love Linux! <3
1. To create an Azure Docker Machine, follow [these instructions](./helpers/CreateDockerMachine.md)

## Advanced challenges

Too comfortable? Eager to do more? Here you are:

1. Instead of leveraging Azure Cloud Shell and an Azure Docker Machine to build your Docker images and run them, you could do that locally on your laptop by installing Docker CE and Docker-compose.
1. Instead of leveraging GitHub to host your source code, you could leverage Azure Repos (Git) in Azure DevOps.

## Learning resources

- [Visual Studio Code embedded in Azure Cloud Shell](https://azure.microsoft.com/en-us/blog/cloudshelleditor/)
- [Visual Studio Team Services (VSTS) became Azure DevOps](https://azure.microsoft.com/en-us/blog/introducing-azure-devops/)
- [Microsoft acquired GitHub](https://news.microsoft.com/2018/06/04/microsoft-to-acquire-github-for-7-5-billion/)
- [Microsoft Azure + Open Source (OSS)](https://open.microsoft.com/)

[Next challenge (Run the App) >](./RunTheApp.md)
