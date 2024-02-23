# Challenge 06 - Create Functions using VS Code

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

In this challenge, you will create two new Azure Functions written in Node.js, using VS Code. These will be triggered by Event Grid and output to Azure Cosmos DB to save the results of license plate processing done earlier by the `ProcessImage` function.  The code for these functions is provided in the challenge instructions below.

Two notes about the code you will use:
- The code uses the [Azure Node.js Functions Programming Model v4](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/azure-functions-node-js-v4-programming-model-is-generally/ba-p/3929217) which has significant differences from previous one, especially around [bindings](https://learn.microsoft.com/en-us/azure/azure-functions/functions-node-upgrade-v4?tabs=v4).
- Do not confuse with the Azure Functions runtime, which [currently is at 4.x](https://learn.microsoft.com/en-us/azure/azure-functions/migrate-version-3-version-4?tabs=net8%2Cazure-cli%2Cwindows&pivots=programming-language-javascript)

## Description

- Create a new folder to contain your event processing functions, call it "Events" for instance- Create a new Project from the "Workspace (local)" dropdown in the Azure Extension tab of VSCode. Choose the events folder. Select Javascript. Model V4, Event Grid trigger, name `savePlateData`
- Replace the code `savePlateData.js` with the following:

```javascript
const { app, output } = require('@azure/functions'); 

const cosmosOutput = output.cosmosDB({ 
    databaseName: 'LicensePlates', 
    collectionName: 'Processed', 
    createIfNotExists: true, 
    connectionStringSetting: 'cosmosDBConnectionString', 
}); 

app.eventGrid('savePlateData', { 
    return: cosmosOutput, 
    handler: (event, context) => { 
        context.log('Event grid function processed event:', event); 
        return { 
            fileName: event.data['fileName'], 
            licensePlateText: event.data['licensePlateText'], 
            timeStamp: event.data['timeStamp'], 
            exported: false 
        }; 
    }, 
}); 
```

- Create a new Azure Function App, from the Azure "Resources" section, in the region of your choice
- Deploy the `savePlateData` function to that Azure Function App, from the Azure "Workspace" Local Project you just created. You are asked if you want to Stream logs, click on it. If it disconnects after a while, stop and start again (from the Function App menu in VS Code)
- Add a new Application Setting `cosmosDBConnectionString` with the connection string (or the corresponding KeyVault Secret reference) to Cosmos DB `LicensePlates`
- From the Azure Portal, open the Function app, function `savePlateData`, and go to Integration. From the Event Grid Trigger, add an event grid subscription
    * Name should contain &quot;`SAVE`&quot;
    * Event Schema: Event Grid Schema.
    * Topic Type: Event Grid Topics.
    * Resource: your recently created Event Grid.
    * Event Type : Add `savePlateData`
    * Endpoint : Select `SavePlateData` Function.

Now let's repeat the same steps for the second event function:
- From VSCode, create another function in the same project that is triggered by event grid,  name `QueuePlateForManualCheckup`. The JS file should appear next to the other one.
-  Replace the code with the following:

```javascript
const { app, output } = require('@azure/functions'); 

const cosmosOutput = output.cosmosDB({ 
    databaseName: 'LicensePlates', 
    collectionName: 'NeedsManualReview', 
    createIfNotExists: true, 
    connectionStringSetting: 'cosmosDBConnectionString', 
}); 

app.eventGrid('queuePlateForManualCheckup', { 
    return: cosmosOutput, 
    handler: (event, context) => { 
        context.log('Event grid function processed event:', event); 
        return { 
            fileName: event.data['fileName'], 
            licensePlateText: '', 
            timeStamp: event.data['timeStamp'], 
            resolved: false 
        };
    },
});
```

- From the portal, go the `queuePlateForManualCheckup` function, add an event grid subscription
    * Name should contain "`QUEUE`"
    * Event Schema: Event Grid Schema.
    * Topic Type: Event Grid Topics.
    * Resource: your recently created Event Grid.
    * Add Event Type `queuePlateForManualCheckup`
    * Endpoint: Select `QueuePlateForManualCheckup` Function.

## Success Criteria

1. Your folder structure looks similar to this:
    * `events/`
        * `host.json`
        * `package.json`
    * `events/src/functions/`
        * `savePlateData.js`
        * `queuePlateForManualCheckup.js`
    * (other files)
2. Both functions do not have any syntax errors
3. Both functions have event grid subscriptions
4. Both functions have the proper Cosmos DB settings as their outputs
5. Open the Function's `LiveStream`, upload a License Plate JPG to the storage account, and validate the event functions are called with the license plate filename, timestamp and text (if successful). 
6. In your CosmosDB, verify the containers contain the information for every scanned license plate. 

## Learning Resources

- [Create a Typescript function using VSCode](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-typescript?pivots=nodejs-model-v4)
- [Store unstructured data using Azure Functions and Azure Cosmos DB](https://docs.microsoft.com/azure/azure-functions/functions-integrate-store-unstructured-data-cosmosdb)
- [Live Metrics Stream from VS Code](https://learn.microsoft.com/en-us/azure/azure-functions/streaming-logs?tabs=vs-code)
