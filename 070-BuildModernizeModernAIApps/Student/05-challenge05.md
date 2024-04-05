# Challenge 5: It's All About the Payload, The Sequel

What you've built so far is a pattern you can use with any type of data. You've built a process that can be used to load data from a storage account into Cosmos DB and then run a process that stores both documents and vector embeddings in Azure Cognitive Search. Now it's time to test your pattern by loading a completely new type of data.

The solution provided by Cosmicworks is specific to Product, Customer and SalesOrder data. In this challenge you will extend the solution so that it can handle any type of data in the JSON format.

## Challenge

Your team must:

1. Create a container named `sourcedata` in Cosmos DB.
2. Create a new entity for the JSON document data type in the starter project.
3. Create a new change feed processor that monitors the `sourcedata` container and works with instances of your new data type.
4. Load data of the new type into Cosmos DB.
5. Use the chat interface to ask questions about the new data type.

### Hints

- With the starter solution supplied by CosmicWorks open in Visual Studio, expand the VectorSearchAiAssistant.Service project, Models, Search and take a look at Product.cs. This class is required to process the data with the Cosmos DB change feed and is also used as the schema for the document added to the Cognitive Search index. You will need to define an entity similar to this for your new type of data.
- Extend the implementation of the `ModelRegistry` class to include your newly created data type.
- Review the implementation of the change feed processor located in the same project under Services, CosmosDbService.cs to validate it is ready to use your new data type. 
- In SemanticKernelRAGService.cs update the setup of the `_memoryTypes` in the SemanticKernelRAGService constructor to include your new type that will be used to initialize the Search index. 

### Success Criteria

To complete this challenge successfully, you must:

- Show your coach the new data that you created and then your chat history showing how it responded using the new data as context. 
- Try to locate the new product or customer data you loaded in the Cognitive Search Index and in Cosmos DB.

### Resources

- [Change feed processor in Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/change-feed-processor?tabs=dotnet)

## Explore Further

- [Reading from the change feed](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/read-change-feed)
