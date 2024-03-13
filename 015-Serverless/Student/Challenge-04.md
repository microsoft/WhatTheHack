# Challenge 04 - Configuration

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

The function code doesn't have any credentials or settings stored in files. Instead, it uses Environment Variables (configured via Application Settings) to point to the specific databases or storage accounts it uses. For further security, the credentials are not directly stored in the Application Settings, we just point to the KeyVault secret instead, and let Azure dynamically fetch the secret values thanks to Managed Identities and RBAC.

In this challenge, you'll create application settings with references to this environment's databases and access keys (from the previous challenge), leveraging the native KeyVault integration. 

Then, you'll open the source code and copy&paste the missing code (in `TODO's`) as well as references to the application setting variable names.

## Step by Step Instructions

- Add the application settings in the **first** Azure Function App (.NET based, with name containing &quot;App&quot;), as follows:

| **Application Key** | **Value** |
| --- | --- |
| `computerVisionApiUrl` | Computer Vision API endpoint you copied earlier. Append **vision/v2.0/ocr** to the end. Example: [https://westus.api.cognitive.microsoft.com/vision/v2.0/ocr](https://westus.api.cognitive.microsoft.com/vision/v2.0/ocr) |
| `computerVisionApiKey` | `computerVisionApiKey` pointer to the Key Vault secret |
| `eventGridTopicEndpoint` | Event Grid Topic endpoint |
| `eventGridTopicKey` | `eventGridTopicKey` pointer to the Key Vault secret |
| `cosmosDBEndPointUrl` | Cosmos DB URI |
| `cosmosDBAuthorizationKey` | `cosmosDBAuthorizationKey` pointer to the Key Vault secret |
| `cosmosDBDatabaseId` | Cosmos DB database id (i.e "`LicensePlates`") |
| `cosmosDBCollectionId` | Cosmos DB processed collection id (i.e "`Processed`") |
| `exportCsvContainerName` | Blob storage CSV export container name (i.e "`export`") |
| `blobStorageConnection` | `blobStorageConnection` pointer to the Key Vault secret |

**HINT** the pointers to KeyVault Secrets must finish with a trailing "/" when not referring a version. For example: `@Microsoft.KeyVault(SecretUri=https://kvname.vault.azure.net/secrets/blobStorageConnection/)`

- Configure a Managed Identity for the Function. 
- Go to the Keyvault, Access Control (IAM), and add the Managed Identity with the proper RBAC permissions to read secrets.
- Open the Tollbooth folder in Visual Studio Code. It's recommended to enable the suggested C# development extensions when prompted by VSCode.
- Open the Todo Tree Extension. You will see a list of TODO tasks, where each task represents one line of code that needs to be completed.

    > ![A list of TODO tasks, including their description, project, file, and line number display.](../images/image38.png 'TODO tasks')

- Click on **TODO 1**, which will open **`ProcessImage.cs`**. Replace the comment to complete the first task in `ProcessImage.cs`:

```csharp
// **TODO 1: Set the licensePlateText value by awaiting a new FindLicensePlateText.GetLicensePlate method.**
licensePlateText = await new FindLicensePlateText(log, _client).GetLicensePlate(licensePlateImage);
```

- **TODO 2** will open **`FindLicensePlateText.cs`**. Replace the comment to complete the second task in `FindLicensePlateText.cs`:

```csharp
// TODO 2: Populate the below two variables with the correct AppSettings properties.
var uriBase = Environment.GetEnvironmentVariable("computerVisionApiUrl");
var apiKey = Environment.GetEnvironmentVariable("computerVisionApiKey");
```

- **TODO 3 and 4** will open **`SendToEventGrid.cs`**. Replace the comments to complete the third and fourth task in `SendToEventGrid.cs`:

```csharp
// TODO 3: Modify send method to include the proper eventType name value for saving plate data.
await Send("savePlateData", "TollBooth/CustomerService", data);

// TODO 4: Modify send method to include the proper eventType name value for queuing plate for manual review.
await Send("queuePlateForManualCheckup", "TollBooth/CustomerService", data);
```

- Optional: Execute **dotnet build** to validate any syntax errors, from the TollBooth root folder.


## OPTIONAL Understand the TollBooth App code

- **`ProcessImage.cs`**. Notice that the Run method is decorated with the `FunctionName` attribute, which sets the name of the Azure Function to "`ProcessImage`". This is triggered by HTTP requests sent to it from the Event Grid service. You tell Event Grid that you want to get these notifications at your function's URL by creating an event subscription, which you will do in a later task, in which you subscribe to blob-created events. The function's trigger watches for new blobs being added to the images container of the storage account that was created in Exercise 1. The data passed to the function from the Event Grid notification includes the URL of the blob. That URL is in turn passed to the input binding to obtain the uploaded image from Blob storage.

- **`FindLicensePlateText.cs`**. This class is responsible for contacting the Computer Vision API to find and extract the license plate text from the photo, using OCR. Notice that this class also shows how you can implement a resilience pattern using [Polly](https://github.com/App-vNext/Polly), an open source .NET library that helps you handle transient errors. This is useful for ensuring that you do not overload downstream services, in this case, the Computer Vision API. This will be demonstrated later on when visualizing the Function's scalability.

- **`SendToEventGrid.cs`**. This class is responsible for sending an Event to the Event Grid topic, including the event type and license plate data. Event listeners will use the event type to filter and act on the events they need to process. Make note of the event types defined here (the first parameter passed into the Send method), as they will be used later on when creating new functions in the second Function App you provisioned earlier.

## Success Criteria

1. The solution successfully builds
2. The Application Settings menu in the Function App does not show any access error for the variables pointing to KeyVault secrets

## Learning Resources

- [Code and test Azure Functions locally](https://docs.microsoft.com/azure/azure-functions/functions-run-local)
- [How to add Application Settings to Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-use-azure-function-app-settings)
