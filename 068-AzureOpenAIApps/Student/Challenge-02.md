# Challenge 02 - Contoso Travel Assistant

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Virtual assistants augment customer service and can be leveraged to interact with customers during off-hours or when the customer service team is extremely busy.

Virtual assistants use information available in vector databases and other APIs to read and write to these data stores while providing assistants to the customers.

In this challenge, you will configure three virtual assistants that will answer questions about a fictitious country called Contoso Islands as well as a hypothetical tour company, Contoso Yachts. The virtual assistants will also allow guest to create accounts, manage bank account balances and make or cancel yacht reservations with Contoso Yachts.

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

#### Configuring Your Virtual Assistants

 In your `/ContosoAIAppsBackend` folder there is an `/assistant_configurations` folder that contains two files: one json and one text file

 The text file (`.txt`) shares the same name as the AI assistant and this is where you enter the system message instructing the AI assistant how it should behave.

 The JSON file (`.json`) share the same name as the AI assistant and this is where we define all the tools that the AI assistant is going to use when interacting with the users.

 For this JSON file, the most important portions are the description property of the function as well as the description for each parameter

#### Mapping Python Data Types to JSON Schema Types

| Python Data Type    | JSON Schema Reference |
| -------- | ------- |
| [`str`](https://docs.python.org/3/library/string.html)  |  [`string`](https://json-schema.org/understanding-json-schema/reference/string)   |
| [`bool`](https://docs.python.org/3/library/stdtypes.html#boolean-type-bool)| [`boolean`](https://json-schema.org/understanding-json-schema/reference/boolean)|
| [`int`](https://docs.python.org/3/library/stdtypes.html#numeric-types-int-float-complex)| [`integer`](https://json-schema.org/understanding-json-schema/reference/numeric#integer)|
| [`float`](https://docs.python.org/3/library/stdtypes.html#numeric-types-int-float-complex)| [`number`](https://json-schema.org/understanding-json-schema/reference/numeric#number)|
| [`list` or `tuple`](https://docs.python.org/3/library/stdtypes.html#sequence-types-list-tuple-range) | [`array`](https://json-schema.org/understanding-json-schema/reference/array) |

#### The Python function registration for each assistant are in the following files

This is where the tools are registered in the application.

- `/controllers/ask_donald.py`
- `/controllers/ask_callum.py`
- `/controllers/ask_veta.py`

#### The Python function definition for each assistant are in the following files:

This is where the functions used in the tools are defined in Python code

- `/shared/assistant_tools_donald.py`
- `/shared/assistant_tools_callum.py`
- `/shared/assistant_tools_veta.py`

You will have to look at the code samples to figure out how to describe the function as well as the data type for each parameter for each function. Take a look at the examples for the remaining assistants (Priscilla and Murphy) to see how it is configured to figure out the function description and parameter data types.

Make sure that the value of the first parameter to `ToolUtils.register_tool_mapping()` matches the name of the function in the JSON function definition for the assistant configuration.

The second parameter to `ToolUtils.register_tool_mapping()` is the actual Python function definition.

You will be using this information in these Python files to configure your assistants tools and system messages.

````python

    util = ToolUtils(AssistantName.VETA, system_message1, tools_config1, conversation_id)

    util.register_tool_mapping("check_if_customer_account_exists", v_check_if_customer_account_exists)
    util.register_tool_mapping("get_yacht_details", v_get_yacht_details)
    util.register_tool_mapping("get_bank_account_balance", v_get_bank_account_balance)
    util.register_tool_mapping("bank_account_balance_is_sufficient", v_bank_account_balance_is_sufficient)
    util.register_tool_mapping("get_valid_reservation_search_dates", v_get_valid_reservation_search_dates)
    util.register_tool_mapping("yacht_is_available_for_date", v_yacht_is_available_for_date)
    util.register_tool_mapping("is_valid_search_date", v_is_valid_search_date)
    util.register_tool_mapping("get_yacht_availability_by_id", v_get_yacht_availability_by_id)
    util.register_tool_mapping("get_yacht_availability_by_date", v_get_yacht_availability_by_date)
    util.register_tool_mapping("yacht_reservation_exists", v_yacht_reservation_exists)
    util.register_tool_mapping("get_reservation_details", v_get_reservation_details)
    util.register_tool_mapping("cancel_yacht_reservation", v_cancel_yacht_reservation)
    util.register_tool_mapping("get_customer_yacht_reservations", v_get_customer_yacht_reservations)
    util.register_tool_mapping("create_yacht_reservation", v_create_yacht_reservation)

````

The format for the parameter description and typing follows the JSON schema specification so you can use [this tool](https://www.liquid-technologies.com/online-json-to-schema-converter) to figure out the data types for the parameters.

```json 
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

```

#### Testing and Debugging the Assistants

You can use the `rest-api-ask-assistants.http` REST Client in the `/ContosoAIAppsBackend` folder to test and debug directly against the backend how the assistants will respond. We recommend you use the REST Client so that you will be able to view and troubleshoot any error messages you receive.

The question you have for the AI assistant needs to be in the `message` field for the JSON object for the body of the HTTP request.

Once you have proved the backend is responding properly using the REST Client, you can navigate to the Frontend webpage for the assistants to send your questions to each one.

#### Sequence Diagram for How the Assistants Function
![screenshot of Priscilla Sequence Diagram](../images/PriscillaAssistant.jpg)


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

- [JSON Schema Generators](https://www.liquid-technologies.com/online-json-to-schema-converter) - This is a free online JSON to JSON Schema Converter. It will take a sample JSON document and then infer JSON schema from it. 
- [Function Calling with Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/function-calling)

## Tips

- The sample app in the Function apps contains examples of function calling and prompt templates
