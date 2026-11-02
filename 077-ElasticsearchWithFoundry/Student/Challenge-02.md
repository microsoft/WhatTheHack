# Challenge 02 - Build the Context Engine

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites

- Completed Challenge 01 and recorded your Agent Mole results.
- The `precision-crm-accounts`, `precision-support-tickets`, and `precision-kb-articles` indices populated with the workshop data.

## Introduction

Agent Mole had to discover (and rediscover) your indices, mappings, and joins before it could answer EVERY query. Elastic's **Context Engine**, available as **Context** in Kibana, moves that recurring interpretation out of the agent's question-answering loop. It lets you create **AI Indices**, attach source indices, and run automations using Kibana Workflows to generate reusable context.

An **AI Index** is a special index (named `ai-index-idx-<name>`) that holds **Knowledge Indicators (KIs)** for agents to consult before querying source data. Each KI has a `type`, `title`, `description`, and `content`. In this challenge, you will create `index_metadata` KIs describing each source's purpose, key fields, join keys, known gaps, and verified ES\|QL access patterns. An AI Index does not merge or replace source documents.

Without KIs, an agent may repeatedly call tools such as `list_indices` and `get_index_mapping`. With KIs, it can retrieve routing facts and move to targeted ES\|QL queries. KIs describe structure and meaning, not live values: current counts, statuses, and dates still require source queries. 

In this challenge you will build an AI Index and KIs for Precision Labs data that Agent Optimus will use in the next challenge. 

## Description

Use Kibana and the workflow files in the `workflows/` folder in your GitHub Codespace, or in the Resources.zip file provided by your coach.

**NOTE:** As of October 2026, Context-Engine is an Experimental feature. You will need to enable it in Kibana before you can use it.

### Enable Context Engine

- In Kibana, click the **Settings** sprocket in the left nav bar, then select **Advanced Settings**.
- Turn on the toggle button for **Context Engine**, then click **Save**.
- Refresh Kibana in the browser and a new **Context** icon should appear in the left nav bar.

### Create the AI Index

- Open **Context** (Context Engine) in Kibana and create an AI Index named `precision-corpus`. (The backing index will be `ai-index-idx-precision-corpus`.).
- Use the text below for the **Description**. The description text shapes the automations that Context Engine generates and helps agents decide when the index is relevant.

```text
Routing context for Precision Labs customer-success data in three Elasticsearch indices: precision-crm-accounts (500 customer accounts with tier, arr = annual recurring revenue in USD, churn risk score, renewal date, and account owner), precision-support-tickets (3,000 support tickets with priority critical, high, medium or low, category, and status; customer_id in accounts joins to account_id in tickets), and precision-kb-articles (150 knowledge base articles by category). Knowledge Indicators describe what each index holds, what its fields mean, how the indices join, and ES|QL query patterns that work. Example questions: Which Enterprise accounts have the highest churn risk, and what are they contacting support about? Which Enterprise accounts renewing in the next 60 days have open critical tickets, and which knowledge base articles cover their issues? Known gaps: there is no product usage, billing, or contract data, and Knowledge Indicators describe structure and meaning, not live values, so query the source indices for current counts, statuses, and dates.
```
- Click **Create AI index** to complete the creation.

### Add The Source Indices

On the `precision-corpus` AI Index's **Overview** tab, find **Sources**, click **Edit**, and under the **Elasticsearch data** tab add each index:

- `precision-crm-accounts`
- `precision-support-tickets`
- `precision-kb-articles`

Click **Save**. Sources should show 3. 

**NOTE:** The **Connectors** tab lists technical-preview sources such as GitHub, Azure Blob Storage, SharePoint, and OneDrive. The same AI Index can be fed from those.

### Generate the Knowledge Indicators with a Workflow

- In the **Automations** section of the Overview tab, click **Add automation** and select **Create workflow**. Kibana Workflows opens with a scaffolded workflow:
- Select all the scaffold text and delete it.
- Copy the contents of the `precision-index-metadata-kis.yml` file from the `workflows/` folder of your Codespace and paste it into the workflow editor. This assumes the AI Index is named `precision-corpus`.
- Click **Save**, then **Run workflow**.

The workflow runs once per source index. It fetches the mapping, samples 20 random documents, runs grounding ES\|QL aggregations (counts by category), renders that into a KI, and writes it to the AI Index with `context-engine.createKi`. Three indices finish in about a minute.

- To check the result, open the `precision-corpus` AI Index, switch to the **Knowledge Indicators** tab. You should see KIs for all three indices. Open one and read `content`.

### Inspect and Edit the KIs

KIs are ordinary Elasticsearch documents. In **Discover** try these queries:

**NOTE:** ES\|QL mode, set the time range wide enough to include when you ran the workflow.

```esql
FROM ai-index-idx-precision-corpus
| KEEP type, title, content
| SORT type
| LIMIT 20
```

Semantic-ish match:

```esql
FROM ai-index-idx-precision-corpus
| WHERE MATCH(content, "which accounts are likely to churn")
| KEEP title, content
| LIMIT 3
```

Generated KIs may not say that `arr` means annual recurring revenue in USD. If so, add it with a plain document update in **Dev Tools**:

```json
POST ai-index-idx-precision-corpus/_update/precision-crm-accounts
{
  "script": {
    "source": "ctx._source.content += '\n\nNote: arr field = Annual Recurring Revenue in USD (not an array).'",
    "lang": "painless"
  }
}
```

Re-run the workflow whenever source schemas or data distributions change. It is idempotent and schedulable.

## Success Criteria

- Verify that the native AI Index `precision-corpus` exists with a description covering the customer-success scenario and known data gaps.
- Show that all three `precision-*` source indices are associated with the AI Index.
- Verify a successful automation run and exactly three `index_metadata` KIs, one for each source, with populated `type`, `title`, `description`, and `content` fields.
- Demonstrate retrieval of KI content through ES\|QL, including a `MATCH` query relevant to a customer-success question.
- Show that the accounts KI correctly defines `arr` and that any corrections you made are persisted and retrievable.
- Demonstrate how a KI helps select an index or construct a working source query, with field names and join guidance checked against the actual source mappings.
- Demonstrate why context generation and refresh cost is separate from per-question token use, and identify when KIs need refreshing.
- Demonstrate that a KI is reusable context, not a security boundary or an automatically current source record.

## Learning Resources

- [Context Engine concepts](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/concepts)
- [Context Engine quickstart](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/quickstart)
- [Retrieve context from an AI Index](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/retrieve-context-from-ai-index)
- [AI Index routing walkthrough](https://www.elastic.co/search-labs/blog/ai-index-building-context-agents)

## Tips

- Inspect the AI Index's actual destination and fields. Do not assume a name prefix alone creates a managed Context Engine resource.
- Agent traces are optional for this workflow; you do not need to supply a baseline agent's traces.
- If generation fails or produces no KIs, inspect the execution details. The supplied `plan-b-write-kis-no-llm.yml` workflow can write three KIs directly without an LLM connector; it assumes the AI Index is named `precision-corpus`. Treat these fallback profiles as drafts and validate their fields and joins against your data.
- In Discover, use a time range that includes the workflow run so newly generated KIs are visible.
- Re-running the workflow can replace manual corrections. Review regenerated content whenever source schemas or data distributions change.

## Advanced Challenges

- Change a source's metadata, regenerate its KI, and explain the impact of stale context.
- Explore when repeated usage could offset KI generation and refresh costs.
