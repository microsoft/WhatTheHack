# What The Hack - Migrating Applications To The Cloud
## Introduction
This intro level hack will run us through a migration and modernization path from On Prem to IaaS to PaaS.

The story goes that, Tailwind Traders acquired Northwind Traders earlier this year, they wanted to be sure that they could access their inventory in real time, which meant moving their existing web API alongside ours on Microsoft Azure.   Besides moving the local web aps and API's to Azure there is a need to move the On-Premise MongoDB and SQL Server to the cloud as well.

This hack includes presentations that feature lectures introducing key topics associated with each challenge. It is recommended that the host present each lecture before attendees kick off that challenge.

## Learning Objectives
In this hack you will solve common challenges for companies migrating to the cloud. 

1. Migrating to the cloud.
1. Containerizing an application.
1. Serverless-izing your application.
1. DevOps-ing your application.

## Challenges
- Challenge 1: **[Learning Azure](Student/Challenge-01.md)**
   - Get familiar with the Azure environment, portal and command line.
- Challenge 2: **[Migrating to the Cloud](Student/Challenge-02.md)**
   - Take an existing web application and move it from a standard deployment using on premises web farms to a container infrastructure on Azure. 
- Challenge 3: **[DevOps and Containers](Student/Challenge-03.md)**
   - Build custom Docker images using Azure DevOps, push and store images in a private repository and deploy and run the images inside the Docker containers.
   
## Prerequisites
- Access to an Azure subscription with Owner access
   - If you don't have one, [Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)
- [**Windows Subsystem for Linux (Windows 10-only)**](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - (Windows-only) Install Azure CLI on Windows Subsystem for Linux
   - Update to the latest
   - Must be at least version 2.7.x
- Alternatively, you can use the [**Azure Cloud Shell**](https://shell.azure.com/)
- [**Visual Studio Code**](https://code.visualstudio.com/)

## Repository Contents
- `../Coach/Presentations`
  - Containers all presentations listed in the Introduction above.
- `../Coach/setupfiles`
   - Example solutions to the challenges (If you're a student, don't cheat yourself out of an education!)
- `../Student/Resources/src`
   - Node.js application src code
- `../Student/images`
   - Images for documentation

## Contributors
- Ryan Berry