# Challenge 3

## [Challenge 3][Exercise 3.2.1]
Exercise:
```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 3][Exercise 3.2.1] Define public properties to expose the intercepted values.
        //--------------------------------------------------------------------------------------------------------
```
---
Solution:
```csharp
        public string RenderedPrompt => _renderedPrompt;

        public string PluginName => _pluginName;

        public string FunctionName => _functionName;

        private string _renderedPrompt = string.Empty;
        private string _pluginName = string.Empty;
        private string _functionName = string.Empty;
```

## [Challenge 3][Exercise 3.2.2]
Exercise:
```csharp
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 3][Exercise 3.2.2] Implement the handler to intercept prompt rendering values.
            //--------------------------------------------------------------------------------------------------------
            await Task.CompletedTask;
```
---
Solution:
```csharp
            _pluginName = context.Function?.PluginName ?? string.Empty;
            _functionName = context.Function?.Name ?? string.Empty;

            await next(context);

            _renderedPrompt = context.RenderedPrompt ?? string.Empty;
```

## [Challenge 3][Exercise 3.1.1]
Exercise:
```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 3][Exercise 3.1.1]
        // Attach an IPromptRenderFilter to the Semantic Kernel kernel.
        // This will allow you to intercept the rendered prompts in their final form (before submission to the Large Language Model).
        // Note that the DefaultPromptFilter is a good starting point to implement a prompt filter.
        //--------------------------------------------------------------------------------------------------------
```
---
Solution:
```csharp
        var promptFilter = new DefaultPromptFilter();
        _semanticKernel.PromptRenderFilters.Add(promptFilter);
```

## [Challenge 3][Exercise 3.1.2]
Exercise:
```csharp
                RenderedPrompt = string.Empty, // TODO: [Challenge 3][Exercise 3.1.2] Retrieve the rendered prompt via the prompt filter.
```
---
Solution:
```csharp
                RenderedPrompt = promptFilter.RenderedPrompt,
```
Exercise:
```csharp
                RenderedPrompt = string.Empty, // TODO: [Challenge 3][Exercise 3.1.2] Retrieve the rendered prompt via the prompt filter.
```
---
Solution:
```csharp
                RenderedPrompt = promptFilter.RenderedPrompt,
```
Exercise:
```csharp
            RenderedPrompt = string.Empty, // TODO: [Challenge 3][Exercise 3.1.2] Retrieve the rendered prompt via the prompt filter.
```
---
Solution:
```csharp
            RenderedPrompt = promptFilter.RenderedPrompt,
```

## [Challenge 3][Exercise 3.3.1]
Exercise:
```csharp
        //--------------------------------------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 3][Exercise 3.3.1]
        // Attach an IFunctionInvocationFilter to the Semantic Kernel kernel.
        // This will allow you to intercept the function calling happening behind the scenes.
        // Note that you will need to write your own implementation class.
        //--------------------------------------------------------------------------------------------------------
```
---
Solution:
```csharp
        //--------------------------------------------------------------------------------------------------------
```

