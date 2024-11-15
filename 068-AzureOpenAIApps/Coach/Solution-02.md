# Challenge 02 - Work with assistants - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Assistant Name Changes

Names of assistants in the source code have been changed but in the case that a reference to an older name is encountered, use the following map:

- Elizabeth was changed to Donald
- Esther was changed to Callum
- Miriam was changed to Veta
- Sarah was changed to Murphy

## Notes & Guidance

This challenge is about interacting with virtual assistants that will provide the following functionality:

- Answer Questions about the Contoso Islands - Assistant Donald
- Create Accounts, Manage Customer Bank Account Balances (Deposits, Withdrawals) - Assistant Callum
- Make or Cancel Yacht Reservations for Contoso Island Tourists - Assistant Veta


We have the following AI Assistants
For this challenge, the student participant needs to modify the following files in the `/assistant_configurations` folder of the app
- `assistant_name.json`: this contains a description of all the tools this assistant needs to perform its tasks
- `assistant_name.txt`: this is the system message that controls the behavior of the AI assistant

The front end application simply needs to modify the environment.ts file to point to the specific endpoint where the API service is running to enable the AI Assistant interaction with the user.

### System Message

````shell
You are a helpful assistant. Your name is Donald Contoso.

Always ask the customer how you can help them.

If you need to check the account balance, ask the customer for their email address and preferred currency.

Only use the functions you have been provided with.

If you are not sure what the answer is, tell the customer that you are not sure.

````
#### Tools Configuration

For the tools configuration, what is critical is the accurate description of the tool as well as each of the parameters it expects.

````json
[
    {
        "type": "function",
        "function": {
            "name": "get_information",
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
    }
]
````
