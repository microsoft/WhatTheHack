# Challenge 01 - Contoso Travel Assistant

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites (Optional)

This challenge assumes that all the dependencies in the Challenge 0 were deployed successfully.

## Introduction
Microsoft Azure offers various capabilities and models that enable you to leverage chat completion APIs alongside static text and other technologies to create virtual assistants that can parse these text to provide answers to users.
The goal of this challenge is to help you understand the technologies and resources you need to implement such a virtual assistant.

## Description

Contoso Travel is a 40-person organization that specializes in booking travel to various destinations around the world. Based on the information available on ContosoTravel.com, implement a chatbot that can leverage static information about Contoso Travel and answer questions that prospective customers may have about travel ideas.

The database contoso-travel within the Cosmos DB service contains a collection called static-data with information used to populate the Contoso Travel website. 

In this challenge, you will design and implement an architecture for a chatbot solution that leverages Azure OpenAI to provide travel ideas and answer questions for prospective customers of Contoso Travel based on the information available in the static-data collection.

## Success Criteria

To complete the challenge successfully, the solution should demonstrate the following:
- The chatbot assistant should be able to understand and respond to natural language queries about travel ideas, such as "What are some popular destinations for summer travel?"
- The virtual assistant should be able to access static information about Contoso Travel, such as information about destinations, activities, and packages.
- The solution should make sure that the number of input+output tokens is always within the limits allowed by the model while minimizing costs.
- The virtual assistant should be able to provide personalized recommendations to customers based on their preferences and interests. 
- The solution should be scalable to handle a large number of concurrent users.

## Learning Resources

Here are a list of resources that should assist you with completing this challenge:

*Sample resources:*

- [Vector Search Similarity Capabilities in Azure Cache for Redis](https://techcommunity.microsoft.com/t5/azure-developer-community-blog/introducing-vector-search-similarity-capabilities-in-azure-cache/ba-p/3827512)
- [Vector Similarity Search with Redis](https://techcommunity.microsoft.com/t5/azure-developer-community-blog/vector-similarity-search-with-azure-cache-for-redis-enterprise/ba-p/3822059)
- [Working with the ChatCompletion APIs](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/chatgpt?pivots=programming-language-chat-completions#working-with-the-chat-completion-api)

## Tips

*Sample tips:*

- Try using the playground first to try some of the responses with excerpts of the static data as context.
- Instruct the virtual assistant to respond to only specific types of questions.
