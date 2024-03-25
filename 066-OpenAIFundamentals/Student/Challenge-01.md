# Challenge 01 - Prompt Engineering

[< Previous Challenge](./Challenge-00.md) -  **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Prerequisites

* Deploy your own AOAI models in the [AOAI portal](https://oai.azure.com/portal/)
* Update the `sample-env.txt` file (and save as `.env`) according to your model names if you haven't already

## Introduction

As LLMs grow in popularity and use around the world, the need to manage and monitor their outputs becomes increasingly important. In this challenge, you will learn how to use prompt engineering techniques to generate desired results for LLMs.

## Description
Model deployment for the challenge:
- Deploy the following models in your Azure OpenAI resource. 
  - `gpt-35-turbo`

    
**NOTE:** Model families currently available as of _Aug 4, 2023_ in Azure OpenAI includes GPT-3, Codex and Embeddings, GPT-4 is available for application. Please reference this link for more information: [Azure OpenAI Service models](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models).
Some models are not available for new deployments beginning **July 6, 2023**. Deployments created prior to July 6, 2023 remain available to customers until **July 5, 2024**. You may revise the environment file and the model you deploy accordingly. Please refer to the following link for more details: [Azure OpenAI Service legacy models](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/legacy-models)
- Add required credentials of Azure resources in the ``.env`` file. Please feel free to make any modifications as needed and then rename the ".env-sample" file to ".env".
  
Questions you should be able to answer by the end of this challenge:
- What is the iterative prompting principle?
- Which hyperparameters could you tune to make the response more diverse in language?
- What prompt engineering technique could you use to help model complete hard tasks like math problems?

You will run the following Jupyter notebook for this challenge. You can find it in the `/Notebooks` folder of `Resources.zip` file. 
- `CH-01-PromptEngineering.ipynb`

Sections in this Challenge:
1. Parameter Experimentation
2. System Message Engineering
3. Iterative Prompting Principles: 

   3.1 Write clear and specific instructions
   
   3.2 Give the model time to “think”

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
