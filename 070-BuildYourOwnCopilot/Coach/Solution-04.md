# Challenge 04 - Cache it away for a rainy day - Coach's Guide

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

View the completed code in the `solutions/challenge-4/code` folder.

### [Challenge 4][Exercise 4.1.1]

Exercise:

```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 4][Exercise 4.1.1]
        // Initialize the semantic cache service here.
        //--------------------------------------------------------------------------------------------------------
```

---

Solution:

```csharp
        _semanticCache = new SemanticCacheService(
            _settings.SemanticCache,
            _settings.OpenAI,
            _settings.SemanticCacheIndexing,
            cosmosDBClientFactory,
            _tokenizerService,
            _settings.TextSplitter.TokenizerEncoder!,
            loggerFactory);
```

Coach notes:

- Encourage attendees to read again the [Key Concepts](https://github.com/Azure/BuildYourOwnCopilot/blob/main/docs/concepts.md) document from the solution accelerator repository to understand the role of the semantic cache in the solution accelerator.
- The `SemanticCacheService` class is responsible for managing the semantic cache. Encourage attendees to analyze the class to understand how the cache is being managed.
- Note how the cache relies on the `AzureCosmosDBNoSQLMemoryStore` and `AzureOpenAITextEmbeddingGenerationService` services to store, vectorize, and retrieve cache items.

Suggested reading:

- [Build Your Own Copilot with Azure Cosmos DB - Key Concepts](https://github.com/Azure/BuildYourOwnCopilot/blob/main/docs/concepts.md)

## [Challenge 4][Exercise 4.2.1]

Exercise:

```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 4][Exercise 4.2.1]
        // Attempt to retrieve the completion from the semantic cache and return it.
        // var cacheItem = ...
        // if (!string.IsNullOrEmpty(cacheItem.Completion))
        // {
        //     return new CompletionResult ...
        // }
        //--------------------------------------------------------------------------------------------------------
```

---

Solution:

```csharp
        var cacheItem = await _semanticCache.GetCacheItem(userPrompt, messageHistory);
        if (!string.IsNullOrEmpty(cacheItem.Completion))
            // If the Completion property is set, it means the cache item was populated with a hit from the cache
            return new CompletionResult
            {
                UserPrompt = userPrompt,
                UserPromptTokens = cacheItem.UserPromptTokens,
                UserPromptEmbedding = cacheItem.UserPromptEmbedding.ToArray(),
                RenderedPrompt = cacheItem.ConversationContext,
                RenderedPromptTokens = cacheItem.ConversationContextTokens,
                Completion = cacheItem.Completion,
                CompletionTokens = cacheItem.CompletionTokens,
                FromCache = true
            };
```

Coach notes:

- The `GetCacheItem` method is responsible for retrieving a cache item from the semantic cache.
- This method should be used to attempt to retrieve a completion from the semantic cache to avoid going through the full pipeline.
- If the cache item being retrieved contains a non-empty completion, a `CompletionResult` object should be returned with the cache item's information.
- Encourage attendees to analyze the definition of the `CompletionResult` class to understand the information that should be returned.

## [Challenge 4][Exercise 4.3.1]

Exercise:

```csharp
                UserPromptTokens = 0, // TODO: [Challenge 4][Exercise 4.3.1] Set the user prompt tokens from the cache item.
```

---

Solution:

```csharp
                UserPromptTokens = cacheItem.UserPromptTokens,
```

Coach notes:

- The `UserPromptTokens` property should be set to the value of the `UserPromptTokens` property of the cache item.
- Encourage attendees to understand how is the `UserPromptTokens` property being populated in the `SemanticCacheService` class.

## [Challenge 4][Exercise 4.3.2]

Exercise:

```csharp
                UserPromptEmbedding = [], // TODO: [Challenge 4][Exercise 4.3.2] Set the user prompt embedding from the cache item.
```

---

Solution:

```csharp
                UserPromptEmbedding = cacheItem.UserPromptEmbedding.ToArray(),
```

Coach notes:

- The `UserPromptEmbedding` property should be set to the value of the `UserPromptEmbedding` property of the cache item.
- Encourage attendees to understand how is the `UserPromptEmbedding` property being populated in the `SemanticCacheService` class.

## [Challenge 4][Exercise 4.4.1]

Exercise:

```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 4][Exercise 4.4.1]
        // Set the completion and the completion tokens count on the cache item and then add then add it to the semantic memory.
        //--------------------------------------------------------------------------------------------------------
```

---

Solution:

```csharp
        cacheItem.Completion = completion;
        cacheItem.CompletionTokens = completionUsage!.CompletionTokens;
        await _semanticCache.SetCacheItem(cacheItem);
```

Coach notes:

- At this point, the completion is a new item that should be added to the semantic cache.
- The `cacheItem` object should have the `Completion` and `CompletionTokens` properties set to the completion and the completion tokens count, respectively.
- The `SetCacheItem` method should be used to add the cache item to the semantic cache.

## [Challenge 4][Exercise 4.5.1]

Exercise:

```csharp
                //--------------------------------------------------------------------------------------------------------
                // TODO: [Challenge 4][Exercise 4.5.1]
                // Handle the particular case when the user asks the same question (or a very similar one) as the previous one.
                // Calculate the similarity between cacheItem.UserPromptEmbedding and userMessageHistory.Last().Vector.
                // If the similarity is above a certain threshold, return the cache item ensuring you update ConversationContext, ConversationContextTokens, Completion, and CompletionTokens.
                //--------------------------------------------------------------------------------------------------------
```

---

Solution:

```csharp
                var similarity = 1 - Distance.Cosine(cacheItem.UserPromptEmbedding.ToArray(), userMessageHistory.Last().Vector!);
                if (similarity >= MinRelevance)
                {
                    // Looks like the user just repeated the previous question
                    cacheItem.ConversationContext = userMessageHistory.Last().Text;
                    cacheItem.ConversationContextTokens = userMessageHistory.Last().TokensSize!.Value;
                    cacheItem.Completion = assistantMessageHistory.Last().Text;
                    cacheItem.CompletionTokens = assistantMessageHistory.Last().TokensSize!.Value;

                    return cacheItem;
                }
```

Trainer notes:

- This is a semi-open exercise that requires attendees to calculate the similarity between the user prompt embedding of the cache item and the vector of the last message in the user message history.
- This similarity calculation should be done using the cosine distance.
- This exercise addresses the case when the user asks the same question (or a very similar one) as the previous one. The typical example is when users start their conversation with "Hi" or "Hello" in multiple interactions.
