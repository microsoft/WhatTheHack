# Challenge 02 - It has no filter

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

In this challenge, you'll learn to use **filters** in Semantic Kernel. Filters allow you to intercept and observe the behavior of the kernel—such as viewing rendered prompts and monitoring function invocations. This can be a powerful tool for debugging and enhancing your AI solutions.

## Description

Your team must:

- Attach a prompt render filter
    - Use the `DefaultPromptFilter` to attach a filter to the kernel. This filter will let you intercept the final form of prompts before they are submitted to the Large Language Model (LLM).
- Retrieve rendered prompts via the filter
    - Add logic to retrieve and store the rendered prompt using the prompt filter.
- Define public properties to expose values
    - Create public properties to expose the values intercepted by the filter, such as the rendered prompt, the plugin name, and the function name.
- Implement the filter handler
    - Implement a handler to capture the intercepted values and continue the pipeline's execution by invoking other filters, if any.

You may now go to the starter solution in Visual Studio and complete Challenge 2. Locate the exercises by searching for `// TODO: [Challenge 2]`

Open-ended exercise (recommended to be completed at the end of the hackathon):

- Create a function invocation filter (Advanced)
    - Exercise `2.3.1`: Design your own `IFunctionInvocationFilter` to intercept and monitor function calls happening in the background of Semantic Kernel.

## Tips

- **Prompt filters**: Use the `DefaultPromptFilter` as a template to build your own custom prompt filters in future challenges.
- **Continuing the pipeline**: Always call `await next(context);` in your handlers to allow other filters to run.
- **Function invocation filters**: Function invocation filters are useful to observe or log which functions are invoked during runtime.

## Success Criteria

To complete this challenge successfully, you must:

- Demonstrate to your coach that the prompt filter is attached and working.
- Show that the rendered prompt, plugin name, and function name are correctly captured and accessible.
- Test your solution by interacting with the assistant through the web-based chat interface and monitoring the filtered outputs.

Optional: Implement the function invocation filter and demonstrate that it captures and logs function calls.

## Learning Resources

- [Using filters in Semantic Kernel](https://devblogs.microsoft.com/semantic-kernel/filters-in-semantic-kernel/)
- [Semantic Kernel function invocation](https://learn.microsoft.com/semantic-kernel/concepts/planning?pivots=programming-language-csharp)

## Advanced Challenges (Optional)

If you want to explore further, consider these additional challenges:

- **Experiment with filters**: Try modifying the `DefaultPromptFilter` to capture additional metadata about the prompts.
- **Enhance function invocation filters**: Extend your function invocation filter to log details of every function call for debugging purposes.
