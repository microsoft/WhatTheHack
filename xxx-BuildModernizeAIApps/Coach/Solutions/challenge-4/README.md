# Challenge 4

## [Challenge 4][Exercise 4.1.1]
Exercise:
```csharp
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 4][Exercise 4.1.1]
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

## [Challenge 4][Exercise 4.2.1]
Exercise:
```csharp
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 4][Exercise 4.2.1]
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

## [Challenge 4][Exercise 4.3.1]
Exercise:
```csharp
            
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 4][Exercise 4.3.1]
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

