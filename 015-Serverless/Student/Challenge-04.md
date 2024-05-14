# Challenge 04 - Configuration

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

The TollBooth application's function code does not have any credentials or settings stored in its code files. Instead, it reads its secrets and configuration settings from Environment Variables that must be set and passed in by the hosting environment (Azure Function App).

Azure Function Apps enable you to set these values in their hosting environment. They are known as Application Settings. For further security, the secret values are not directly stored in the Application Settings, we just point to the KeyVault secret instead, and let Azure dynamically fetch the secret values thanks to Managed Identities and RBAC.

## Description

In this challenge, you will create Application Settings for each of the configuration settings and secrets the TollBooth app requires, leveraging the native KeyVault integration.  

You will also prepare the TollBooth application's code by adding code snippets that reference the Environment Variables and other functions it will call.

### Configure Function App Application Settings in Azure

Via the Azure Portal, add the application settings in the **first** Azure Function App (.NET based, with name containing `app`), as follows:

| **Application Key** | **Value** |
| --- | --- |
| `computerVisionApiUrl` | Computer Vision API endpoint you copied earlier. Append **vision/v2.0/ocr** to the end. Example: [https://westus.api.cognitive.microsoft.com/vision/v2.0/ocr](https://westus.api.cognitive.microsoft.com/vision/v2.0/ocr) |
| `computerVisionApiKey` | `computerVisionApiKey` pointer to the Key Vault secret |
| `eventGridTopicEndpoint` | Event Grid Topic endpoint |
| `eventGridTopicKey` | `eventGridTopicKey` pointer to the Key Vault secret |
| `cosmosDBEndPointUrl` | Cosmos DB URI |
| `cosmosDBAuthorizationKey` | `cosmosDBAuthorizationKey` pointer to the Key Vault secret |
| `cosmosDBDatabaseId` | Cosmos DB database id (i.e "`LicensePlates`") |
| `cosmosDBCollectionId` | Cosmos DB processed container id (i.e "`Processed`") |
| `exportCsvContainerName` | Blob storage CSV export container name (i.e "`export`") |
| `blobStorageConnection` | `blobStorageConnection` pointer to the Key Vault secret |

**HINT:** The pointers to KeyVault Secrets must finish with a trailing "/" when not referring a version. For example: `@Microsoft.KeyVault(SecretUri=https://kvname.vault.azure.net/secrets/blobStorageConnection/)`

If you did not configure the Function App in Azure to access Key Vault in the previous challenge, you will need to do this now:
- Configure a Managed Identity for the Function App. 
- Go to the Key Vault's Access Control (IAM) settings, and add the Managed Identity with the proper Azure RBAC permissions to read secrets.

### Configure TollBooth Application Code

- Open the `/Tollbooth` folder in Visual Studio Code. It's recommended to enable the suggested C# development extensions when prompted by VSCode.
- Open the Todo Tree Extension. You will see a list of TODO tasks, where each task represents one line of code that needs to be completed.

    > ![A list of TODO tasks, including their description, project, file, and line number display.](../images/image38.png 'TODO tasks')

- Click on **TODO 1**, which will open **`ProcessImage.cs`**. Replace the comment to complete the first task in `ProcessImage.cs`:

```csharp
// TODO 1: Set the licensePlateText value by awaiting a new FindLicensePlateText.GetLicensePlate method.
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

### Understand the TollBooth App code (Optional)

- **`ProcessImage.cs`**. Notice that the `Run` method is decorated with the `FunctionName` attribute, which sets the name of the Azure Function to `ProcessImage`. This is triggered by HTTP requests sent to it from the Event Grid service. You tell Event Grid that you want to get these notifications at your function's URL by creating an event subscription, which you will do in a later task, in which you subscribe to blob-created events. The function's trigger watches for new blobs being added to the images container of the storage account that was created in Challenge 2. The data passed to the function from the Event Grid notification includes the URL of the blob. That URL is in turn passed to the input binding to obtain the uploaded image from Blob storage.

- **`FindLicensePlateText.cs`**. This class is responsible for contacting the Computer Vision API to find and extract the license plate text from the photo, using OCR. Notice that this class also shows how you can implement a resilience pattern using [Polly](https://github.com/App-vNext/Polly), an open source .NET library that helps you handle transient errors. This is useful for ensuring that you do not overload downstream services, in this case, the Computer Vision API. This will be demonstrated later on when visualizing the Function's scalability.

- **`SendToEventGrid.cs`**. This class is responsible for sending an Event to the Event Grid topic, including the event type and license plate data. Event listeners will use the event type to filter and act on the events they need to process. Make note of the event types defined here (the first parameter passed into the Send method), as they will be used later on when creating new functions in the second Function App you provisioned earlier.

## Success Criteria

1. The solution successfully builds
2. The Application Settings menu in the Function App does not show any access error for the variables pointing to KeyVault secrets

## Learning Resources

- [Code and test Azure Functions locally](https://docs.microsoft.com/azure/azure-functions/functions-run-local)
- [How to add Application Settings to Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-use-azure-function-app-settings)
