# Challenge 05 - Do as the Colonel commands

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)**

## Introduction

In this challenge, you will extend the capabilities of Semantic Kernel by integrating and managing system commands. These commands enable specialized actions, such as resetting the cache or modifying the relevance score. You'll work with plugins, invoke prompts, and extract numerical values from user input to update system settings dynamically.

## Description

Your team must:

- Add system command plugins
    - Integrate the system command plugins from the configuration settings into the list of context builder plugins.
    - Analyze the `SystemCommandPlugin` class to understand how it manages system commands.
- Reset the semantic cache
    - Implement functionality to reset the semantic cache and notify the user when the reset is complete.
- Set a minimum relevance override
    - Retrieve a numerical value from the user prompt and use it to set a new minimum relevance override.
    - Use the `GetSemanticCacheSimilarityScore` method to parse the similarity score from the prompt.
- Parse similarity score with the plugin prompt
    - Invoke a plugin prompt and parse the response to extract the similarity score.
    - Analyze the `ParsedSimilarityScore` model to understand how the response structure aligns with the prompt output.

You may now go to the starter solution in Visual Studio and complete Challenge 5. Locate the exercises by searching for `// TODO: [Challenge 5]`

Open-ended exercise (recommended to be completed at the end of the hackathon):

- Create a new system command and plug it into the system. Test the command to ensure it works as expected.

## Tips

- **System commands**: Review the key concepts document to understand how system commands are integrated into the solution accelerator.
- **Cache reset**: Make sure the user is notified after resetting the cache.
- **Similarity score parsing**: Use the `GetSemanticCacheSimilarityScore` method to accurately extract numerical values from the user prompt.

## Success Criteria

To complete this challenge successfully, you must:

- Demonstrate that the system command plugins are integrated correctly from the configuration settings.
- Show that the semantic cache can be reset and the user is notified.
- Implement the logic to set the minimum relevance override and notify the user about the change.
- Invoke a plugin prompt to parse the similarity score and validate the extracted value.

## Learning Resources

- [Build your own Copilot with Azure Cosmos DB - Key concepts](https://github.com/Azure/BuildYourOwnCopilot/blob/main/docs/concepts.md)

## Advanced Challenges (Optional)

If you want to explore further, try these additional challenges:

- Experiment with changing the similarity score parsing logic to see how it impacts the behavior.
- Try adding more system command plugins to explore other useful commands.
