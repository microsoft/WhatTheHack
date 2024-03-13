# Challenge 03 - Create Resources

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

You must provision a few resources in Azure before you start developing the solution. Ensure all resources use the same resource group for easier cleanup.  Put resources in the same region as the resource group.  Remember that some resources need to have unique names.

## Description

In this challenge, you will provision a blob storage account using the Hot tier, and create two containers within to store uploaded photos and exported CSV files. You will then provision two Function Apps instances, one you will deploy from Visual Studio, and the other you will manage using the Azure portal. Next, you will create a new Event Grid topic. After that, you will create an Azure Cosmos DB account with two collections. Then, you will provision a new Cognitive Services Computer Vision API service for applying object character recognition (OCR) on the license plates.  Lastly, you will implement Key Vault for secure some of the resource keys.

**HINT:** _Record names and keys_

Create the resources in Azure according the following specifications:

- Create a resource group
- Create an Azure Cosmos DB account
*If this takes a while, move ahead and come back to finish the containers*
    * API : Core (SQL)
    * Disable Geo-redundancy and multi-region writes
    * Create a container
      * Database ID `LicensePlates`
      * Uncheck **Provision database throughput**
      * Container ID `Processed`
      * Partition key : **`/licensePlateText`**
    * Create a second container
      * Database ID created above `LicensePlates`
      * Container ID `NeedsManualReview`
      * Partition key : **`/fileName`**
- Create a storage account (refer to this one as INIT)
    * Create a container `images`
    * Create a container `export`
- Create a function app (put `App` in the name)
    * For your tollbooth app, consumption plan, .NET runtime stack
    * Create new storage and disable application insights
- Create a function app (put `Events` in the name)
    * For your tollbooth events, consumption plan, Node.js runtime stack
    * Create new storage and disable application insights
- Create an Event Grid Topic (leave schema as Event Grid Schema)
- Create a Computer Vision API service (S1 pricing tier), nowadays called Azure AI Vision
- Create a Key Vault
    * Pricing Tier : Standard
    * Create Secrets According to below
    |                          |                                                                                                                                                             |
    | ------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------: |
    | **Secret Name**      |                                                                          **Value**                                                                          |
    | `computerVisionApiKey`     |                                                                   Computer Vision API key                                                                   |
    | `eventGridTopicKey`        |                                                                 Event Grid Topic access key                                                                 |
    | `cosmosDBAuthorizationKey` |                                                                    Cosmos DB Primary Key                                                                    |
    | `cosmosDBConnectionString` |                                                                    Cosmos DB Primary Connection String                                                                 |
    | `blobStorageConnection`    |                                                               Blob storage connection string                                                                |

- Configure the RBAC role "KeyVault Administrator" for yourself, to read and write secrets via the portal, which is a more privileged role than the "KeyVault Secrets User" role that the functions will use to just read secrets using a Managed Identity.


## Success Criteria

1. Validate that you have 11 resources in your resource group in the same region (This includes the 2 storage accounts associated to your function apps). If you enabled Application Insights on any of your functions, it's OK, we'll change it later.
2. Ensure you have permissions to read/write the Key Vault Secrets using the Portal

## Learning Resources

- [Creating a storage account (blob hot tier)](https://docs.microsoft.com/azure/storage/common/storage-create-storage-account?toc=%2fazure%2fstorage%2fblobs%2ftoc.json%23create-a-storage-account)
- [Creating a function app](https://docs.microsoft.com/azure/azure-functions/functions-create-function-app-portal)
- [Concepts in Event Grid](https://docs.microsoft.com/azure/event-grid/concepts)
- [Creating an Azure Cosmos DB account](https://docs.microsoft.com/azure/cosmos-db/manage-account)
- [Key Vault Secret Identifiers](https://docs.microsoft.com/azure/key-vault/about-keys-secrets-and-certificates)
- [Configure Azure Functions and KeyVault to work together](https://docs.microsoft.com/azure/app-service/app-service-key-vault-references?tabs=azure-cli#granting-your-app-access-to-key-vault)
- [Key Vault roles for RBAC](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations)
- [Azure Computer Vision API, aka Azure AI Vision](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/overview#getting-started)