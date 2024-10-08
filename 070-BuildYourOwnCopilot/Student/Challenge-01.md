# Challenge 01 - The Landing Before the Launch

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

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

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites that are specific to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

You have two deployment options: AKS and Azure Container Apps. You can choose either one, but you should have the tools installed for both. Which one you choose will depend on your familiarity with the tools and your team's preference.

> [!IMPORTANT]
> **Before continuing**, make sure have enough Tokens Per Minute (TPM) in thousands quota available in your subscription. By default, the script will attempt to set a value of 120K for each deployment. In case you need to change this value, you can edit the `params.deployments.sku.capacity` values (lines 131 and 142 in the `infra\aca\infra\main.bicep` file for **ACA** deployments, or lines 141 and 152 in the `infra\aks\infra\main.bicep` file for **AKS** deployments).

Run the following script to provision the infrastructure and deploy the API and frontend. This will provision all of the required infrastructure, deploy the API and web app services into your choice of Azure Kubeternetes Service or Azure Container Apps, and import data into Azure Cosmos DB.

### Deploy with Azure Kubernetes Service

This script will deploy all services including a new Azure OpenAI account and AKS

```pwsh
cd ./infra/aks
azd up
```

You will be prompted for the target subscription, location, and desired environment name.  The target resource group will be `rg-` followed by the environment name (i.e. `rg-my-aks-deploy`)

To validate the deployment using AKS run the following script. When the script it complete it will also output this value. You can simply click on it to launch the app.

> ```pwsh
>  az aks show -n <aks-name> -g <resource-group-name> -o tsv --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName
>  ```

After running `azd up` and the deployment finishes, you will see the output of the script which will include the URL of the web application. You can click on this URL to open the web application in your browser. The URL is beneath the "Done: Deploying service web" message, and is the second endpoint (the Ingress endpoint of type `LoadBalancer`).

![The terminal output after azd up completes shows the endpoint links.](../media/azd-aks-complete-output.png)

If you closed the window and need to find the external IP address of the service, you can open the Azure portal, navigate to the resource group you deployed the solution to, and open the AKS service. In the AKS service, navigate to the `Services and Ingress` blade, and you will see the external IP address of the LoadBalancer service, named `nginx`:

![The external IP address of the LoadBalancer service is shown in the Services and Ingress blade of the AKS service.](../media/aks-external-ip.png)

### Deploy with Azure Container Apps

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

![The terminal output aafter azd up completes shows the resource group link.](../media/azd-aca-complete-output.png)

In the resource group, you will see the `ca-search-xxxx` Azure Container Apps service.

![The Search Azure Container App is highlighted in the resource group.](../media/search-container-app-resource-group.png)

Select the service to open it, then select the `Application Url` to open the web application in your browser.

![The Application Url is highlighted in the Search Azure Container App overview blade.](../media/search-container-app-url.png)

> [!IMPORTANT]
> If you encounter any errors during the deployment, rerun `azd up` to continue the deployment from where it left off. This will not create duplicate resources, and tends to resolve most issues.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a new Azure Cosmos DB workspace with the NoSQL API. It should have a database named `database` and containers named `completions` with a partition key of `/sessionId`, `customer` with a partition key of `/customerId`, `embedding` with a partition key of `/id`, `product` with a partition key of `/categoryId`, and `leases` with a partition key of `/id`.
- Verify that you have Azure OpenAI with the following deployments:
  - `completions` with the `gpt-35-turbo` model
  - `embeddings` with the `text-embedding-ada-002` model
- Verify that you have Azure Cognitive Search in the basic tier.
- Verify that the solution contains Azure Container Apps, an Azure Container Registry, and an Azure Storage Account.
- Verify that the `product` and `customer` containers contain data.

## Learning Resources

- [Azure Cosmos DB](https://learn.microsoft.com/azure/cosmos-db/)
- [Azure OpenAI service](https://learn.microsoft.com/azure/cognitive-services/openai/overview)
- [Azure Cognitive Search](https://learn.microsoft.com/azure/search/)
- [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/start)

### Explore Further

- [Understanding embeddings](https://learn.microsoft.com/azure/cognitive-services/openai/concepts/understand-embeddings)
