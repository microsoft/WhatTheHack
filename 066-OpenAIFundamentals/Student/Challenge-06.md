# Challenge 06 - Agentic AI

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)**

## Introduction

Integrating agents into an application after implementing Retrieval-Augmented Generation (RAG) can significantly enhance user experience by providing personalized interactions and automating repetitive tasks. Additionally, agents can improve decision-making, ensure scalability, and offer real-time responses, making them ideal for complex task management and continuous improvement. In this challenge, you will learn how to use the Azure AI Agent service to build, deploy, and scale enterprise-grade AI agents.

## Description

In this challenge, you will create a basic agent. 

### Setup

1. Log into your [AI Foundry portal](ai.azure.com)
2. In your project's left-hand pane, navigate to `My assets -> Models and endpoints`.
3. On the Model deployments tab, click the `+ Deploy model` button and select `Deploy base model` from the drop down.
4. Search for the gpt-4o-mini model, select it, and confirm the deployment.

### Creating the Agent 
1. In the left-hand pane, under `Build & Customize`, select `Agents`
2. Select your Azure OpenAI resource and hit `Let's go`.
3. Select your model deployment and hit `Next`.
4. You should see an agent under the `Agents` tab at the top. If you select it, you can give it a new name. Enter "`FlightAgent`".
5. You can add instructions as well. Within your codespace, you should see a data folder. That contains the text in the file `FlightAgent.md`. Copy the text from here and add it in instructions.
6. Optional: You can also add a Knowledge Base and Actions to enhance the agent's capabilities.
7. At the top of the agent's `Setup` pane, select `Try in playground`.
8. Here you can interact with your agent in the `Playground` by entering queries in the chat window. For instance, ask the agent to `search for queries from Seattle to New York on the 28th`. Note: The agent may not provide completely accurate responses as it doesn't use real-time data in this example. The purpose is to test its ability to understand and respond to queries.

### Clean-Up
1. Remember to delete your resource group in the Azure portal once you have completed all of the challenges. 


## Success Criteria

To complete this challenge successfully, you should be able to:
- Articulate what an agent is and why it can be used
- Identify tools available to extend an agents capabilities

## Conclusion 
In this Challenge, you explored creating an AI Agent through the Azure AI Foundry portal. This developer friendly experience integrates with several tools, knowledge connections, and systems. As you start or continue to develop your AI applications, think about the coordination needed between different agents and their roles. What would be some important considerations with multi-agent systems when handling complex tasks?

## Learning Resources

- [Overview of Azure AI Agents](https://learn.microsoft.com/en-us/azure/ai-services/agents/?view=azure-python-preview)
- These steps are listed here along with many other prompts: [AI Agents in AI Foundry](https://techcommunity.microsoft.com/blog/educatordeveloperblog/step-by-step-tutorial-building-an-ai-agent-using-azure-ai-foundry/4386122) . 


  
