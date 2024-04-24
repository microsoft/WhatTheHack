# Challenge 02 - Contoso Travel Assistant

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites (Optional)

This challenge assumes that Challenge 01 has been completed successfully.

## Introduction

Virtual assistants augment customer service and can be leveraged to interact with customers during off-hours or when the customer service team is extremely busy.

Virtual assistants use information available in vector databases and other APIs to read and write to these data stores while providing assistants to the customers.

In this challenge, you will configure three virtual assistants that will answer questions about a fictitious country called Contoso Islands as well as a hypothetical tour company (Contoso Yachts). The virtual assistants will also allow guest to create accounts, manage bank account balances and make/cancel Yacht reservations with Contoso Yachts.

There are two existing customers in the database, and there are 5 yachts that customers can make future reservations for a specific date and yacht.

## Description

In this challenge, you will create 3 virtual assistants:
- Contoso Islands Travel Assistant
- Contoso Yachts Assistant
- Bank Account Management Assistant

#### Contoso Islands Travel Assistant (Elizabeth)
This assistant should be able to answer any question about the country of Contoso Island from any of the following categories:
- Climate of Contoso Islands
- Location and Geography of Contoso Islands
- Population, Tourism details, Languages Spoken and the Economy of Contoso Islands
- Government and Cabinet Members of Contoso Islands

#### Contoso Yachts Assistant (Esther)

Reservations can only be made up to 3 days from the current date.
Reservations must be within the passenger capacity of the yacht.
Reservations should contain the full name, email address and customer identifier in the database.

This virtual assistant should be able to do the following:
- Check if an existing customer has a Yacht reservation in the database or not.
- Create a new reservation for a specific date and yacht name
- Cancel existing reservation for a specific yacht and date. Updates the status to cancelled.
- Update the travel party size (number of passengers) for a particular reservation
- Get details about the Yacht like how many passengers it can take, its maximum speed, initial date of service and cost of acquisition.

#### Bank Account Management Assistant (Miriam)
This assistants allows customers to manage bank accounts.
- It can help the guest to create a new bank account with their email address and full name.
- It can also check account balances
- It can also make deposits and withdrawals from the bank accounts

#### Configuring Your Virtual Assistants

 In your ContosoAIAppsBackend folder there is an assistant_configurations folder that contains two files: one json and one text file

 The text file (.txt) shares the same name as the AI assistant and this is where you enter the system message instructing the AI assistant how it should behave.

 The json file (.json) share the same name as the AI assistant and this is where we define all the tools that the AI assistant is going to use when interacting with the users.

 For this JSON file, the most important portions are the description property of the function as well as the description for each parameter

 ````json
[
    {
        "type": "function",
        "function": {
            "name": "ask_question",
            "description": "Retrieves answers to relevant questions about the country Contoso Islands",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "The question about Contoso Islands"
                    }
                },
                "required": ["query"]
            }
        }
    },
    {
      "type": "function",
      "function": {
          "name": "get_yacht_details",
          "description": "Retrieves the details of the yacht such as name, price, maximum capacity and description",
          "parameters": {
              "type": "object",
              "properties": {
                  "yacht_id": {
                    "type": "string",
                    "enum": ["100", "200","300","400","500"],
                    "description": "The yacht id for the yacht"
                  }
              },
              "required": ["yacht_id"]
          }
      }
  },
]

 ````

 You can use the rest-api-ask-assistants.http REST Client to interact with the first assistant (Elizabeth) to make sure it is all working properly. The question you have for the AI assistant needs to be in the "message" field for the JSON object for the body of the HTTP request.

 Once this is up and running for the backend, you can navigate to the page for Elizabeth to send you questions to her.

## Success Criteria for Each Assistant

To complete the challenge successfully, the solution should demonstrate the following:
- Ensure that the application is able to handle the natural language inputs from the customer
- Configure the assistants that receives that question/query from the customer and responses.
- The assistant should be able to keep track of the conversation history during the session and remember important details about the customer making the inquiry or reservation. This should be true for at least the last 3 to 5 sentences input from the customer. 
- The virtual assistant should be able to handle natural language inputs and be trained to understand different variations of the questions related to the tour status. 
- It should also be able to all the scenarios identified as capabilities for each assistant
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
