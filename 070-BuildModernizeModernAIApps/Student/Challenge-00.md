# Challenge 00 - Prerequisites - The Landing Before the Launch

## Introduction

CosmicWorks has big plans for their retail site, but they need to start somewhere; they need a landing zone in Azure for all of their services. It will take a while to prepare their e-Commerce site to migrate to Azure, but they're eager to launch a POC of a simple chat interface where users can interact with a virtual agent to find product and account information.

They've created a simple Blazor web application for the UI elements and have asked you to to incorporate the backend plumbing to do the following:

- Store the chat history in an Azure Cosmos DB database
  - They expect the following types of messages: Session (for the chat session), Message (the user and assistant message).
  - A message should have a sender (Assistant or User), tokens (that indicates how many tokens were used), text (the text from the assistant or the user), rating (thumbs up or down) and vector (the vector embedding of the user's text).
- Source the customer and product data from the Azure Cosmos DB database.
- Use Azure OpenAI service to create vector embeddings and chat completions.
- Use a Azure Cognitive Search to search for relevant product and account information by the vector embeddings.
- Encapsulate the orchestration of interactions with OpenAI behind a back-end web service.
- Create a storage account to externalize prompts that will be used by your assistant.

For this challenge, you will deploy the services into the landing zone in preparation for the launch of the POC.

## Common Prerequisites

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- Subscription access to Azure OpenAI service. Start here to [Request Access to Azure OpenAI Service](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR7en2Ais5pxKtso_Pz4b1_xUOFA5Qk1UWDRBMjg0WFhPMkIzTzhKQ1dWNyQlQCN0PWcu)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites that are specific to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Please install these additional tools:

- Visual Studio 2022 or later
- .NET 7 SDK or later. This can be downloaded from [here](https://www.microsoft.com/net/download/all) for multiple platforms
- Docker Desktop
- Helm v3.11.1 or greater - https://helm.sh/ (for AKS)

In the \`/Challenge00/\` folder of the Resources.zip file, you will find an ARM template, \`setupIoTEnvironment.json\` that sets up the initial hack environment in Azure you will work with in subsequent challenges.

Please deploy the template by running the following Azure CLI commands from the location of the template file:
\`\`\`
az group create --name myIoT-rg --location eastus
az group deployment create -g myIoT-rg --name HackEnvironment -f setupIoTEnvironment.json
\`\`\`

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a new Azure Cosmos DB workspace with the NoSQL API. It should have a database named `database` and containers named `completions` with a partition key of `/sessionId`, `customer` with a partition key of `/customerId`, `embedding` with a partition key of `/id`, `product` with a partition key of `/categoryId`, and `leases` with a partition key of `/id`.
- Verify that you have Azure OpenAI with the following deployments:
  - `completions` with the `gpt-35-turbo` model
  - `embeddings` with the `text-embedding-ada-002` model
- Verify that you have Azure Cognitive Search in the basic tier.
- Verify that the solution contains Azure Container Apps, an Azure Container Registry, and an Azure Storage Account.

## Learning Resources

- [Azure Cosmos DB](https://learn.microsoft.com/azure/cosmos-db/)
- [Azure OpenAI service](https://learn.microsoft.com/azure/cognitive-services/openai/overview)
- [Azure Cognitive Search](https://learn.microsoft.com/azure/search/)
- [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/start)

### Explore Further

- [Understanding embeddings](https://learn.microsoft.com/azure/cognitive-services/openai/concepts/understand-embeddings)
