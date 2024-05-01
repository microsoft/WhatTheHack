# Challenge 05 - Responsible AI

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)**

## Pre-requisites

- Cognitive Search Index implementation from Challenge 4
- Install required libraries in the `requirements.txt` file via `pip install -r requirements.txt` if you have not already.

## Introduction

As LLMs grow in popularity and use around the world, the need to manage and monitor their outputs becomes increasingly important. In this challenge, you will learn how to evaluate the outputs of LLMs and how to identify and mitigate potential biases in the model.

## Description

Questions you should be able to answer by the end of this challenge:
- What are services and tools to identify and evaluate harms and data leakage in LLMs?
- What are ways to evaluate truthfulness and reduce hallucinations?
- What are methods to evaluate a model if you don't have a ground truth dataset for comparison?

Sections in this Challenge:
1. Identifying harms and detecting Personal Identifiable Information (PII)
2. Evaluating truthfulness using Ground-Truth Datasets
3. Evaluating truthfulness using GPT without Ground-Truth Datasets

You will run the following Jupyter notebook for this challenge:

- `CH-05-ResponsibleAI.ipynb`

The file can be found in your Codespace under the `/notebooks` folder. 
If you are working locally or in the Cloud, you can find it in the `/notebooks` folder of `Resources.zip` file. 

To run a Jupyter notebook, navigate to it in your Codespace or open it in VS Code on your local workstation. You will find further instructions for the challenge, as well as in-line code blocks that you will interact with to complete the tasks for the challenge.  Return here to the student guide after completing all tasks in the Jupyter notebook to validate you have met the [success criteria](#success-criteria) below for this challenge.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Articulate Responsible AI principles with OpenAI
- Demonstrate methods and approaches for evaluating LLMs
- Identify tools available to identify and mitigate harms in LLMs

## Additional Resources

- [Overview of Responsible AI practices for Azure OpenAI models](https://learn.microsoft.com/en-us/legal/cognitive-services/openai/overview)
- [Azure Cognitive Services - What is Content Filtering](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/content-filter)
- [Azure AI Content Safety tool](https://learn.microsoft.com/en-us/azure/cognitive-services/content-safety/overview)
- [Azure Content Safety Annotations feature](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/content-filter#annotations-preview)
- [OpenAI PII Detection Plugin](https://github.com/openai/chatgpt-retrieval-plugin/tree/main#plugins)
- [Hugging Face Evaluate Library](https://huggingface.co/docs/evaluate/index)
- [Question Answering Evaluation using LangChain](https://python.langchain.com/en/latest/use_cases/evaluation/qa_generation.html)
- [OpenAI Technical Whitepaper on evaluating models (see Section 3.1)](https://cdn.openai.com/papers/gpt-4-system-card.pdf)
