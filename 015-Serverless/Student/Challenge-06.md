# Challenge 06 - Create Functions in the Portal

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

Create two new Azure Functions written in Node.js, using the Azure portal. These will be triggered by Event Grid and output to Azure Cosmos DB to save the results of license plate processing done by the ProcessImage function.

## Description

1. Navigate to the function app &quot;Events&quot;
2. Create a function that is triggered by event grid (install extensions if prompted)
    * Name : SavePlateData
3. Replace the code with the following:

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

4. Add an event grid subscription
    * Name should contain &quot;SAVE&quot;
    * Event Schema: Event Grid Schema.
    * Topic Type: Event Grid Topics.
    * Resource: your recently created Event Grid.
    * Event Type : Add `savePlateData`
    * Endpoint : Select SavePlateData Function.
5. Add a Cosmos DB Output to the function (install extensions if needed)
    * Select the Cosmos DB account created earlier
    * Database Name : LicensePlates
    * Collection Name : Processed
6. Create another function that is triggered by event grid
    * Name : QueuePlateForManualCheckup
7. Replace the code with the following:


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

8. Add an event grid subscription
    * Name should contain &quot;QUEUE&quot;
    * Event Schema: Event Grid Schema.
    * Topic Type: Event Grid Topics.
    * Resource: your recently created Event Grid.
    * Add Event Type `queuePlateForManualCheckup`
    * Endpoint: Select QueuePlateForManualCheckup Function.
9. Add a Cosmos DB Output to the QueuePlateForManualCheckup function
    * Select the Cosmos DB account connection created earlier
    * Database Name : LicensePlates
    * Collection Name : NeedsManualReview

## Success Criteria

1. Both functions do not have any compillation errors
1. Both functions have event grid subscriptions
1. Both functions have Cosmos DB as their outputs

## Learning Resources

- [Create your first function in the Azure portal](https://docs.microsoft.com/azure/azure-functions/functions-create-first-azure-function)
- [Store unstructured data using Azure Functions and Azure Cosmos DB](https://docs.microsoft.com/azure/azure-functions/functions-integrate-store-unstructured-data-cosmosdb)