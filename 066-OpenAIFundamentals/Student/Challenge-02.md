# Challenge 02 - OpenAI Models, Capabilities, and Model Router

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

In this challenge, you will learn about the different capabilities of OpenAI models and learn how to choose the best model for your use case.

There are a lot of different models available in the Azure AI Model Catalog. These include models from OpenAI and other open source large language models from Meta, Hugging Face, and more. You are going to explore various LLMs and compare gpt3.5 to gpt4-o model in this challenge and learn about the benefits of model router.

In a world where the availability and development of models are always changing, the models we compare may change over time. But we encourage you to understand the general concepts and material in this Challenge because the comparison techniques utilized can be applicable to scenarios where you are comparing Large and/or Small Language Models. For more information on legacy models and additional models, reference the [documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/legacy-models) and [Azure model catalog](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/model-catalog-overview) for more details.

Due to the rapid change in model capabilites, model router works to make model picking easier. It automatically analyzes prompts and sends them to the model that is most appropriate for the job. For example, simple questions will be routed to lightweight models, and more complex ones would go to larger, more powerful models. This smart routing works to reduce latency and optimize costs while being more scaleable, flexible, and reliable since we are not reliant on an individual model.  

## Description
Questions you should be able to answer by the end of this challenge:
- What are the capacities of each Azure OpenAI model?
- How to select the right model for your application?
- What model would you select to perform complex problem solving？
- What model would you select to generate new names?

You will work in the Azure AI Foundry for this challenge. We recommend keeping the student guide and the Azure AI Foundry in two windows side by side as you work. This will also help to validate you have met the [success criteria](#success-criteria) below for this challenge.

This challenge is divided into the following sections:

- [2.1 Model Discovery](#21-model-discovery)
- [2.2 Model Benchmarking](#22-model-benchmarking)
- [2.3 Model Comparison](#23-model-comparison)
    - 2.3.1 Complex Problem Solving
    - 2.3.2 Creative and Technical Writing
    - 2.3.3 Long Form Content Understanding
- [2.4 Model Router](#24-model-router)
  

### 2.1 Model Discovery
Scenario: You are part of a research team working on getting information from biotech news articles. Your goal is to explore the Model Catalog and identify some suitable models for accurate question answering. There is no right or wrong answer here.

#### Student Task 2.1
- Go into the [Azure AI Foundry](https://ai.azure.com).
- Navigate to the Model Catalog and explore different models using the correct filters. 
- Identify which models can potentially improve the accuracy of the task at hand.

**HINT:** Take a look at the model cards for each model by clicking into them. Evaluate the models based on their capabilities, limitations, and fit for the use case. Which models seem to be good options for question answering? 

### 2.2 Model Benchmarking 
#### Student Task 2.2
- Use the benchmarking tool and **Compare models** in Foundry to compare the performance of all the selected models you chose from the previous challenge, on industry standard datasets now.
- Leverage the metrics such as accuracy, coherence, and more.
- Recommend the best-performing model for biotech news Q&A.

### 2.3 Model Comparison
#### Student Task 2.3
- Navigate to [Github's Model Marketplace](https://github.com/marketplace/models) and sign in with your Github credentials. Github Models provide free access to a set of AI models for anyone with a Github account. 
- Choose two models to compare for the following scenario. What are your observations?

**TIP** The scenario will go into the system prompt. Click on the button "Show parameters setting" next to the trash can once your model has been selected.

Scenario: You are a product manager at a multinational tech company, and your team is developing an advanced AI-powered virtual assistant to provide real-time customer support. The company is deciding between GPT-3.5 Turbo and GPT-4o to power the virtual assistant. Your task is to evaluate both models to determine which one best meets the company's needs for handling diverse customer inquiries efficiently and effectively.

#### Student Task 2.3.1: Complex Problem Solving
  Compare the models' abilities to navigate complex customer complaints and provide satisfactory solutions.
  - Prompt: "A customer is unhappy with their recent purchase due to a missing feature. Outline a step-by-step resolution process that addresses their concern and offers a satisfactory solution."
  - Prompt: "Develop a multi-step troubleshooting guide for customers experiencing issues with their smart home devices, integrating potential scenarios and solutions."

#### Student Task 2.3.2: Creative and Technical Writing
  Assess the models' capabilities in technical writing, such as creating detailed product manuals or help articles.
  - Prompt: "Write a product description for a new smartphone that highlights its innovative features in a creative and engaging manner."
  - Prompt: "Create a comprehensive FAQ section for a complex software application, ensuring clarity and technical accuracy."

#### Student Task 2.3.3: Long Form Content Understanding
  Provide both models with extensive customer feedback or product reviews and ask them to summarize the key points.

  We have provided a `ch2_1.5_product_review.txt` file that contains a product review for you to use with the given prompt below. You will find the `ch2_1.5_product_review.txt` file in the `/data` folder of the codespace. If you are working on your local workstation, you will find the `ch2_1.5_product_review.txt` file in the `/data` folder of the `Resources.zip` file. Please copy & paste the contents of this file within your prompt.
  - Prompt: "Analyze a detailed product review and extract actionable insights that can inform future product development."

### 2.4 Model Router
#### Student Task 2.4
- Navigate to AI Foundry and deploy an instance of model router in the same project as your other models
- In Chat Playground use the model router deployment and prompt the it with different difficulty of questions and watch it swtich models (you can see this switch in the metadata on top of the query).

Simple Prompt:

```
What is the capital of the United States?
```
Medium Prompt:

```
Given a hybrid cloud architecture with latency-sensitive workloads, how would you design a multi-region failover strategy using Azure services?
```
Difficult Prompt:

```
Generate a Bicep script to deploy a secure, autoscaling AKS cluster with Azure Entra ID integration and private networking.
```


## Success Criteria

To complete this challenge successfully, you should be able to:
- Show an understanding of each model and its suitable use cases
- Show an understanding of differences between models
- Select the most suitable model to apply under different scenarios
- Show an understanding for the capabilites of model router and its use cases

## Learning Resources

- [Overview of Azure OpenAI Models](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/models)
- [Azure OpenAI Pricing Page](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/)
- [Request for Quota Increase](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR4xPXO648sJKt4GoXAed-0pURVJWRU4yRTMxRkszU0NXRFFTTEhaT1g1NyQlQCN0PWcu)
- [Customize Models](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio)
