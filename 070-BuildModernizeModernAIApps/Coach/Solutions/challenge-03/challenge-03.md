# Solution for Challenge 03

[Watch the Train the Trainer video for Challenge 3](https://aka.ms/vsaia.hack.ttt.03)
[Deck for the Challenge](Challenge%203.pptx)

1. `ChatBuilder.cs`

The `WithMemories` method populates the `_memories` private property in `ChatBuilder`. It uses `EmbeddingUtility.Transform` to get the text representation of the entities in the memories. The `Transform` method uses the `ModelRegistry` to determine the type of the entity and the `EmbeddingField` attribute to determine the prefix used when serializing the property value to text. The `ModelRegistry` is also used to determine the name of the entity, using the `NamingProperties` attribute. For more details, see [Solution notes](../../solution-notes.md)

`memoriesPrompt` will be a simple concatenation of the JSON representations of the objects from `_memories`.

The `AddSystemMessage` method adds a system message to the chat. The message to be added is the system prompt stored in `_systemPrompt` when `WithSystemPrompt` is called.

The `AddMesage` method adds the user message to the chat. The messages are stored in `_messages` when `WithMessageHistory` is called. The `AuthorRole` property on each message is defined by Semantic Kernel and can be one of `system`, `assistant`, or `user`.

2. `ChatService.cs`

The prompt message shoud contain the sender name (`user`), the number of user prompt tokens (`result.UserPromptTokens`), the user prompt and the embedding of the user prompt.

The completion message should contain the sender name (`assistant`), the number of response tokens (`result.ResponseTokens`), and the text of completion.

3. `SemanticKernelRAGService.cs`

The `WithSystemPrompt` method sets the `_systemPrompt` private property in `ChatBuilder`.

The `WithMemories` method sets the `_memories` private property in `ChatBuilder`.

The `WithMessageHistory` method sets the `_messages` private property in `ChatBuilder`.

A chat completion Semantic Kernel flow returns one or more completions. For the purpose of this exercise we are only interested in the first completion, returned by `completionResults[0]`.

When returning results:

- The completion is available in `reply.Content`.
- The user prompt is the first message in the chat history.
- The tokens consumptions are available in `rawResult.Usage`.
- The user prompt embedding is available in `userPromptEmbedding` (retrieved earlier as the last embedding returned by the `TextEmbeddingObjectMemorySkill`).
