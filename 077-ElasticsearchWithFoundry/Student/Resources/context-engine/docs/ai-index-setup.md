# Set up the AI Index, Knowledge Indicators, and Context Engine

This is the Elastic side of the Context Engine workshop, rewritten for your own Elastic Cloud Serverless project. Everything here happens in Kibana unless a step says otherwise.

Prerequisite: the three `precision-*` indices are loaded (see [`data/`](../data/)).

## Concepts

- **AI Index**: a special index (named `ai-index-idx-<name>`) that holds **Knowledge Indicators** (KIs). Agents query it before they query your data.
- **Knowledge Indicator (KI)**: a document with `type`, `title`, `description` and `content`. Here we write `index_metadata` KIs: for each source index, its purpose, key fields, join keys, what it does *not* contain, and verified ES|QL access patterns.
- **Context Engine**: the Kibana app (**Context** in the left nav, `/app/context_engine`) where you create AI Indices, attach sources, and run automations (Kibana Workflows) that generate KIs.
- **Why**: without KIs, an agent rediscovers your indices, mappings and joins on every question (many `list_indices` / `get_index_mapping` calls). With KIs it reads the routing facts once and goes straight to targeted ES|QL.

## 1. Create the AI Index

1. Open **Context** (Context Engine) in Kibana and click **Create AI Index**.
2. **Name**: `precision-corpus` (the backing index becomes `ai-index-idx-precision-corpus`).
3. **Description**: paste the text below. It shapes the automations Context Engine generates and helps agents decide when the index is relevant.

```text
Routing context for Precision Labs customer-success data in three Elasticsearch indices: precision-crm-accounts (500 customer accounts with tier, arr = annual recurring revenue in USD, churn risk score, renewal date, and account owner), precision-support-tickets (3,000 support tickets with priority critical, high, medium or low, category, and status; customer_id in accounts joins to account_id in tickets), and precision-kb-articles (150 knowledge base articles by category). Knowledge Indicators describe what each index holds, what its fields mean, how the indices join, and ES|QL query patterns that work. Example questions: Which Enterprise accounts have the highest churn risk, and what are they contacting support about? Which Enterprise accounts renewing in the next 60 days have open critical tickets, and which knowledge base articles cover their issues? Known gaps: there is no product usage, billing, or contract data, and Knowledge Indicators describe structure and meaning, not live values, so query the source indices for current counts, statuses, and dates.
```

4. Optional: under **Agent traces**, pick an existing agent whose traces the automation generator may learn from. In the workshop this was a plain baseline agent built in an earlier lab. The workflow in this repo does **not** need traces, so you can skip this.
5. Click **Create AI index**.

## 2. Add the three source indices

On the AI Index's **Overview** tab, find **Sources**, click **Edit**, and under the **Elasticsearch data** tab add each index:

- `precision-crm-accounts`
- `precision-support-tickets`
- `precision-kb-articles`

Click **Save**. Sources should show 3. (The **Connectors** tab lists technical-preview sources such as Salesforce, Zendesk and Jira; the same AI Index can be fed from those.)

## 3. Generate the Knowledge Indicators with a workflow

In the **Automations** section of the Overview tab, click **Create automation**. Kibana Workflows opens with a scaffold:

1. Select all the scaffold text and delete it.
2. Paste [`workflows/precision-index-metadata-kis.yml`](../workflows/precision-index-metadata-kis.yml).
3. Replace `<YOUR_LLM_CONNECTOR_ID>` with the id of a chat-completion connector in your project. Use any chat-completion connector available in your project (list them under **Stack Management > Connectors**). Connector ids differ per project and can be renamed, so do not reuse an id from someone else's setup.
4. **Save**, then **Run**.

The workflow runs once per source index: it fetches the mapping, samples 20 random documents, runs grounding ES|QL aggregations (counts by category), asks the LLM for a structured index profile constrained to a JSON schema, renders that into a KI, and writes it to the AI Index with `context-engine.createKi`. Three indices finish in about a minute.

Check the result: open `precision-corpus` > **Knowledge Indicators**. The badge should show **3**; open one and read `content`.

**If the workflow fails or the count stays at 0:** use the no-LLM fallback [`workflows/plan-b-write-kis-no-llm.yml`](../workflows/plan-b-write-kis-no-llm.yml). It writes the same three KIs directly with `elasticsearch.request`, in seconds. This assumes the AI Index is named `precision-corpus`.

## 4. Inspect and edit the KIs

KIs are ordinary Elasticsearch documents. In Discover (ES|QL mode, time range wide enough to include when you ran the workflow):

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

Generated KIs may not say that `arr` means annual recurring revenue in USD. If so, add it with a plain document update in Dev Tools:

```json
POST ai-index-idx-precision-corpus/_update/precision-crm-accounts
{
  "script": {
    "source": "ctx._source.content += '\n\nNote: arr field = Annual Recurring Revenue in USD (not an array).'",
    "lang": "painless"
  }
}
```

Re-run the workflow whenever source schemas or data distributions change; it is rerunnable and schedulable.

## 5. Use the Context Engine from an agent

The AI Index exposes three tools, available to any agent that can call Elastic tools (Agent Builder agents get them when the AI Index is assigned; for an external agent such as one in Azure AI Foundry, you need to expose them through whatever Elastic tool interface you connect it with, which this repo does not cover):

- `platform.context_engine.list_ai_indices`
- `platform.context_engine.describe_ai_index`
- `platform.context_engine.query_ai_indices`

Recommended agent pattern (what the workshop's Agent Builder agent used):

1. **Instructions** along these lines (adapt the names):

```
You are a customer-success analyst for Precision Labs. Answer questions about accounts, support tickets, and knowledge-base articles using the data available to you. Show your reasoning. Before querying data, retrieve relevant Knowledge Indicators to learn which index to use and what fields mean. Your Knowledge Indicators are in AI Index precision-corpus (ES|QL target: ai-index-idx-precision-corpus). KI fields: type (index_metadata or playbook), title, content. Go directly to query_ai_indices — skip list_ai_indices, describe_ai_index, list_indices, and get_index_mapping. The KIs already tell you the index names and schemas.
```

2. Retrieve KIs first via `query_ai_indices` (an ES|QL query against `ai-index-idx-precision-corpus`).
3. Then expose **only** an ES|QL execution tool for the data itself (`platform.core.execute_esql`, or your framework's equivalent). Fewer tools made the agent's behavior more predictable: KI retrieval first, then targeted ES|QL, with no fallback to schema discovery.

## Questions to try

```
Which Enterprise accounts have the highest churn risk, and what are they mostly calling us about?
Which Enterprise accounts renewing in the next 60 days have open critical tickets, and which knowledge base articles cover their issues?
What is the total ARR of the five accounts you just listed?
```
