# Challenge 04 - Configuration - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

None

## Step by Step Instructions

### Help references

- [Code and test Azure Functions locally](https://docs.microsoft.com/azure/azure-functions/functions-run-local)

### Task 1: Configure application settings

In this task, you will apply application settings using the Microsoft Azure Portal. You will then add the application settings to the TollBooth Starter Project.

1.  Using a new tab or instance of your browser navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Open the **ServerlessArchitecture** resource group, and then select the Azure Function App you created whose name ends with **FunctionApp**. This is the one you created using the **.NET** runtime stack. If you did not use this naming convention, that's fine. Just be sure to make note of the name so you can distinguish it from the Function App you will be developing using the portal later on.

3.  Select **Application settings** on the Overview pane.


4.  Scroll down to the **Application settings** section. Use the **+ Add new setting** link to create the following additional Key/Value pairs (the key names must exactly match those found in the table below):

|                          |                                                                                                                                                             |
| ------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------: |
| **Application Key**      |                                                                          **Value**                                                                          |
| computerVisionApiUrl     | Computer Vision API endpoint you copied earlier. Append **vision/v2.0/ocr** to the end. Example: https://westus.api.cognitive.microsoft.com/vision/v2.0/ocr |
| computerVisionApiKey     |                                                                   Computer Vision API key                                                                   |
| eventGridTopicEndpoint   |                                                                  Event Grid Topic endpoint                                                                  |
| eventGridTopicKey        |                                                                 Event Grid Topic access key                                                                 |
| cosmosDBEndPointUrl      |                                                                        Cosmos DB URI                                                                        |
| cosmosDBAuthorizationKey |                                                                    Cosmos DB Primary Key                                                                    |
| cosmosDBDatabaseId       |                                                            Cosmos DB database id (LicensePlates)                                                            |
| cosmosDBCollectionId     |                                                        Cosmos DB processed collection id (Processed)                                                        |
| exportCsvContainerName   |                                                       Blob storage CSV export container name (export)                                                       |
| blobStorageConnection    |                                                               Blob storage connection string                                                                |


5.  Select **Save**.

 
6.  _Optional steps_, only if you wish to debug the functions locally on your development machine:

    a. Update the local.settings.json file with the same values.

    b. Update the AzureWebJobsStorage and AzureWebJobsDashboard values in local.settings.json with those found under Application settings for the Function App. Save your changes.

### Task 2: Finish the ProcessImage function

There are a few components within the starter project that must be completed, marked as TODO in the code. The first set of TODO items we will address are in the ProcessImage function, the FindLicensePlateText class that calls the Computer Vision API, and finally the SendToEventGrid.cs class, which is responsible for sending processing results to the Event Grid topic you created earlier.

> **Note:** Do **NOT** update the version of any NuGet package. This solution is built to function with the NuGet package versions currently defined within. Updating these packages to newer versions could cause unexpected results.

1.  Navigate to the **TollBooth** project using the Solution Explorer of Visual Studio.

2.  From the Visual Studio **View** menu, select **Task List**.

3.  There you will see a list of TODO tasks, where each task represents one line of code that needs to be completed.

    > ![A list of TODO tasks, including their description, project, file, and line number display.](./images/image38.png 'TODO tasks')

4.  Open **ProcessImage.cs**. Notice that the Run method is decorated with the FunctionName attribute, which sets the name of the Azure Function to "ProcessImage". This is triggered by HTTP requests sent to it from the Event Grid service. You tell Event Grid that you want to get these notifications at your function's URL by creating an event subscription, which you will do in a later task, in which you subscribe to blob-created events. The function's trigger watches for new blobs being added to the images container of the storage account that was created in Exercise 1. The data passed to the function from the Event Grid notification includes the URL of the blob. That URL is in turn passed to the input binding to obtain the uploaded image from Blob storage.

5.  The following code represents the completed task in ProcessImage.cs:

```csharp
// **TODO 1: Set the licensePlateText value by awaiting a new FindLicensePlateText.GetLicensePlate method.**

licensePlateText = await new FindLicensePlateText(log, _client).GetLicensePlate(licensePlateImage);
```

6.  Open **FindLicensePlateText.cs**. This class is responsible for contacting the Computer Vision API to find and extract the license plate text from the photo, using OCR. Notice that this class also shows how you can implement a resilience pattern using [Polly](https://github.com/App-vNext/Polly), an open source .NET library that helps you handle transient errors. This is useful for ensuring that you do not overload downstream services, in this case, the Computer Vision API. This will be demonstrated later on when visualizing the Function's scalability.

7.  The following code represents the completed task in FindLicensePlateText.cs:

```csharp
// TODO 2: Populate the below two variables with the correct AppSettings properties.
var uriBase = Environment.GetEnvironmentVariable("computerVisionApiUrl");
var apiKey = Environment.GetEnvironmentVariable("computerVisionApiKey");
```

8.  Open **SendToEventGrid.cs**. This class is responsible for sending an Event to the Event Grid topic, including the event type and license plate data. Event listeners will use the event type to filter and act on the events they need to process. Make note of the event types defined here (the first parameter passed into the Send method), as they will be used later on when creating new functions in the second Function App you provisioned earlier.

9.  The following code represents the completed tasks in `SendToEventGrid.cs`:

```csharp
// TODO 3: Modify send method to include the proper eventType name value for saving plate data.
await Send("savePlateData", "TollBooth/CustomerService", data);

// TODO 4: Modify send method to include the proper eventType name value for queuing plate for manual review.
await Send("queuePlateForManualCheckup", "TollBooth/CustomerService", data);
```
