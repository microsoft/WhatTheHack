# Challenge 06 - Agentic AI

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)**

## Pre-requisites

- Python 3.10+ installed
- Access to a Microsoft Foundry project with a deployed model (e.g., `gpt-4o`)

## Introduction

Integrating agents into an application after implementing Retrieval-Augmented Generation (RAG) can significantly enhance user experience by providing personalized interactions and automating repetitive tasks. Additionally, agents can improve decision-making, ensure scalability, and offer real-time responses, making them ideal for complex task management and continuous improvement. 

In this challenge, you will build a **Research Assistant Agent** using the Microsoft Agent Framework. This agent will leverage **Model Context Protocol (MCP)** to connect to live data sources like Microsoft Learn documentation, enabling it to provide accurate, up-to-date answers to technical questions.

## Description

In this challenge, you will create a code-based agent that can query real-time documentation using MCP tools.

You will run the following Jupyter notebook to complete the tasks for this challenge:
- `CH-06-AgenticAI.ipynb`

The file can be found in your Codespace under the `/notebooks` folder. 
If you are working locally or in the Cloud, you can find it in the `/notebooks` folder of `Resources.zip` file. 


The notebook covers the following areas:
- Setting up your environment and installing the Microsoft Agent Framework
- Creating the Research Assistant agent with MCP integration
- Testing single queries and multi-turn conversations
- Exploring how to extend the agent with custom tools

Test your agent with questions like:
- "What is Azure Kubernetes Service and when should I use it?"
- "How do I set up managed identity for Azure Functions?"
- "What are the best practices for Azure OpenAI prompt engineering?"

## Success Criteria

To complete this challenge successfully, you should be able to:
- Demonstrate your understanding of what an agent is and how tools extend its capabilities
- Verify that your agent is created using the Microsoft Agent Framework in Python
- Verify that MCP tools are integrated to connect your agent to live data sources
- Demonstrate a multi-turn conversation with your Research Assistant

## Tips

As you continue developing AI applications, consider how agents can be composed together—what coordination patterns would you use for multi-agent systems handling complex research or analysis tasks?

**Clean-Up:** Remember to delete your resource group in the Azure portal once you have completed all of the challenges.

## Learning Resources

- [Microsoft Agent Framework on GitHub](https://github.com/microsoft/agent-framework)
- [Overview of Microsoft Agents](https://learn.microsoft.com/en-us/azure/ai-services/agents/)
- [Model Context Protocol (MCP) Overview](https://modelcontextprotocol.io/)
- [Microsoft Learn MCP Integration](https://learn.microsoft.com/en-us/mcp) 


  
