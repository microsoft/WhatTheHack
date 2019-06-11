# Challenge 5 - Create Functions in the Portal

## Prerequisities

1. [Challenge 4 - Deployment](./Deployment.md) should be done successfuly.

## Introduction

Create two new Azure Functions written in Node.js, using the Azure portal. These will be triggered by Event Grid and output to Azure Cosmos DB to save the results of license plate processing done by the ProcessImage function.

1. Navigate to the function app &quot;Events&quot;
2. Create a function that is triggered by event grid (install extensions if prompted)
    * Name : SavePlateData
3. Replace the code with the following:

```csharp
module.exports=function (context, eventGridEvent) {
    context.log(typeof eventGridEvent);
    context.log(eventGridEvent);
    context.bindings.outputDocument= {
        fileName :eventGridEvent.data[&quot;fileName&quot;],
        licensePlateText :eventGridEvent.data[&quot;licensePlateText&quot;],
        timeStamp :eventGridEvent.data[&quot;timeStamp&quot;],
        exported :false
    }
    context.done();
};
```

4. Add an event grid subscription
    * Name should contain &quot;SAVE&quot;
    * Event Schema: Event Grid Schema.
    * Topic Type: Event Grid Topics.
    * Resource: your recently created Event Grid.
    * Ensure that Subscribe to all event types _is checked_. You  will enter a custom event type later.
    * Leave Web Hook as the Endpoint Type.
5. Add a Cosmos DB Output to the function (install extensions if needed)
    * Select the Cosmos DB account created earlier
    * Database Name : LicensePlates
    * Collection Name : Processed
6. Create another function that is triggered by event grid
    * Name : QueuePlateForManualCheckup
7. Replace the code with the following:

```csharp
module.exports=asyncfunction (context, eventGridEvent) {
    context.log(typeof eventGridEvent);
    context.log(eventGridEvent);
    context.bindings.outputDocument= {
        fileName :eventGridEvent.data[&quot;fileName&quot;],
        licensePlateText :&quot;&quot;,
        timeStamp :eventGridEvent.data[&quot;timeStamp&quot;],
        resolved :false
    }
    context.done();
};
```

8. Add an event grid subscription
    * Name should contain &quot;QUEUE&quot;
    * Event Schema: Event Grid Schema.
    * Topic Type: Event Grid Topics.
    * Resource: your recently created Event Grid.
    * Ensure that Subscribe to all event types _is checked_. You will enter a custom event type later.
    * Leave Web Hook as the Endpoint Type.
9. Add a Cosmos DB Output to the QueuePlateForManualCheckup function
    * Select the Cosmos DB account created earlier
    * Database Name : LicensePlates
    * Collection Name : NeedsManualReview
10. Navigate to your event grid topic
11. Modify the &quot;SAVE&quot; subscription so it no longer subscribes to all events and add an event type named &quot;savePlateData&quot;.  _Note – If you changed this in the solution, you will have to make sure the name matches what was in the solution_
12. Modify the &quot;QUEUE&quot; subscription so it no longer subscribes to all events and add an event type named &quot; **queuePlateForManualCheckup&quot;**.  _Note – If you changed this in the solution, you will have to make sure the name matches what was in the solution_


## Success Criteria
1. Both functions do not have any compillation errors
1. Both functions have event grid subscriptions
1. Both functions have Cosmos DB as their outputs

## Tips

|                                                                   |                                                                                                         |
| ----------------------------------------------------------------- | :-----------------------------------------------------------------------------------------------------: |
| **Description**                                                   |                                                **Links**                                                |
| Create your first function in the Azure portal                    |        <https://docs.microsoft.com/azure/azure-functions/functions-create-first-azure-function>         |
| Store unstructured data using Azure Functions and Azure Cosmos DB | <https://docs.microsoft.com/azure/azure-functions/functions-integrate-store-unstructured-data-cosmosdb> |

[Next challenge (Monitoring) >](./Monitoring.md)
