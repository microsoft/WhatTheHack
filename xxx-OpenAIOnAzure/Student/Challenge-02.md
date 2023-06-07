# Challenge 02 - Contoso Real-time Order Tracking Assistant

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites (Optional)

This challenge assumes that all the dependencies in the Challenge 0 were deployed successfully.

## Introduction

Microsoft Azure offers various capabilities and models that enable you to leverage chat completion APIs alongside dynamic content and other technologies to create virtual assistants that can parse these text to provide answers to users.
The goal of this challenge is to help you understand the technologies and resources you need to implement such a virtual assistant.

## Description

Contoso Pizza allows customers to check on the status of their Pizza order right after the order has been placed. The system updates the status of the order in the database at every stage of the process from when it is in the oven, to when it is done and while it is in transit for delivery to the customer

The goal of this challenge is to design and implement a solution that uses Azure OpenAI to create a real-time order tracking assistant chatbot for Contoso Pizza that allows customers to check the status of their Pizza order. The chatbot should be able to query the database to identify the customer based on their email address or phone number and then provide them with the correct status of their order. It should also be able to preserve the context of the conversation history and leverage prior questions and responses to provide good answers.

The order number, name, email address, current status and delivery information of each order is available in the Cosmos DB database.

The database is continuously updated as orders are created, processed, shipped, in-transit and delivered to customers.

A stubbed version of this implementation demonstrating the response formats has been made available for your reference.

## Success Criteria

To complete the challenge successfully, the solution should demonstrate the following:
- Ensure that the application is able to handle the natural language inputs from the customer
- Create an Azure Function that receives that question/query from the customer and responses with an array of most recent responses from the assistant and queries to the assistant.
- The virtual assistant should be able to handle natural language inputs and be trained to understand different variations of the questions related to the order status. 
- It should also be able to handle scenarios where the customer asks for more details about the order status, such as the estimated delivery time.

## Learning Resources

Here are a list of resources that should assist you with completing this challenge:

*Sample resources:*
- [Working with the ChatCompletion APIs](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/chatgpt?pivots=programming-language-chat-completions#working-with-the-chat-completion-api)

## Tips

*Sample tips:*

- Try using the playground first to try some of the responses with excerpts of the order from the database as context.
- Instruct the virtual assistant to respond to only specific types of questions. 
- Implement the solution in any programming language of your choosing using Azure Functions, Azure Cosmos DB, and Azure OpenAI. Use the Azure Cosmos DB SDK to interact with the Cosmos DB database and retrieve the order details. Use the Azure OpenAI SDK to create the chatbot and handle the natural language inputs from the customer.

The code could implement the following utilities and helpers to aid in your implementation:
- A method to retrieve the order details from the Cosmos DB database based on the customer email address or phone number
- A helper function or method that converts the database content for the customer into text that can be injected into the assistant's context.
- The virtual assistant should be able to handle scenarios where the customer asks for more details about the order status, such as the estimated delivery time, and provide the appropriate response.
