# Challenge 08 - Data Export Workflow

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)**

## Introduction

In this challenge, you create a new Logic App for your data export workflow. This Logic App will execute periodically and call your `ExportLicensePlates` function, then conditionally send an email if there were no records to export.

## Description

1. Create a logic app
    * Name : Similar to `TollBoothLogic`
    * Make sure Log Analytics is Off
    * Trigger should be Recurrence, 15 minutes
2. Add an action to call your &quot;App&quot; function app function name `ExportLicensePlates`
3. Add a condition control
    * Value : Status Code parameter
    * Operator : is equal to
    * Second value : 200
4. Ignore the True condition
5. In the False condition, send an O365 email
    * To : your email
    * Subject : enter something meaningful
    * Message Body : enter something here and include the status code value
6. Save and Run
7. Once your email message is received, return to your solution and replace the To-Do's accordingly:
```csharp
    // TODO 5: Retrieve a List of LicensePlateDataDocument objects from the collectionLink where the exported value is false.
    licensePlates = _client.CreateDocumentQuery<LicensePlateDataDocument>(collectionLink,
            new FeedOptions() { EnableCrossPartitionQuery=true,MaxItemCount = 100 })
        .Where(l => l.exported == false)
        .ToList();
    // TODO 6: Remove the line below.
```

```csharp
    // TODO 7: Asyncronously upload the blob from the memory stream.
    await blob.UploadAsync(stream, true);
 ```
 8. Publish to Azure
 9. In your App Azure Function, add `FUNCTIONS_V2_COMPATIBILITY_MODE` with a value of `true` in the application settings.
 10. Run the Logic App.  This time, the condition should be true.


## Success Criteria

1. The first execution of the logic app has executed successfully and you have received an email from your Logic App
2. The first execution of the logic app has executed successfully and you have data in your export container

## Learning Resources

- [What are Logic Apps?](https://docs.microsoft.com/azure/logic-apps/logic-apps-what-are-logic-apps)
- [Call Azure Functions from logic apps](https://docs.microsoft.com/azure/logic-apps/logic-apps-azure-functions#call-azure-functions-from-logic-apps)
