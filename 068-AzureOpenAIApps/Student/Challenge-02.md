# Challenge 02 - Weather Integration Using Model Context Protocol

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Contoso Yacht's "Citrus Bus" application features multiple AI-powered virtual assistants that can be used by both its customer service team and Contoso Yacht's customers. The virtual assistants augment customer service and can be leveraged to interact with customers during off-hours or when the customer service team is extremely busy.

There are three virtual assistants that you will experiment with during this challenge:
- Donald
- Callum
- Veta

The virtual assistants use information available in vector databases and other APIs to read and write to these data stores while providing assistance to the customers. They also allow customers to create accounts, manage bank account balances, and make or cancel yacht reservations with Contoso Yachts. There are two existing customers in the Citrus Bus application database and there are 5 yachts that customers can make future reservations for a specific date and yacht.

The Donald & Callum assistants are fully implemented and you will explore their functionality during this challenge. The main focus of this challenge is to extend the Veta virtual assistant's functionality using Model Context Protocol (MCP) to consider the current weather forecast when booking a yacht reservation.

### What is Model Context Protocol (MCP)?
MCP is an open protocol that allows us to standardize how tools and data is provided to LLMs. Before MCP, one would have to do custom integrations for tools based on the specific APIs and models that are being used. However, with MCP you can make one server which has the tools, and the agents can directly talk to the server and access those tools in a standardized way. Below is a diagram of how MCP works (credit to Anthropic for the diagram).

![screenshot of General MCP Diagram](../images/General-MCP-Architecture.png)

### Components of MCP

**Host** - The user facing application that manages different clients, enforces security policies, and coordinates AI integration. The main job of a host is to facilitate user interactions and initiate connections to servers via clients.

**Client** - Maintains a 1:1 connection with the specific server using the MCP protocol as shown in the diagram above. The main job of a client is to manage bidirectional communication and maintain session state and security boundaries. 

**Server** - Provides specialized capabilities and access to resources such as data and APIs. This can be local or remote. The main job of the server is to give tools, data, or prompts to the client.

### Security in Model Context Protocol (MCP)?

There are many security aspects to consider when using MCP for enterprise applications, your coach should cover these during the lecture for this challenge. There is also a link provided in the Learning Resources section below about security, that you can read for more guidance and details..

## Description

The goal of this challenge is explore the existing functionality of the virtual assistants, then extend the functionality of the Veta virtual assistant to consider the current weather forecast when booking a yacht reservation. Finally, you will test all of the assistants to ensure they work properly.

### Understanding Virtual Assistant Functionality

The virtual assistants are configured with System Messages (prompts) to use Tools (functions/APIs) to complete their tasks.

#### System Messages & Tools for AI Assistants
- System Messages are used in the application configuration to direct the LLM on how it should behave. This is where you exert control over the behavior of the language models used in the application.
- Tools are application method invocations (or functions) that are invoked optionally with input data and the actions are used to query databases or remote APIs to create, update or fetch data that can be used by the LLM to perform tasks or respond to queries from the user.

Please view the configuration files in the `/ContosoAIAppsBackend/assistant_configurations` folder for the Donald, Veta, and Callum assistants to understand what each of the assistants do. 

- The `.txt` file for each assistant contains the system message (prompt) that specifies to the LLM how the assistant should behave
- The `.json` file for each assistant specifies what tools (functions/APIs) the assistants have the ability to invoke.

As you will be extending Veta's functionality, note the following requirements for Veta:
- Reservations can only be made up to 3 days from the current date.
- Reservations must be within the passenger capacity of the yacht.
- Reservations should contain the full name, email address and customer identifier in the database.

At the end of this challenge, you will test each of the assistant's functionalities to see them in action.

### Configure MCP Server for the Veta Virtual Assistant

In this challenge, you will configure and build an MCP server that connects the Veta assistant to the National Weather Service API.

In your `/data/mcp-info` folder there is an `llm-full.txt` file that contains detailed instructions to give LLMs on how to build an MCP server. Your job in this hack is to feed that file and the given prompt to GitHub Copilot and build an MCP server that connects Veta, the the booking assistant to the national weather service API. This functionality will help you check the weather before booking the yacht reservation to tour Contoso Islands. 
 
We have already configured the the MCP client files and all the necessary architecture, your task is to fill in the missing code in `mcp_weather_server.py` located in `/ContosoAIAppsBackend/mcp` folder to build the MCP server component with the help of GitHub Copilot. 

Use the `llm-full.txt` file in `/data/mcp-info` and the prompt below to ensure that the MCP server is built properly:
 
