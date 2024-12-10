# Challenge 01 - Finding the kernel of truth - Coach's Guide

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

View the completed code in the `solutions/challenge-1/code` folder.

### [Challenge 1][Exercise 1.1.1]

Exercise:

```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 1][Exercise 1.1.1]
        // Explore setting up a Semantic Kernel kernel.
        // Explore the use of completion services in the kernel (see the lines above).
        // Explore the setup for the Azure OpenAI-based chat completion service.
        //--------------------------------------------------------------------------------------------------------
        _semanticKernel = builder.Build();
```

---

Trainer notes:

- The Kernel is the core component of the Semantic Kernel library. It is responsible for managing the context and plugins, and for providing the completion services.
- The Kernel builder is used to configure the Kernel and its dependencies.
- The Kernel builder supports dependency injection.
- Semantic Kernel provides a set of extension methods to configure the Kernel builder with the required services.
- The `AddAzureOpenAIChatCompletion` extension method is used to configure the Azure OpenAI-based chat completion service.
- Encourage the participants to identify the Azure OpenAI account they deployed, its endpoint, completion model deployment and API key.

Suggested reading:

- [Understanding the kernel](https://learn.microsoft.com/semantic-kernel/concepts/kernel?pivots=programming-language-csharp)

### [Challenge 1][Exercise 1.2.1]

Exercise:

```csharp
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 1][Exercise 1.2.1]
            // Explore importing plugins into a Semantic Kernel kernel.
            // Explore the implementation of the KnowledgeManagementContextPlugin plugin.
            //--------------------------------------------------------------------------------------------------------
            _semanticKernel.ImportPluginFromObject(_kmContextPlugin);
```

---

Trainer notes:

- Plugins are a key component of Semantic Kernel. If you have already used plugins from ChatGPT or Copilot extensions in Microsoft 365, you’re already familiar with them. With plugins, you can encapsulate your existing APIs into a collection that can be used by an AI. This allows you to give your AI the ability to perform actions that it wouldn’t be able to do otherwise.
- Behind the scenes, Semantic Kernel leverages function calling, a native feature of most of the latest LLMs to allow LLMs, to perform planning and to invoke your APIs. With function calling, LLMs can request (i.e., call) a particular function. Semantic Kernel then marshals the request to the appropriate function in your code base and returns the results back to the LLM so the LLM can generate a final response.
- The RAG context is built dynamically using the plugins that are imported into the kernel. The plugins are used to provide the context for the LLM to generate responses.
- The main plugin used to generate the context is `KnowledgeManagementContextPlugin`. It uses a list of more atomic plugins, the `MemoryStoreContextPlugin` plugins which retrieve data from a vector memory store.
- Encourage the participants to explore the implementation of the `KnowledgeManagementContextPlugin` and `MemoryStoreContextPlugin` plugins.
- Encourage the participants to explore the chain of calls that leads to the call of the `SetContextPlugins` method in the `KnowledgeManagementContextPlugin` plugin.
- Note that vector memory stores are the focus of one of the following exercises.

Suggested reading:

- [What is a Plugin?](https://learn.microsoft.com/semantic-kernel/concepts/plugins/?pivots=programming-language-csharp)
- [How to use function calling with Azure OpenAI Service](https://learn.microsoft.com/azure/ai-services/openai/how-to/function-calling)

### [Challenge 1][Exercise 1.3.1]

Exercise:

```csharp
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 1][Exercise 1.3.1]
            // Explore importing plugins into a Semantic Kernel kernel.
            // Explore the implementation of the ContextPluginsListPlugin plugin.
            //--------------------------------------------------------------------------------------------------------
            _semanticKernel.ImportPluginFromObject(_listPlugin);
```

---

Trainer notes:

- One of the immediate questions raised by the previous exercise is how are the context plugins selected and used by the LLM. The `ContextPluginsListPlugin` plugin is responsible for managing the list of context plugins that are used by the LLM.
- Encourage the attendees to explore the implementation of the `ContextPluginsListPlugin` plugin.
- Note how the main role of the `ContextPluginsListPlugin` plugin is to create a list of plugin names and descriptions which are later used by the LLM to decide which plugins to use.
- Note the capability of an LLM to correlate the user question with the descriptions of plugins.

Suggested reading:

- [What is a Planner?](https://learn.microsoft.com/semantic-kernel/concepts/planning?pivots=programming-language-csharp)

### [Challenge 1][Exercise 1.4.1]

Exercise:

```csharp
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 1][Exercise 1.4.1]
            // Explore using vector stores with a Semantic Kernel kernel.
            // Explore the implementation of the VectorMemoryStore class which enables us to use multiple memory store
            // implementations provided by Semantic Kernel.
            //--------------------------------------------------------------------------------------------------------
            var memoryStore = new VectorMemoryStore(
                item.IndexName,
                
                new AzureCosmosDBNoSQLMemoryStore(
                    _cosmosDBClientFactory.Client,
                    _cosmosDBClientFactory.DatabaseName,
                    item.VectorEmbeddingPolicy,
                    item.IndexingPolicy),
                
                new AzureOpenAITextEmbeddingGenerationService(
                    _settings.OpenAI.EmbeddingsDeployment,
                    _settings.OpenAI.Endpoint,
                    _settings.OpenAI.Key,
                    dimensions: (int)item.Dimensions),
                _loggerFactory.CreateLogger<VectorMemoryStore>()
            );

            _longTermMemoryStores.Add(memoryStore.CollectionName, memoryStore);
            
            _contextPlugins.Add(new MemoryStoreContextPlugin(
                memoryStore,
                item,
                _loggerFactory.CreateLogger<MemoryStoreContextPlugin>()));
```

---

Trainer notes:

- The `VectorMemoryStore` is a key abstraction of the solution accelerator that allows the LLM to interact with multiple memory stores implemented by Semantic Kernel.
- The `VectorMemoryStore` class is a wrapper around the `IMemoryStore` interface that provides the fundamental operations for a memory store: add memory, remove memory, and get all the memories that are closes to a give chunk of text or a vector.
- Encourage the attendees to explore the implementation of the `VectorMemoryStore` class.

### [Challenge 1][Exercise 1.5.1]

Exercise:

```csharp
                //--------------------------------------------------------------------------------------------------------
                // TODO: [Challenge 1][Exercise 1.5.1]
                // Explore the CosmosDB memory store implementation from Semantic Kernel.
                //--------------------------------------------------------------------------------------------------------
                new AzureCosmosDBNoSQLMemoryStore(
                    _cosmosDBClientFactory.Client,
                    _cosmosDBClientFactory.DatabaseName,
                    item.VectorEmbeddingPolicy,
                    item.IndexingPolicy),
```

Trainer notes:

- The `AzureCosmosDBNoSQLMemoryStore` class is an implementation of the `IMemoryStore` interface that provides the fundamental operations for a memory store using Azure Cosmos DB.
- Encourage the attendees to explore the implementation of the `AzureCosmosDBNoSQLMemoryStore` class.
- Encourage the attendees to take a close look at the `UpsertAsync` method that is used to add or update a memory in the memory store. 
- Encourage the attendees to take a close look at the `MemoryRecord` class that is used by Semantic Kernel to represent a memory in the memory store.
- Encourage the attendees to take a close look at the `GetNearestMatchesAsync` method that is used to retrieve the memories that are closest to a given vector. Note the query used to retrieve the memories.
- Encourage the attendees to take a close look at the `CreateCollectionAsync` method that is used to create a vector store collection in the Cosmos DB database. Note the indexing policy and the vector embedding policy used to create the collection.
- Encourage the attendees to explore the Azure Cosmos DB account they deployed, the database, and the vector store collections created by the solution accelerator.

### [Challenge 1][Exercise 1.6.1]

Exercise:

```csharp
                //--------------------------------------------------------------------------------------------------------
                // TODO: [Challenge 1][Exercise 1.6.1]
                // Explore the use of text embedding services in the kernel.
                // Explore the setup for the Azure OpenAI-based text embedding service.
                //--------------------------------------------------------------------------------------------------------
                new AzureOpenAITextEmbeddingGenerationService(
                    _settings.OpenAI.EmbeddingsDeployment,
                    _settings.OpenAI.Endpoint,
                    _settings.OpenAI.Key,
                    dimensions: (int)item.Dimensions),
                _loggerFactory.CreateLogger<VectorMemoryStore>()
            );

            _longTermMemoryStores.Add(memoryStore.CollectionName, memoryStore);
```

---

Trainer notes:

- The `AzureOpenAITextEmbeddingGenerationService` class is an implementation of the `ITextEmbeddingGenerationService` interface that provides the fundamental operations for a text embedding service using Azure OpenAI.
- Encourage the participants to identify the Azure OpenAI account they deployed, its endpoint, embedding model deployment and API key.
- Note how embeddings are core to implementing a RAG pattern.
- Encourage attendees to explore how items added to Cosmos DB are embedded using the Azure OpenAI text embedding service.
- Explain how the Cosmos DB change feed capability is used to update the embeddings of the memories in the memory store.
- Encourage attendees to explore the `CosmosDBService.StartChangeFeedProcessors` and `CosmosDBService.GenericChangeFeedHandler` methods.
- Encourage attendees to read again the [Key Concepts](https://github.com/Azure/BuildYourOwnCopilot/blob/main/docs/concepts.md) document from the solution accelerator repository to understand the role of embeddings in the solution accelerator.

Suggested reading:

- [Embeddings](https://platform.openai.com/docs/guides/embeddings/use-cases)
- [Build Your Own Copilot with Azure Cosmos DB - Key Concepts](https://github.com/Azure/BuildYourOwnCopilot/blob/main/docs/concepts.md)

### [Challenge 1][Exercise 1.7.1]

Exercise:

```csharp
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 1][Exercise 1.7.1]
            // Explore importing plugins into a Semantic Kernel kernel.
            // Explore the implementation of the MemoryStoreContextPlugin plugin.
            //--------------------------------------------------------------------------------------------------------
            _contextPlugins.Add(new MemoryStoreContextPlugin(
                memoryStore,
                item,
                _loggerFactory.CreateLogger<MemoryStoreContextPlugin>()));
```

---

Trainer notes:

- Note how everything comes together in the `MemoryStoreContextPlugin` plugin. This plugin is responsible for retrieving the memories from the memory store and providing them to the LLM.
- Encourage the attendees to explore the implementation of the `MemoryStoreContextPlugin` plugin.
- The solution accelerator uses two types of memory stores: long-term memory stores (with persisted memories) and short-term memory stores (with memories that are kept in memory for a short period of time).
- Note how the list of context plugins contains several long-term ones and one short-term one.
- Note how the list of long-term memory context plugins is driven by the `ModelRegistryKnowledgeIndexing` application setting. Encourage attendees to explore the relevant sections of the `appsettings.json` file in the `ChatAPI` project.
- Semantic Kernel provides the `VolatileMemoryStore` class to implement short-term memory stores.
- Encourage the attendees to explore the initialization of the short-term memory store via the `EnsureShortTermMemory` method.
- Challenge the attendees to identify the sources of the short-term memories in the storage account deployed by the solution accelerator.
