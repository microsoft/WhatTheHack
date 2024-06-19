# Challenge 03 - Create Resources - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

See the bottom of this page for instructions on generating a CLI script using Copilot or ChatGPT.

## Challenge 03 Accelerator

By default, Challenge 03 involves having the students doing a lot of discovery by navigating the Azure Portal to deploy all of the PaaS resources that make up the TollBooth application's Serverless architecture.  This is a worthy challenge, but can be time consuming.

If the organization you are delivering this hack to has limited time, you may wish to "accelerate" students through this challenge by providing them with an automation script & bicep template that pre-deploys all of the Azure resources required by Challenge 3.

There is a "hidden" Challenge 03 Accelerator page in the Student guide. You can point students at this page by having them add an "A" to the end of the Challenge 03 link in the Student Guide:
- `https://microsoft.github.io/WhatTheHack/015-Serverless/Student/Challenge-03A.html`

This page has abbreviated challenge tasks that include having the students:
- Figure out how to view the secrets in Key Vault
- Identify how the Function Apps have access to the Key Vault
- Validate there are values in each of the Key Vault secrets

To use the Challenge 03 Accelerator when delivering the hack, you have two options:
1. Provide the automation script to the students for them to run on their own.
2. Provide the automation script to an Azure Lab provider (like [Spektra Systems](https://spektrasystems.com/)) and have the lab provider pre-deploy it to lab environments ahead of the hack.

Whether you provide the automation script to the students or a lab provider, you can use the following instructions to deploy it:

1. Navigate to the [`/Coach/Solutions/Challenge-03-Accelerator`](Solutions/Challenge-03-Accelerator) folder in this repo.
2. Download the `deployAzureResources.sh` & `main.bicep` files to your local workstation and ensure they are both in the same folder.
    - **NOTE:** If you are providing the script & bicep template to the students, you should package them to a ZIP file and distribute directly to the students.  You should NOT direct students to the What The Hack repo link here in the Coach Guide!
4. Open a Terminal/WSL with Bash shell to the folder where you downloaded the files.
5. Make the `deployAzureResources.sh` file executable with the following command: `chmod +x deployAzureResources.sh`
6. Log into the Azure CLI: `az login`
7. Run the deployment script: `./deployAzureResources.sh`

While the script is running, you can monitor its progress in the Azure Portal by navigating to the Resource Group `wth-serverless-rg` and checking the `Deployments` pane.

**NOTE:** If you plan to deploy these resources to different resource groups in a shared subscription, you must modify the `RGName` value in the `deployAzureResources.sh` script for each deployment so you don't collide on the same Resource Group.

## Step by Step Instructions

If you wish to deploy the resources manually and stay ahead of the students, you can follow the step-by-step instructions here, along with some references to the documentation that explains further details.

### Help references

- [Creating a storage account (blob hot tier)](https://docs.microsoft.com/azure/storage/common/storage-create-storage-account?toc=%2fazure%2fstorage%2fblobs%2ftoc.json%23create-a-storage-account)
- [Creating a function app](https://docs.microsoft.com/azure/azure-functions/functions-create-function-app-portal)
- [Concepts in Event Grid](https://docs.microsoft.com/azure/event-grid/concepts)
- [Creating an Azure Cosmos DB account](https://docs.microsoft.com/azure/cosmos-db/manage-account

### Task 1: Provision the storage account

1.  Using a new tab or instance of your browser, navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then select **Storage**, **Storage account**.

3.  On the **Create storage account** blade, specify the following configuration options:

    a. For **Resource group**, select the **Use existing** radio button, and specify the **`ServerlessArchitecture`** resource group.

    b. **Name**: enter a unique value for the storage account such as **`tollboothstorageINIT`** (ensure the green check mark appears).

    c. Ensure the **Location** is the same region as the resource group.

    d. For performance, ensure **Standard** is selected.

    e. For account kind, select **Blob Storage**.

    f. Select the **Hot** access tier.

    g. For replication, select **Locally-redundant storage (LRS)**.

4.  Select **Review + create**, then select **Create**.

5.  After the storage account has completed provisioning, open the storage account by opening the **`ServerlessArchitecture`** resource group, and then selecting the **storage account** name.

6.  On the **Storage account** blade, select **Access Keys**, under Settings in the menu. Then on the **Access keys** blade, select the **Click to copy** button for **key1 connection string.**

7.  Paste the value into a text editor, such as Notepad, for later reference.

8.  Select **Blobs** under **Blob Service** in the menu. Then select the **+ Container** button to add a new container. In the **Name** field, enter **images**, select **Private (no anonymous access)** for the public access level, then select **OK** to save.

9.  Repeat these steps to create a container named **export**.


### Task 2: Provision the Function Apps

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then enter **function** into the search box on top. Select **Function App** from the results.

3.  Select the **Create** button on the **Function App overview** blade.

4.  On the **Create Function App** blade, specify the following configuration options:

    a. **Name**: Unique value for the App name (ensure the green check mark appears). Provide a name similar to **`TollBoothFunctionApp`**.

    b. Specify the Resource Group **`ServerlessArchitecture`**.

    c. For Runtime stack, select **.NET Core**.

    d. Leave the default for Version 

    e. Select the same **Region** as your Resource Group.

    f. Click **Next: Hosting** 
    
    g. Leave the **storage** option as **create new**.

    h. For Plan Type, select **Consumption (Serverless))**.

    i. Click **Next: Monitoring**
    
    j. Set **Enable Application Insights** radio button to No (we'll add this later).

5.  Select **Create**.

6.  **Repeat steps 2-4** to create a second Function App.

7.  On the **Create Function App** blade, specify the following configuration options:

    a. **Name**: Unique value for the App name (ensure the green check mark appears). Provide a name similar to **`TollBoothEvents`**.

    b. Specify the Resource Group **`ServerlessArchitecture`**.

    c. For Runtime stack, select **Node.js**.

    d. Leave the default for Version 

    e. Select the same **Region** as your Resource Group.

    f. Click **Next: Hosting** 
    
    g. Leave the **storage** option as **create new**.

    h. For Plan Type, select **Consumption (Serverless)**.

    i. Click **Next: Monitoring**
    
    j. Set **Enable Application Insights** radio button to No (we'll add this later).

8.  Select **Create**.


### Task 3: Provision the Event Grid topic

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then enter **event grid** into the search box on top. Select **Event Grid Topic** from the results.

3.  Select the **Create** button on the **Event Grid Topic overview** blade.

4.  On the **Create Topic** blade, specify the following configuration options:

    a. **Name:** Unique value for the App name such as **`TollboothEventGrid`** (ensure the green check mark appears).

    b. Specify the Resource Group **`ServerlessArchitecture`**.

    c. Select the same **location** as your Resource Group.

    d. Leave the schema as **Event Grid Schema**.

5.  Select **Create**.

6.  After the Event Grid topic has completed provisioning, open the account by opening the **`ServerlessArchitecture`** resource group, and then selecting the **Event Grid** topic name.

7.  Select **Overview** in the menu, and then copy the **Topic Endpoint** value.

8.  Select **Access Keys** under Settings in the menu.

9.  Within the **Access Keys** blade, copy the **Key 1** value.

10. Paste the values into a text editor, such as Notepad, for later reference.

### Task 4: Provision the Azure Cosmos DB account

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, select **Databases** then select **Azure Cosmos DB**.

3.  On the **Create new Azure Cosmos DB** **account** blade, specify the following configuration options:

    a. Specify the Resource Group **`ServerlessArchitecture`**.

    a. For Account Name, type a unique value for the App name such as **`TollBoothDB`** (ensure the green check mark appears).

    b. Select the **Core (SQL)** API.

    d. Select the same **location** as your Resource Group if available. Otherwise, select the next closest **region**.

    e. Ensure **Disable geo-redundancy** is selected.

    f. Ensure **Disable multi-region writes** is selected.

4.  Select **Review + create**, then select **Create**

5.  After the Azure Cosmos DB account has completed provisioning, open the account by opening the **`ServerlessArchitecture`** resource group, and then selecting the **Azure Cosmos DB** account name.

6.  Select **+ Add Container** from the top toolbar

7.  On the **Add Container** blade, specify the following configuration options:

    a. Enter **`LicensePlates`** for the **Database id**.

    b. Leave **Provision database throughput** unchecked.

    c. Enter **Processed** for the **Collection id**.

    d. Partition key: **`/licensePlateText`**

    e. Throughput: **500**

8)  Select **OK**.

9)  Select **New Container** to add another collection.

10) On the **Add Container** blade, specify the following configuration options:

    a. For Database id, choose **Use existing** and select **`LicensePlates`**.

    b. For Collection id, enter **`NeedsManualReview`**.

    c. Partition key: **`/fileName`**

    d. Throughput: **500**

11) Select **OK**.

12) Select **Keys** under Settings in the menu.

13) Underneath the **Read-write Keys** tab within the Keys blade, copy the **URI** and **Primary Key** values.

14) Paste the values into a text editor, such as Notepad, for later reference.

