# Challenge 5

## [Challenge 5][Exercise 5.1.1]
Exercise:
```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 5][Exercise 5.1.1]
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

## [Challenge 5][Exercise 5.2.1]
Exercise:
```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 5][Exercise 5.2.1]
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

## [Challenge 5][Exercise 5.3.1]
Exercise:
```csharp
                UserPromptTokens = 0, // TODO: [Challenge 5][Exercise 5.3.1] Set the user prompt tokens from the cache item.
```
---
Solution:
```csharp
                UserPromptTokens = cacheItem.UserPromptTokens,
```
Exercise:
```csharp
                UserPromptTokens = 0, // TODO: [Challenge 5][Exercise 5.3.1] Set the user prompt tokens from the cache item.
```
---
Solution:
```csharp
                UserPromptTokens = cacheItem.UserPromptTokens,
```
Exercise:
```csharp
            UserPromptTokens = 0, // TODO: [Challenge 5][Exercise 5.3.1] Set the user prompt tokens from the cache item.
```
---
Solution:
```csharp
            UserPromptTokens = cacheItem.UserPromptTokens,
```

## [Challenge 5][Exercise 5.3.2]
Exercise:
```csharp
                UserPromptEmbedding = [], // TODO: [Challenge 5][Exercise 5.3.2] Set the user prompt embedding from the cache item.
```
---
Solution:
```csharp
                UserPromptEmbedding = cacheItem.UserPromptEmbedding.ToArray(),
```
Exercise:
```csharp
                UserPromptEmbedding = [], // TODO: [Challenge 5][Exercise 5.3.2] Set the user prompt embedding from the cache item.
```
---
Solution:
```csharp
                UserPromptEmbedding = cacheItem.UserPromptEmbedding.ToArray(),
```
Exercise:
```csharp
            UserPromptEmbedding = [], // TODO: [Challenge 5][Exercise 5.3.2] Set the user prompt embedding from the cache item.
```
---
Solution:
```csharp
            UserPromptEmbedding = cacheItem.UserPromptEmbedding.ToArray(),
```

## [Challenge 5][Exercise 5.4.1]
Exercise:
```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 5][Exercise 5.4.1]
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

## [Challenge 5][Exercise 5.5.1]
Exercise:
```csharp
                //--------------------------------------------------------------------------------------------------------
                // TODO: [Challenge 5][Exercise 5.5.1]
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

