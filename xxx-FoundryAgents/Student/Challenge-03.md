# Challenge 03 - Connect Your Agents to Tools

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Pre-requisites

- Complete [Challenge 02](./Challenge-02.md) — you should have `NewsAgent` deployed programmatically and accessible in your Foundry project.

## Introduction

An agent without tools is just a chatbot with good instructions. Tools are what turn your agents into *doers* — they give agents the ability to retrieve real data, execute code, search through files, and call external functions. Without tools, your agents can only respond based on their training data and whatever fits in the conversation context. With tools, they can look things up, crunch numbers, and ground their answers in actual organizational knowledge.

Microsoft Foundry supports several categories of tools that you can attach to agents:

- **File Search**: Lets your agent search through uploaded files (PDFs, Word docs, spreadsheets) using a vector store. The agent can retrieve relevant passages and ground its responses in your actual data.
- **Code Interpreter**: Gives your agent a sandboxed Python execution environment. The agent can write and run code to perform calculations, generate charts, transform data, and analyze files you upload.
- **Function Calling**: Lets you define custom functions (with schemas) that the agent can invoke. When the agent decides it needs data from an external source or needs to perform an action, it generates a structured function call that your application code fulfills.
- **Azure AI Search**: Connects your agent to an Azure AI Search index for retrieval-augmented generation (RAG). This is the production-grade approach to grounding agents with large-scale organizational data.

In this challenge, you will connect tools to both portal-created and code-first agents in your travel planning scenario. By the end, your agents will be able to answer questions backed by real data — hotel information, flight options, and news sources — rather than making things up.

**Why this matters for production:** In production applications, agents must be grounded in verifiable data. A travel agent that hallucinates hotel names or makes up flight prices is worse than useless. Tool connections are how you bridge the gap between a helpful conversational interface and accurate, data-driven responses.

## Description

In this challenge you will equip your agents with tools that give them access to your travel planning data. You will work with two agents: the portal-based `TravelAgent` (Agent 3 — hotel and activity knowledge) and the code-based `NewsAgent` (Agent 2 — news and event knowledge).

You can find the hotel and flight data files in the `/Challenge-03` folder of the Resources.zip file provided by your coach. These include an Excel spreadsheet with hotel information (2 hotels with pricing, amenities, neighborhoods, and ratings) and a CSV with flight options.

### Part 1: Ground the TravelAgent with File Search (Portal)

Your `TravelAgent` from Challenge 01 needs access to real hotel and flight data so it can make grounded recommendations instead of hallucinating.

Using the Foundry portal:

- Navigate to your `TravelAgent` and open its tool configuration
- Enable the **File Search** tool
- Upload the hotel spreadsheet and flight options file to a vector store associated with the agent
- Update the agent's system instructions to reflect that it now has access to real hotel and flight data, and should always reference this data when making recommendations
- Test the agent in the playground with queries that require data lookup:
  - *"What hotels do you have available and what are their price ranges?"*
  - *"Which hotel is better for someone who wants to be near restaurants?"*
  - *"What flight options are there for next Friday?"*
- Verify the agent cites specific data from your files rather than generating generic responses

### Part 2: Add Code Interpreter to the TravelAgent (Portal)

Your `TravelAgent` should also be able to perform calculations and comparisons for users planning a trip on a budget.

- Enable the **Code Interpreter** tool on your `TravelAgent`
- Test it with queries that require computation:
  - *"Compare the total cost of a 3-night stay at each hotel including the cheapest flight option."*
  - *"If my budget is $2000 for hotel and flights, what combinations work?"*
- Verify the agent writes and executes code to perform the calculation rather than estimating

### Part 3: Connect the NewsAgent to Tools via Code (SDK)

Your `NewsAgent` from Challenge 02 currently has no access to external data. In this part, you will update your Python script to create a new version of the agent with **function calling** configured, allowing it to call an external news source.

Create or modify your Python script to:

- Define a function tool schema for a `get_news_articles` function that accepts parameters:
  - `topic` (string) — the news topic to search for
  - `region` (string, optional) — geographic region to filter by
  - `max_results` (integer, optional) — number of articles to return
- Create a new agent (or update the existing `NewsAgent`) with the function tool attached
- Implement the function calling loop:
  - Send a user message to the agent (e.g., *"What are the latest travel advisories for Europe?"*)
  - When the agent responds with a function call (status `requires_action`), extract the function name and arguments
  - Provide a simulated function response with sample news data (you can hardcode 2-3 sample news articles as the return value for now)
  - Submit the tool output back to the agent and let it generate its final response incorporating the news data
