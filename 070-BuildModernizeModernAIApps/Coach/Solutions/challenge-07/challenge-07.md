# Solution for Challenge 07


**Placeholder**

[Watch the Train the Trainer video for Challenge 7](https://aka.ms/vsaia.hack.ttt.07)
[Deck for the Challenge]()

1. Open an Azure ML workspace in the Azure portal, or create a new one if you don't have one yet.
2. Navigate to the `Prompt flow` section on the left.
3. Create a connection to an Azure Open AI account (for details, see [Prompt Flow connection](https://learn.microsoft.com/en-us/azure/machine-learning/prompt-flow/get-started-prompt-flow?view=azureml-api-2#connection)).
4. Select an Azure ML compute instance as your runtime (for details, see [Prompt Flow runtime](https://learn.microsoft.com/en-us/azure/machine-learning/prompt-flow/get-started-prompt-flow?view=azureml-api-2#runtime)).
5. Create and develop your own prompt flow. We recommend the use of the `Chat flow` template or the `Bring Your Own Data QnA` starter from the gallery. For details, see [Create and develop your prompt flow](https://learn.microsoft.com/en-us/azure/machine-learning/prompt-flow/get-started-prompt-flow?view=azureml-api-2#create-and-develop-your-prompt-flow).
6. Deploy your flow to an online endpoint for integration with your application. For details, see [Deploy a flow as a managed online endpoint for real-time inference](https://learn.microsoft.com/en-us/azure/machine-learning/prompt-flow/how-to-deploy-for-real-time-inference?view=azureml-api-2).
7. Develop a new class (named `AMLPromptFlowService`) that implements the `IRAGService` interface. This class will be responsible for calling the Azure ML Prompt Flow endpoint.
8. Update the dependency injection configuration in the `Program` class to use the new `AMLPromptFlowService` class instead of the `SemanticKernelRAGService` class.


References:

- [Get stated with Prompt Flow](https://learn.microsoft.com/en-us/azure/machine-learning/prompt-flow/get-started-prompt-flow?view=azureml-api-2#create-and-develop-your-prompt-flow)
- [Integrate LangChain in PromptFlow](https://learn.microsoft.com/en-us/azure/machine-learning/prompt-flow/how-to-integrate-with-langchain?view=azureml-api-2)
- [Deploy a flow as a managed online endpoint for real-time inference](https://learn.microsoft.com/en-us/azure/machine-learning/prompt-flow/how-to-deploy-for-real-time-inference?view=azureml-api-2)
