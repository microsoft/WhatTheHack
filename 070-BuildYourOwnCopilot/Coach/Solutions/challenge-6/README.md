# Challenge 6

## [Challenge 6][Exercise 6.1.1]
Exercise:
```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 6][Exercise 6.1.1]
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

## [Challenge 6][Exercise 6.2.1]
Exercise:
```csharp
                    //--------------------------------------------------------------------------------------------------------
                    // TODO: [Challenge 6][Exercise 6.2.1]
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

## [Challenge 6][Exercise 6.3.1]
Exercise:
```csharp
                    //--------------------------------------------------------------------------------------------------------
                    // TODO: [Challenge 6][Exercise 6.3.1]
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

## [Challenge 6][Exercise 6.3.2]
Exercise:
```csharp
        
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 6][Exercise 6.3.2]
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

