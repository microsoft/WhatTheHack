# Challenge 02 - Best Practices When Using Copilot - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance
***Update and build upon with latest best practices in student guide and coaches***
- In the previous challenge we let the students explore and experiment. While they may have noticed a few of these strategies, we want to make sure we cover these best practices to ensure they have a good experience and know how to work with Copilot.
- **Recommended: Demonstrate all three prompt engineering techniques once everyone has completed** - Some students may not be aware of all the techniques. Going through each one (Start General Then Get Specific, Break Complex Tasks Into Simpler Tasks, Give Examples) helps ensure everyone understands the core concepts before exploring additional techniques.
  - **Start General, Then Get Specific** - They should be setting the stage for the new feature, describing at a high level what they are trying to do. Note, if they want they may even get ideas for new features from Copilot. Setting the stage gives Copilot context for our long term goals, then add specific requirements.
  - **Break Complex Tasks Into Simpler Tasks** - Now that we have a high level goal, we can't have Copilot write out the entire thing as there may be too much. Lets break things down to smaller chunks and have Copilot assist us with focused, incremental tasks.
  - **Give Examples** - Examples are great when you have a dataset or schema that Copilot wasn't aware of. You can even have Copilot learn about some custom module that you may have internally. Show input data, expected outputs, or implementation patterns.
- **Additional Prompt Engineering Techniques** - Students should explore at least one of these. Consider demonstrating a few examples:
  - **Avoid Ambiguity** - Be specific instead of vague. Don't say "what does this do" - instead say "what does the create user function do" or "what does the code in your last response do". Specify which library you're using if it's not obvious.
  - **Provide Relevant Context** - Open files that are related to your task and close irrelevant ones. Copilot uses open files to understand your request. Highlight specific code you want Copilot to reference.
  - **Experiment and Iterate** - If you don't get the result you want, rephrase your prompt or break it into smaller requests. You can keep a suggestion and request modifications, or delete it and start over.
  - **Keep History Relevant** - Use threads for new conversations when starting a different task. Delete requests that didn't give useful results to keep context clean.
  - **Follow Good Coding Practices** - Use consistent code style, descriptive names, comments, and modular structure. Well-organized code helps Copilot provide better suggestions.
  - **Indicate Relevant Code** - In Copilot Chat, use keywords like `@workspace` to provide specific context about repositories, files, or symbols you want referenced.
- Note that they may not be able to try all examples in their feature implementation. They can just test it out with sandbox code.
- Some ideas of features:
  - Allow multiple players
  - Include a top score board
  - Add a difficulty settings
 
- https://github.blog/2023-06-20-how-to-write-better-prompts-for-github-copilot/ - This article goes deeper on the best practices
