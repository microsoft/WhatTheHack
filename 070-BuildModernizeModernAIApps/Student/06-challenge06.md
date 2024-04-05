# Challenge 6: The Colonel Needs a Promotion

In this challenge, you and your team will add a new capability by creating a couple of new plugins for Semantic Kernel.

You have lately become a big fan of Shakespeare's sonnets. You love how they convey details and information, and you want your copilot to provide details about your company's policies in the poetic form of Shakespearean language.

Your challenge is correctly handling requests about your company's policies (return or shipping), including when users ask to get them as poems written in Shakespearean style.

## Challenge

Your team must:

1. Create a new Semantic Kernel plugin that will retrieve only memories related to company policies.
2. Create a new Semantic Kernel plugin that will present any information as a poem written in Shakespearean language.
3. Register the plugins with Semantic Kernel.
4. Create a plan to respond to requests.
5. Replace the logic in the SemanticKernalRAGService.cs GetResponse method with one that will first make a plan to decide if your functions should be used or not, and then execute the completion request accordingly.

### Hints

- You might want to try building this first in a simple console project.
- You should use the SequentialPlanner from Semantic Kernel to create and execute a plan around the prompt, so that it can choose when to invoke your plugins. 
- You will have to update how you handle the completion response from the SequentialPlanner.

### Success Criteria

To complete this challenge successfully, you must:

- Show your coach an example chat where your new plugins where selected by the plan and executed to produce the completion.

### Resources

- [Semantic Kernel auto create plans with planner](https://learn.microsoft.com/semantic-kernel/ai-orchestration/planner?tabs=Csharp)
- [Semantic Kernel creating native functions](https://learn.microsoft.com/en-us/semantic-kernel/ai-orchestration/native-functions?tabs=Csharp)


## Explore Further

[Microsoft Semantic Kernel on Github](https://github.com/microsoft/semantic-kernel)

