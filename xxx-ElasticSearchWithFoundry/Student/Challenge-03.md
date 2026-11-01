# Challenge 03 - Rise of Agent Optimus

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Pre-requisites

- Completed Challenge 02 and have the Context Engine MCP endpoint URL.
- Your Elastic API key from Challenge 00.
- Your Agent Mole results table from Challenge 01.

## Introduction

Agent Optimus uses the Context Engine and its AI Index to understand your data before retrieving it. You have already built agent Mole in Microsoft Foundry. This challenge repeats most of those steps, but with a slightly different tool configuration and System Prompt. Then you will measure whether the context-first approach changes how the new agent Optimus works.

The AI Index exposes three new MCP tools:

- `platform.context_engine.list_ai_indices`
- `platform.context_engine.describe_ai_index`
- `platform.context_engine.query_ai_indices`

These tools are available to any agent that can call the MCP endpoint for your Elasticsearch database. 

Your agent can call ANY of these tools, but we want to restrict the agent to only using the AI Index tools, and a core ES|QL execute tool.

If we don't restrict the agent, it can all the tools which Agent Mole uses for discovery. This applies for Agent Mole too. There's nothing preventing Agent Mole from seeing and accessing the AI Index tools!  If you go back and re-read/inspect Mole's system prompt, you'll see that we give it instructions to NOT use the AI Index tools! (which didn't exist when you implemented Mole, but Mole knew not to try anything funny like that.)


Building and refreshing context has a cost, so reduced per-question discovery is a hypothesis to measure, not a given.

## Description

### Create Agent "Optimus"

- Open [Microsoft Foundry](https://ai.azure.com) and select your lab project.
- Go to **Agents** and create a new agent named `Optimus`.
- Select the same model deployment you used for Agent Mole.
- In **Instructions**, paste the system prompt provided below:

```
You are a customer-success analyst for Precision Labs. Answer questions about accounts, support tickets, and knowledge-base articles using the data available to you. Show your reasoning. Before querying data, retrieve relevant Knowledge Indicators to learn which index to use and what fields mean. Your Knowledge Indicators are in AI Index precision-corpus (ES|QL target: ai-index-idx-precision-corpus). KI fields: type (index_metadata or playbook), title, content. Go directly to query_ai_indices — skip list_ai_indices, describe_ai_index, list_indices, and get_index_mapping. The KIs already tell you the index names and schemas.
```
- Back in your agent in Foundry, open **Tools** and select **Add tool** (or **+ Add**).
  - In the tool catalog, choose **Elasticsearch** if it is listed. The Elasticsearch tool includes a dedicated configuration form for the MCP connection.
  - Fill in the connection fields with your Kibana MCP settings:
    - Name: `elastic-mcp` (or similar)
    - MCP server URL / endpoint: paste the **MCP server URL** from Kibana
    - Authentication: **API key** / **Key-based**
    - Header name: `Authorization`
    - Header value: `ApiKey <your Elastic API key>` (replace the placeholder with your encoded key from Challenge 00; keep the word `ApiKey` and the space)
  
    ![Screenshot of the completed MCP tool connection in Foundry](../images/foundry-add-elasticsearch-tool.png)

  - If you do not see an Elasticsearch entry in the catalog, choose **Model Context Protocol (MCP)** or **Custom** from the catalog and enter the same MCP endpoint URL and API key. The configuration flow is the same.
  - Select **Connect** (or **Create**) and confirm the Elastic tools are listed. If the tool list shows an error, re-check the URL and key.
  - Leave tool approval enabled so that you can inspect each call.


### Test Agent "Optimus"

- Open Optimus in the **Playground**.
- Ask the same sample queries you used with Agent Mole, each in a **new conversation**:

```
Which Enterprise accounts have the highest churn risk, and what are they mostly calling us about?
Which Enterprise accounts renewing in the next 60 days have open critical tickets, and which knowledge base articles cover their issues?
What is the total ARR of the five accounts you just listed?
```
- Review and approve each MCP call. Expand the tool-call details and note which context tools were called, and whether source data was still queried for current details.
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

- Answer a question that requires two sources while retaining document references.
- Repeat a question in several fresh conversations and compare variation without cherry-picking.
