# Challenge 04 - Configuration

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

In this challenge, you will apply application settings using the Microsoft Azure Portal. You will then add the application settings to the TollBooth Starter Project.

## Description

1. Add the application settings in the **first** function app (with name containing &quot;App&quot;) you created as follows:

| **Application Key** | **Value** |
| --- | --- |
| computerVisionApiUrl | Computer Vision API endpoint you copied earlier. Append **vision/v2.0/ocr** to the end. Example: [https://westus.api.cognitive.microsoft.com/vision/v2.0/ocr](https://westus.api.cognitive.microsoft.com/vision/v2.0/ocr) |
| computerVisionApiKey | computerVisionApiKey from Key Vault |
| eventGridTopicEndpoint | Event Grid Topic endpoint |
| eventGridTopicKey | eventGridTopicKey from Key Vault |
| cosmosDBEndPointUrl | Cosmos DB URI |
| cosmosDBAuthorizationKey | cosmosDBAuthorizationKey from Key Vault |
| cosmosDBDatabaseId | Cosmos DB database id (LicensePlates) |
| cosmosDBCollectionId | Cosmos DB processed collection id (Processed) |
| exportCsvContainerName | Blob storage CSV export container name (export) |
| blobStorageConnection | blobStorageConnection from Key Vault |
 
2. Open the Tollbooth folder in Visual Studio Code.
3. Open the Todo Tree Extension
4. Open ProcessImage.cs. Notice that the Run method is decorated with the FunctionName attribute, which sets the name of the Azure Function to &quot;ProcessImage&quot;. This is triggered by HTTP requests sent to it from the Event Grid service. You tell Event Grid that you want to get these notifications at your function&#39;s URL by creating an event subscription, which you will do in a later task, in which you subscribe to blob-created events. The function&#39;s trigger watches for new blobs being added to the images container of the storage account that was created in Exercise 1. The data passed to the function from the Event Grid notification includes the URL of the blob. That URL is in turn passed to the input binding to obtain the uploaded image from Blob storage.

5.  The following code represents the completed task in ProcessImage.cs:

```csharp
// **TODO 1: Set the licensePlateText value by awaiting a new FindLicensePlateText.GetLicensePlate method.**

licensePlateText = await new FindLicensePlateText(log, _client).GetLicensePlate(licensePlateImage);
```

6. Open FindLicensePlateText.cs. This class is responsible for contacting the Computer Vision API to find and extract the license plate text from the photo, using OCR. Notice that this class also shows how you can implement a resilience pattern using Polly, an open source .NET library that helps you handle transient errors. This is useful for ensuring that you do not overload downstream services, in this case, the Computer Vision API. This will be demonstrated later on when visualizing the Function&#39;s scalability.
7. The following code represents the completed task in FindLicensePlateText.cs:


```csharp
// TODO 2: Populate the below two variables with the correct AppSettings properties.
var uriBase = Environment.GetEnvironmentVariable("computerVisionApiUrl");
var apiKey = Environment.GetEnvironmentVariable("computerVisionApiKey");
```

8. Open SendToEventGrid.cs. This class is responsible for sending an Event to the Event Grid topic, including the event type and license plate data. Event listeners will use the event type to filter and act on the events they need to process. Make note of the event types defined here (the first parameter passed into the Send method), as they will be used later on when creating new functions in the second Function App you provisioned earlier.
9. The following code represents the completed tasks in SendToEventGrid.cs:

```csharp
// TODO 3: Modify send method to include the proper eventType name value for saving plate data.
await Send("savePlateData", "TollBooth/CustomerService", data);

// TODO 4: Modify send method to include the proper eventType name value for queuing plate for manual review.
await Send("queuePlateForManualCheckup", "TollBooth/CustomerService", data);
```


## Success Criteria

1. The solution successfully builds
2. The function app does not show any errors

## Learning Resources

- [Code and test Azure Functions locally](https://docs.microsoft.com/azure/azure-functions/functions-run-local)
- [How to add Application Settings to Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-use-azure-function-app-settings)