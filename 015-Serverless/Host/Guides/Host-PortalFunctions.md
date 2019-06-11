# Challenge 5 - Create Functions in the Portal

### Help references


|                                                                   |                                                                                                         |
| ----------------------------------------------------------------- | :-----------------------------------------------------------------------------------------------------: |
| **Description**                                                   |                                                **Links**                                                |
| Create your first function in the Azure portal                    |        <https://docs.microsoft.com/azure/azure-functions/functions-create-first-azure-function>         |
| Store unstructured data using Azure Functions and Azure Cosmos DB | <https://docs.microsoft.com/azure/azure-functions/functions-integrate-store-unstructured-data-cosmosdb> |


### Task 1: Create function to save license plate data to Azure Cosmos DB

In this task, you will create a new Node.js function triggered by Event Grid and that outputs successfully processed license plate data to Azure Cosmos DB.

1.  Using a new tab or instance of your browser navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Open the **ServerlessArchitecture** resource group, then select the Azure Function App you created whose name ends with **Events**. If you did not use this naming convention, make sure you select the Function App that you _did not_ deploy to in the previous exercise.

3.  Select **Functions** in the menu. In the **Functions** blade, select **+ New Function**.

    ![In the TollBoothEvents2 blade, in the pane under Function Apps, TollBoothEvents2 is expanded, and Functions is selected. In the pane, the + New function button is selected.](../images/image43.png 'TollBoothEvents2 blade')

4.  Enter **event grid** into the template search form, then select the **Azure Event Grid trigger** template.

    a. If prompted, click **Install** and wait for the extension to install.

    b. Click **Continue**

    ![In the Template search form, event grid is typed in the search field. Below, the Event Grid trigger function option displays.](../images/image44.png 'Template search form')

5.  In the New Function form, fill out the following properties:

    a. For name, enter **SavePlateData**

    ![In the New Function form SavePlateData is typed in the Name field.](../images/image45.png 'Event Grid trigger, New Function form')

    b. Select **Create**.

6)  Replace the code in the new SavePlateData function with the following:

```javascript
module.exports = function(context, eventGridEvent) {
  context.log(typeof eventGridEvent);
  context.log(eventGridEvent);

  context.bindings.outputDocument = {
    fileName: eventGridEvent.data['fileName'],
    licensePlateText: eventGridEvent.data['licensePlateText'],
    timeStamp: eventGridEvent.data['timeStamp'],
    exported: false
  };

  context.done();
};
```

8.  Select **Save**.

### Task 2: Add an Event Grid subscription to the SavePlateData function

In this task, you will add an Event Grid subscription to the SavePlateData function. This will ensure that the events sent to the Event Grid topic containing the savePlateData event type are routed to this function.

1.  With the SavePlateData function open, select **Add Event Grid subscription**.

    ![In the SavePlateData blade, the Add Event Grid subscription link is selected.](../images/saveplatedata-add-eg-sub.png 'SavePlateData blade')

2.  On the **Create Event Subscription** blade, specify the following configuration options:

    a. **Name**: Unique value for the App name similar to **saveplatedatasub** (ensure the green check mark appears).

    b. **Event Schema**: Select Event Grid Schema.

    c. For **Topic Type**, select **Event Grid Topics**.

    d. Select your **subscription** and **ServerlessArchitecture** resource group.

    e. For resource, select your recently created Event Grid.

    f. Ensure that **Subscribe to all event types** is checked. You will enter a custom event type later.

    g. Leave Web Hook as the Endpoint Type.

3.  Leave the remaining fields at their default values and select **Create**.

    ![In the Create Event Subscription blade, fields are set to the previously defined settings.](../images/saveplatedata-eg-sub.png)

### Task 3: Add an Azure Cosmos DB output to the SavePlateData function

In this task, you will add an Azure Cosmos DB output binding to the SavePlateData function, enabling it to save its data to the Processed collection.

1.  Expand the **SavePlateData** function in the menu, then select **Integrate**.

