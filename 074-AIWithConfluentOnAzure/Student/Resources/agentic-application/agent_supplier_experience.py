import os

from pydantic_ai import Agent
from pydantic_ai.mcp import MCPServerStreamableHTTP
from pydantic_ai.messages import ModelRequest, ModelResponse
from rich.prompt import Prompt

from contoso_retail_application import ai_foundry_model, StaticDataset

instructions = """
You are an agent called Andrew and you help suppliers of Contoso Groceries (an online grocery store) to do the following tasks:

 - Check the inventory levels of product SKUs for the "appliance", "cleaning", "dairy", "deli", "meat", "pharmacy", "produce", "seafood" departments.
 - Check inventory levels for all SKUs for a specific department
 - Replenish inventory for specific product SKUs
 - Replenish inventory for all product SKUs for a specific department
 
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

valid_suppliers = StaticDataset.get_vendor_identifiers()

async def thank_you_message():
    print("\n\nThank you for using the Supplier Experience Agent. Have a wonderful day\n\n")

async def main():

    replenishment_service_endpoint = os.getenv('MCP_SERVICE_ENDPOINT_REPLENISHMENT')
    replenishment_service_definition = MCPServerStreamableHTTP(url=replenishment_service_endpoint)
    mcp_services = [replenishment_service_definition]

    # Keeping track of the Message history
    message_history: list[ModelRequest | ModelResponse] = []

    # initial prompt to get started
    current_prompt = "\nHow can I help you?"

    vendor_id: str = Prompt.ask("What is your vendor id?", choices=valid_suppliers, show_choices=False)
    agent_system_prompt = f"My vendor id is {vendor_id}"

    while True:

        user_prompt = Prompt.ask(current_prompt)
        supplier_experience_agent = Agent(ai_foundry_model, instructions=instructions, system_prompt=agent_system_prompt, toolsets=mcp_services)

        results = await supplier_experience_agent.run(user_prompt, message_history=message_history)

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