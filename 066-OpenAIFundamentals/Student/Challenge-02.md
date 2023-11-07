# Challenge 02 - OpenAI Models & Capabilities - OPTIONAL

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

**NOTE:** This challenge is OPTIONAL due to the retirement of several Azure OpenAI models. You can read more about this decision on the Microsoft blog [here](https://techcommunity.microsoft.com/t5/azure-ai-services-blog/announcing-updates-to-azure-openai-service-models/ba-p/3866757). 

If you already have _existing_ deployments of the models outlined below, you should be able to complete this hack before July 5, 2024, when existing deployments will become unavailable. However, these models are unavailable for _new_ deployments beginning July 6, 2023. In that case, you may revise the environment file and the models you deploy accordingly. Please refer to the [documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/legacy-models) and below for more details.

However, in a world where the availability and development of models are always changing, **we highly encourage** you to understand the general concepts and material in this Challenge because the comparison techniques utilized can be applicable to scenarios where you are comparing Large Language Models (LLMs).  It is straightforward to utilize alternative models in place of the ones included here, since additional models have become available in the [Azure model catalog](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-use-foundation-models?view=azureml-api-2) since the time of publishing.

## Introduction

As LLMs grow in popularity and use around the world, the need to manage and monitor their outputs becomes increasingly important. In this challenge, you will learn how to evaluate the Azure OpenAI models and how to apply them in different scenarios.

## Description
Model deployment for the challenge:
- Deploy the following models in your Azure OpenAI resource. 
  - `gpt-35-turbo`
  - `text-ada-001`
  - `text-babbage-001`
  - `text-curie-001`
  - `text-davinci-003`
  - `text-embedding-ada-002`
    
Note: Model families currently available as of _Aug 4, 2023_ in Azure OpenAI includes GPT-3, Codex and Embeddings, GPT-4 is available for application. Please reference this link for more information: https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models.
Some models are not available for new deployments beginning **July 6, 2023**. Deployments created prior to July 6, 2023 remain available to customers until **July 5, 2024**. You may revise the environment file and the model you deploy accordingly. Please refer to the following link for more details: `https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/legacy-models`

**If you have deployed some of these models from before, you will still be able to use them until the dates listed above. However if you had not deployed those models, but have gpt-4 access, you can compare gpt3.5 to gpt4 in this challenge. If you do not have gpt-4 access, you can still go through this challenge conceptually to understand how to best pick a model from the ones you have deployed as well as the ones in the model catalog.**
  
- Add required credentials of Azure resources in the ``.env`` file

Questions you should be able to answer by the end of this challenge:
- What are the capacities of each Azure OpenAI model?
- How to select the right model for your application?
- What model would you select to summarize prompts？
- What model would you select to generate new names?
- How to retrieve embeddings?

You will run the following Jupyter notebook for this challenge. You can find it in the `/Notebooks` folder of `Resources.zip` file.

- `CH-02-ModelComparison.ipynb`

Sections in this Challenge:
1. Overview on finding the right model
- 1.1 Model Families
- 1.2 Model Capacities
- 1.3 Model Taxonomy
- 1.4 Pricing Details
- 1.5 Quotas and Limits
- 1.6 Model Best Use Cases
- 1.7 Model Selection Best Practices
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
