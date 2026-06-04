# Challenge 04 - Deploy a Hosted Weather Agent

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Pre-requisites

- Complete Challenge 03 -- you should be comfortable creating agents with the SDK and connecting tools.

## Introduction

In the previous challenges you built prompt-based agents: you defined a system prompt, connected tools, and let the Foundry platform run everything. The platform chose how to host the agent, manage conversations, and call your tools. That works well for many scenarios, but it means you are limited to what the platform supports out of the box.

Hosted agents are different. A hosted agent is a containerized application -- your code, your framework, your logic -- that runs on Foundry-managed infrastructure. You write a Python application that handles requests, calls models, and returns responses. You package it in a Docker container and deploy it. Foundry provisions the compute, assigns a dedicated Microsoft Entra ID identity, handles scaling, and gives you a persistent endpoint. But the code inside the container is entirely yours.

This matters because real teams build agents with different frameworks. One team might use LangGraph, another Semantic Kernel, a third might have a custom orchestrator. Hosted agents let you deploy all of them to the same platform with the same management, observability, and security model -- regardless of how the agent was built internally.

In this challenge, you will build a Weather Agent using the Agent Framework SDK with a custom tool function. You will define the tool, write instructions, assemble the code into a container, build the image on Azure Container Registry, deploy to Foundry via the Python SDK, and invoke the running agent.

## Description

Build and deploy a hosted weather agent on Foundry Agent Service. You will complete the tasks in the following Jupyter notebook: `CH-04-HostedAgents.ipynb`

The notebook can be found in the `/Resources` folder of the `Resources.zip` file provided by your coach.

The `Resources.zip` also includes a `weather-agent/` folder with pre-built container files (Dockerfile, requirements.txt, .dockerignore). You do not need to write these from scratch.

By the end of this challenge, you should have:

- A weather tool function with typed parameters that the agent can call
- Agent instructions that define the persona and tool-calling behavior
- A complete `main.py` assembled from your code components
- A container image built on Azure Container Registry
- A deployed hosted agent with Active status on Foundry Agent Service
- A successful invocation of the deployed agent that returns weather data

**NOTE:** Your weather tool can return simulated data. This challenge is about the hosting and deployment pattern, not integrating a real weather API.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that your weather tool function accepts a typed location parameter and returns weather data
- Demonstrate agent instructions that define a weather assistant persona
- Verify that `main.py` was assembled correctly and exists in the `weather-agent/` directory
- Verify the container image was built successfully on Azure Container Registry
- Demonstrate a deployed agent with **Active** status in the Foundry portal
- Verify you can invoke the deployed agent and receive a weather response that includes tool-calling behavior
- Explain to your coach the difference between a prompt-based agent and a hosted agent

## Learning Resources

- [What are Hosted Agents in Foundry Agent Service?](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agents)
- [Quickstart: Create and Deploy a Hosted Agent](https://learn.microsoft.com/en-us/azure/foundry/agents/quickstarts/quickstart-hosted-agent)
- [Deploy a Hosted Agent (Python SDK / REST)](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/deploy-hosted-agent)
- [Agent Framework GitHub Repository](https://github.com/microsoft/agent-framework)
- [Foundry Samples -- Hosted Agents (Python)](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/python/hosted-agents)
- [Hosted Agent with Tools Sample](https://github.com/microsoft-foundry/foundry-samples/tree/main/samples/python/hosted-agents/agent-framework/responses/02-tools)
- [DefaultAzureCredential documentation](https://learn.microsoft.com/python/api/azure-identity/azure.identity.defaultazurecredential)
- [Azure AI Projects SDK reference](https://learn.microsoft.com/en-us/python/api/overview/azure/ai-projects-readme)

## Tips

- Your weather tool can return simulated/hardcoded data -- the learning objective is the deployment pattern.
- `FOUNDRY_PROJECT_ENDPOINT` is injected automatically by the platform at runtime. You only need it locally in your `.env` for development.
- If `az acr build` produces encoding errors on Windows, use the `--no-logs` flag.
- If deployment fails with permission errors, check that you have the **Foundry Project Manager** role at project scope.
- The notebook includes an idempotency guard -- if an active version already exists, it skips creation.

## Advanced Challenges (Optional)

Too comfortable? Eager to do more? Try these additional challenges!

- Build the same Weather Agent using a different framework (LangGraph, Semantic Kernel, or custom code) and deploy it as a hosted agent
- Add a `get_forecast` tool that returns a 5-day forecast and observe how the agent decides which tool to call
- Deploy the agent using the Python SDK programmatically instead of the notebook workflow -- the pattern you would use in a CI/CD pipeline
