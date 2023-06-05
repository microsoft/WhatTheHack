# Challenge 03 - Create Resources - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

None.

## Step by Step Instructions

### Help references

- [Creating a storage account (blob hot tier)](https://docs.microsoft.com/azure/storage/common/storage-create-storage-account?toc=%2fazure%2fstorage%2fblobs%2ftoc.json%23create-a-storage-account)
- [Creating a function app](https://docs.microsoft.com/azure/azure-functions/functions-create-function-app-portal)
- [Concepts in Event Grid](https://docs.microsoft.com/azure/event-grid/concepts)
- [Creating an Azure Cosmos DB account](https://docs.microsoft.com/azure/cosmos-db/manage-account

### Task 1: Provision the storage account

1.  Using a new tab or instance of your browser, navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then select **Storage**, **Storage account**.

3.  On the **Create storage account** blade, specify the following configuration options:

    a. For **Resource group**, select the **Use existing** radio button, and specify the **ServerlessArchitecture** resource group.

    b. **Name**: enter a unique value for the storage account such as **tollboothstorageINIT** (ensure the green check mark appears).

    c. Ensure the **Location** is the same region as the resource group.

    d. For performance, ensure **Standard** is selected.

    e. For account kind, select **Blobstorage**.

    f. Select the **Hot** access tier.

    g. For replication, select **Locally-redundant storage (LRS)**.

4.  Select **Review + create**, then select **Create**.

5.  After the storage account has completed provisioning, open the storage account by opening the **ServerlessArchitecture** resource group, and then selecting the **storage account** name.

6.  On the **Storage account** blade, select **Access Keys**, under Settings in the menu. Then on the **Access keys** blade, select the **Click to copy** button for **key1 connection string.**

7.  Paste the value into a text editor, such as Notepad, for later reference.

8.  Select **Blobs** under **Blob Service** in the menu. Then select the **+ Container** button to add a new container. In the **Name** field, enter **images**, select **Private (no anonymous access)** for the public access level, then select **OK** to save.

9.  Repeat these steps to create a container named **export**.


### Task 2: Provision the Function Apps

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then enter **function** into the search box on top. Select **Function App** from the results.

3.  Select the **Create** button on the **Function App overview** blade.

4.  On the **Create Function App** blade, specify the following configuration options:

    a. **Name**: Unique value for the App name (ensure the green check mark appears). Provide a name similar to **TollBoothFunctionApp**.

    b. Specify the Resource Group **ServerlessArchitecture**.

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

    a. **Name**: Unique value for the App name (ensure the green check mark appears). Provide a name similar to **TollBoothEvents**.

    b. Specify the Resource Group **ServerlessArchitecture**.

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

    a. **Name:** Unique value for the App name such as **TollboothEventGrid** (ensure the green check mark appears).

    b. Specify the Resource Group **ServerlessArchitecture**.

    c. Select the same **location** as your Resource Group.

    d. Leave the schema as **Event Grid Schema**.

5.  Select **Create**.

6.  After the Event Grid topic has completed provisioning, open the account by opening the **ServerlessArchitecture** resource group, and then selecting the **Event Grid** topic name.

7.  Select **Overview** in the menu, and then copy the **Topic Endpoint** value.

8.  Select **Access Keys** under Settings in the menu.

9.  Within the **Access Keys** blade, copy the **Key 1** value.

10. Paste the values into a text editor, such as Notepad, for later reference.

### Task 4: Provision the Azure Cosmos DB account

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, select **Databases** then select **Azure Cosmos DB**.

3.  On the **Create new Azure Cosmos DB** **account** blade, specify the following configuration options:

    a. Specify the Resource Group **ServerlessArchitecture**.

    a. For Account Name, type a unique value for the App name such as **ToolboothDB** (ensure the green check mark appears).

    b. Select the **Core (SQL)** API.

    d. Select the same **location** as your Resource Group if available. Otherwise, select the next closest **region**.

    e. Ensure **Disable geo-redundancy** is selected.

    f. Ensure **Disable multi-region writes** is selected.

4.  Select **Review + create**, then select **Create**

5.  After the Azure Cosmos DB account has completed provisioning, open the account by opening the **ServerlessArchitecture** resource group, and then selecting the **Azure Cosmos DB** account name.

6.  Select **+ Add Container** from the top toolbar

7.  On the **Add Container** blade, specify the following configuration options:

    a. Enter **LicensePlates** for the **Database id**.

    b. Leave **Provision database throughput** unchecked.

    c. Enter **Processed** for the **Collection id**.

    d. Partition key: **/licensePlateText**

    e. Throughput: **5000**

8)  Select **OK**.

9)  Select **New Container** to add another collection.

10) On the **Add Container** blade, specify the following configuration options:

    a. For Database id, choose **Use existing** and select **LicensePlates**.

    b. For Collection id, enter **NeedsManualReview**.

    c. Partition key: **/fileName**

    d. Throughput: **5000**

11) Select **OK**.

12) Select **Keys** under Settings in the menu.

13) Underneath the **Read-write Keys** tab within the Keys blade, copy the **URI** and **Primary Key** values.

14) Paste the values into a text editor, such as Notepad, for later reference.

