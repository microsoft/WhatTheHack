# Challenge 03 - Create Resources

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

You must provision a few resources in Azure before you start developing the solution. Ensure all resources use the same resource group for easier cleanup.  Put resources in the same region as the resource group.  Remember that some resources need to have unique names.

## Description

In this challenge, you will provision a blob storage account using the Hot tier, and create two containers within to store uploaded photos and exported CSV files. You will then provision two Function Apps instances, one you will deploy from Visual Studio, and the other you will manage using the Azure portal. Next, you will create a new Event Grid topic. After that, you will create an Azure Cosmos DB account with two collections. Then, you will provision a new Cognitive Services Computer Vision API service for applying object character recognition (OCR) on the license plates.  Lastly, you will implement Key Vault for secure some of the resource keys.

**HINT:** _Record names and keys_

1. Create a resource group
1. Create an Azure Cosmos DB account
*If this takes a while, move ahead and come back to finish the containers*
    * API : Core (SQL)
    * Disable Geo-redundency and multi-region writes
    * Create a container
      * Database ID &quot;LicensePlates&quot;
      * Uncheck **Provision database throughput**
      * Container ID &quot;Processed&quot;
      * Partition key **: &quot;**/licensePlateText&quot;
    * Create a second container
      * Database ID created above &quot;LicensePlates&quot;
      * Container ID &quot;NeedsManualReview&quot;
      * Partition key **: &quot;**/fileName&quot;
1. Create a storage account (refer to this one as INIT)
    * Create a container &quot;images&quot;
    * Create a container &quot;export&quot;
1. Create a function app (put &quot;App&quot; in the name)
    * For your tollbooth app, consumption plan, .NET runtime stack
    * Create new storage and disable application insights
1. Create a function app (put &quot;Events&quot; in the name)
    * For your tollbooth events, consumption plan, Node.js runtime stack
    * Create new storage and disable application insights
1. Create an Event Grid Topic (leave schema as Event Grid Schema)
1. Create a Computer Vision API service (S1 pricing tier)
1. Create a Key Vault
    * Pricing Tier : Standard
    * Create Secrets According to below
1. Configure your Tollbooth app to use KeyVault for secrets

    |                          |                                                                                                                                                             |
    | ------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------: |
    | **Name**      |                                                                          **Value**                                                                          |
    | computerVisionApiKey     |                                                                   Computer Vision API key                                                                   |
    | eventGridTopicKey        |                                                                 Event Grid Topic access key                                                                 |
    | cosmosDBAuthorizationKey |                                                                    Cosmos DB Primary Key                                                                    |
    | blobStorageConnection    |                                                               Blob storage connection string                                                                |



## Success Criteria

1. You have 11 resources in your resource group in the same region (Includes the 2 storage accounts associated to your function apps)

## Learning Resources

- [Creating a storage account (blob hot tier)](https://docs.microsoft.com/azure/storage/common/storage-create-storage-account?toc=%2fazure%2fstorage%2fblobs%2ftoc.json%23create-a-storage-account)
- [Creating a function app](https://docs.microsoft.com/azure/azure-functions/functions-create-function-app-portal)
- [Concepts in Event Grid](https://docs.microsoft.com/azure/event-grid/concepts)
- [Creating an Azure Cosmos DB account](https://docs.microsoft.com/azure/cosmos-db/manage-account)
- [Key Vault Secret Identifiers](https://docs.microsoft.com/azure/key-vault/about-keys-secrets-and-certificates)
- [Configure Azure Functions and KeyVault to work together](https://docs.microsoft.com/azure/app-service/app-service-key-vault-references?tabs=azure-cli#granting-your-app-access-to-key-vault)