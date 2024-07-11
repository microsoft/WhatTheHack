# Challenge 02 - OpenAI Models & Capabilities

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

In this challenge, you will learn about the different capabilities of OpenAI models and learn how to choose the best model for your use case.

There are a lot of different models available in the Azure AI Model Catalog. These include models from OpenAI and other open source large language models from Meta, Hugging Face, and more. You are going to explore various LLMs and compare gpt3.5 to gpt4 model in this challenge. 

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
- What model would you select to perform complex problem solving？
- What model would you select to generate new names?

You will work in the Azure AI Studio for this challenge. Return here to the student guide after completing all student tasks in the Azure AI Studio to validate you have met the [success criteria](#success-criteria) below for this challenge.

Sections in this Challenge:
1. Overview on finding the right model
- 1.1 Model Discovery
- 1.2 Model Benchmarking
- 1.3 Prompt Flow
    - 1.3.1 Complex Problem Solving
    - Creative and Technical Writing
    - Long Form Content Understanding
 
## Overview on finding the right model 

### Model Discovery
Scenario: You are part of a research team working on classifying biotech news articles. Your goal is to identify the most suitable models for accurate text classification.

  #### Student Task 1.1
      - Go into the [Azure AI Studio](ai.azure.com) and create a project.
      - Navigate to the Model Catalog and explore different models using the correct filters. 
      - Identify which models can potentially improve the accuracy of the task at hand.
      - Evaluate the models based on their capabilities, limitations, and fit for the use case from the model card.

### Model Benchmarking 
  #### Student Task 1.2
      - Use the benchmarking tool in the Studio to compare the performance of all the selected models on industry standard datasets. 
      - Leverage the metrics such as accuracy, coherence, and more.
      - Recommend the best-performing model for biotech news classification.

### Prompt Flow
Scenario: You are a product manager at a multinational tech company, and your team is developing an advanced AI-powered virtual assistant to provide real-time customer support. The company is deciding between GPT-3.5 Turbo and GPT-4 to power the virtual assistant. Your task is to evaluate both models to determine which one best meets the company's needs for handling diverse customer inquiries efficiently and effectively.

Navigate to the AI Studio and click on your project. You should be able to see Prompt flow under Tools in the navigation bar. Use the provided resources to solve the tasks below leveraging Prompt Flow to compare the responses from different models.

  #### Student Task 1.3: Complex Problem Solving
  Compare the models' abilities to navigate complex customer complaints and provide satisfactory solutions.
  - Prompt: "A customer is unhappy with their recent purchase due to a missing feature. Outline a step-by-step resolution process that addresses their concern and offers a satisfactory solution."
  - Prompt: "Develop a multi-step troubleshooting guide for customers experiencing issues with their smart home devices, integrating potential scenarios and solutions."

  #### Student Task 1.4: Creative and Technical Writing
  Assess the models' capabilities in technical writing, such as creating detailed product manuals or help articles.
  - Prompt: "Write a product description for a new smartphone that highlights its innovative features in a creative and engaging manner."
  - Prompt: "Create a comprehensive FAQ section for a complex software application, ensuring clarity and technical accuracy."

  #### Student Task 1.5: Long Form Content Understanding
  Provide both models with extensive customer feedback or product reviews and ask them to summarize the key points.
  - Prompt: "Analyze a detailed product review and extract actionable insights that can inform future product development."
  - Prompt: Product Review: You can find this in the data folder labelled `ch2_1.5_product_review.txt`

## Success Criteria

To complete this challenge successfully, you should be able to:
- Show an understanding of each model and its suitable use cases
- Show an understanding of differences between models
- Select the most suitable model to apply under different scenarios

## Additional Resources

- [Overview of Azure OpenAI Models](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/models)
- [Prompt Flow](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/prompt-flow)
- [Azure OpenAI Pricing Page](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/)
- [Request for Quota Increase](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR4xPXO648sJKt4GoXAed-0pURVJWRU4yRTMxRkszU0NXRFFTTEhaT1g1NyQlQCN0PWcu)
- [Customize Models](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio)
