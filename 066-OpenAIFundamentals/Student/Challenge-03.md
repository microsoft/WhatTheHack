# Challenge 03 - Grounding, Chunking, and Embedding

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)


## Pre-requisites

* Azure Cognitive Search resource for indexing and retrieving relevant information
* Azure OpenAI service for Generative AI Models and Embedding Models
* Add required credentials of above resources in `.env` file
* Install the required libraries in the `requirements.txt` file via ```pip install -r requirements.txt ``` if you have not already.

## Introduction

When working with large language models, it is important to understand how to ground them with the right data. In addition, you will take a look at how to deal with token limits when you have a lot of data. Finally, you will experiment with embeddings. This challenge will teach you all the fundamental concepts - Grounding, Chunking, Embedding - before you see them in play in Challenge 4. Below are brief introductions to the concepts you will learn.

Grounding is a technique used when you want the model to return reliable answers to a given question.
Chunking is the process of breaking down a large document. It helps limit the amount of information we pass into the model.
An embedding is an information dense representation of the semantic meaning of a piece of text.

## Description

Questions you should be able to answer by the end of the challenge:

- Why is grounding important and how can you ground a LLM model?
- What is a token limit?
- How can you deal with token limits? What are techniques of chunking?
- What do embedding help accomplish?


You will run the following three Jupyter notebooks for this challenge:

* `CH-03-A-Grounding.ipynb`
* `CH-03-B-Chunking.ipynb`
* `CH-03-C-Embeddings.ipynb`

These files can be found in your Codespace under the `/notebooks` folder. 
If you are working locally or in the Cloud, you can find them in the `/notebooks` folder of `Resources.zip` file. 

To run a Jupyter notebook, navigate to it in your Codespace or open it in VS Code on your local workstation. You will find further instructions for the challenge, as well as in-line code blocks that you will interact with to complete the tasks for the challenge.  Return here to the student guide after completing all tasks in the Jupyter notebook to validate you have met the [success criteria](#success-criteria) below for this challenge.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that you are able to ground a model through the system message
- Demonstrate various chunking techniques
- Demonstrate how to create embeddings 

## Additional Resources 

* [Grounding LLMs](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/grounding-llms/ba-p/3843857)
* [Embeddings example](https://github.com/openai/openai-cookbook/blob/main/examples/Embedding_Wikipedia_articles_for_search.ipynb)
* [Langchain Chunking](https://js.langchain.com/docs/modules/indexes/text_splitters/examples/recursive_character)
  
