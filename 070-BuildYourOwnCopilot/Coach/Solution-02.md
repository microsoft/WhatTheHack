# Challenge 02 - It has no filter - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

View the completed code in the `solutions/challenge-2/code` folder.

### [Challenge 2][Exercise 2.1.1]

Exercise:

```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 2][Exercise 2.1.1]
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

Coach notes:

- Encourage attendees to read first about [Using Filters in Semantic Kernel](https://devblogs.microsoft.com/semantic-kernel/filters-in-semantic-kernel/) to understand the concept of filters in the Semantic Kernel.
- Let attendees know that the `DefaultPromptFilter` class is already created in the project and they can use it as a starting point to implement their own prompt filter (which they will do in the following exercises).

Suggested reading:

- [Using Filters in Semantic Kernel](https://devblogs.microsoft.com/semantic-kernel/filters-in-semantic-kernel/)

### [Challenge 2][Exercise 2.1.2]

Exercise:

```csharp
                RenderedPrompt = string.Empty, // TODO: [Challenge 2][Exercise 2.1.2] Retrieve the rendered prompt via the prompt filter.
```

---

Solution:

```csharp
                RenderedPrompt = promptFilter.RenderedPrompt,
```

Coach notes:

- Once the prompt filter is attached to the Semantic Kernel, attendees can access the rendered prompt by exposing a property in the filter class.
- Note that at this point, the property is not yet available as it will be implemented in the next exercises. Once the exercises are complete, they can come back to this point and replace the `string.Empty` with the actual value.

### [Challenge 2][Exercise 2.2.1]

Exercise:

```csharp
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 2][Exercise 2.2.1] Define public properties to expose the intercepted values.
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

Trainer notes:

- Suggest attendees to define three public properties: one for the plugin name, one for the function name, and one for the rendered prompt.

### [Challenge 2][Exercise 2.2.2]

Exercise:

```csharp
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 2][Exercise 2.2.2] Implement the handler to intercept prompt rendering values.
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

Trainer notes:

- This is the core of the prompt filter implementation. Here, the handler is intercepting the prompt rendering values and storing them in the properties defined in the previous exercise.
- The properties are available in the `PromptRenderContext` class.
- The handler should call the `next` delegate to continue the pipeline execution (to allow other filters to execute as well).

### [Challenge 2][Exercise 2.3.1]

Exercise:

```csharp
        //--------------------------------------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 2][Exercise 2.3.1]
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

Trainer notes:

- This is an open challenge for attendees to implement their own `IFunctionInvocationFilter` class to intercept function invocations in the Semantic Kernel.
- Encourage attendees to read again [Using Filters in Semantic Kernel](https://devblogs.microsoft.com/semantic-kernel/filters-in-semantic-kernel/) and use it as a starting point to implement their own function invocation filter.
