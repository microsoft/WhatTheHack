# Challenge 02 - Build the Context Engine - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

This challenge turns source structure and business meaning into reusable Knowledge Indicators (KIs). Students create a native Context Engine AI Index, associate three sources, run the supplied workflow, and inspect its output. A KI can help an agent decide where and how to query; it does not replace current source records. Use the current [student challenge](../Student/Challenge-02.md) and the supplied YAML workflows rather than the old notebook's automation brief.

### Prepare the native feature and workflow

- Rehearse the current Kibana UI shortly before delivery. Context Engine is experimental in the documentation reviewed for this guide, and menu labels, backing storage, workflow steps, and KI schemas can change.
- Enable `contextEngine:enabled` in **the same Kibana space** that students use for Context, workflows, and MCP. The current documentation calls this **Stack Management > Advanced Settings**; the student guide uses the settings navigation.
  - If Context is missing, confirm the setting was saved, refresh the browser, check the space and permissions, and verify the project's feature eligibility.
  - A setting toggle is not proof that KI creation or external MCP retrieval works. Pilot both.
- The setup identity needs Context Engine management, workflow edit/run access, source read/metadata access, backing-index write/create access, and permission to use the chosen LLM connector.
- Inspect [the generation workflow](../Student/Resources/workflows/precision-index-metadata-kis.yml) before the event. Its opening comment mentions replacing a placeholder, but the actual `generate_index_profile` step contains a concrete `connector-id`.
  - Replace that value in the student's imported workflow with the ID of an available, approved **chat-completion connector**. Copy the connector ID, not its display name or an Elasticsearch inference endpoint ID.
  - This connector runs inside Elastic; it is not the Foundry model deployed for Mole. Confirm its credentials, service access, quota, and charges separately.
  - Test the structured `ai.prompt` output and the workflow's references to `output.content`. A connector/schema mismatch can break the later assembly step even if the model returns text.
- Prepare a tested fallback, but keep it clearly labeled. The supplied no-LLM workflow has known draft inaccuracies described below. Do not hand it out as a verified equivalent without inspecting it.

### Explain what creation does and does not do

- `precision-corpus` is the logical AI Index ID used by the workflow. In the current student path, its expected backing target is `ai-index-idx-precision-corpus`.
  - Create it through **Context**, not by creating an Elasticsearch index with a matching name.
  - Verify the actual target and fields from the native description or KI Document view. Newer documentation also describes data-stream-backed storage; a naming convention is not an API contract.
  - This is a **user-created** AI Index. Product documentation uses "Managed" for product-supplied AI indices whose configuration users cannot edit.
- A description helps route questions and explain scope. It neither grants source access nor generates KIs by itself.
- Adding the three Elasticsearch sources registers what can be analyzed; it does not copy all accounts, tickets, and articles into the AI Index.
- The supplied workflow explicitly loops over its `consts.indices`. Changing only the AI Index's Sources list does not automatically change that loop. Keep both aligned.
- Three source indices should produce **three `index_metadata` KIs**, not 3,650 KIs and not three separate AI indices. The workflow's stable KI IDs are the source index names.

### Understand the workflow before coaching it

The workflow fetches each mapping, samples 20 documents, calculates category/extra-field counts and totals, asks the Elastic-side LLM for an index profile, renders it, and calls `context-engine.createKi`.

- The mapping provides field types and descriptions; the sample provides examples; the aggregations provide full-source statistics. A 20-document sample is not evidence about every account or issue.
- The workflow runs one loop iteration per source. A failed later iteration can leave some KIs already written. Inspect the execution tree and the first failing step rather than blindly rerunning.
- Saving a workflow is not running it, and a successful run is not proof that the generated content is correct.
  - The supplied workflow requests verified access patterns but **does not execute its generated example queries or configure KI verifiers**. Coaches/students must test those examples against the actual source data.
  - Each iteration only sees one source's mapping/sample. Cross-index join guidance may be incomplete or invented; the LLM cannot reliably infer all relationships from one source.
  - Random samples and LLM output can change across runs even though the source dataset is seeded.
- The workflow has a manual trigger. Scheduling is a capability students can explore, not something automatically installed by this file.
- Stable IDs are intended to address the same logical KIs on reruns. Confirm the current service's replacement/revision behavior and count the resulting active KIs; do not assume a rerun preserves manual corrections or identical content.

### What accurate KIs should say

| Source | Important coach checks |
| --- | --- |
| Accounts | One row per account; `customer_id` identifies it; `arr` is annual recurring revenue in USD; `churn_risk_score` is 0-1; renewals are dates |
| Tickets | `account_id` links to CRM `customer_id`; `ticket_id` identifies a ticket; `open`/`in_progress` are unresolved; `resolved`/`closed` are resolved |
| KB articles | Article IDs/titles support citations; match issue topics through content/tags; there is no direct account-ID join |

