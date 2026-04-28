# Challenge 02 - Build a News Agent with Code - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

This is the first code-based challenge. Students transition from the portal UI to the CLI and Agent Framework SDK. The challenge has three parts: CLI-based model deployment, SDK-based agent creation + conversation, and CLI-based agent deployment to the Azure resource.

### Part 1: CLI Model Deployment

Students should use the Azure CLI to verify and/or create the `gpt-5.1` model deployment. The exact commands depend on the CLI version and Foundry extension, but the general pattern is:

```bash
# List existing model deployments in the project
az ai model deployment list \
  --resource-group <rg-name> \
  --workspace-name <project-name>

# If gpt-5.1 is not deployed, create it
az ai model deployment create \
  --resource-group <rg-name> \
  --workspace-name <project-name> \
  --name gpt-5.1 \
  --model-id azureml://registries/azure-openai/models/gpt-5.1 \
  --sku-name Standard \
  --sku-capacity 10
```

**NOTE:** The exact command syntax may vary depending on the installed Azure CLI version and whether the `ml` or `ai` extension is being used. Students may need to explore `az ml online-deployment`, `az ai model deployment`, or similar subcommands. The key coaching point is that they use the CLI to manage the deployment rather than the portal.

If the model was already deployed via the Challenge 00 infrastructure scripts, students should still demonstrate they can **list** and **verify** the deployment via CLI. The goal is CLI fluency, not just checking a box.

### Part 3: CLI Agent Deployment

After students have created their `NewsAgent` via the Python script (Part 2), they need to deploy it as a hosted agent using the CLI. The key distinction to drive home: **creating** an agent (SDK) defines it, **deploying** an agent (CLI) makes it a persistent, hosted endpoint on Azure.

The general CLI pattern:

```bash
# List agents in the project to find the NewsAgent's ID
az ai agent list \
  --resource-group <rg-name> \
  --workspace-name <project-name>

# Deploy the agent (using the agent ID from the list command or from the script output)
az ai agent deploy \
  --resource-group <rg-name> \
  --workspace-name <project-name> \
  --agent-id <agent-id>

# Verify deployment status
az ai agent show \
  --resource-group <rg-name> \
  --workspace-name <project-name> \
  --agent-id <agent-id>
```

**NOTE:** The exact CLI commands and flags will depend on the installed Azure CLI version and Foundry extension. Students may need to explore `az ai agent`, `az ml agent`, or check `az ai --help` for the correct subcommands. The critical coaching point is that they deploy the agent through the CLI rather than the portal.

**Important:** Students must **not** delete the agent at the end of their Part 2 script, or it won't exist for Part 3. If they already ran cleanup, they need to re-run the script without the delete call.

After deployment, have students confirm the agent shows up in the Foundry portal as a deployed/hosted agent — this closes the loop between code creation and CLI deployment.

### Portal Code Hint

The biggest hint in this challenge is in the Tips section: students can go back to the Foundry portal, open one of their Challenge 01 agents, and look for a **"View code"** button or code snippet panel. The portal generates equivalent Python SDK code for portal-created agents. If a student is stuck on the SDK structure, point them there first before giving away the solution.

### Solution Script Structure

A working `news_agent.py` should follow this general pattern:

```python
import os
from dotenv import load_dotenv
from azure.identity import DefaultAzureCredential
from azure.ai.projects import AIProjectClient
from azure.ai.agents.models import MessageRole

load_dotenv()

endpoint = os.getenv("AZURE_AI_FOUNDRY_ENDPOINT")
project_name = os.getenv("AZURE_AI_PROJECT_NAME")

credential = DefaultAzureCredential()
project_client = AIProjectClient(
    endpoint=endpoint,
    credential=credential
)

# Use the agents client from the project client
agents_client = project_client.agents

# Create the agent
agent = agents_client.create_agent(
    model="gpt-5.1",
    name="NewsAgent",
    instructions="""You are a concise and neutral news briefing assistant named NewsAgent.
    You summarize news topics with clear headlines and short summaries.
    You cover multiple perspectives on controversial topics.
    You clarify that you do not have access to live news feeds and rely on your training knowledge.
    You organize your briefings in a structured, easy-to-scan format."""
)
print(f"Created agent: {agent.name} (ID: {agent.id})")

# Create a thread
thread = agents_client.threads.create()

# Send first message
agents_client.messages.create(
    thread_id=thread.id,
    role=MessageRole.USER,
    content="Give me a briefing on the latest developments in renewable energy."
)

# Create a run and wait for completion
run = agents_client.runs.create_and_process(thread_id=thread.id, agent_id=agent.id)
print(f"Run status: {run.status}")

# Read messages
messages = agents_client.messages.list(thread_id=thread.id)
for msg in messages:
    if msg.role == MessageRole.AGENT:
        for block in msg.content:
            if hasattr(block, "text"):
                print(f"\nNewsAgent: {block.text.value}")

# Second message
agents_client.messages.create(
    thread_id=thread.id,
    role=MessageRole.USER,
    content="What are the key things happening in AI regulation right now?"
)

run2 = agents_client.runs.create_and_process(thread_id=thread.id, agent_id=agent.id)
print(f"Run status: {run2.status}")

messages2 = agents_client.messages.list(thread_id=thread.id)
for msg in messages2:
    if msg.role == MessageRole.AGENT:
        for block in msg.content:
            if hasattr(block, "text"):
                print(f"\nNewsAgent: {block.text.value}")

# NOTE: Do NOT delete the agent — it is needed for Part 3 (CLI deployment)
# agents_client.delete_agent(agent.id)
print(f"Agent '{agent.name}' is ready for CLI deployment. Agent ID: {agent.id}")
print("Use this agent ID in Part 3 to deploy via Azure CLI.")
```

**NOTE:** The exact SDK API surface may vary slightly depending on the installed version of `azure-ai-projects` and `azure-ai-agents`. The pattern above is the canonical one. Students may use `create_and_process` (synchronous wait) or manually poll with `runs.create()` + a status-check loop — both are acceptable.

### What to Look For When Reviewing

- **Authentication:** Must use `DefaultAzureCredential`. If a student hardcodes an API key or connection string, have them fix it. The `.env` should only contain the endpoint and project name.
- **Agent creation:** Should have a name (`NewsAgent`), a model (`gpt-5.1`), and meaningful system instructions. If the instructions are just "You are a helpful assistant," push them to be more specific about the news briefing persona.
- **Multi-turn conversation:** The student should send at least two messages and show both responses. Verify they are creating messages on the same thread (not creating a new thread per message).
- **No cleanup in Part 2:** The script should NOT delete the agent — it's needed for Part 3. If a student's script deletes the agent, have them comment out the delete call and re-run.
- **Portal verification:** After Part 2, ask the student to show the agent in the portal. After Part 3, ask them to show the deployment status. This proves the full lifecycle: code creation → CLI deployment.
- **Agent ID handoff:** The student needs the agent ID from their Part 2 script output to use in Part 3 CLI commands. Make sure they capture/record it.

### Common Issues

- **CLI extension not installed**: If `az ai` or `az ml` commands aren't recognized, the student needs to install the extension: `az extension add --name ml`. Have them run `az extension list` to check.
- **CLI auth issues**: Student needs to be logged in via `az login` and have their subscription set: `az account set --subscription <id>`. Verify with `az account show`.
- **Model deployment already exists**: If the Challenge 00 infra scripts already deployed the model, students will get an error trying to create it again. That's fine — the goal is demonstrating they can verify it via CLI. Have them run the `list` command instead.
- **`ModuleNotFoundError`**: Student hasn't activated their virtual environment or hasn't run `pip install -r requirements.txt`. Make sure they're in the correct directory with the `.env` file.
- **`DefaultAzureCredential` fails**: Student isn't logged in via `az login`. In Codespaces, they may need to set `CODESPACES=false` and re-run `az login` (covered in Challenge 00).
- **Run status is `failed`**: Usually a model deployment issue. Confirm the `gpt-5.1` deployment exists in their project. Have them check the run's `last_error` property for details.
- **Empty response**: Student may be reading messages before the run completes. Make sure they are using `create_and_process` or polling until `run.status == "completed"`.
- **Student uses a different agent name**: That's fine as long as it reflects a news/briefing persona. The name `NewsAgent` is a suggestion, not a hard requirement.

### Discussion Prompt (Optional)

After all three parts are working, ask:
- *"How does writing the agent in code compare to configuring it in the portal? What can you do in code that you can't do in the portal?"*
- *"If you needed to create 10 variations of this agent with slightly different instructions, how would you do it in code vs. the portal?"*
- *"Now that you've done create (SDK) and deploy (CLI) separately — how would you combine these into a single CI/CD pipeline?"*
- *"What's the difference between an agent that exists in your project vs. one that's deployed as a hosted endpoint?"*
