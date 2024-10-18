# Challenge 03 - What's Your Vector, Victor? - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

[Watch the Train the Trainer video for Challenge 4](https://aka.ms/vsaia.hack.ttt.05)

1. Create the `campaign` container in Cosmos DB. Use default settings for the container and a partition key of `/campaignId`.
2. Add the `Campaign` class to the `VectorSearchAiAssistant.Service` project under `Models/Search`.
3. Add the new entity to the model registry in `ModelRegistry.cs` in the `VectorSearchAiAssistant.Service` project, under the `Models` folder. For more details, see [Solution notes](../../solution-notes.md).
4. Create two new campaign documents in Cosmos DB:

```json
{
    "campaignId": "campaign-1",
    "campaignName": "Three for two",
    "campaignDescription": "Buy any three products and get the cheapest one for free"
}
```

```json
{
    "campaignId": "campaign-2",
    "campaignName": "Buy one get one free",
    "campaignDescription": "Buy any product and get the cheapest one for free"
}
```

5. Add the new container to the Cosmos DB configuration in `appsettings.json` in the `VectorSearchAiAssistant.Service` project. The configuration should look like this:

```json
   "CosmosDB": {
      "Containers": "completions, customer, product, campaign",
      "MonitoredContainers": "customer, product, campaign",
```

6. Run the `ChatWebServiceApi` project in debug and validate that the Cognitive Search index was expanded with the new entities (both the definition and the content).

Hint: Set one breakpoint at line 126 in `AzureCognitiveSearchService.cs` and another one at line 149 in `CosmosDbService.cs` to see the data flow.

7. Ask questions about the newly vectorized campaigns, for example:

`Are you currently running any three for two campaigns?`
