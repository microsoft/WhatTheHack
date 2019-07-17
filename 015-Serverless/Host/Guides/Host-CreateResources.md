# Challenge 2 - Create Resources


### Help references

|                                            |                                                                                                                                                       |
| ------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------: |
| **Description**                            |                                                                       **Links**                                                                       |
| Creating a storage account (blob hot tier) | <https://docs.microsoft.com/azure/storage/common/storage-create-storage-account?toc=%2fazure%2fstorage%2fblobs%2ftoc.json%23create-a-storage-account> |
| Creating a function app                    |                                <https://docs.microsoft.com/azure/azure-functions/functions-create-function-app-portal>                                |
| Concepts in Event Grid                     |                                                <https://docs.microsoft.com/azure/event-grid/concepts>                                                 |
| Creating an Azure Cosmos DB account        |                                              <https://docs.microsoft.com/azure/cosmos-db/manage-account>                                              |

### Task 1: Provision the storage account

1.  Using a new tab or instance of your browser, navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then select **Storage**, **Storage account**.


    ![In the menu pane of Azure Portal, Create a resource is selected. Under Azure Marketplace, Storage is selected, and under Featured, Storage account - blob, file, table, queue is selected.](../images/new-storage-account.png 'Azure Portal')

3.  On the **Create storage account** blade, specify the following configuration options:

    a. For **Resource group**, select the **Use existing** radio button, and specify the **ServerlessArchitecture** resource group.

    b. **Name**: enter a unique value for the storage account such as **tollboothstorageINIT** (ensure the green check mark appears).

    c. Ensure the **Location** is the same region as the resource group.

    d. For performance, ensure **Standard** is selected.

    e. For account kind, select **Blobstorage**.

    f. Select the **Hot** access tier.

    g. For replication, select **Locally-redundant storage (LRS)**.

    ![Fields in the Create storage account blade are set to the previously defined values.](../images/image12.png 'Create strorage account blade')

4.  Select **Review + create**, then select **Create**.

5.  After the storage account has completed provisioning, open the storage account by opening the **ServerlessArchitecture** resource group, and then selecting the **storage account** name.

    ![In the ServerlessArchitecture blade, Overview is selected. Under Name, the tollbooth storage account is selected.](../images/image14.png 'ServerlessArchitecture blade')

6.  On the **Storage account** blade, select **Access Keys**, under Settings in the menu. Then on the **Access keys** blade, select the **Click to copy** button for **key1 connection string.**

    ![In the Storage account blade, under Settings, Access keys is selected. Under Default keys, the copy button next to the key1 connection string is selected.](../images/image15.png 'Storage account blade')

7.  Paste the value into a text editor, such as Notepad, for later reference.

8.  Select **Blobs** under **Blob Service** in the menu. Then select the **+ Container** button to add a new container. In the **Name** field, enter **images**, select **Private (no anonymous access)** for the public access level, then select **OK** to save.

    ![In the Storage blade, under Settings, Containers is selected. In the Containers blade, the + (add icon) Container button is selected. Below, the Name field displays images, and the Public access level is set to Private (no anonymous access).](../images/image16.png 'Storage and Containers blade')

9.  Repeat these steps to create a container named **export**.

    ![In the Storage blade, under Settings, Containers is selected. In the Containers blade, the + (add icon) Container button is selected. Below, the Name field displays export, and the Public access level is set to Private (no anonymous access).](../images/new-container-export.png 'Storage and Containers blade')

### Task 2: Provision the Function Apps

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then enter **function** into the search box on top. Select **Function App** from the results.

    ![In the menu pane of the Azure Portal, the New button is selected. Function is typed in the search field, and Function App is selected from the search results.](../images/image17.png 'Azure Portal')

3.  Select the **Create** button on the **Function App overview** blade.

