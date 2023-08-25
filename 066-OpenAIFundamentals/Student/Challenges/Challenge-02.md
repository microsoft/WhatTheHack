# Challenge 02 - OpenAI Models & Capabilities

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)


## Pre-requisites

* Access to Azure subscription, create notebook in Azure Machine Learning Studio
* Get access to Azure OpenAI resources
* Deploy your own AOAI models in AOAI portal
* Apply for Quota Increase

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
- Add required credentials of Azure resources in the ``.env`` file

Questions you should be able to answer by the end of this challenge:
- What are the capacities of each Azure OpenAI model?
- How to select the right model for your application?
- What model would you select to summarize prompts？
- What model would you select to generate new names?
- How to retrieve embeddings?

Sections in this Challenge:
1. Overview on finding the right model

    1.1 Model Families
    
    1.2 Model Capacities

    1.3 Model Taxonomy

    1.4 Pricing Details

    1.5 Quotas and Limits

    1.6 Model Best Use Cases

    1.7 Model Selection Best Practices
2. Implementation

    2.0 Helper Functions

    2.1 Summarize Text

    2.2 Summarization for a targeted audience

    2.3 Summarize Cause & Effect

    2.4 Generate Nick Names

    2.5 Embeddings

Link to the Notebook:
- [Challenge 02](https://github.com/izzymsft/WhatTheHack/blob/066-OpenAIFundamentals/066-OpenAIFundamentals/Student/Resources/Notebooks/CH-02-ModelComparison.ipynb)

## Success Criteria

To complete this challenge successfully, you should be able to:
- Show the understanding of each model and its suitable use cases
- Show the understanding of differences between each model
- Be able to select the most suitable model to apply under different scenarios
- Make all the code cells run successfully

## Additional Resources

- [Overview of Azure OpenAI Models](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/models)
- [Azure OpenAI Pricing Page](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/)
- [Request for Quota Increase](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR4xPXO648sJKt4GoXAed-0pURVJWRU4yRTMxRkszU0NXRFFTTEhaT1g1NyQlQCN0PWcu)
- [Customize Models](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio)