### Task 5: Create the Cognitive Services API

Look in the portal for Azure AI services, then Computer vision. Select S1 pricing, leave all other options as default. Learn more in the [Azure AI Vision doc page](https://learn.microsoft.com/en-gb/azure/ai-services/computer-vision/)

### Task 6: Create the Keyvault secrets

Create a KeyVault with RBAC permission model (from the Access Configuration menu), everything else by default. Add yourself as KeyVault administrator from the Access Control (IAM) menu. If soft-delete is enabled, that keyvault won't be removed when deleted, so that name cannot be used again (this may affect those Coaches using the CLI for a 2nd time) until manually purged.

Here's a table with example values for the secrets, redacted (to ensure the right syntax). 
**NOTE FOR LINUX/WSL USERS**: If there's a \r or \n in the value, weird things will happen in the code. Ensure you just copy&paste the values from the portal.

| **Secret** | **Value** |
| --- | --- |
| `blobStorageConnection` | `DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=wthserverless2014xxz;AccountKey=xxxxxxxxxxxxxxxxxxxxxxxxxxxqeyH6w==;BlobEndpoint=https://wthserverless2014xxz.blob.core.windows.net/;FileEndpoint=https://wthserverless2014xxz.file.core.windows.net/;QueueEndpoint=https://wthserverless2014xxz.queue.core.windows.net/;TableEndpoint=https://wthserverless2014xxz.table.core.windows.net/` |
| `computerVisionApiKey` | `cXxxxxxxxxxxxxxxxxxxxxx0b` |
| `cosmosDBAuthorizationKey` | `vxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxQQ==` |
| `cosmosDBConnectionString` | `AccountEndpoint=https://wth-serverless-cosmosdbxx.documents.azure.com:443/;AccountKey=vxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxQ==;` |
| `eventGridTopicKey` | `Pxxxxxxxxxxxxxxxxxxxxx8=` |

## Copilot prompt for Azure CLI

**NOTE:** If you'd like, you can try using the Copilot prompt below to generate an Azure CLI script that can deploy the resources as described above. Your results may vary and you should check any generated script to validate it would do what is specified above.

Using Microsoft Copilot, ask in Precise mode: 
```
Give me the Azure CLI commands to execute the following actions. Use variables for all the parameters:  

- Create a resource group  

- Create an Azure Cosmos DB account with the following characteristics: API type Core (SQL), Disable Geo-redundency and multi-region writes.  

- Create an Azure Cosmos DB SQL database with Database Name `LicensePlates` .  

- Create a container inside the Cosmos DB account, in the Database `LicensePlates` (do not provision database throughput) and Container ID "Processed", Partition key : "`/licensePlateText`"  

- Create a similar second container, Database `LicensePlates`, Container ID "NeedsManualReview", Partition key : "/fileName"  

- Create a storage account, name INIT, Create two blob containers "images" and "export"  

- Create an Event Grid Topic (leave schema as Event Grid Schema)  

- Create a Computer Vision API service (S1 pricing tier)  

- Create a Key Vault, Pricing Tier Standard 

Get the Computer Vision Api Key and put it in a variable named computerVisionApiKey  

Get the eventGrid Topic Key and put it in a variable named eventGridTopicKey  

Get the CosmosDB Authorization Key and put it in a variable named cosmosDBAuthorizationKey 

Get the blob Storage Connection string to the storage account and put it in a variable named Connection 

Create 4 secrets with their respective values: computerVisionApiKey , eventGridTopicKey , cosmosDBAuthorizationKey ,blobStorageConnection. 
```
(IMPORTANT: you still have to configure the RBAC for the Function to be able to read from the Key Vault using a Managed Identity)



