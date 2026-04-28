# Challenge 02 - Build a News Agent with Code

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites

- Complete [Challenge 01](./Challenge-01.md) — you should have at least one agent created and tested in the Foundry portal.

## Introduction

In Challenge 01 you built agents through the portal UI. That is great for prototyping, but real-world agent development happens in code. The Microsoft Agent Framework SDK (`azure-ai-projects` and `azure-ai-agents`) lets you programmatically create agents, manage conversation threads, execute runs, and read responses — all from a Python script.

In this challenge you will build a completely different agent — a **news briefing agent** — entirely through code. You will authenticate with Azure Identity (no API keys), create the agent, send it messages, and receive responses right in your terminal. This is the same pattern you would use in a production application, a CI/CD pipeline, or an automated workflow.

**Why code matters:** Code-based agents can be version-controlled, tested, parameterized, and deployed across environments. You can't do that by clicking through a portal. Every challenge from here forward will be code-first.

## Description

This challenge has three parts: first you will use the Azure CLI to deploy a model to your Foundry project, then you will write a Python script that creates an agent backed by that model and has a conversation with it, and finally you will deploy that agent to your Azure resource using the CLI so it persists as a hosted, reusable endpoint.

### Part 1: Deploy the Model via Azure CLI

Before your code can create an agent, a model deployment must exist in your project. In Challenge 00, this may have been done through infrastructure scripts, but in a production workflow you would manage model deployments through the CLI or infrastructure-as-code.

Use the Azure CLI to verify your model deployment exists — and if needed, create one:

- Use `az` commands to list the model deployments in your Foundry project
- Verify that a `gpt-5.1` deployment is available
- If the deployment does not exist, use the CLI to create it
- Record the deployment name — you will reference it in your Python script

**Why the CLI?** In production, model deployments are managed through automation — CLI scripts, Bicep/Terraform, or CI/CD pipelines. You wouldn't log into the portal to deploy a model every time you spin up a new environment.

### Part 2: Build the News Agent in Code

Create a Python script called `news_agent.py` that builds a news briefing agent and holds a conversation with it.

Your script should:

- Load your Foundry project configuration from the `.env` file (`AZURE_AI_FOUNDRY_ENDPOINT` and `AZURE_AI_PROJECT_NAME`)
- Authenticate using `DefaultAzureCredential` — **no API keys**
- Create an agent named `NewsAgent` using the `gpt-5.1` model deployment you verified/created in Part 1
- Give the agent system instructions that define its persona as a news briefing assistant. Your instructions should tell the agent to:
  - Summarize news topics in a concise, neutral, and informative tone
  - Organize briefings with clear headlines and short summaries
  - Cover multiple perspectives when discussing controversial topics
  - Clarify that it does not have access to live news feeds — it uses its training knowledge to discuss news topics
- Create a conversation thread and send at least **two user messages** — for example:
  - *"Give me a briefing on the latest developments in renewable energy."*
  - *"What are the key things happening in AI regulation right now?"*
- Wait for each run to complete, then print the agent's response to the console
- **Do NOT delete the agent at the end** — you will need it for Part 3

### Part 3: Deploy the Agent via CLI

Now that your agent exists in your Foundry project (you can verify it in the portal), use the Azure CLI to deploy it as a hosted agent on your Azure resource.

In a real production workflow, you wouldn't just create agents in throwaway scripts — you would deploy them so they are accessible as persistent endpoints that other applications, APIs, or users can call.

Using the Azure CLI:

- List the agents in your Foundry project to find the `NewsAgent` you created in Part 2
- Deploy the agent to your Azure resource so it is hosted and accessible
- Verify the deployment succeeded by checking the agent's status via CLI
- Confirm the deployed agent is visible in the Foundry portal under your project's agents/deployments section

**Why deploy via CLI?** Just like model deployments, agent deployments should be automated. In a CI/CD pipeline, your code would create the agent definition and then a CLI or IaC step would deploy it to the target environment. This separation between "define" and "deploy" is a core pattern in production agent workflows.

### Key Concepts

- **`AIProjectClient`**: The main client for interacting with your Foundry project. You initialize it with your project endpoint and credential.
- **`DefaultAzureCredential`**: Passwordless authentication that automatically chains multiple credential sources (Azure CLI login, managed identity, etc.). No secrets in your code.
- **Agent creation vs. deployment**: Creating an agent (via SDK) defines its configuration — name, model, instructions. Deploying an agent (via CLI) makes it a persistent, hosted endpoint on your Azure resource that can be called by other services.
- **Thread → Message → Run → Response**: The conversation lifecycle. You create a thread, add a user message, create a run (which triggers the agent to respond), wait for the run to complete, then read the response messages.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Demonstrate using the Azure CLI to list model deployments in your project and verify `gpt-5.1` is available
- Show a `news_agent.py` script that creates and interacts with the `NewsAgent`
- Demonstrate the script authenticates using `DefaultAzureCredential` with no API keys or secrets in the code
- Verify the agent is created with the name `NewsAgent`, connected to `gpt-5.1`, and has system instructions defining its news briefing persona
- Show the agent's responses printed to the console for at least two different user messages
- Demonstrate using the Azure CLI to deploy the `NewsAgent` to your Azure resource as a hosted agent
- Verify the deployed agent is visible and accessible in the Foundry portal
- Show the agent's deployment status via CLI

## Learning Resources

- [Quickstart: Create a Foundry agent](https://learn.microsoft.com/azure/ai-services/agents/quickstart)
- [Azure AI Agent Service overview](https://learn.microsoft.com/azure/ai-services/agents/overview)
- [Azure CLI: Manage Azure AI model deployments](https://learn.microsoft.com/cli/azure/ai)
- [Azure AI Projects SDK for Python](https://learn.microsoft.com/python/api/overview/azure/ai-projects-readme)
- [DefaultAzureCredential documentation](https://learn.microsoft.com/python/api/azure-identity/azure.identity.defaultazurecredential)
- [Agent Framework SDK concepts: agents, threads, and runs](https://learn.microsoft.com/azure/ai-services/agents/concepts/agents)

## Tips

- **Stuck on the SDK structure?** Go back to the Foundry portal, open one of the agents you created in Challenge 01, and look for a **"View code"** or **code snippet** option. The portal can show you the equivalent SDK code for an agent you built through the UI — use that as a starting reference for your script.
- Load your `.env` file at the top of your script using `dotenv` — the `AZURE_AI_FOUNDRY_ENDPOINT` and `AZURE_AI_PROJECT_NAME` values are what you need to initialize the client.
- After creating a run, you need to poll or wait for it to complete before reading messages. Check the run's status for `completed` vs `failed`.
- Use `python-dotenv` to load environment variables: `from dotenv import load_dotenv` then `load_dotenv()`.
- Remember to handle the conversation lifecycle in order: create agent → create thread → add message → create run → wait for completion → read response.
- For the CLI portions, `az ml` or `az ai` commands can help you manage both model and agent deployments. Use `az --help` to explore available subcommands for your Foundry project.
- For Part 3, look into `az ai agent` or similar CLI commands for deploying agents. The Foundry portal's deployment section can also give you hints about what CLI parameters are needed.
- Remember: in Part 2, do **not** delete the agent — you need it to still exist for the CLI deployment in Part 3.

