# What The Hack - Dapr

## Introduction
This repository contains several hands-on assignments that will introduce you to Dapr. You will start with a simple ASP.NET Core application that is composed of several microservices. In each assignment, you'll enhance the the application by adding Dapr building blocks and components. At the same time, you'll configure the application to consume Azure-based backing services. When complete, you'll have implemented the following Dapr building blocks:

- Service invocation
- State-management
- Publish / Subscribe
- Bindings
- Secrets management

As Dapr can run on a variety of hosts, you'll start by running Dapr in self-hosted mode on your computer. Then, you'll deploy the Dapr application to run in Azure Kubernetes Service.

## Learning Objectives

## Challenges
1. Challenge 0: **[Install tools and Azure pre-requisites](Student/Challenge-00.md)**
   - Install the pre-requisites tools and software as well as create the Azure resources required for the workshop.
2. Challenge 1: **[Run the application](Student/Challenge-01.md)**
   - Run the Traffic Control application to make sure everything works correctly
3. Challenge 2: **[Add Dapr service invocation](Student/Challenge-02.md)**
   - Add Dapr into the mix, using the Dapr service invocation building block.
4. Challenge 3: **[Add pub/sub messaging](Student/Challenge-03.md)**
   - Add Dapr publish/subscribe messaging to send messages from the TrafficControlService to the FineCollectionService.
5. Challenge 4: **[Add Dapr state management](Student/Challenge-04.md)**
   - Add Dapr state management in the TrafficControl service to store vehicle information.
5. Challenge 5: **[Add a Dapr output binding](Student/Challenge-05.md)**
   - Use a Dapr output binding in the FineCollectionService to send an email.
5. Challenge 6: **[Add a Dapr input binding](Student/Challenge-06.md)**
   - Add a Dapr input binding in the TrafficControlService. It'll receive entry- and exit-cam messages over the MQTT protocol.
5. Challenge 7: **[Add secrets management](Student/Challenge-07.md)**
   - Add the Dapr secrets management building block.
5. Challenge 8: **[Deploy to Azure Kubernetes Service (AKS)](Student/Challenge-08.md)**
   - Deploy the Dapr-enabled services you have written locally to an Azure Kubernetes Service (AKS) cluster.

## Prerequisites
- Git ([download](https://git-scm.com/))
- .NET 5 SDK ([download](https://dotnet.microsoft.com/download/dotnet/5.0))
- Visual Studio Code ([download](https://code.visualstudio.com/download)) with the following extensions installed:
  - [C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)
  - [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)
  - [Install Bicep extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep))
- Docker for desktop ([download](https://www.docker.com/products/docker-desktop))
- Dapr CLI and Dapr runtime ([instructions](https://docs.dapr.io/getting-started/install-dapr-selfhost/))
- Install Azure CLI ([instructions]())
  - Linux ([instructions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#linux))
  - macOS ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos))
  - Windows ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli))
- Install Azure CLI Bicep tools ([instructions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-cli))

## Repository Contents
- `../Coach/Guides`
  - Coach's Guide and related files
- `../Student/Guides`
  - Student's Challenge Guide

## Contributors
- Jordan Bean