# What The Hack - Traffic Control With Dapr - Coach Guide

## Introduction

Welcome to the coach's guide for the Traffic Control with Dapr What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 0: **[Install local tools and Azure prerequisites](Solution-00.md)**
  - Install the pre-requisites tools and software as well as create the Azure resources required.
- Challenge 1: **[Run the TrafficControl application](Solution-01.md)**
  - Run the Traffic Control application to make sure everything works correctly.
- Challenge 2: **[Dapr Service Invocation](Solution-02.md)**
  - Add Dapr into the mix, using the Dapr service invocation building block.
- Challenge 3: **[Dapr Pub/Sub Messaging](Solution-03.md)**
  - Add Dapr publish/subscribe messaging to send messages from the `TrafficControlService` to the `FineCollectionService`.
- Challenge 4: **[Dapr Pub/Sub Messaging](Solution-04.md)**
  - Add Dapr state management in the `TrafficControlService` to store vehicle information.
- Challenge 5: **[Dapr SMTP Output binding](Solution-05.md)**
  - Use a Dapr output binding in the `FineCollectionService` to send an email.
- Challenge 6: **[Dapr MQTT Input Binding](Solution-06.md)**
  - Add a Dapr input binding in the `TrafficControlService`. It'll receive entry- and exit-cam messages over the MQTT protocol.
- Challenge 7: **[Dapr Secrets Management](Solution-07.md)**
  - Add the Dapr secrets management building block.
- Challenge 8: **[Dapr-enabled Services running in Azure Kubernetes Service (AKS)](Solution-08.md)**
  - Deploy the Dapr-enabled services you have written locally to an Azure Kubernetes Service (AKS) cluster.

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

To start, you'll need access to an Azure Subscription & Resource Group.

You will need the following subcription [resource providers](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types) registered.

- Microsoft.Cache
- Microsoft.ContainerService
- Microsoft.ContainerRegistry
- Microsoft.Devices
- Microsoft.EventHub
- Microsoft.Insights
- Microsoft.KeyVault
- Microsoft.Logic
- Microsoft.OperationalInsights
- Microsoft.ServiceBus
- Microsoft.Storage
- Microsoft.Web

- If you already have an Azure account, make sure you have at least [Contributor access instructions](https://docs.microsoft.com/azure/role-based-access-control/check-access) for the resource group in which you'll provision Azure resources.

_Your IT organization may provide you access to an Azure resource group, but not the entire subscription. If that's the case, take note of that resource group name and make sure you have `Contributor` access to it, using the instructions mentioned above._

This hack's setup files will create the following resources in your Azure Resource Group. Make sure you can create the following:

- Application Insights
- Azure Cache for Redis
- Azure Container Registry
- Azure Kubernetes Service
- Event Hub Namespace
- IoT Hub
- Key Vault
- Log Analytics Workspace
- Logic App (with the Office 365 activity for sending email)
- Storage Account
- Service Bus Namespace

_If you can't instantiate some of these resources, you won't be able to complete the part of the challenge that uses them, but you may still be able to complete the other challenges_

#### Special Considerations for Azure Kubernetes Service (AKS)

- AKS requires the ability to create a public IP address. This may be blocked by some organizations. You will either need to get an exception or have an admin create the AKS cluster for you.
- The `Resources\Infrastructure\bicep\aks.bicep` file specifies the default values for the cluster that will work for this hack. Customize as needed.
  - 1 Agent Pool with 3 Linux VMs using the **Standard_DS2_v2** SKU.
  - 3 services using a total of `300m` of CPU & `300Mi` of memory by default, limited to a total of `3000m` of CPU & `600Mi` of memory.
  - 1 Zipkin service running to monitor communciation between the services.
- **WARNING:** For simplicity, a Kubernetes secret is used to allow AKS to pull images from the Azure Container Registry via the [admin account](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication?tabs=azure-cli#admin-account). **This is not a best practice**. In a production example, you should use a managed identity & RBAC.

**IMPORTANT:** You will need to register the AKS Dapr extension feature flags in your Azure subscription. Follow the instructions at the link provided below.

[Enable the Azure CLI Extension for Cluster Extensions](https://docs.dapr.io/developing-applications/integrations/azure/azure-kubernetes-service-extension/#enable-the-azure-cli-extension-for-cluster-extensions)

**IMPORTANT:** You will need to register the AKS Workload Identity extension feature flags in your Azure subscription. Follow the instructions at the links provided below.

1.  [Install the AKS Preview Azure CLI Extension](https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster#install-the-aks-preview-azure-cli-extension)
1.  [Register the enableworkloadidentitypreview feature flag](https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster#register-the-enableworkloadidentitypreview-feature-flag)
1.  [Register the enabledoidcissuepreview feature flag](https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster#register-the-enableoidcissuerpreview-feature-flag)

## Student Local Machine Requirements

Students will need to have the following tools installed locally on their machine to do the hack.

- Git ([download](https://git-scm.com/))
- .NET 6 SDK ([download](https://dotnet.microsoft.com/download/dotnet/6.0))
- Visual Studio Code ([download](https://code.visualstudio.com/download)) with the following extensions installed:
  - [C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)
  - [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)
- Docker for desktop ([download](https://www.docker.com/products/docker-desktop))
- Dapr CLI and Dapr runtime ([instructions](https://docs.dapr.io/getting-started/install-dapr-selfhost/))
- Install Azure CLI
  - Linux ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt))
  - macOS ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos))
  - Windows ([instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli))
- Install Bicep extension for VS Code ([instructions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep))
- If you're running Windows, you'll need to install a **bash shell** to run some of the commands. Install either the [Git Bash](https://git-scm.com/downloads) client or the [Windows Subsystem for Linux 2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
- Helm ([instructions](https://helm.sh/docs/intro/install/))

## Suggested Hack Agenda

- Day 1
  - Challenge 0 (30 minutes)
  - Challenge 1 (1 hour)
  - Challenge 2 (1 hour)
  - Challenge 3 (1 hour)
  - Challenge 4 (1 hour)
- Day 2
  - Challenge 5 (1 hour)
  - Challenge 6 (1 hour)
  - Challenge 7 (1 hour)
  - Challenge 8 (1 hour)

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
