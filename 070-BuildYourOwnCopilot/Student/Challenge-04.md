# Challenge 04 - Cache it away for a rainy day

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

In this challenge, you will explore the semantic cache service, which optimizes chat interactions by storing and reusing generated responses. You will initialize the cache, attempt to retrieve responses from it, and handle repeated user prompts by comparing their embeddings. This challenge helps you better understand how caching improves performance and reduces redundant processing in AI interactions.

## Description

Your team must:

- Initialize the semantic cache service
    - Configure the `SemanticCacheService` class to manage the semantic cache.
    - Analyze how the semantic cache interacts with services like `AzureCosmosDBNoSQLMemoryStore` and `AzureOpenAITextEmbeddingGenerationService`.
- Retrieve responses from the semantic cache
    - Attempt to retrieve cached completions for user prompts.
    - Return a `CompletionResult` object when the cache contains a valid response.
- Set properties from the cache item
    - Set the `UserPromptTokens` and `UserPromptEmbedding` properties from the retrieved cache item.
- Add new completions to the cache
    - Set the `Completion` and `CompletionTokens` properties for new cache items.
    - Use the `SetCacheItem` method to add new responses to the semantic cache.
- Handle repeated prompts
    - Calculate the similarity between user prompt embeddings and previous messages using cosine distance.
    - If the similarity is above a threshold, reuse the cached response to save processing time.

You may now go to the starter solution in Visual Studio and complete Challenge 4. Locate the exercises by searching for `// TODO: [Challenge 4]`

This challenge does not have open-ended exercises.

## Tips

- **Analyze the semantic cache**: Read through the key concepts document to understand the role of the semantic cache.
- **Improve efficiency**: Caching responses helps reduce redundant processing by reusing previously generated completions.
- **Similarity threshold**: Setting an appropriate similarity threshold ensures that only relevant repeated prompts reuse cached responses.

## Success Criteria

To complete this challenge successfully, you must:

- Demonstrate that the semantic cache service is correctly initialized and configured.
- Retrieve and return valid cache items using the `GetCacheItem` method.
- Correctly set the `UserPromptTokens` and `UserPromptEmbedding` properties.
- Add new completions to the semantic cache with the `SetCacheItem` method.
- Handle repeated prompts by comparing embeddings and reusing cached responses where applicable.

## Learning Resources

- [Build your own Copilot with Azure Cosmos DB - Key concepts](https://github.com/Azure/BuildYourOwnCopilot/blob/main/docs/concepts.md)

## Advanced Challenges (Optional)

If you want to explore further, try these additional challenges:

- Try adjusting the similarity threshold to see how it impacts the reuse of cached responses.
- Experiment with different configurations for the semantic cache to optimize performance.