2.  Under Outputs, select **+ New Output**, select **Azure Cosmos DB** from the list of outputs, then select **Select**.

    ![In the SavePlateData blade, in the pane under Function Apps, TollBoothEvents2, Functions, and SavePlateData are expanded, and Integrate is selected. In the pane, + New Output is selected under Outputs. In the list of outputs, the Azure Cosmos DB tile is selected.](../images/image48.png 'SavePlateData blade')

3.  In the Azure Cosmos DB output form, select **new** next to the Azure Cosmos DB account connection field.

    ![The New button is selected next to the Azure Cosmos DB account connection field.](../images/image49.png 'New button')

    > **Note**: If you see a notice for "Extensions not installed", click **Install**.

4.  Select your Cosmos DB account from the list that appears.

5.  Specify the following configuration options in the Azure Cosmos DB output form:

    a. For database name, type **LicensePlates**.

    b. For the collection name, type **Processed**.

    ![Under Azure Cosmos DB output the following field values display: Document parameter name, outputDocument; Collection name, Processed; Database name, LicensePlates; Azure Cosmos DB account conection, tollbooths_DOCUMENTDB.](../images/saveplatedata-cosmos-integration.png 'Azure Cosmos DB output section')

6.  Select **Save**.

    > **Note**: you should wait for the template dependency to install if you were prompted earlier.

### Task 4: Create function to save manual verification info to Azure Cosmos DB

In this task, you will create a new function triggered by Event Grid and outputs information about photos that need to be manually verified to Azure Cosmos DB.

1.  Select **Functions** in the menu. In the **Functions** blade, select **+ New Function**.

    ![In the pane of the TollBoothEvents2 blade under Functions Apps, TollBoothEvents2 is expanded, and Functions is selected. In the pane, + New function is selected.](../images/image43.png 'TollBoothEvents2 blade')

2.  Enter **event grid** into the template search form, then select the **Azure Event Grid trigger** template.

    a. If prompted, click **Install** and wait for the extension to install.

    b. Click **Continue**.

    ![Event grid displays in the choose a template search field, and in the results, Event Grid trigger displays.](../images/image44.png 'Event grid trigger')

3.  In the **New Function** form, fill out the following properties:

    a. For name, type **QueuePlateForManualCheckup**.

    ![In the New Function form, JavaScript is selected from the Language drop-down menu, and QueuePlateForManualCheckup is typed in the Name field.](../images/image51.png 'Event Grid trigger, New Function form')

4.  Select **Create**.

5.  Replace the code in the new QueuePlateForManualCheckup function with the following:

```javascript
module.exports = async function(context, eventGridEvent) {
  context.log(typeof eventGridEvent);
  context.log(eventGridEvent);

  context.bindings.outputDocument = {
    fileName: eventGridEvent.data['fileName'],
    licensePlateText: '',
    timeStamp: eventGridEvent.data['timeStamp'],
    resolved: false
  };

  context.done();
};
```

6.  Select **Save**.

### Task 5: Add an Event Grid subscription to the QueuePlateForManualCheckup function

In this task, you will add an Event Grid subscription to the QueuePlateForManualCheckup function. This will ensure that the events sent to the Event Grid topic containing the queuePlateForManualCheckup event type are routed to this function.

1.  With the QueuePlateForManualCheckup function open, select **Add Event Grid subscription**.

    ![In the QueuePlateForManualCheckup blade, the Add Event Grid subscription link is selected.](../images/manualcheckup-add-eg-sub.png 'QueuePlateForManualCheckup blade')

2.  On the **Create Event Subscription** blade, specify the following configuration options:

    a. **Name**: Unique value for the App name similar to **queueplateFormanualcheckupsub** (ensure the green check mark appears).

    b. **Event Schema**: Select Event Grid Schema.

    c. For **Topic Type**, select **Event Grid Topics**.

    d. Select your **subscription** and **ServerlessArchitecture** resource group.

    e. For resource, select your recently created Event Grid.

    f. Ensure that **Subscribe to all event types** is checked. You will enter a custom event type later.

    g. Leave Web Hook as the Endpoint Type.

