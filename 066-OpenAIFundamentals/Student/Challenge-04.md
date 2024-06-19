# Challenge 04 - Retrieval Augmented Generation (RAG) 

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Pre-requisites 

- Azure Form Recognizer resource for extracting text from raw unstructured data
- Azure Cognitive Search resource for indexing and retrieving relevant information
- Azure OpenAI service for Generative AI Models and Embedding Models
- Add required credentials of above resources in `.env` file 
- Install the required libraries in the `requirements.txt` file via ```pip install -r requirements.txt ``` if you have not already

## Introduction

Knowledge bases are widely used in enterprises and can contain an extensive number of documents across various categories. Retrieving relevant content based on user queries is a challenging task. Traditionally, methods like Page Rank have been employed to accurately retrieve information at the document level. However, users still need to manually search within the document to find the specific and relevant information they need. The recent advancements in Foundation Models, such as the one developed by OpenAI, offer a solution through the use of "Retrieval Augmented Generation" techniques and encoding information like "Embeddings." These methods aid in finding the relevant information and then to answer or summarize the content to present to the user in a concise and succinct manner.

Retrieval augmented generation (RAG) is an innovative approach that combines the power of retrieval-based Knowledge bases, such as Azure Cognitive Search, and generative Large Language Models (LLMs), such as Azure OpenAI ChatGPT, to enhance the quality and relevance of generated outputs. This technique involves integrating a retrieval component into a generative model, enabling the retrieval of contextual and domain-specific information from the knowledge base. By incorporating this contextual knowledge alongside the original input, the model can generate desired outputs, such as summaries, information extraction, or question answering. In essence, the utilization of RAG with LLMs allows you to generate domain-specific text outputs by incorporating specific external data as part of the context provided to the LLMs.

RAG aims to overcome limitations found in purely generative models, including issues of factual accuracy, relevance, and coherence, often seen in the form of "hallucinations". By integrating retrieval into the generative process, RAG seeks to mitigate these challenges. The incorporation of retrieved information serves to "ground" the large language models (LLMs), ensuring that the generated content better aligns with the intended context, enhances factual correctness, and produces more coherent and meaningful outputs.

## Description

Questions you should be able to answer by the end of the challenge:

- How do we create ChatGPT-like experiences on Enterprise data? In other words, how do we "ground" powerful Large Language Models (LLMs) to primarily our own data?
- Why is the combination of retrieval and generation steps so important and how do they allow integration of knowledge bases and LLMs for downstream AI tasks?
- Given the token limit constraints, how does RAG approach help in dealing with long and complex documents?
- How can this approach be applied to wide range of applications such as question answering, summarization, dialogue systems, and content generation?

Some Considerations:

- **Evaluation challenges:** Evaluating the performance of RAG poses challenges, as traditional metrics may not fully capture the improvements achieved through retrieval. Developing task-specific evaluation metrics or conducting human evaluations can provide more accurate assessments of the quality and effectiveness of the approach.
- **Ethical considerations:** While RAG provides powerful capabilities, it also introduces ethical considerations. The retrieval component should be carefully designed and evaluated to avoid biased or harmful information retrieval. Additionally, the generated content should be monitored and controlled to ensure it aligns with ethical guidelines and does not propagate misinformation or harmful biases.

You will run the following two Jupyter notebooks for this challenge:

- `CH-04-A-RAG_for_structured_data.ipynb` 
- `CH-04-B-RAG_for_unstructured_data.ipynb`

These files can be found in your Codespace under the `/notebooks` folder. 
If you are working locally or in the Cloud, you can find them in the `/notebooks` folder of `Resources.zip` file. 

To run a Jupyter notebook, navigate to it in your Codespace or open it in VS Code on your local workstation. You will find further instructions for the challenge, as well as in-line code blocks that you will interact with to complete the tasks for the challenge.  Return here to the student guide after completing all tasks in the Jupyter notebook to validate you have met the [success criteria](#success-criteria) below for this challenge.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that you have extracted text from raw unstructured data using the Azure Document Intelligence API into a more structured format such as JSON
- Verify that you have created an index using Azure Cognitive Search based on the type of data you are dealing with and load data into the index.
- Demonstrate the use of Iterative Prompt Development to write effective prompts for your AI tasks


## Learning Resources

- [Use OpenAI GPT with your Enterprise Data](https://techcommunity.microsoft.com/t5/startups-at-microsoft/use-openai-gpt-with-your-enterprise-data/ba-p/3817141)
- [ChatGPT + Enterprise data with Azure OpenAI and Cognitive Search](https://github.com/Azure-Samples/azure-search-openai-demo)
- [Build Industry-Specific LLMs Using Retrieval Augmented Generation](https://towardsdatascience.com/build-industry-specific-llms-using-retrieval-augmented-generation-af9e98bb6f68)

## Advanced Challenges (Optional)

Too comfortable?  Eager to do more?  Try these additional challenges!

- Think about how you can evaluate your answers and the performance of RAG. What are some techniques you can apply?
- Think about how you can moderate harmful user questions, avoid biases, and mitigate prompt injection attacks.