- Verify field names against source mappings, not plausible business vocabulary. For example, tickets have `account_id`, not `customer_id`; accounts have `customer_id`, not `account_id`.
- Keep limitations explicit: ARR is present, but there is no invoice ledger, product-usage telemetry, or authoritative contract record. Billing-related support content does not remove those gaps.
- A business relationship is not automatically a supported ES|QL join. The supplied indices are ordinary indices, not lookup-mode indices. Sequential queries using IDs are a valid approach.
- Validate both syntax and meaning. A query can execute while using the wrong date window, aggregating the wrong population, or double-counting account ARR across tickets.
- Metadata KIs can contain sampled facts and generation-time counts. Those values can go stale; current account rankings, status, renewal windows, and totals still require source queries.
- Good KIs should improve multiple questions and agents. They are not a cached answer to a single prompt and are not an authorization boundary.

### Inspection, corrections, and fallback gotchas

- Inspect all three KIs in Context, including populated `type`, `title`, `description`, and `content`. Use the Document view to check IDs, references, timestamps, and workflow provenance.
- In Discover, confirm the ES|QL target and fields and check the time range. If available, **View raw docs in Discover** from the KI tab is a useful shortcut.
  - Test the student `MATCH(content, ...)` example against the actual field mapping. `MATCH` is full-text relevance retrieval, not proof of embedding/vector search. No hits can mean a poor phrase, a field mismatch, or filtering rather than a failed generation.
  - Raw Elasticsearch document visibility is not proof that native Context Engine retrieval exposes the same documents. Native retrieval can apply lifecycle, expiry, revision, and space filters.
- The student's direct `_update` example assumes an ordinary backing index and KI document ID `precision-crm-accounts`. Repeated execution appends the same ARR note repeatedly.
  - Pilot this command against the current storage model. If the backing data or document ID differs, do not blindly substitute a guessed index.
  - Current product documentation recommends fixing generated content in the **source or owning automation**, then regenerating, or using supported KI workflow steps for intentional individual updates. Prefer that path if the direct-update assumptions no longer hold.
  - For a durable correction, add the ARR definition and explicit join guidance to the workflow prompt/rendering. Read the corrected KI again after regeneration and through the retrieval route Optimus will use.
- [The no-LLM fallback](../Student/Resources/workflows/plan-b-write-kis-no-llm.yml) is **disabled by default** and writes directly to the assumed backing index. Check whether it must be enabled for manual execution in the current UI.
  - Its CRM KI incorrectly points to ticket `customer_id`; its ticket KI incorrectly points to CRM `account_id`. Both must describe **CRM `customer_id` = ticket `account_id`**.
  - It omits the explicit ARR definition, uses a 90-day renewal example without a lower bound, and includes quoted index names and date syntax that must be tested in the current ES|QL version.
  - It references contract status despite the absence of authoritative contract data. Treat every supplied profile and example as a draft.
  - Direct writes do not establish native KI lifecycle/provenance behavior. Verify the three KIs in Context and native retrieval; use supported KI steps if required by the current service.
  - A validated fallback can let students continue inspecting and querying KIs without an LLM connector. Record that they used prewritten profiles; do not claim they completed LLM-based generation.

### Troubleshooting and handoff to Optimus

| Symptom | Coach check |
| --- | --- |
| Every Context Engine operation returns `404` | Feature enabled in the targeted space and correct API route |
| Context access returns `403` | Context Engine feature privilege, not only source read access |
| Describe/query returns `403` or the AI Index is omitted | Backing-index read/metadata access and correct space |
| Workflow fails at `ai.prompt` | Connector ID/access, provider error/quota, and output schema |
| Workflow fails after generation | Step output shape, KI fields, and current `createKi` contract |
| Only one or two KIs exist | Per-source execution failures or wrong workflow constants |
| Raw docs exist but context retrieval is empty | Registration, lifecycle/revision metadata, permissions, and query filters |

- Keep the **same Kibana MCP endpoint from Challenge 01**. An AI Index does not imply a new dedicated Foundry endpoint.
- Verify that the necessary `platform.context_engine.*` retrieval tools are actually advertised through MCP using the intended runtime credential. Their presence inside Kibana's Agent Builder is not sufficient evidence of external exposure.
- Before Challenge 03, retain the logical AI Index ID, exact query target/fields, three inspected KIs, a successful execution, and one working source-query example.
- If native features or external tools are unavailable, report the blocker and discuss the concepts; do not substitute a plain index or local tool and call the native objective complete.

### Completion and debrief

Have students explain one routing decision using a KI, demonstrate retrieval of all three profiles and an ARR correction, and then query a source for a current value. Ask: "What can this KI tell an agent without another source query, and what must still be checked?" KI generation and refresh incur separate costs from the later Foundry question-answering loop.

### Product references for coaches

- [Context Engine concepts](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/concepts)
- [Context Engine quickstart](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/quickstart)
- [Inspect and manage KIs, including supported corrections](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/inspect-and-manage-knowledge-indicators)
- [Native retrieval, permissions, filters, and troubleshooting](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/retrieve-context-from-ai-index)
- [Configure agents to use an AI Index](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/use-context-engine-with-agents)
