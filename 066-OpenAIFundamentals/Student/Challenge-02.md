# Challenge 02 - OpenAI Models, Capabilities, and Model Router

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

In this challenge, you will learn about the different capabilities of OpenAI models and learn how to choose the best model for your use case.

There are a lot of different models available in the Azure AI Model Catalog. These include models from OpenAI and other open source large language models from Meta, Hugging Face, and more. You are going to explore and compare various LLMs in this challenge while learning about the benefits of model router.

In a world where the availability and development of models are always changing, the models we compare may change over time. But we encourage you to understand the general concepts and material in this challenge because the comparison techniques utilized can be applicable to scenarios where you are comparing Large and/or Small Language Models. For more information on legacy models and additional models, reference the [documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/legacy-models) and [Azure model catalog](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/model-catalog-overview) for more details.

Due to the rapid change in model capabilities, model router works to make model picking easier. It automatically analyzes prompts and sends them to the model that is most appropriate for the job. For example, simple questions will be routed to lightweight models and more complex ones would go to larger, more powerful models. This smart routing works to reduce latency and optimize costs while being more scalable, flexible, and reliable since we are not reliant on an individual model.  

## Description
Questions you should be able to answer by the end of this challenge:
- What are the capacities of each Azure OpenAI model?
- How to select the right model for your application?
- What model would you select to perform complex problem solving？
- What model would you select to generate new names?

You will work in the Azure AI Foundry for this challenge. We recommend keeping the student guide and the Azure AI Foundry in two windows side by side as you work. This will also help to validate you have met the [success criteria](#success-criteria) below for this challenge.

This challenge is divided into the following sections:

- [2.1 Model Discovery](#21-model-discovery)
- [2.2 Model Leaderboards](#22-model-leaderboards)
- [2.3 Model Comparison](#23-model-comparison)
    - 2.3.1 Complex Problem Solving
    - 2.3.2 Creative and Technical Writing
    - 2.3.3 Long Form Content Understanding
- [2.4 Model Router](#24-model-router)
  

### 2.1 Model Discovery
Scenario: You are building a chatbot for a retail company that needs fast responses and safe outputs. Your goal is to explore the Model Catalog and identify models for this use case. There is no right or wrong answer here.

#### Student Task 2.1
- Go into the [Azure AI Foundry](https://ai.azure.com).
- Navigate to the Model Catalog and explore different models using the correct filters. 
- Identify which model can potentially help with the task at hand.
- Share your findings with a peer and compare your choices. Did you pick the same models? Why or why not?

**HINT:** Take a look at the model cards for each model by clicking into them. Evaluate the models based on their capabilities, limitations, and fit for the use case. Which models seem to be good options? Think about the trade-offs as you choose.

### 2.2 Model Leaderboards 
#### Student Task 2.2
- Use the leaderboard feature within the **Model Catalog** in Foundry to compare the performance of selected models you chose from the previous challenge, on industry standard datasets now. This can be found in the **Trade-off charts** section by clicking on **Compare between metrics**.
- Leverage the metrics such as quality, cost, safety, and throughput.

### 2.3 Model Comparison
#### Student Task 2.3
- Navigate to [Github's Model Marketplace](https://github.com/marketplace/models) and sign in with your Github credentials. Github Models provide free access to a set of AI models for anyone with a Github account. 
- Choose two models to compare for the following scenario. What are your observations?

**TIP** The scenario will go into the system prompt. Click on the button "Show parameters setting" next to the trash can once your model has been selected.

Scenario: You are a product manager at a multinational tech company, and your team is developing an advanced AI-powered virtual assistant to provide real-time customer support. The company is deciding between the two models you chose above to power the virtual assistant. Your task is to evaluate both models to determine which one best meets the company's needs for handling diverse customer inquiries efficiently and effectively.

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
- In Chat Playground use the model router deployment and prompt it with a variety of questions ranging simple to difficult. You can use the sample prompts below or come up with your own! Note how different models are used for each query (you can see this switch in the metadata on top of the prompt).
- After trying the below prompts navigate to a browser window and open Copilot. Ask Copilot the pricing for the three different models each query used. Note the price difference for each model. The smart routing is optimizing cost by using light weight models (which are cheaper) for the easier prompts!

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
- Show an understanding for the capabilities of model router and its use cases

## Learning Resources

- [Overview of Azure OpenAI Models](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/models)
- [Use Model Router for Azure AI Foundry](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/model-router)
- [Azure OpenAI Pricing Page](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/)
- [Request for Quota Increase](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR4xPXO648sJKt4GoXAed-0pURVJWRU4yRTMxRkszU0NXRFFTTEhaT1g1NyQlQCN0PWcu)
- [Customize Models](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio)
