# Challenge 2

## [Challenge 2][Exercise 2.1.1]
Exercise:
```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 2][Exercise 2.1.1]
        // Explore setting up a Semantic Kernel kernel.
        // Explore the use of completion services in the kernel (see the lines above).
        // Explore the setup for the Azure OpenAI-based chat completion service.
        //--------------------------------------------------------------------------------------------------------
        _semanticKernel = builder.Build();
```
---
Solution:
```csharp
        _semanticKernel = builder.Build();
```

## [Challenge 2][Exercise 2.2.1]
Exercise:
```csharp
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 2][Exercise 2.2.1]
            // Explore importing plugins into a Semantic Kernel kernel.
            // Explore the implementation of the KnowledgeManagementContextPlugin plugin.
            //--------------------------------------------------------------------------------------------------------
            _semanticKernel.ImportPluginFromObject(_kmContextPlugin);
```
---
Solution:
```csharp
            _semanticKernel.ImportPluginFromObject(_kmContextPlugin);
```

## [Challenge 2][Exercise 2.3.1]
Exercise:
```csharp
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 2][Exercise 2.3.1]
            // Explore importing plugins into a Semantic Kernel kernel.
            // Explore the implementation of the ContextPluginsListPlugin plugin.
            //--------------------------------------------------------------------------------------------------------
            _semanticKernel.ImportPluginFromObject(_listPlugin);
```
---
Solution:
```csharp
            _semanticKernel.ImportPluginFromObject(_listPlugin);
```

## [Challenge 2][Exercise 2.4.1]
Exercise:
```csharp
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 2][Exercise 2.4.1]
            // Explore using vector stores with a Semantic Kernel kernel.
            // Explore the implementation of the VectorMemoryStore class which enables us to use multiple memory store
            // implementations provided by Semantic Kernel.
            //--------------------------------------------------------------------------------------------------------
            var memoryStore = new VectorMemoryStore(
```
---
Solution:
```csharp
            var memoryStore = new VectorMemoryStore(
```

## [Challenge 2][Exercise 2.5.1]
Exercise:
```csharp
                //--------------------------------------------------------------------------------------------------------
                // TODO: [Challenge 2][Exercise 2.5.1]
                // Explore the CosmosDB memory store implementation from Semantic Kernel.
                //--------------------------------------------------------------------------------------------------------
                new AzureCosmosDBNoSQLMemoryStore(
```
---
Solution:
```csharp
                new AzureCosmosDBNoSQLMemoryStore(
```

## [Challenge 2][Exercise 2.6.1]
Exercise:
```csharp
                //--------------------------------------------------------------------------------------------------------
                // TODO: [Challenge 2][Exercise 2.6.1]
                // Explore the use of text embedding services in the kernel.
                // Explore the setup for the Azure OpenAI-based text embedding service.
                //--------------------------------------------------------------------------------------------------------
                new AzureOpenAITextEmbeddingGenerationService(
```
---
Solution:
```csharp
                new AzureOpenAITextEmbeddingGenerationService(
```

## [Challenge 2][Exercise 2.7.1]
Exercise:
```csharp
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 2][Exercise 2.7.1]
            // Explore importing plugins into a Semantic Kernel kernel.
            // Explore the implementation of the MemoryStoreContextPlugin plugin.
            //--------------------------------------------------------------------------------------------------------
            _contextPlugins.Add(new MemoryStoreContextPlugin(
```
---
Solution:
```csharp
            _contextPlugins.Add(new MemoryStoreContextPlugin(
```