3.  Leave the remaining fields at their default values and select **Create**.

    ![In the Create Event Subscription blade, fields are set to the previously defined settings.](../images/manualcheckup-eg-sub.png)

### Task 6: Add an Azure Cosmos DB output to the QueuePlateForManualCheckup function

In this task, you will add an Azure Cosmos DB output binding to the QueuePlateForManualCheckup function, enabling it to save its data to the NeedsManualReview collection.

1.  Expand the QueuePlateForManualCheckup function in the menu, the select **Integrate**.

2.  Under Outputs, select **+ New Output** then select **Azure Cosmos DB** from the list of outputs, then select **Select**.

    ![In the blade, in the pane under Function Apps, TollBoothEvents2\ Functions\QueuePlateForManualCheckup are expanded, and Integrate is selected. In the pane, + New Output is selected under Outputs. In the list of outputs, the Azure Cosmos DB tile is selected.](../images/image54.png)

3.  Specify the following configuration options in the Azure Cosmos DB output form:

    > **Note**: If you see a notice for "Extensions not installed", click **Install**.

    a. For database name, enter **LicensePlates**.

    b. For collection name, enter **NeedsManualReview**.

    c. Select the **Azure Cosmos DB account connection** you created earlier.

    ![In the Azure Cosmos DB output form, the following field values display: Document parameter name, outputDocument; Collection name, NeedsManualReview; Database name, LicensePlates; Azure Cosmos DB account connection, tollbooths_DOCUMENTDB.](../images/manualcheckup-cosmos-integration.png 'Azure Cosmos DB output form')

4.  Select **Save**.

### Task 7: Configure custom event types for the new Event Grid subscriptions

In this task, you will configure a custom event type for each new Event Grid subscription you created for your functions in the previous steps of this exercise. Currently the event types are set to All. We want to narrow this down to only the event types specified within the SendToEventGrid class in the TollBooth solution. This will ensure that all other event types are ignored by your functions.

1.  Using a new tab or instance of your browser navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Open the **ServerlessArchitecture** resource group, then select your Event Grid Topic.

3.  At the bottom of the **Overview** blade, you will see both Event Grid subscriptions created from the functions. Select **saveplatedatasub**.

    ![On the Event Grid Topic overview blade, select the saveplatedatasub Event Grid subscription.](../images/image56.png)

4.  Select the **Filters** tab, then _uncheck_ **Subscribe to all event types**.

5.  Select the **Delete** button (x inside of a circle) on the **All** event type to delete it.

    ![The Filters tab is selected and the Subscribe to all event types checkbox has been cleared. An arrow is pointing to the Delete button on the All event type.](../images/event-grid-delete-all.png 'Delete all')

6.  Select **Add Event Type**, then enter **savePlateData** into the event types field. If you specified a different name in the SendToEventGrid class in the TollBooth solution, use that instead.

    ![The savePlateData event type has been added.](media/event-grid-saveplatedata.png 'Add event type')

7.  Select **Save**.

8.  Select the **queueplateformanualcheckupsub** Event Grid subscription at the bottom of the **Overview** blade.

    ![On the Event Grid Topic overview blade, select the queueplateformanualcheckupsub Event Grid subscription.](../images/image58.png)

9.  Select the **Filters** tab, then _uncheck_ **Subscribe to all event types**.

10. Select the **Delete** button (x inside of a circle) on the **All** event type to delete it.

    ![The Filters tab is selected and the Subscribe to all event types checkbox has been cleared. An arrow is pointing to the Delete button on the All event type.](../images/event-grid-delete-all.png 'Delete all')

11. Select **Add Event Type**, then enter **queuePlateForManualCheckup** into the event types field. If you specified a different name in the SendToEventGrid class in the TollBooth solution, use that instead.

    ![The queuePlateForManualCheckup type has been added.](../images/event-grid-queueplateformanualcheckup.png 'Add event type')

12. Select **Save**.


[Next challenge (Monitoring) >](./Host-Monitoring.md)
