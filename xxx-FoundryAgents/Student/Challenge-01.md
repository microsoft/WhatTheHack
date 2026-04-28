# Challenge 01 - Your First Foundry Agent (Portal)

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Before writing any code, it is valuable to understand how Microsoft Foundry agents work by building and testing them through the portal UI. The Microsoft Foundry portal at [ai.azure.com](https://ai.azure.com) gives you a visual environment to create agents, configure system instructions, connect models, and test conversations — all without writing a single line of code.

**Why start in the portal?** The portal is a great way to prototype and iterate quickly on agent behavior. You can experiment with different system prompts, see how the model responds, and fine-tune your agent's persona before investing time in code. Think of it like sketching a design before building the final product.

**A note on production workflows:** While the portal is excellent for exploration and prototyping, in a production environment you will most likely deploy and manage agents programmatically using the Azure CLI, infrastructure-as-code (Bicep/Terraform), and the Agent Framework SDK. The portal should not be your long-term deployment mechanism — it is a development and testing tool. Later challenges in this hack will move you to code-based agent creation and deployment.

**Microsoft Foundry vs. Copilot Studio:** Microsoft Foundry is a developer-focused platform for building custom AI agents backed by Azure AI models and services. It is not the same as Copilot Studio, which is a low-code/no-code platform aimed at business users for building copilots within the Microsoft 365 ecosystem. In this hack, you are working with Microsoft Foundry and the Azure AI Agent Service — a pro-developer experience with full control over models, tools, and deployment.

## Description

In this challenge, you will use the Microsoft Foundry portal to create and test two agents within the project you deployed in Challenge 00.

### Agent 1: The Travel Agent

Your first agent will be a **travel assistant**. Use the specifications below to configure it in the portal.

- Navigate to the Microsoft Foundry portal at [ai.azure.com](https://ai.azure.com) and open your project
- Create a new agent inside your project
- Give the agent the name `TravelAgent`
- Connect the agent to your deployed `gpt-5.1` model
- Set the following system instructions:

  > You are a friendly and knowledgeable travel assistant named TravelAgent. You help users plan trips by suggesting destinations, creating itineraries, providing packing tips, and answering questions about travel logistics. You always ask clarifying questions about budget, travel dates, and interests before making recommendations. You respond in a conversational, upbeat tone. If you don't know something, you say so honestly rather than making things up.

- Use the built-in playground to test your agent with the following conversation starters:
  - *"I want to plan a week-long trip to Japan in the spring."*
  - *"What should I pack for a hiking trip in Patagonia?"*
  - *"Can you compare beach destinations in Southeast Asia for a budget traveler?"*
- Observe how the agent follows (or doesn't follow) the system instructions
- Iterate on the system instructions if the responses don't match what you expect

### Agent 2: Your Custom Agent

Now it is your turn. Create a **second agent** with a persona and purpose of your own choosing.

- Create another new agent in your project
- Give it a descriptive name that reflects its purpose
- Connect it to the same `gpt-5.1` model
- Write your own system instructions from scratch — think about:
  - What role or persona should the agent have?
  - What tone should it use (formal, casual, technical, friendly)?
  - What topics should it be an expert in?
  - Are there things it should refuse to do or topics it should avoid?
  - Should it ask clarifying questions before answering?
- Test your agent in the playground with at least three different conversation starters
- Iterate on the system instructions until you are satisfied with the agent's behavior

### Key Concepts

- **Agent**: A configured AI entity with a name, system instructions, a connected model, and optional tools. An agent defines *how* the AI should behave.
- **System Instructions (System Prompt)**: The behind-the-scenes instructions that shape the agent's personality, expertise, and guardrails. Users do not see these — they guide the model's behavior.
- **Model Deployment**: The specific AI model (e.g., `gpt-5.1`) powering the agent's responses. An agent must be connected to a deployed model.
- **Playground**: The built-in testing environment in the Foundry portal where you can have conversations with your agent and see how it responds in real time.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Show both agents created and visible in the Microsoft Foundry portal
- Demonstrate that `TravelAgent` is connected to the `gpt-5.1` model and has the provided system instructions configured
- Verify that `TravelAgent` responds appropriately to at least two of the provided conversation starters (e.g., asks clarifying questions, stays in character)
- Show your custom agent with its own unique name, system instructions, and connected model
- Demonstrate a multi-turn conversation with your custom agent in the playground where it behaves consistently with its system instructions
- Explain to your coach why the portal is useful for prototyping but not ideal for production deployments

## Learning Resources

- [What is Microsoft Foundry?](https://learn.microsoft.com/azure/ai-foundry/what-is-azure-ai-foundry)
- [Quickstart: Create an agent in the Foundry portal](https://learn.microsoft.com/azure/ai-services/agents/quickstart)
- [Azure AI Agent Service overview](https://learn.microsoft.com/azure/ai-services/agents/overview)
- [Prompt engineering techniques](https://learn.microsoft.com/azure/ai-services/openai/concepts/prompt-engineering)
- [System message framework and best practices](https://learn.microsoft.com/azure/ai-services/openai/concepts/system-message)

## Tips

- The system instructions are the most important part of your agent configuration. Be specific about the persona, tone, and boundaries.
- If your agent gives generic or off-topic responses, your system instructions may be too vague. Try adding more detail about what the agent should and should not do.
- The playground preserves conversation history within a session — use this to test multi-turn conversations where the agent needs to remember context.
- For your custom agent, pick a domain you find interesting — it will make the iteration process more engaging.
