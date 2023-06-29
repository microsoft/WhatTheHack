# Challenge 01 - Prompt Engineerng

   **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)


## Pre-requisites

* Access to Azure subscription, create notebook in Azure Machine Learning Studio
* Apply and obtain access to Azure OpenAI resources
* Deploy your own AOAI models in AOAI portal
* Edit the .env file according to your model names

## Introduction

As LLMs grow in popularity and use around the world, the need to manage and monitor their outputs becomes increasingly important. In this challenge, you will learn how to use prompt engineering techniques to generate desired results for LLMs.


## Description
Model deployment for the challenge:
- Deploy the following models in your Azure OpenAI resource. 
  - gpt-35-turbo
  - text-ada-001
  - text-babbage-001
  - text-curie-001
  - text-davinci-003
  - text-embedding-ada-002
- Add required credentials of Azure resources in the ``.env`` file
  
Questions you should be able to answer by the end of this challenge:
- What is iterative prompting principle?
- Which hyperparameters could you tune to make the response more diverse in language?
- What prompt engineering technique could you use to help model complete hard tasks like math problems?

Sections in this Challenge:
1. Parameter Experimentation
2. System Message Engineering
3. Iterative Prompting Principles: 

   3.1 Write clear and specific instructions
   
   3.2 Give the model time to “think”

Link to the Notebook: 
- [Challenge 01](https://github.com/izzymsft/WhatTheHack/blob/xxx-OpenAIFundamentals/xxx-OpenAIFundamentals/Student/Resources/Notebooks/CH-01-PromptEngineering.ipynb)


## Success Criteria
To complete this challenge successfully:
- Demonstrate understanding of types of tasks OpenAI models are capable of
- Demonstrate understanding of different hyperparameters in OpenAI models
- Demonstrate understanding of different using scenarios of prompt engineering techniques
- Be able to perform iterative prompting practice in exercise
- Make all the code cells run successfully


## Additional Resources
- [Introduction to prompt engineering](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/prompt-engineering)
- [Prompt engineering techniques](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/advanced-prompt-engineering?pivots=programming-language-chat-completions)
- [System message framework and template recommendations for Large Language Models (LLMs)](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/system-message)
- [Introduction to Azure OpenAI Service](https://learn.microsoft.com/en-us/training/modules/explore-azure-openai/)
- [Learn how to prepare your dataset for fine-tuning](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/prepare-dataset)
- [Learn how to customize a model for your application](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio)
