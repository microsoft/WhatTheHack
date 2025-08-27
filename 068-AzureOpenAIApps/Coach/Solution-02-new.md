
# Challenge 02 - Create MCP Server - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Assistant Name Changes

Names of assistants in the source code have been changed but in the case that a reference to an older name is encountered, use the following map:

- Elizabeth was changed to Donald
- Esther was changed to Callum
- Miriam was changed to Veta
- Sarah was changed to Murphy

## Notes & Guidance

This challenge is about creating an MCP server using Github Copilot to connect Veta to the national weather API. They will need to complete the #TODO comments in the `mcp_weather_server.py` file to actually add functionality using the `llms-full.txt` file and the given prompt. They will also need to use the Add Context button to add the `mcp_weather_client.py` file, and the `ContosoAIAppsBackend` folder to ensure the functions are named the same across files. This may take some debugging.

The front end application simply needs to modify the environment.ts file to point to the specific endpoint where the API service is running to enable the AI Assistant interaction with the user.

The environment.ts file tells the client where to find the backend. If the backend location get changed because it ran in a codespace, or any other reason, the student might need to change the value in the file.



### Working MCP Server Code

Refer to this file for working version of mcp server code: ![mcp_solution_server.py](../Coach/Solutions/mcp_solution_server.py)

