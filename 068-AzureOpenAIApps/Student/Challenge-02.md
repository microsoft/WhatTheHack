# Challenge 02 - Contoso Travel Assistant

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites (Optional)

This challenge assumes that Challenge 01 has been completed successfully.

## Introduction

Virtual assistants augment customer service and can be leveraged to interact with customers during off-hours or when the customer service team is extremely busy.

Virtual assistants use information available in vector databases and other APIs to read and write to these data stores while providing assistants to the customers.

In this challenge, you will design a system that will read data about a fictitious country Contoso Islands as well as a hypothetical tour company (Contoso Yachts).

There are two existing customers in the database, and there are 5 yachts that customers can make future reservations for a specific date and yacht.

## Description

In this challenge, you will create 3 virtual assistants:
- Contoso Islands Travel Assistant
- Contoso Yachts Assistant

#### Contoso Islands Travel Assistant
This assistant should be able to answer any question about the country of Contoso Island from any of the following categories:
- Climate of Contoso Islands
- Location and Geography of Contoso Islands
- Population, Tourism details, Languages Spoken and the Economy of Contoso Islands
- Government and Cabinet Members of Contoso Islands

#### Contoso Yachts Assistant

Reservations can only be made up to 3 days from the current date.
Reservations must be within the passenger capacity of the yacht.
Reservations should contain the full name, email address and customer identifier in the database.

This virtual assistant should be able to do the following:
- Check if an existing customer has a Yacht reservation in the database or not.
- Create a new reservation for a specific date and yacht name
- Cancel existing reservation for a specific yacht and date. Updates the status to cancelled.
- Update the travel party size (number of passengers) for a particular reservation
- Get details about the Yacht like how many passengers it can take, its maximum speed, initial date of service and cost of acquisition.

## Success Criteria

To complete the challenge successfully, the solution should demonstrate the following:
- Ensure that the application is able to handle the natural language inputs from the customer
- Create an Azure Function that receives that question/query from the customer and responses.
- The assistant should be able to keep track of the conversation history during the session and remember important details about the customer making the inquiry or reservation 
- The virtual assistant should be able to handle natural language inputs and be trained to understand different variations of the questions related to the tour status. 
- It should also be able to handle scenarios where the customer asks for more details about the reservation status, such as the estimated delivery time.
- For read/write scenarios, the changes requested by the customer/user should be captured and saved correctly to the databases.

## Learning Resources

Here are a list of resources that should assist you with completing this challenge:

*Sample resources:*
- [Function Calling with Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/function-calling)
- https://redis.io/docs/data-types/strings/
- https://redis.io/docs/data-types/lists/

## Tips

*Sample tips:*

- The sample app in the Function apps contains examples of function calling and prompt templates