4.  On the **Create Function App** blade, specify the following configuration options:

    a. **Name**: Unique value for the App name (ensure the green check mark appears). Provide a name similar to **TollBoothFunctionApp**.

    b. Specify the Resource Group **ServerlessArchitecture**.

    c. For hosting plan, select the **Consumption Plan**.

    d. Select the same **location** as your Resource Group.

    e. For Runtime stack, select **.NET**.

    f. Leave the **storage** option as **create new**.

    g. Ensure **Disabled** is selected for **Application Insights** (we'll add this later).

    ![Fields in the Function App blade are set to the previously defined settings.](../images/new-functionapp-net.png 'Function App blade')

5.  Select **Create**.

    ![Screenshot of the Create button.](../images/image13.png 'Create button')

6.  **Repeat steps 1-3** to create a second Function App.

7.  On the **Create Function App** blade, specify the following configuration options:

    a. **Name**: Unique value for the App name (ensure the green check mark appears). Provide a name similar to **TollBoothEvents**.

    b. Specify the Resource Group **ServerlessArchitecture**.

    c. For hosting plan, select the **Consumption Plan**.

    d. Select the same **location** as your Resource Group.

    e. For Runtime stack, select **Javascript**.

    f. Leave the **storage** option as **create new**.

    g. Ensure **Disabled** is selected for **Application Insights** (we'll add this later).

    ![Fields in the Function App blade are set to the previously defined settings.](../images/new-functionapp-javascript.png 'Function App blade')

8.  Select **Create**.

    ![Screenshot of the Create button.](../images/image13.png 'Create button')

### Task 3: Provision the Event Grid topic

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then enter **event grid** into the search box on top. Select **Event Grid Topic** from the results.

    ![In the menu pane of the Azure Portal, the New button is selected. Event grid is typed in the search field, and Event Grid Topic is selected from the search results.](../images/image19.png 'Azure Portal')

3.  Select the **Create** button on the **Event Grid Topic overview** blade.

4.  On the **Create Topic** blade, specify the following configuration options:

    a. **Name:** Unique value for the App name such as **TollboothEventGrid** (ensure the green check mark appears).

    b. Specify the Resource Group **ServerlessArchitecture**.

    c. Select the same **location** as your Resource Group.

    d. Leave the schema as **Event Grid Schema**.

    ![In the Create Topic blade, the Name field is TollBoothTopic, Resource Group is using existing ServerlessArchitecture, and the location is West US 2.](../images/image20.png 'Create Topic blade')

5.  Select **Create**.

6.  After the Event Grid topic has completed provisioning, open the account by opening the **ServerlessArchitecture** resource group, and then selecting the **Event Grid** topic name.

7.  Select **Overview** in the menu, and then copy the **Topic Endpoint** value.

    ![In the TollBoothTopic blade, Overview is selected, and the copy button next to the Topic Endpoint is called out.](../images/image21.png 'TollBoothTopic blade')

8.  Select **Access Keys** under Settings in the menu.

9.  Within the **Access Keys** blade, copy the **Key 1** value.

    ![In the TollBoothTopic - Access keys, under Settings, Access keys is selected. The copy button next to the Key 1 access key is also selected.](../images/image22.png 'TollBoothTopic - Access keys blade')

10. Paste the values into a text editor, such as Notepad, for later reference.

### Task 4: Provision the Azure Cosmos DB account

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, select **Databases** then select **Azure Cosmos DB**.

    ![In Azure Portal, in the menu, New is selected. Under Azure marketplace, Databases is selected, and under Featured, Azure Cosmos DB is selected.](../images/image23.png 'Azure Portal')

3.  On the **Create new Azure Cosmos DB** **account** blade, specify the following configuration options:

    a. Specify the Resource Group **ServerlessArchitecture**.

    a. For Account Name, type a unique value for the App name such as **ToolboothDB** (ensure the green check mark appears).

    b. Select the **Core (SQL)** API.

    d. Select the same **location** as your Resource Group if available. Otherwise, select the next closest **region**.

    e. Ensure **Disable geo-redundancy** is selected.

    f. Ensure **Disable multi-region writes** is selected.

    ![Fields in the Azure Cosmos DB blade are set to the previously defined settings.](../images/image24.png 'Azure Cosmos DB blade')

4.  Select **Review + create**, then select **Create**

5.  After the Azure Cosmos DB account has completed provisioning, open the account by opening the **ServerlessArchitecture** resource group, and then selecting the **Azure Cosmos DB** account name.

6.  Select **Browse** in the blade menu, then select **+ Add Collection**.

    ![In the Tollbooths blade, Overview is selected, and the Add Collection button is selected.](../images/image25.png 'Tollbooths blade')

7.  On the **Add Collection** blade, specify the following configuration options:

    a. Enter **LicensePlates** for the **Database id**.

    b. Leave **Provision database throughput** unchecked.

    c. Enter **Processed** for the **Collection id**.

    d. Partition key: **/licensePlateText**

    e. Throughput: **5000**

    ![In the Add Collection blade, fields are set to the previously defined settings.](../images/cosmosdb-add-processed-collection.png 'Add Collection blade')

8)  Select **OK**.

9)  Select **New Collection** to add another collection.

10) On the **Add Collection** blade, specify the following configuration options:

    a. For Database id, choose **Use existing** and select **LicensePlates**.

    b. For Collection id, enter **NeedsManualReview**.

    c. Partition key: **/fileName**

    d. Throughput: **5000**

    ![In the Add Collection blade, fields are set to the previously defined values.](../images/cosmosdb-add-manualreview-collection.png 'Add Collection blade')

11) Select **OK**.

12) Select **Keys** under Settings in the menu.

13) Underneath the **Read-write Keys** tab within the Keys blade, copy the **URI** and **Primary Key** values.

    ![In the tollbooth - Keys blade, under Settings, Keys is selected. On the Read-write Keys tab, the copy buttons for the URL and Primary Key fields are selected.](../images/image28.png 'tollbooth - Keys blade')

14) Paste the values into a text editor, such as Notepad, for later reference.



[Next challenge (Configuration) >](./Host-Configuration.md)
