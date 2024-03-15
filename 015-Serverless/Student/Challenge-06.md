# Challenge 06 - Create Functions using VS Code

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

In this challenge, you will create two new Azure Functions written in Node.js, using VS Code. These will be triggered by Event Grid and output to Azure Cosmos DB to save the results of license plate processing done earlier by the `ProcessImage` function.  The code for these functions is provided in the challenge instructions below.

Two notes about the code you will use:
- The code uses the [Azure Node.js Functions Programming Model v4](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/azure-functions-node-js-v4-programming-model-is-generally/ba-p/3929217) which has significant differences from previous one, especially around [bindings](https://learn.microsoft.com/en-us/azure/azure-functions/functions-node-upgrade-v4?tabs=v4).
- Do not confuse with the Azure Functions runtime, which [currently is at 4.x](https://learn.microsoft.com/en-us/azure/azure-functions/migrate-version-3-version-4?tabs=net8%2Cazure-cli%2Cwindows&pivots=programming-language-javascript)

## Description

Since these new functions will be written in a different language than the ones from the previous challenge (Node.js vs. C#), you will need to open a new Visual Studio code window.  

- Local Workstation: Open a new VS Code window to the "Events" folder wherever you unpacked the student Resources.zip package.
- GitHub Codespaces: Open the "Events" folder in the Codespace by:
    - Select `Open Folder` from the "hamburger menu" in the upper left corner of the screen
    - Navigate to the `Events` folder from the drop down that appears at the top of the VS Code window and click `OK`
    - The Codespace will re-load in the browser, with VS Code opened to the `Events` folder.

Using the skills you learned in Challenge 02 when creating a "Hello World" function, you will create two new functions and deploy each both to the Function App in Azure with the `events` in the name that you created earlier in Challenge 03.

### Create & Publish `savePlateData` Function

- Create a new Project from the "Workspace (local)" dropdown in the Azure Extension tab of VSCode.
- Choose the `Events` folder.
- Create the first function with the following specifications:
    - Select Javascript
    - Model V4
    - Event Grid trigger
    - Name `savePlateData`
- Replace the code in the generated `savePlateData.js` file with the following:

```javascript
const { app, output } = require('@azure/functions'); 

const cosmosOutput = output.cosmosDB({ 
    databaseName: 'LicensePlates', 
    containerName: 'Processed', 
    createIfNotExists: true, 
    connection: 'cosmosDBConnectionString', 
}); 

app.eventGrid('savePlateData', { 
    return: cosmosOutput, 
    handler: (event, context) => { 
        context.log('Event grid function processed event:', event); 
        return { 
            fileName: event.data['fileName'], 
            licensePlateText: event.data['licensePlateText'], 
            timeStamp: event.data['timeStamp'], 
            exported: false,
            id: event.id 
        }; 
    }, 
}); 
```

- In the Azure Resources pane of Azure Extension tab of VSCode, deploy the `savePlateData` function to the Function App with `events` in the name, from the Azure "Workspace" Local Project you just created.
- You are asked if you want to Stream logs, click on it. If it disconnects after a while, stop and start again (from the Function App menu in VS Code)
- Add a new Application Setting `cosmosDBConnectionString` with the connection string (or the corresponding KeyVault Secret reference) to Cosmos DB `LicensePlates`
- From the Azure Portal, open the Function app, function `savePlateData`, and go to Integration. From the Event Grid Trigger, add an event grid subscription
    * Name should contain &quot;`SAVE`&quot;
    * Event Schema: Event Grid Schema.
    * Topic Type: Event Grid Topics.
    * Resource: your recently created Event Grid.
    * Event Type to filter: Add `savePlateData`
    * Endpoint : Select `SavePlateData` Function.

### Create and Publish `queuePlateForManualCheckup` Function

Now let's repeat the same steps for the second event function:
- From VSCode, create another function in the same project with the following specifications:
  - Select Javascript
  - Model V4
  - Event Grid trigger
  - Name `queuePlateForManualCheckup`
- Replace the code in the generated `queuePlateForManualCheckup.js` file with the following:

```javascript
const { app, output } = require('@azure/functions'); 

const cosmosOutput = output.cosmosDB({ 
    databaseName: 'LicensePlates', 
    containerName: 'NeedsManualReview', 
    createIfNotExists: true, 
    connection: 'cosmosDBConnectionString', 
}); 

app.eventGrid('queuePlateForManualCheckup', { 
    return: cosmosOutput, 
    handler: (event, context) => { 
        context.log('Event grid function processed event:', event); 
        return { 
            fileName: event.data['fileName'], 
            licensePlateText: '', 
            timeStamp: event.data['timeStamp'], 
            resolved: false,
            id: event.id
        };
    },
});
```

- In the Azure Resources pane of Azure Extension tab of VSCode, deploy the `queuePlateForManualCheckup` function to the Function App with `events` in the name, from the Azure "Workspace" Local Project.
- You are asked if you want to Stream logs, click on it. If it disconnects after a while, stop and start again (from the Function App menu in VS Code)
- Add a new Application Setting `cosmosDBConnectionString` with the connection string (or the corresponding KeyVault Secret reference) to Cosmos DB `LicensePlates`
- From the Azure Portal, open the Function app, function `queuePlateForManualCheckup`, and go to Integration. From the Event Grid Trigger, add an event grid subscription
    * Name should contain "`QUEUE`"
    * Event Schema: Event Grid Schema.
    * Topic Type: Event Grid Topics.
    * Resource: your recently created Event Grid.
    * Event Type to filter `queuePlateForManualCheckup`
    * Endpoint: Select `queuePlateForManualCheckup` Function.

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
