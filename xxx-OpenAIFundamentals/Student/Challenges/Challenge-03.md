# Challenge 03 - Grounding, Chunking, and Embedding

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)


## Pre-requisites

* Azure Cognitive Search resource for indexing and retrieving relevant information
* Azure OpenAI service for Generative AI Models and Embedding Models
* Add required credentials of above resources in .env file
* Install the required libraries in the requirements.txt file via ```pip install -r requirements.txt ```

## Introduction

When working with large language models, it is important to understand how to ground them with the right data. In addition, you will take a look at how to deal with token limits when you have a lot of data. Finally, you will experiment with embeddings. This challenge will teach you all the fundamental concepts before you see them in play in Challenge 4.

## Description

Questions you should be able to answer by the end of the challenge:

* Why is grounding important and how can you ground a LLM model?

* What is a token limit?

* How can you deal with token limits? What are techniques of chunking?

* What do embedding help accomplish?

Sections in this Challenge:

* [CH-03-A-Grounding](../Resources/Notebooks/CH-03-A-Grounding.ipynb?raw=true)
* [CH-03-B-Chunking](../Resources/Notebooks/CH-03-B-Chunking.ipynb)
* [CH-03-C-Embeddings](../Resources/Notebooks/CH-03-C-Embeddings.ipynb)



   
## Success Criteria

To complete this challenge successfully, you should be able to:
- Identify the simplest method for grounding
- Understand chunking techniques
- Create embeddings 

## Additional Resources 

* [Grounding LLMs](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/grounding-llms/ba-p/3843857)
* [Embeddings example](https://github.com/openai/openai-cookbook/blob/main/examples/Embedding_Wikipedia_articles_for_search.ipynb)
* [Langchain Chunking](https://js.langchain.com/docs/modules/indexes/text_splitters/examples/recursive_character)
  
