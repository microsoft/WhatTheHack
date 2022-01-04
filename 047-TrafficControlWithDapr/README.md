# What The Hack - TrafficControlWithDapr

## Introduction
This repository contains several hands-on challenges that will introduce you to [Dapr](https://dapr.io/). You will start with a simple ASP.NET Core application that is composed of several microservices. In each challenge, you'll enhance the application by adding Dapr building blocks and components. At the same time, you'll configure the application to consume Azure-based backing services. When complete, you'll have implemented the following Dapr building blocks:

- Service invocation
- State-management
- Publish / Subscribe
- Bindings
- Secrets management

As Dapr can run on a variety of hosts, you'll start by running Dapr in self-hosted mode on your computer. Then, you'll deploy the Dapr application to run in Azure Kubernetes Service.

## Learning Objectives

The challenges implement a traffic-control camera system that are commonly found on Dutch highways. Here's how the simulation works:

![Speeding cameras](images/speed-trap-overview.png)

There's 1 entry-camera and 1 exit-camera per lane. When a car passes an entry-camera, a photo of the license plate is taken and the car and the timestamp is registered.

When the car passes an exit-camera, another photo and timestamp are registered. The system then calculates the average speed of the car based on the entry- and exit-timestamp. If a speeding violation is detected, a message is sent to the Central Fine Collection Agency (or CJIB in Dutch). The system retrieves the vehicle information and the vehicle owner is sent a notice for a fine.

## Challenges
- Challenge 0: **[Install tools and Azure pre-requisites](Student/Challenge-00.md)**
   - Install the pre-requisites tools and software as well as create the Azure resources required.
- Challenge 1: **[Run the application](Student/Challenge-01.md)**
   - Run the Traffic Control application to make sure everything works correctly.
- Challenge 2: **[Add Dapr service invocation](Student/Challenge-02.md)**
   - Add Dapr into the mix, using the Dapr service invocation building block.
- Challenge 3: **[Add pub/sub messaging](Student/Challenge-03.md)**
   - Add Dapr publish/subscribe messaging to send messages from the `TrafficControlService` to the `FineCollectionService`.
- Challenge 4: **[Add Dapr state management](Student/Challenge-04.md)**
   - Add Dapr state management in the `TrafficControlService` to store vehicle information.
- Challenge 5: **[Add a Dapr output binding](Student/Challenge-05.md)**
   - Use a Dapr output binding in the `FineCollectionService` to send an email.
- Challenge 6: **[Add a Dapr input binding](Student/Challenge-06.md)**
   - Add a Dapr input binding in the `TrafficControlService`. It'll receive entry- and exit-cam messages over the MQTT protocol.
- Challenge 7: **[Add secrets management](Student/Challenge-07.md)**
   - Add the Dapr secrets management building block.
- Challenge 8: **[Deploy to Azure Kubernetes Service (AKS)](Student/Challenge-08.md)**
   - Deploy the Dapr-enabled services you have written locally to an Azure Kubernetes Service (AKS) cluster.

## Prerequisites
- Git ([download](https://git-scm.com/))
- .NET 5 SDK ([download](https://dotnet.microsoft.com/download/dotnet/5.0))
- Visual Studio Code ([download](https://code.visualstudio.com/download)) with the following extensions installed:
  - [C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)
  - [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)
- Docker for desktop ([download](https://www.docker.com/products/docker-desktop))
- Dapr CLI and Dapr runtime ([instructions](https://docs.dapr.io/getting-started/install-dapr-selfhost/))
- Install Azure CLI
  - Linux ([instructions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#linux))
  - macOS ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos))
  - Windows ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli))
- Install Bicep extension for VS Code ([instructions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep))   
- If you're running Windows, you'll need to install a **bash shell** to run some of the commands. Install either the [Git Bash](https://git-scm.com/downloads) client or the [Windows Subsystem for Linux 2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

## Repository Contents
- `./Coach/Guides`
  - Coach's Guide and related files
- `./Student/Guides`
  - Student's Challenge Guide

## Contributors
- Jordan Bean
- Eldon Gormsen
- Sander Molenkamp
- Scott Rutz
- Marcelo Silva
- Rob Vettor
- Edwin van Wijk
- Chandrasekar B
