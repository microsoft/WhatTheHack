# Challenge 4: What's Your Vector, Victor?

Now it's time to see the end-to-end process in action. In this challenge, you will load new data using the data loading mechanism you created in a previous challenge, then observe the automatic vectorization in action. Once you ingest the new data, ask a question through the prompt interface and see if it returns an answer about the new data you loaded.

## Challenge

Your team must:

1. Load new data using the data loading mechanism you created in a previous challenge.
2. Ask a question through the prompt interface and see if it returns an answer about the new data you loaded.

### Hints

- Cosmicworks has provided the JSON files containing the initial products and customers that you loaded into the system, take one of these and modify it to create some new products or customers and uploaded it to the storage account from where you loaded the initial data and run your data loading process. 
- Experiment using prompts to elicit different response formats from the completions model:
   - Respond with a single number or with one or two words
   - Respond with a bulleted lists or formatted a certain way
   - Respond using simpler syntax (e.g. explain it like I'm five)
   - Challenge the model with prompts that require reasoning or chain of thought. For example, ask it to calculate aggregates on the data or go further and give some word problems like those you had in school.
   - Challenge the model to explain its reasoning
   - Request that the model list its sources

### Success Criteria

To complete this challenge successfully, you must:

- Show your coach the new data that you created and then your chat history showing how it responded using the new data as context. 
- Try to locate the new product or customer data you loaded in the Cognitive Search Index and in Cosmos DB.

### Resources

- [Query Azure Search using Search Explorer](https://learn.microsoft.com/azure/search/search-explorer)
- [Work with data using Azure Cosmos DB Explorer](https://learn.microsoft.com/en-us/azure/cosmos-db/data-explorer)

## Explore Further

- [Prompt engineering techniques](https://learn.microsoft.com/azure/cognitive-services/openai/concepts/advanced-prompt-engineering?pivots=programming-language-chat-completions)