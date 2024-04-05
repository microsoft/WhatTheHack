# Challenge 7: Getting Into the Flow

Up until now, you have used a web service (ChatServiceWebAPI) that utilizes an instance of the ChatService singleton to  orchestrate calls to Azure OpenAI and Azure Cognitive Search by using Semantic Kernel. This effectively provides the "smarts" to your AI assistant. This is not the only way that you could build these smarts. 

In this challenge, you and your team will use Azure ML Prompt Flow to replace portions of the ChatService singleton. 

## Challenge

Your team must:

1. Create an Azure Machine Learning Prompt Flow that re-creates the core steps of the ChatService, which are:
    - Get user query vector embedding
    - Search for context data
    - Request the completion
    - Store and return the result

### Hints

- For all interactions with Azure OpenAI, you will want to use the LLM Tool in Prompt Flow.
- To search for context data from Cognitive Search you will want the Vector DB Lookup Tool.
- For storing the results back to Cosmos DB, consider using the Python Tool.

### Success Criteria

To complete this challenge successfully, you must:
- Demonstrate to your coach the PromptFlow you created in Azure Machine Learning.
- Deploy your Prompt Flow endpoint and integrate that into the solution.


### Resources

- [Get stated with Prompt Flow](https://learn.microsoft.com/en-us/azure/machine-learning/prompt-flow/get-started-prompt-flow?view=azureml-api-2#create-and-develop-your-prompt-flow)
- [Integrate LangChain in PromptFlow](https://learn.microsoft.com/en-us/azure/machine-learning/prompt-flow/how-to-integrate-with-langchain?view=azureml-api-2)
- [Deploy a flow as a managed online endpoint for real-time inference](https://learn.microsoft.com/en-us/azure/machine-learning/prompt-flow/how-to-deploy-for-real-time-inference?view=azureml-api-2)

## Explore Further

[The Prompt Flow GitHub repository](https://github.com/microsoft/promptflow)