- Print the agent's grounded response to the console

### Part 4: Connect the NewsAgent to Azure AI Search (Code)

For production-grade knowledge retrieval, connect your `NewsAgent` to the Azure AI Search index that was provisioned in Challenge 00.

- Upload a small set of sample news/event documents to your Azure AI Search index (you can find sample documents in the Resources.zip)
- Update your Python script to create an agent with an **Azure AI Search** tool connection
- Configure the search tool with your AI Search resource endpoint and index name
- Test the agent with queries that should trigger search retrieval:
  - *"Are there any upcoming music festivals in Barcelona?"*
  - *"What events are happening in Tokyo this month?"*
- Verify the agent's response references information from your search index

### Key Concepts

- **Vector Store**: A searchable collection of document embeddings. When you upload files to File Search, Foundry chunks the documents, generates embeddings, and stores them so the agent can perform semantic search.
- **Function Calling**: A structured way for agents to request external data. The agent doesn't call the function directly — it generates a JSON object describing what function it wants to call and with what arguments. Your application code handles the actual execution.
- **Tool Output Submission**: After your code executes the function the agent requested, you submit the result back to the agent so it can incorporate the data into its response.
- **Grounding**: The practice of connecting agent responses to verifiable source data rather than relying solely on the model's training knowledge. Grounding reduces hallucination.
- **RAG (Retrieval-Augmented Generation)**: A pattern where the agent retrieves relevant documents from a knowledge base before generating a response, ensuring answers are based on current, domain-specific data.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Demonstrate that your `TravelAgent` in the portal has File Search enabled and can answer questions about specific hotels and flights from your uploaded data
- Verify that the `TravelAgent` uses Code Interpreter to perform calculations when asked budget or comparison questions
- Show a Python script that creates an agent with a function calling tool definition (`get_news_articles`)
- Demonstrate the full function calling loop: agent requests a function call → your code provides the response → agent generates a grounded answer
- Show the `NewsAgent` connected to Azure AI Search and returning responses that reference data from your search index
- Demonstrate that your agents cite specific data from their tools rather than generating hallucinated responses
- Explain to your coach the difference between File Search, Code Interpreter, Function Calling, and Azure AI Search — and when you would use each in a production application

## Learning Resources

- [Azure AI Agent Service: File Search tool](https://learn.microsoft.com/azure/ai-services/agents/how-to/tools/file-search)
- [Azure AI Agent Service: Code Interpreter tool](https://learn.microsoft.com/azure/ai-services/agents/how-to/tools/code-interpreter)
- [Azure AI Agent Service: Function Calling](https://learn.microsoft.com/azure/ai-services/agents/how-to/tools/function-calling)
- [Azure AI Agent Service: Azure AI Search integration](https://learn.microsoft.com/azure/ai-services/agents/how-to/tools/azure-ai-search)
- [Grounding and RAG concepts](https://learn.microsoft.com/azure/ai-services/openai/concepts/retrieval-augmented-generation)
- [Function calling with the Agent SDK](https://learn.microsoft.com/azure/ai-services/agents/concepts/tools)
- [Vector stores and file management](https://learn.microsoft.com/azure/ai-services/agents/how-to/tools/file-search?tabs=python#vector-stores)

## Tips

- When writing function tool schemas, be very precise with your parameter descriptions — the model uses these descriptions to decide when and how to call the function. Vague descriptions lead to incorrect function calls.
- For File Search, smaller and well-structured documents work better than large monolithic files. If your hotel data is messy, consider cleaning it up before uploading.
- The function calling loop requires your code to handle the `requires_action` run status. If you skip this step, the agent will appear to hang waiting for tool output.
- When testing grounding, ask the agent questions you *know* the answer to from your data. If the agent gives an answer that doesn't match your files, it may be hallucinating rather than using the tool.
- **Stuck on function calling?** Look at the portal code snippets for agents with tools enabled — they show the exact SDK patterns for defining tool schemas and handling the function calling loop.

## Advanced Challenges (Optional)

Too comfortable? Eager to do more? Try these additional challenges!

- Add a **Bing Grounding** tool to your `TravelAgent` so it can supplement file-based knowledge with live web search results for destination information
- Implement multiple function tools on a single agent (e.g., `get_news_articles` AND `get_weather_forecast`) and observe how the agent decides which tool to call based on the user's query