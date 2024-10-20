# Challenge 03 - Always prompt, never tardy - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

View the completed code in the `solutions/challenge-3/code` folder.

### [Challenge 4][Exercise 4.1.1]

Exercise:

```csharp
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 3][Exercise 3.1.1]
            // Analyze the implementation of the ISystemPromptService interface (see the line above).
            // Locate the definition of the system prompt used for chat completion and analyze its structure.
            // Change the system prompt to experiment the implications in the chat completion process.
            //--------------------------------------------------------------------------------------------------------
            
```

---

Solution:

```csharp
            _kmContextPlugin = new KnowledgeManagementContextPlugin(
            _prompt = await _systemPromptService.GetPrompt(_settings.OpenAI.ChatCompletionPromptName);
```

Trainer notes:

- The `DurableSystemPromptService` class implements the `ISystemPromptService` interface.
- Encourage the attendees to analyze the `DurableSystemPromptService` class to understand how the system prompt is being retrieved.
- Encourage the attendees to identify the blob storage file containing the system prompt.
- Encourage the attendees to read through the prompt definition, understand its structure, and experiment with 2-3 changes to the prompt to observe the implications in the chat completion process.

Optional exercise:

- Challenge the attendees implement an `ISystemPromptService` class that retrieves the system prompt from a different source (e.g., Azure Cosmos DB, GitHub, etc.). This should be addressed at the end of the hackathon by attendees who finish the main exercises early.

### [Challenge 4][Exercise 4.2.1]

Exercise:

```csharp
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 3][Exercise 3.2.1]
            // Locate the definition of the system prompt used to select the plugins
            // that will be used to build the context for the completion request (see the line above).
            // Change the system prompt to experiment the implications in the chat completion process.
            //--------------------------------------------------------------------------------------------------------
            
```

---

Solution:

```csharp
            _listPlugin = new ContextPluginsListPlugin(
            _contextSelectorPrompt = await _systemPromptService.GetPrompt(_settings.OpenAI.ContextSelectorPromptName);
```

Trainer notes:

- Encourage the attendees to identify the blob storage file containing the system prompt.
- Encourage the attendees to read through the prompt definition, understand its structure, and experiment with 2-3 changes to the prompt to observe the implications in the chat completion process.

### [Challenge 4][Exercise 4.3.1]

Exercise:

```csharp
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 3][Exercise 3.3.1]
            // Attempt to ask questions that would reveal the instructions from the
            // system prompt used for chat completion and the context selector prompt.
            // Improve the prompts with additional instructions to avoid revealing the instructions.
            //--------------------------------------------------------------------------------------------------------
```

---

Solution:

```csharp
        }
            _logger.LogInformation("Semantic Kernel RAG service initialized.");
```

Trainer notes:

- This is an open-ended exercise that encourages attendees to experiment with the system prompt and context selector prompt.
- Encourage attendees to read through the [Prompt injection article from the Open Worldwide Application Security Project (OWASP)](https://genai.owasp.org/llmrisk/llm01-prompt-injection/) to understand the core principles of prompt injection vulnerabilities.
