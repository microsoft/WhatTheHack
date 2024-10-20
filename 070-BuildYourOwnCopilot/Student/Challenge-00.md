# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Build Modern AI Apps What The Hack. Over the next series of challenges you'll provision Azure resources, populate your Azure Cosmos DB database with initial data, create a vector index for the data, use Azure OpenAI models to ask questions about the data, and write some code. But before we get started, let's make sure we've got everything setup.

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

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Windows Subsystem for Linux](../../000-HowToHack/WTH-Common-Prerequisites.md#windows-subsystem-for-linux)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
- [Azure Storage Explorer](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specifc to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Please enable Azure OpenAI for your Azure subscription and install these additional tools:

- Enable subscription access to Azure OpenAI service. Start here to [Request Access to Azure OpenAI Service](https://aka.ms/oaiapply)
- .NET 8 SDK
- Docker Desktop
- Azure CLI ([v2.51.0 or greater](https://docs.microsoft.com/cli/azure/install-azure-cli))
- Cross-platform (not Windows) PowerShell ([7.0 or greater](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell))
- [Helm 3.11.1 or greater](https://helm.sh/docs/intro/install/) (for AKS deployment)
- Visual Studio 2022

> [!NOTE]
>  Free Azure Trial does not have sufficient quota for Azure OpenAI to run this hackathon successfully and cannot be used.

> [!NOTE]
> Installation requires the choice of an Azure Region. Make sure to set region you select which is used in the `<location>` value below supports Azure OpenAI services. See [Azure OpenAI service regions](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/?products=cognitive-services&regions=all) for more information.

> [!NOTE]
> This hackathon requires quota for Azure OpenAI models. To avoid capacity or quota issues, it is recommended before arriving for the hackathon, you deploy both `GPT-4o` and `text-embedding-3-large` models with **at least 100K token capacity** into the subscription you will use for this hackathon. You may delete these models after creating them. This step is to ensure your subscription has sufficient capacity. If it does not, see [How to increase Azure OpenAI quotas and limits](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits#how-to-request-increases-to-the-default-quotas-and-limits)

## Deployment steps

Follow the steps below to deploy the solution to your Azure subscription.

1. Ensure all the prerequisites are installed.  Check to make sure you have the `Owner` role for the subscription assigned to your account.

2. Clone the repository:

    ```cmd
    git clone https://github.com/Azure/BuildYourOwnCopilot.git
    ```

3. Switch to the `main` branch:

    ```cmd
    cd BuildYourOwnCopilot
    git checkout main
    ```

    > [!IMPORTANT]
    > **Before continuing**, make sure have enough Tokens Per Minute (TPM) in thousands quota available in your subscription. By default, the script will attempt to set a value of 120K for each deployment. In case you need to change this value, you can edit the `params.deployments.sku.capacity` values (lines 131 and 142 in the `infra\aca\infra\main.bicep` file for **ACA** deployments, or lines 141 and 152 in the `infra\aks\infra\main.bicep` file for **AKS** deployments).

4. Run the following script to provision the infrastructure and deploy the API and frontend. This will provision all of the required infrastructure, deploy the API and web app services into Azure Container Apps and import data into Azure Cosmos DB.

    This script will deploy all services including a new Azure OpenAI account using Azure Container Apps. (This can be a good option for users not familiar with AKS)

    ```pwsh
    cd ./infra/aca
    azd up
    ```

    You will be prompted for the target subscription, location, and desired environment name. The target resource group will be `rg-` followed by the environment name (i.e. `rg-my-aca-deploy`)

    To validate the deployment to ACA run the following script:

    > ```pwsh
    >  az containerapp show -n <aca-name> -g <resource-group-name>
    >  ```

    After running `azd up` on the **ACA** deployment and the deployment finishes, you can locate the URL of the web application by navigating to the deployed resource group in the Azure portal. Click on the link to the new resource group in the output of the script to open the Azure portal.
    
    ![The terminal output aafter azd up completes shows the resource group link.](media/azd-aca-complete-output.png)
    
    In the resource group, you will see the `ca-search-xxxx` Azure Container Apps service.
    
    ![The Search Azure Container App is highlighted in the resource group.](media/search-container-app-resource-group.png)
    
    Select the service to open it, then select the `Application Url` to open the web application in your browser.
    
    ![The Application Url is highlighted in the Search Azure Container App overview blade.](media/search-container-app-url.png)

> [!IMPORTANT]
> If you encounter any errors during the deployment, rerun `azd up` to continue the deployment from where it left off. This will not create duplicate resources, and tends to resolve most issues.

## Deployment validation

Use the steps below to validate that the solution was deployed successfully.

Once the deployment script completes, the Application Insights `traces` query should display the following sequence of events:

![API initialization sequence of events](media/initialization-trace.png)

Next, you should be able to see multiple entries referring to the vectorization of the data that was imported into Cosmos DB:

![API vectorization sequence of events](media/initialization-embedding.png)

Finally, you should be able to see the Azure Cosmos DB vector store collection being populated with the vectorized data:

![Cosmos DB vector store collection populated with vectorized data](media/initialization-vector-index.png)

> **NOTE**:
>
> It takes several minutes until all imported data is vectorized and indexed.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that all services have been deployed successfully.
- Verify that you have a new Azure Cosmos DB workspace with the NoSQL API. It should have a database named `database` and containers named `completions` with a partition key of `/sessionId`, `customer` with a partition key of `/customerId`, `embedding` with a partition key of `/id`, `product` with a partition key of `/categoryId`, and `leases` with a partition key of `/id`.
