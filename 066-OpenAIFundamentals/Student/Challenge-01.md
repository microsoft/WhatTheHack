# Challenge 01 - Prompt Engineering

[< Previous Challenge](./Challenge-00.md) -  **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Prerequisites

* Ensure you have the needed resources from the previous challenge in [Microsoft Foundry](https://ai.azure.com/)
* Update the `.env.sample` file (and save as `.env`) with your respective resource credentials if you haven't already done so. 

## Introduction

As LLMs grow in popularity and use around the world, the need to manage and monitor their outputs becomes increasingly important. In this challenge, you will learn how to use prompt engineering techniques to generate desired results for LLMs.

## Description

**NOTE:** For model families currently available, please reference this link for more information: [Azure OpenAI Service models](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models).
  
Questions you should be able to answer by the end of this challenge:
- What is the iterative prompting principle?
- Which hyperparameters could you tune to make the response more diverse in language?
- What prompt engineering technique could you use to help model complete hard tasks like math problems?

You will run the following Jupyter notebook to complete the tasks for this challenge:
- `CH-01-PromptEngineering.ipynb`

The file can be found in your Codespace under the `/notebooks` folder. 
If you are working locally or in the Cloud, you can find it in the `/notebooks` folder of `Resources.zip` file. 

To run a Jupyter notebook, navigate to it in your Codespace or open it in VS Code on your local workstation. You will find further instructions for the challenge, as well as in-line code blocks that you will interact with to complete the tasks for the challenge.  Return here to the student guide after completing all tasks in the Jupyter notebook to validate you have met the [success criteria](#success-criteria) below for this challenge.

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
