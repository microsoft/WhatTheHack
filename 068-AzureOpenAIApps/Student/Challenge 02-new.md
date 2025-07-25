# Challenge 02 - Model Context Protocol (MCP)

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Virtual assistants augment customer service and can be leveraged to interact with customers during off-hours or when the customer service team is extremely busy.

Virtual assistants use information available in vector databases and other APIs to read and write to these data stores while providing assistance to the customers. 

The virtual assistants will also allow guest to create accounts, manage bank account balances and make or cancel yacht reservations with Contoso Yachts.

There are two existing customers in the database, and there are 5 yachts that customers can make future reservations for a specific date and yacht.

## Description

In this challenge, you will configure 3 virtual assistants:
- A Contoso Islands Travel Assistant
- A Contoso Yachts Assistant
- A Bank Account Management Assistant

#### Contoso Islands Travel Assistant (Donald)
This assistant should be able to answer any question about the country of Contoso Island from any of the following categories:
- Climate of Contoso Islands
- Location and Geography of Contoso Islands
- Population, Tourism details, Languages Spoken and the Economy of Contoso Islands
- Government and Cabinet Members of Contoso Islands

#### Contoso Yachts Assistant (Veta)

Reservations can only be made up to 3 days from the current date.
Reservations must be within the passenger capacity of the yacht.
Reservations should contain the full name, email address and customer identifier in the database.

This virtual assistant should be able to do the following:
- Check if an existing customer has a yacht reservation in the database or not.
- Create a new reservation for a specific date and yacht name
- Cancel existing reservation for a specific yacht and date. Updates the status to cancelled.
- Update the travel party size (number of passengers) for a particular reservation
- Get details about the yacht like how many passengers it can take, its maximum speed, initial date of service and cost of acquisition.

#### Bank Account Management Assistant (Callum)
This assistants allows customers to manage bank accounts.
- It can help the guest to create a new bank account with their email address and full name.
- It can also check account balances
- It can also make deposits and withdrawals from the bank accounts

#### System Messages & Tools for AI Assistants
- System Messages are used in the application configuration to direct the LLM on how it should behave. This is where you exert control over the behavior of the language models used in the application.
- Tools are application method invocations (or functions) that are invoked optionally with input data and the actions are used to query databases or remote APIs to create, update or fetch data that can be used by the LLM to perform tasks or respond to queries from the user.

In this challenge, you will be asked to configure the system message and tools used by each assistant to perform the tasks.

#### What is Model Context Protocol (MCP)?
 MCP is an open protocol that allows us to standardize how tools and data is provided to LLMs. Before MCP one would have to do custom integrations for tools based on the specific APIs and models that are being used. However with MCP you can make one server which has the tools, and the agents can directly talk to the server and access those tools in a standardized way. Below is a diagram of how MCP works (Credit to anthropic for the diagram).

![screenshot of General MCP Diagram](../images/General-MCP-Architecture.png)

#### Components of MCP

Host - The user facing application that manages different clients, enforces security policies, coordinate AI intergration. The main job of a host is to facilitate user interactions and initate connectrions to servers via clients.

Client - Maintains a 1:1 connection with the specific server using the MCP protocol as shown in the diagram above. The main job of a client is to manage bidirectional communication and maintain session state and security boundaries. 

Server - Provides specialized capabilites and access to resources such as data and APIs. This can be local or remote. The main job of the server is to give tools, data or prompts to the client.

#### TODO: Configuring Your MCP Server

 In your `/ContosoAIAppsBackend` folder there is an `llm-full.txt` file that contains detailed instructions to give LLMs on how to build an MCP server. Your job in this hack is to feed that file and the given prompt to Github Copilot and build an MCP server that connects the Veta agent to the national weather service API. This functionality will help you  check the weather before booking the yacht reservation to tour Contoso Islands. 
 
 We have already configured the the client files and all the necessary architecture, all you have to do is fill in the code in `mcp_weather_server.py` to build the server with the help of Github Copilot. Use using the `llm-full.txt` file and the prompt below to ensure that the MCP server is built properly.

**PASTE FINAL PROMPT HERE**

Note: Ensure Github Copilot is in Agent mode and you have used the Add Context button to give it all the files it needs to execute the job properly. The following files may be helpful to add as context but you can add more based on what you think is necessary: veta.json, veta.txt, mcp_weather_server.py, and the ContosoAIAppsBackend folder.

#### How All the Assitants (Except Veta) Currently Work

![screenshot of Priscilla Sequence Diagram](../images/PriscillaAssistant.jpg)

#### How Veta Will Work After Implementing MCP Server

#### Testing and Debugging the Assistants

You can use the `rest-api-ask-assistants.http` REST Client in the `/ContosoAIAppsBackend` folder to test and debug directly against the backend how the assistants will respond. We recommend you use the REST Client so that you will be able to view and troubleshoot any error messages you receive.

The question you have for the AI assistant needs to be in the `message` field for the JSON object for the body of the HTTP request.

Once you have proved the backend is responding properly using the REST Client, you can navigate to the Frontend webpage for the assistants to send your questions to each one.

#### Sequence Diagram for How the Assistants Function
![screenshot of Priscilla Sequence Diagram](../images/PriscillaAssistant.jpg)


## Success Criteria for Each Assistant

To complete the challenge successfully, the solution should demonstrate the following:
- Ensure that the application is able to handle the natural language inputs from the customer
- Configure the assistants that receives that question/query from the customer and responses
- The assistant should be able to keep track of the conversation history during the session and remember important details about the customer making the inquiry or reservation. This should be true for at least the last 3 to 5 sentences input from the customer
- The virtual assistant should be able to handle natural language inputs and be trained to understand different variations of the questions related to the tour status. 
- It should also be able to all the scenarios identified as capabilities for each assistant
- For read/write scenarios, the changes requested by the customer/user should be captured and saved correctly to the databases.

## Learning Resources

Here are a list of resources that should assist you with completing this challenge: 

- [JSON Schema Generators](https://www.liquid-technologies.com/online-json-to-schema-converter) - This is a free online JSON to JSON Schema Converter. It will take a sample JSON document and then infer JSON schema from it. 
- [Function Calling with Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/function-calling)

## Tips

- The sample app in the Function apps contains examples of function calling and prompt templates
