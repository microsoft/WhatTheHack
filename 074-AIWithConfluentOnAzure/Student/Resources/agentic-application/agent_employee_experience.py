import os

from pydantic_ai import Agent
from pydantic_ai.mcp import MCPServerStreamableHTTP
from pydantic_ai.messages import ModelRequest, ModelResponse
from rich.prompt import Prompt

from contoso_retail_application import ai_foundry_model

instructions = """
You are an agent called Mikhail and you help employees of Contoso Groceries (an online grocery store) to get information about the following:

 - Names of departments available in the grocery store
 - The prices for different product SKUs in the grocery store
 - Inventory levels for different product SKUs in the grocery store
 - Net sales reports for different product SKUs in the grocery store
 
 Please use the data from tools provided and do not make up any information. 
 
 If you cannot answer a question, please let the user know that you cannot answer the question.
 
Whenever the response is a list of items, always convert it into a clean, readable Markdown table.  

Formatting rules for Markdown table dataset:  
- Always include a header row with clear column names.  
- Auto-detect the best column names based on the data (e.g., "Item", "Description", "Value", "Date").  
- Keep the table compact, aligned, and visually appealing.  
- If there are more than 5 items, add alternating row shading (if the environment supports it).  
- If some items have missing fields, leave the cell blank.  
- Never return the list as plain text — always return a table.  
- Use Markdown tables by default unless explicitly asked for HTML, CSV, or another format.
"""

async def thank_you_message():
    print("\n\nThank you for using the Employee Experience Agent. Have a wonderful day\n\n")

async def main():

    inventory_service_endpoint = os.getenv('MCP_SERVICE_ENDPOINT_INVENTORY')
    inventory_service_definition = MCPServerStreamableHTTP(url=inventory_service_endpoint)
    mcp_servers: list[MCPServerStreamableHTTP] = [inventory_service_definition]

    # Keeping track of the Message history
    message_history: list[ModelRequest | ModelResponse] = []

    # initial prompt to get started
    current_prompt = "\nHow can I help you?"


    while True:

        user_prompt = Prompt.ask(current_prompt)
        employee_experience_agent = Agent(ai_foundry_model, instructions=instructions, toolsets=mcp_servers)
        results = await employee_experience_agent.run(user_prompt, message_history=message_history)
        print(results.output)
        message_history = results.all_messages()

        exit_or_not = Prompt.ask("\nIs there anything else you would like me to assist you with?", choices=['y','n'])

        if exit_or_not == 'n':
            await thank_you_message()
            break
        current_prompt = "\nWhat else would you like me to help you with?"


if __name__ == '__main__':
    import asyncio
    asyncio.run(main())