# Challenge 05 - Do as the Colonel commands - Coach's Guide

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)**

## Notes & Guidance

View the completed code in the `solutions/challenge-5/code` folder.

### [Challenge 5][Exercise 5.1.1]

Exercise:

```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 5][Exercise 5.1.1]
        // Add system command plugins to the list of context builder plugins.
        // The list of system command plugins is available in _settings.SystemCommandPlugins.
        //--------------------------------------------------------------------------------------------------------
```

---

Solution:

```csharp
        _contextPlugins.AddRange(
            _settings.SystemCommandPlugins.Select(
                sp => new SystemCommandPlugin(sp.Name, sp.Description, sp.PromptName)));
```

Trainer notes:

- Encourage attendees to read again the [Key Concepts](https://github.com/Azure/BuildYourOwnCopilot/blob/main/docs/concepts.md) document from the solution accelerator repository to understand the role of the system commands in the solution accelerator.
- The `SystemCommandPlugin` class is responsible for managing the system commands. Encourage attendees to analyze the class to understand how the system commands are being managed.
- The `SystemCommandPlugins` property in the `appsettings.json` configuration file contains the list of system command plugins that are available in the solution accelerator. Encourage attendees to analyze the `appsettings.json` configuration file in the `ChatAPI` project to understand how the system command plugins are being configured.

Suggested reading:

- [Build Your Own Copilot with Azure Cosmos DB - Key Concepts](https://github.com/Azure/BuildYourOwnCopilot/blob/main/docs/concepts.md)

### [Challenge 5][Exercise 5.2.1]

Exercise:

```csharp
                    //--------------------------------------------------------------------------------------------------------
                    // TODO: [Challenge 5][Exercise 5.2.1]
                    // Invoke the Reset method on the semantic cache service.
                    // Add a relevant message to the results list to inform the user about the reset.
                    //--------------------------------------------------------------------------------------------------------
```

---

Solution:

```csharp
                    await _semanticCache.Reset();
                    results.Add("The content of the semantic cache was reset.");
```

Trainer notes:

- The `Reset` method is responsible for resetting the semantic cache.

### [Challenge 5][Exercise 5.3.1]

Exercise:

```csharp
                    //--------------------------------------------------------------------------------------------------------
                    // TODO: [Challenge 5][Exercise 5.3.1]
                    // Invoke the SetMinRelevanceOverride method on the semantic cache service.
                    // Add a relevant message to the results list to inform the user about the change.
                    // Compared to handling the cache reset, this exercise is more challenging because you will need to find
                    // a way to extract the numerical value from the user prompt and set it as the new minimum relevance override.
                    // Note the GetSemanticCacheSimilarityScore method that you can use to parse the similarity score from the user prompt.
                    //--------------------------------------------------------------------------------------------------------
```

---

Solution:

```csharp
                    var similarityScore = await GetSemanticCacheSimilarityScore(userPompt, pluginName);
                    var newSimilarityScore = similarityScore == 1 
                        ? 1
                        : similarityScore;

                    _semanticCache.SetMinRelevanceOverride(newSimilarityScore);

                    results.Add(similarityScore == 1
                        ? "The similarity score parser was not able to parse a value for the similarity score of the semantic cache. The default value of 0.95 will be used."
                        : $"The similarity score {similarityScore} was set for the semantic cache. The new score will be in effect until the backend API is restarted.");
```

Trainer notes:

- The `SetMinRelevanceOverride` method is responsible for setting the minimum relevance override in the semantic cache.
- Handling this system command is more difficult than the previous one because the actual value of the similarity score must be retrieved from the user message. Suggest attendees use the `GetSemanticCacheSimilarityScore` method to parse the similarity score from the user prompt. Note that the full implementation of the method is the subject of the next exercise.

### [Challenge 5][Exercise 5.3.2]

Exercise:

```csharp
        
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 5][Exercise 5.3.2]
        // Check out the prompt that is already configured for the plugin.
        // Invoke the prompt to get a structured response that you can then parse to extract the numerical value.
        // Note the ParsedSimilarityScore model which is already available and aligned with the prompt structure.
        //--------------------------------------------------------------------------------------------------------
        return 0.95;
```

---

Solution:

```csharp

        var result = await _semanticKernel.InvokePromptAsync(
            pluginPrompt,
            new KernelArguments()
            {
                ["userPrompt"] = userPrompt
            });
        var serializedSimilarityScore = result.GetValue<string>();

        try
        {
            var score = JsonSerializer.Deserialize<ParsedSimilarityScore>(serializedSimilarityScore!);
            return score == null
                ? 1
                : score.SimilarityScore;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error when parsing similarity score: {ErrorMessage}", ex.Message);
            return 1;
        }
```

Trainer notes:

- Attendees should use the `InvokePromptAsync` method to invoke the prompt that is already configured for the plugin.
- Encourage attendees to analyze the prompt structure to understand how the similarity score is being extracted.
- Encourage attendees to analyze the `ParsedSimilarityScore` model to understand the structure of the response that is expected from the LLM.
- Encourage attendees to try to change the parsing logic in the prompt to see how it affects the similarity score extraction.
