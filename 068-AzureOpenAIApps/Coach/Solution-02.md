
# Challenge 02 - Weather Integration Using Model Context Protocol - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Assistant Name Changes

The names of the assistants in the source code have been changed from an older version of the hack, but in the case that a reference to an older name is encountered, use the following map:

- Elizabeth was changed to Donald
- Esther was changed to Callum
- Miriam was changed to Veta
- Sarah was changed to Murphy

## Notes & Guidance

### MCP Server Challenge

This challenge is about creating an MCP server using GitHub Copilot to connect Veta to the national weather API. They will need to complete the #TODO comments in the `mcp_weather_server.py` file to actually add functionality using the `llms-full.txt` file and the given prompt. They will also need to use the Add Context button to add the `mcp_weather_client.py` file, and the `ContosoAIAppsBackend` folder to ensure the functions are named the same across files. This may take some debugging.

### Working MCP Server Code

Refer to this file for a working version of MCP server code: [`mcp_solution_server.py`](../Coach/Solutions/mcp_solution_server.py)

### Front End Application Configuration

The front end application uses the `environment.ts` file to point to the specific endpoint where the backend API service is running to enable the AI Assistant interaction with the user. If the front end application does not work, you should advise students to troubleshoot by examining the the backend's endpoint and ensuring the `environment.ts` file has the proper value.  The location could be changed if the application is run in a codespace or deployed to any other location other than the default.

If you change any values in the `environment.ts` file, you will need to stop and restart the frontend application.
