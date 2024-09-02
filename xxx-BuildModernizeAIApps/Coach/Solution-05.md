# Challenge 05 - The Colonel Needs a Promotion - Coach's Guide

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

[Watch the Train the Trainer video for Challenge 5](https://aka.ms/vsaia.hack.ttt.06)

1. Create a dedicated Semantic Kernel for policies memories. Make sure the description of the policy is clear and concise, to enable the planner to pick it up. For details, see the `PolicyPlugin` class under `VectorSearchAiAssistant\Plugins\Fun` in the challenge solution code.
2. Filter out the short term memories that are loaded, so you can construct the dedicated policy memory. See line 121 in `SemanticKernelRAGService.cs` in the challenge solution code:

```csharp
foreach (var memorySource in _memorySources)
{
    if (memorySource is BlobStorageMemorySource)
        shortTermMemories.AddRange(await memorySource.GetMemories());
}
```

3. Create a Semantic Kernel plugin for transforming text into Shakespearean poems. For details, see the `ShakespearePlugin` class under `VectorSearchAiAssistant\Plugins\Fun` in the challenge solution code.
4. Replace the body of the `GetResponse` method in the `SemanticKernelRAGService` class with the following code:

```csharp
await EnsureShortTermMemory();

var policyPlugin = new PolicyPlugin(
    _shortTermMemory,
    _logger);

_semanticKernel.ImportFunctions(policyPlugin);
var shakespearePlugin = new ShakespearePlugin(_semanticKernel);

var planner = new SequentialPlanner(_semanticKernel);
var plan = await planner.CreatePlanAsync(userPrompt);
var planResult = await _semanticKernel.RunAsync(plan);

return new(planResult.GetValue<string>(), userPrompt, 0, 0, null);
```
5. Start the solution and test it with the following user prompts:

```text
Tell me about your return policy. Present it as a poem written by Shakespeare.
```

```text
Tell me about your shipping policy. Present it as a poem written by Shakespeare.
```

6. Run the solution in debug mode, and set a breakpoint in the `GetResponse` method of the `SemanticKernelRAGService` class. Inspect the `plan` variable to see the plan that was created by the planner.

>**NOTE**
>
> Notice how the `GetResponse` method is now much simpler, because the planner is doing all the heavy lifting. At the same time, the actual token consumption values are not retrieved. For teams that are advancing quicly through the challenge, you might consider extending the challenge with a requirement to retrieve the token consumption values from the plan result.