```
Complete the functions with TODO in the mcp_weather_server.py file to have the proper functionality and look the llms-full.txt file to do so. Carefully look at the mcp_weather_client file to ensure the names of functions are the same to ensure they can call each other. Also look at veta.txt and veta.json to know what the agent functionality is supposed to be. Make the code as simple as possible to have proper functionality. Only change the server file since everything else is properly configured to work with a properly configured server.
```

In the `/data` folder you will find a set of documentation files that were generated by AI.  We recommend optionally reading through these files to help you learn and fully understand what the code does:
- [MCP Weather Integration - Implementation Summary](./Resources/data/mcp-info/IMPLEMENTATION_SUMMARY.md)
- [MCP_Weather Integration for Contoso AI Apps Backend](./Resources/data/mcp-info/MCP_WEATHER_INTEGRATION.md)
- [MCP_Weather Integration - Documentation](./Resources/data/mcp-info/MCP_WEATHER_README.md)

#### Tips for using GitHub Copilot
- Ensure GitHub Copilot is in Agent mode and you have used the Add Context button to give it all the files it needs to execute the job properly.
- The following files may be helpful to add as context but you can add more based on what you think is necessary: `llm-full.txt`, `veta.json`, `veta.txt`, `mcp_weather_server.py`, `ask_veta.py`, `IMPLEMENTATION_SUMMARY.md`, `MCP_WEATHER_INTEGRATION.md`, `MCP_WEATHER_README.md`, and the `ContosoAIAppsBackend` folder.
- After implemented toggle from Agent mode to Ask mode to ask it whether the implementation is proper.
- Also play around with the coordinates in `veta.txt` and change them to your current location to see how accurate the weather is (you will have the kill the terminal and restart the front and backend after making any changes to the app).
- This challenge will take a few tries and debugging to work, but please try to persevere through it.

#### How All the Assistants (Except Veta) Currently Work

![screenshot of Priscilla Sequence Diagram](../images/PriscillaAssistant.jpg)

#### How Veta Will Work After Implementing MCP Server

![screenshot of Veta Sequence Diagram](../images/Veta-ADS.png)

#### Initialization Sequence

This is how the sync between the client and server is initialized.

```
Veta Assistant Request
    ↓
Weather Tools Called
    ↓
SyncMCPWeatherClient._ensure_client()
    ↓
Start subprocess: python mcp_weather_server.py
    ↓
JSON-RPC handshake:
    - initialize request
    - capabilities exchange
    - initialized notification
```

#### Weather Request Flow

This is a flow of the user query, showing which functions are activated when a prompt is given to the Veta Assistant. This is the general flow that your prompt takes before the Assistant gives you back the response.

```
User: "Book yacht for tomorrow"
    ↓
Veta: Check weather conditions
    ↓
Weather Tools: v_get_weather_summary_for_client()
    ↓
MCP Client: get_weather_summary()
    ↓
JSON-RPC: tools/call request
    ↓
MCP Server: handle_call_tool()
    ↓
HTTP Request: NWS API
    ↓
Format & Return: Client-friendly summary
    ↓
Veta: Present weather to customer
```
### Testing and Debugging the Assistants

You can use the `rest-api-ask-assistants.http` REST Client in the `/ContosoAIAppsBackend` folder to test and debug directly against the backend how the assistants will respond. We recommend you use the REST Client so that you will be able to view and troubleshoot any error messages you receive.

The question you have for the AI assistant needs to be in the `message` field for the JSON object for the body of the HTTP request.

Once you have proved the backend is responding properly using the REST Client, you can navigate to the Frontend webpage for the assistants to send your questions to each one.

## Success Criteria

To complete the challenge successfully, the solution should demonstrate the following:
- Understand how the agents work and play with their functionalities
- The MCP server is built and functioning
- Veta is providing weather information when you ask for a yacht reservation.
- You are able to book a reservation using the Veta agent

## Learning Resources

Here are a list of resources that should assist you with completing this challenge: 

- [Basic MCP Information](https://modelcontextprotocol.io/introduction) - This is basic documentation for MCP provided by Anthropic
- [How to Build MCP Servers With LLMS](https://modelcontextprotocol.io/tutorials/building-mcp-with-llms) - Clearly lays out instructions for how to build MCP servers faster using LLMs
- [MCP for Beginners](https://github.com/microsoft/mcp-for-beginners#msdynttrid=l9Nn7lrAy_8n7EEHOO-5tEDmdgsw2eIsIXZAuIMQwAs) - GitHub repo that walks through key concepts of MCP
- [Security Best Practices](https://modelcontextprotocol.io/specification/draft/basic/security_best_practices) - Anthropic's recommendations for security with MCP
## Tips

- If you run into bugs try adding more context to GitHub Copilot and maybe even change the provided prompt to deal with those bugs















