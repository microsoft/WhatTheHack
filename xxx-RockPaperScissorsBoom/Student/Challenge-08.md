# Challenge 08 - Leverage SignalR

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-09.md)

## Introduction

With this challenge you will deploy and add your own SmartBot by leveraging SignalR, you will add a new competitor in your games.

## Description

- There is already the `RockPaperScissorsBoom.ExampleBot` project in your solution implementing a SignalR bot, let's just use it and deploy it!
- Deployit on a new Azure Web App for Containers instance.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Make sure `az webapp list` and `az acr repository show-tags` are showing your Azure services properly.
- In your web browser, navigate to the main web app (Server), add this Bot as a new competitor and play a game, make sure it's working without any error.

## Learning Resources

1. [SignalR](https://www.asp.net/signalr)
1. [Azure SignalR](https://azure.microsoft.com/en-us/services/signalr-service/)
1. [Leverage Azure SignalR](https://docs.microsoft.com/en-us/azure/azure-signalr/signalr-quickstart-dotnet-core)
1. [The Twelve Factor App - checklist to build microservices-based solution](https://12factor.net/)

## Tips

- Revisit challenges [Challenge 4 - Run the app on Azure](RunOnAzure.md) and/or [Challenge 7 - Build a CI/CD pipeline with Azure DevOps](BuildCICDPipelineWithAzureDevOps.md). For the latter, the recommendation is to create its own Build and Release definition (not impacting the ones already created for the `Server`).
- To add this new Bot deployed in your Game, just navigate to the `Competitors` menu of your main web app (Server) and create a new competitor. You will have to provide the URL of your Bot and add `/decision` to the end of the URL.
