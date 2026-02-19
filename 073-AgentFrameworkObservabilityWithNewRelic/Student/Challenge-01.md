# Challenge 01 - Master the Foundations

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Before you start building WanderAI's AI agents, you need to understand the core concepts that power them. This challenge focuses on building your foundational knowledge of AI agents, the Microsoft Agent Framework, and observability concepts.

An AI agent is different from a simple LLM API call. While a direct API call just sends a prompt and receives a response, an agent can reason about problems, decide when to use external tools, and orchestrate multiple steps to accomplish complex tasks. Understanding this distinction is crucial for building effective AI-powered applications.

In this challenge, you will study the Microsoft Agent Framework documentation and learn about tool calling, agent lifecycles, and why observability matters for AI systems.

## Target Architecture

The focus for this challenge is conceptual rather than code-based. You will focus on understanding how the components fit together in the overall architecture:

```plaintext
+-------------------+
|   User Request    |
+-------------------+
          |
          v
+-------------------+
|   Flask Web App   |
+-------------------+
          |
          v
+-------------------+
| Microsoft Agent   |
|    Framework      |
+-------------------+
          |
          v
+-------------------+    +-------------------+
|   AI Agent with   |    |   Microsoft       |
|     Tools         |<-->|    Foundry        |
+-------------------+    +-------------------+
          |
          v
+-------------------+
|  OpenTelemetry    |
|   Instrumentation |
+-------------------+
          |
          v
+-------------------+
|   New Relic       |
|  Observability    |
+-------------------+
```

## Description

Your goal is to gain a solid understanding of the following concepts:

- **AI Agents vs. Simple LLM Calls** - Understand what differentiates an agent from a basic chat completion API call
- **Tool Calling** - Learn why agents need tools and how they decide when to call them
- **Agent-Tool Lifecycle** - Understand the flow from user request through agent reasoning to tool execution and response
- **OpenTelemetry Basics** - Learn about traces, metrics, and logs and why they matter for AI systems
- **Observability for AI** - Grasp why observability is critical for debugging and monitoring AI agents in production
- **New Relic Observability** - Understand how New Relic can help monitor AI applications
- **Application Architecture** - Understand how a Flask web app integrates with the Microsoft Agent Framework

### Key Concepts to Study

**AI Agents:**

- What is a `ChatAgent` in the Microsoft Agent Framework?
- How does an agent decide when to call a tool vs. respond directly to the user?
- What's the relationship between instructions, tools, and responses?

**Observability:**

- **Traces** - A record of all the work done to fulfill a user request, showing the full journey from request to response
- **Metrics** - Measurements over time (e.g., average response time, requests per second)
- **Logs** - Text records of events (e.g., "Tool get_weather() called for Barcelona")

**Why AI agents need observability:**

- AI is non-deterministic (same input might give different outputs)
- Tool calling adds complexity (is the right tool being called?)
- Latency can come from multiple sources (LLM, tools, network)
- Debugging production AI failures requires understanding the full trace

**Application Architecture:**

- How does a Flask web application serve as the API layer for agent interactions?
- Where does the Microsoft Agent Framework fit in the application stack?
- How do HTTP requests flow through Flask routes to agent execution and back to the client?
- What role does OpenTelemetry play in instrumenting the entire stack?

### Knowledge Check Questions

Answer these questions to validate your learning:

- What's the difference between calling an LLM API directly vs. using an agent?
- Why does an agent need tools like `get_weather()`?
- Why can't you just use print() statements to debug an AI agent in production?
- Describe the basic architecture of an agent-powered Flask app

## Success Criteria

# **TODO: check whether we want to run some kind of quiz or knowledge check here**

As part of this challenge we are not actually building any code. Instead, you are focusing on learning the foundational concepts needed for the rest of the challenges.

To complete this challenge successfully, you should be able to:

- [ ] Reflect on your understanding of what an AI agent is and how it differs from a simple LLM API call
- [ ] Articulate what tool calling means and why agents need tools
- [ ] Describe the agent-tool lifecycle
- [ ] Explain what OpenTelemetry is and why observability matters for AI
- [ ] Identify the key components of the complete solution architecture

In the subsequent challenges, you will apply this foundational knowledge by building a Flask web application that uses the Microsoft Agent Framework to create customized travel plans. You will also implement OpenTelemetry instrumentation to monitor and observe the application's behavior in production.

## Learning Resources

- [Microsoft Agent Framework GitHub](https://github.com/microsoft/agent-framework)
- [Agent Framework Documentation](https://learn.microsoft.com/en-us/agent-framework/overview/agent-framework-overview)
- [ChatAgent Concepts](https://learn.microsoft.com/en-us/agent-framework/tutorials/agents/run-agent?pivots=programming-language-python#create-the-agent-1)
- [OpenTelemetry Concepts](https://opentelemetry.io/docs/concepts/)
- [Why Observability Matters](https://docs.newrelic.com/docs/using-new-relic/welcome-new-relic/get-started/introduction-new-relic/#observability)
- [Flask Quickstart](https://flask.palletsprojects.com/en/3.0.x/quickstart/)

## Tips

- Don't skip reading the docs—they answer most questions
- Ask "why?" for every design decision you see
- Take notes on concepts you find unclear
- Ask coaches for clarification on tricky parts
- This is a learning challenge—no code to write yet!
