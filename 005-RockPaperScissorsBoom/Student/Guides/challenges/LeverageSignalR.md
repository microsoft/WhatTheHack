# Challenge 9 - Leverage SignalR

## Prerequisities

1. [Challenge 6 - Implement Azure AD B2C](./ImplementAADB2C.md) should be done successfuly.

## Introduction

With this challenge you will deploy and add your own SmartBot by leveraging SignalR, you will add a new competitor in your games.

## Challenges

1. There is already the `RockPaperScissorsBoom.ExampleBot` project in your solution implementing a SignalR bot, let's just use it and deploy it!
1. Ready to create your own `Dockerfile-ExampleBot`, here you are! We are asking you to deploy locally in Azure Cloud Shell this container once built. And then deployed it on new Azure Web App for Containers. Could be under the same App Service Plan or under a new one, up to you.

## Success criteria

1. In Azure Cloud Shell, make sure `az webapp list` and `az acr repository show-tags` are showing your Azure services properly.
1. In your web browser, navigate to the main web app (Server), add this Bot as a new competitor and play a game, make sure it's working without any error.
1. In GitHub, make sure you documented the different commands you have used to update or provision your infrastructure. It could be in a `.md` file or in `.sh` file. You will complete this script as you are moving forward with the further challenges.
  1. Be sure you don't commit any secrets/passwords into a public GitHub repo.
1. In Azure DevOps (Boards), from the Boards view, you could now drag and drop the user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)

## Tips

1. Don't reinvent the wheels, just copy/paste the `Dockerfile-Server` file to your `Dockerfile-ExampleBot` and change the content accordingly. You could also add a new entry in the `docker-compose.yaml` file if you would like. Then you could run `docker build` or `docker-compose up` with the appropriate parameters.
1. Revisit challenges [Challenge 4 - Run the app on Azure](RunOnAzure.md) and/or [Challenge 7 - Build a CI/CD pipeline with Azure DevOps](BuildCICDPipelineWithAzureDevOps.md). For the latter, the recommendation is to create its own Build and Release definition (not impacting the ones already created for the `Server`).
1. To edit or read files from within Azure Cloud Shell, you could run `code .` to graphically browse the current folder and its files and subfolders. FYI, `cat` or `vi` are other alternatives.
1. To add this new Bot deployed in your Game, just navigate to the `Competitors` menu of your main web app (Server) and create a new competitor. You will have to provide the URL of your Bot by adding at the end of this URL: `/decision`. 

## Advanced challenges

Too comfortable? Eager to do more? Try this:

1. Now let's add more capability to your SignalR project by adding an Azure SignalR service.
1. Instead of leveraging Azure Web App Service for Containers, you could deploy your app in Azure Container Instance (ACI) or Azure Kubernetes Service (AKS).
1. Instead of leveraging Azure CLI to provision your infrastructure, you could leverage instead Azure ARM Templates, Ansible for Azure or Terraform for Azure.

## Learning resources

1. [SignalR](https://www.asp.net/signalr)
1. [Azure SignalR](https://azure.microsoft.com/en-us/services/signalr-service/)
1. [Leverage Azure SignalR](https://docs.microsoft.com/en-us/azure/azure-signalr/signalr-quickstart-dotnet-core)
1. [The Twelve Factor App - checklist to build microservices-based solution](https://12factor.net/) 

[Next challenge (Leverage Azure CDN) >](./LeverageCDN.md)