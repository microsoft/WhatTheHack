# Challenge 01 - Your First Foundry Agent

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Microsoft Foundry provides a managed platform for building, deploying, and managing AI agents. The Azure AI Agent Service, accessed through the `azure-ai-projects` and `azure-ai-agents` SDKs, lets you create agents that can reason, use tools, and hold conversations — all backed by models like GPT-5.1.

In this challenge, you will connect to your Foundry project and create your first agent using the Microsoft Agent Framework SDK. You will learn how to authenticate using Azure Identity, initialize a project client, create an agent with instructions, and run a conversation thread.

## Description

Using the Foundry project you deployed in Challenge 00, build a Python script that creates and interacts with a basic AI agent.

Your agent should:
- Connect to your Microsoft Foundry project using the endpoint and project name from your `.env` file
- Authenticate using `DefaultAzureCredential` (no API keys)
- Be created with a name, a model deployment (`gpt-5.1`), and custom instructions that define its persona (e.g., a helpful travel assistant, a coding tutor, or a subject-matter expert of your choice)
- Use a conversation thread to send at least one user message and receive the agent's response
- Print the agent's response to the console
- Clean up by deleting the agent after the conversation is complete

### Key Concepts

- **Agent**: A configured AI entity with instructions, a model, and optional tools
- **Thread**: A conversation session between a user and an agent
- **Run**: An execution of the agent against a thread to produce a response
- **DefaultAzureCredential**: Passwordless authentication that chains multiple credential types (CLI, managed identity, etc.)

## Success Criteria

To complete this challenge successfully, you should be able to:

- Demonstrate a Python script that connects to your Foundry project without using API keys.
- Show that an agent is created with a custom name, instructions, and the `gpt-5.1` model.
- Verify that a thread is created, a user message is sent, and the agent produces a meaningful response.
- Show the agent's response printed in the console.
- Verify the agent is cleaned up (deleted) after the conversation.

## Learning Resources

- [Quickstart: Create a Foundry agent](https://learn.microsoft.com/azure/ai-services/agents/quickstart)
- [Azure AI Agent Service overview](https://learn.microsoft.com/azure/ai-services/agents/overview)
- [Azure AI Projects SDK for Python](https://learn.microsoft.com/python/api/overview/azure/ai-projects-readme)
- [DefaultAzureCredential documentation](https://learn.microsoft.com/python/api/azure-identity/azure.identity.defaultazurecredential)
- [Agent Framework SDK concepts: threads and runs](https://learn.microsoft.com/azure/ai-services/agents/concepts/agents)

## Tips

- Load your `.env` file at the top of your script using `dotenv` — the `AZURE_AI_FOUNDRY_ENDPOINT` and `AZURE_AI_PROJECT_NAME` are the key values you need.
- After creating a run, you need to poll or wait for it to complete before reading the response messages.
- Check the run's status for `completed` vs `failed` to handle errors gracefully.
