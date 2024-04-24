# Challenge 02 - OpenAI Models & Capabilities

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

In this challenge, you will learn about the different capabilities of OpenAI models and learn how to choose the best model for your use case.

You are going to compare gpt3.5 to gpt4 model in this challenge. If you do not have gpt-4 access, you can compare the legacy models if they are deployed, or go through this challenge conceptually to understand how to best pick a model from the ones you have deployed as well as the ones in the model catalog.

In a world where the availability and development of models are always changing, the model we compare may change over time. But we encourage you to understand the general concepts and material in this Challenge because the comparison techniques utilized can be applicable to scenarios where you are comparing Large Language Models. For more information on legacy models and additional models, reference the [documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/legacy-models) and [Azure model catalog](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-use-foundation-models?view=azureml-api-2) for more details.

## Description
Model deployment for the challenge:
- Deploy the following models in your Azure OpenAI resource using these names: 
  - `gpt-4`
  - `gpt-35-turbo`
 **If you do not have gpt-4 access, you can still go through this challenge conceptually to understand how to best pick a model from the ones you have deployed as well as the ones in the model catalog.**

- Add required credentials of Azure resources in the `.env` file

Questions you should be able to answer by the end of this challenge:
- What are the capacities of each Azure OpenAI model?
- How to select the right model for your application?
- What model would you select to summarize prompts？
- What model would you select to generate new names?
- How to retrieve embeddings?

You will run the following Jupyter notebook for this challenge:

- `CH-02-ModelComparison.ipynb`

The file can be found in your Codespace under the `/notebooks` folder. 
If you are working locally or in the Cloud, you can find it in the `/notebooks` folder of `Resources.zip` file. 

To run a Jupyter notebook, navigate to it in your Codespace or open it in VS Code on your local workstation. You will find further instructions for the challenge, as well as in-line code blocks that you will interact with to complete the tasks for the challenge.  Return here to the student guide after completing all tasks in the Jupyter notebook to validate you have met the [success criteria](#success-criteria) below for this challenge.

Sections in this Challenge:
1. Overview on finding the right model
- 1.1 Model Families
- 1.2 Model Capacities
- 1.3 Pricing Details
- 1.4 Quotas and Limits
- 1.5 Model Best Use Cases
- 1.6 Model Selection Best Practices
2. Implementation

- 2.0 Helper Functions
- 2.1 Summarize Text
- 2.2 Summarization for a targeted audience
- 2.3 Summarize Cause & Effect
- 2.4 Generate Nick Names
- 2.5 Embeddings

## Success Criteria

To complete this challenge successfully, you should be able to:
- Show an understanding of each model and its suitable use cases
- Show an understanding of differences between models
- Select the most suitable model to apply under different scenarios
- Make all  code cells run successfully

## Additional Resources

- [Overview of Azure OpenAI Models](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/models)
- [Azure OpenAI Pricing Page](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/)
- [Request for Quota Increase](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR4xPXO648sJKt4GoXAed-0pURVJWRU4yRTMxRkszU0NXRFFTTEhaT1g1NyQlQCN0PWcu)
- [Customize Models](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio)
