# Challenge 03 - Rise of Agent Optimus

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Pre-requisites

- Completed Challenge 02 and have an AI Index with multiple Knowledge Indicators.
- Your Elastic API key from Challenge 00.
- Your Kibana MCP endpoint URL from Challenge 01.
- Your Agent Mole results table from Challenge 01.

## Introduction

In Challenge 01, you observed how Agent Mole had to dig around blindly in your data on EVERY query to discover your data before it could answer. In this challenge, we're going to create a new agent named "Agent Optimus" that will not be running blind!

The AI Index you created in Challenge 02 exposes several new MCP tools, all pre-fixed: `platform.context_engine.*`

- `platform.context_engine.list_ai_indices`
- `platform.context_engine.describe_ai_index`
- `platform.context_engine.query_ai_indices`
- `platform.context_engine.run_automation`
- `platform.context_engine.save_automation`

These new tools will give Agent Optimus the vision it needs to understand your data before retrieving it! The Knowledge Indicators in the AI Index provide a rich natural language description of your data and how to query it. In theory, this should reduce the work it takes for Agent Optimus to build context and figure things out on its own.

## Description

You have already built Agent Mole in Microsoft Foundry. This challenge repeats most of those steps to create Agent Optimus, but with a slightly different tool configuration and System Prompt. Then you will measure whether the context-first approach changes how the new Agent Optimus behaves.

### Create Agent "Optimus"

- Open [Microsoft Foundry](https://ai.azure.com) and select your project. You should use the same project that you used in Challenge 01 to build Agent Mole.
- Go to **Agents** and create a new agent named `Optimus`.
- Select the same model deployment you used for Agent Mole. (`gpt-5-mini`)
- In **Instructions**, paste the system prompt provided below:

```text
You are a customer-success analyst for Precision Labs. 
Answer questions about accounts, support tickets, and knowledge-base articles using the data available to you. 
Show your reasoning. 
Before querying data, retrieve relevant Knowledge Indicators to learn which index to use and what fields mean. 
Your Knowledge Indicators are in AI Index precision-corpus (ES|QL target: ai-index-idx-precision-corpus). 
KI fields: type (index_metadata or playbook), title, content. 
Go directly to query_ai_indices — skip list_ai_indices, describe_ai_index, list_indices, and get_index_mapping. 
The KIs already tell you the index names and schemas.
```
Note that this system prompt guides Agent Optimus to use the new AI Index and Knowledge Indicators. We'll come back to this fact after the next step.

### Connect Agent "Optimus" to Elastic

Since you connected Agent Mole to Elasticsearch using the same project in Foundry during Challenge 01, the same connection should be available in Foundry under **Tools**.

- In **Tools**, click the **Add** dropdown and select the **Elasticsearch** connection from **Recently Used**.

Foundry connects the **Web search** tool by default when creating a new agent. We want to restrict the agent to only data from Elasticsearch, therefore, you should remove it.

- In **Tools**, click the elipsis (...) next to **Web search** and remove it.

> **NOTE:** If you do not see your Elasticsearch connection under **"Recently Used"**, review the instructions in Challenge 01 for connecting to the Elastic MCP server.

When connecting an agent to Elasticsearch via MCP, by default ALL of the tools available in your Elasticsearch instance are available to the agent. 

In the agent's **Instructions**, we used the system prompt to *guide* Agent Optimus to use the AI Index and Knowledge Indicators. If we do not guide the agent, its LLM could decide to call the `platform.core.*` tools for discovery instead of the new AI Index tools. 

> **NOTE:** This applies for Agent Mole too! There's nothing preventing Agent Mole from seeing and accessing the new `platform.context_engine.*` tools you created in Challenge 2.  If you go back and re-read/inspect Agent Mole's system prompt, you'll see that we gave it instructions to NOT use the AI Index tools (which didn't exist when you implemented Agent Mole, but we knew not to let Agent Mole try anything funny like that!)

Microsoft Foundry allows you to configure the MCP connection to allow the agent access to only specific tools. This is a stricter way of controlling tool access than with only a system prompt.

- In **Tools**, click the elipsis (...) next to **Elasticsearch** and select **Configure**.
- In the **Allowed Precision Labs Elastic tools** box, enter the following list of allowed tools (comma delimited):

```text
platform_context_engine_list_ai_indices, 
platform_context_engine_describe_ai_index, 
platform_context_engine_query_ai_indices, 
platform_context_engine_run_automation, 
platform_context_engine_save_automation, 
platform_core_execute_esql, 
platform_core_generate_esql
```

> **WARNING:** The Foundry tool configuration only accepts tool names with letters, numbers, hyphens, and underscores. The Elasticsearch tool names in Kibana contain periods (i.e.`platform.context_engine.list_ai_indices`). The periods are converted to underscores via MCP. We have already done the conversion so you can copy/paste the list above without any headaches.

- Optionally, select **"Always auto-approve all tools"** so that you don't need to approve each tool call when running queries in the agent playground.
- Click **Update** to save the tool configuration.
- **Save** the agent to complete the tool connection.

> **NOTE:** The "allowed tool list" configuration only applies to the current agent (Agent Optimus). If you want to restrict Agent Mole from calling the new context engine tools, you will need to open Agent Mole and give it a different list of tools to allow.

### Test Agent "Optimus"

- Open Agent Optimus in the **Playground**.
- Ask the same sample queries you used with Agent Mole (listed below), each in a **new conversation**.
- Re-run the same query multiple times as you may observe the agent making different tool calls and a different number of tool calls.

**Prioritize At-Risk Customers**
```
Which Enterprise accounts have the highest churn risk, and what are they mostly calling us about?
```

**Support Tickets: Unresolved Integration Issues**
```
Which Enterprise accounts renewing in the next 60 days have open critical tickets, and which knowledge base articles cover their issues?
```

**Financial Impact of at risk customers**
```
What is the total ARR of the five accounts you just listed?
```
- Verify the answers come from Elastic data and match the records in Kibana.
- Ask a question the data cannot answer and observe how Optimus responds.

### Observe Agent "Optimus"

- Collect the same measurements as in Challenge 01: MCP calls, input tokens, output tokens, and total tokens, using the response details and **Tracing**.
- Add Optimus rows to your results table next to the Agent Mole results.
- Compare correctness, citations, calls, tokens, and latency. Explain the tradeoff, even if savings are small or negative.

## Success Criteria

- Verify that a Foundry agent named **Optimus** exists with a deployed model and the Context Engine MCP tool connected.
- Demonstrate at least one answer that uses KI context from the AI Index and current data from Elastic.
- Show a side-by-side comparison of Mole and Optimus for the same questions.
- Explain the observed difference in calls and tokens, including any added overhead.
- Demonstrate that Optimus can acknowledge a question the data cannot answer.

## Learning Resources

- [Use Context Engine with agents](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/use-context-engine-with-agents)
- [Connect Foundry agents to MCP server endpoints](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/model-context-protocol)
- [Set up MCP server authentication in Foundry](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/mcp-authentication)

## Tips

- Compare the same questions, model deployment, and data. Use fresh conversations.
- A native context lookup may involve list, describe, and query calls. Success does not require exactly one call.
- A low token count is not success if the answer was guessed or retrieval failed.

## Advanced Challenges

- Update the tool configuration to remove access to the tools you observed the agent calling, and then see what happens when you re-run the same queries.
- Answer a question that requires two sources while retaining document references.
- Repeat a question in several fresh conversations and compare variation without cherry-picking.
