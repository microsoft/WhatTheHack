# Challenge 06 - Agentic AI

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)**

## Introduction

Integrating agents into an application after implementing Retrieval-Augmented Generation (RAG) can significantly enhance user experience by providing personalized interactions and automating repetitive tasks. Additionally, agents can improve decision-making, ensure scalability, and offer real-time responses, making them ideal for complex task management and continuous improvement. 

In this challenge, you will build a **Research Assistant Agent** using the Microsoft Agent Framework. This agent will leverage **Model Context Protocol (MCP)** to connect to live data sources like Microsoft Learn documentation, enabling it to provide accurate, up-to-date answers to technical questions.

## Description

In this challenge, you will create a code-based agent that can query real-time documentation using MCP tools.

### Prerequisites
- Ensure you have Python 3.10+ installed
- Have access to a Microsoft Foundry project with a deployed model (e.g., `gpt-4o`)

### Getting Started

1. Open the Jupyter notebook for this challenge:
   
   📓 **[CH-06-AgenticAI.ipynb](./Resources/notebooks/CH-06-AgenticAI.ipynb)**

2. Work through the notebook sections:
   - **Section 1:** Set up your environment and install the Microsoft Agent Framework
   - **Section 2:** Create the Research Assistant agent with MCP integration
   - **Section 3:** Test single queries and multi-turn conversations
   - **Section 4:** Explore extending the agent with custom tools

3. Test your agent with questions like:
   - "What is Azure Kubernetes Service and when should I use it?"
   - "How do I set up managed identity for an Azure Function?"
   - "What are the best practices for Azure OpenAI prompt engineering?"

### Clean-Up
1. Remember to delete your resource group in the Azure portal once you have completed all of the challenges.


## Success Criteria

To complete this challenge successfully, you should be able to:
- Explain what an agent is and how tools extend its capabilities
- Create an agent using the Microsoft Agent Framework in Python
- Integrate MCP tools to connect your agent to live data sources
- Demonstrate a multi-turn conversation with your Research Assistant

## Conclusion 
In this challenge, you built a Research Assistant agent using the Microsoft Agent Framework and connected it to live documentation via MCP. This code-first approach gives you full control over your agent's behavior while leveraging powerful integrations. As you continue developing AI applications, consider how agents can be composed together—what coordination patterns would you use for multi-agent systems handling complex research or analysis tasks?

## Learning Resources

- [Microsoft Agent Framework on GitHub](https://github.com/microsoft/agent-framework)
- [Overview of Microsoft Agents](https://learn.microsoft.com/en-us/azure/ai-services/agents/)
- [Model Context Protocol (MCP) Overview](https://modelcontextprotocol.io/)
- [Microsoft Learn MCP Integration](https://learn.microsoft.com/en-us/mcp) 


  
