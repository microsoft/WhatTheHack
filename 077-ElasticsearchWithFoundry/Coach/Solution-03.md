# Challenge 03 - Rise of Agent Optimus - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

Students create Optimus in Foundry, retrieve KIs from `precision-corpus`, and use their guidance to query the original source data. The goal is a supported answer and an explainable comparison with Mole, not a guaranteed reduction in tokens. Follow the current [student challenge](../Student/Challenge-03.md); no separate agent notebook or dedicated Context Engine MCP server is required.

### Prepare the agent and connection

- Verify the current Foundry UI, especially **Recently Used**, per-agent allowed-tool configuration, and approval settings. A saved project connection and an agent's attached/configured tool are different things.
- Use the same project and **actual model deployment** as Mole. Recommend `gpt-5-mini`, but retain whichever coach-approved deployment the team successfully used in Challenge 01.
- Save Optimus's instructions and tool configuration before testing. Remove Web search if present and check that no unintended knowledge source is attached.
- Use the same Kibana MCP endpoint as Challenge 01, including its space path when applicable. Context Engine and the AI Index must be enabled/registered in that space.
- Reusing the project's Elastic connection is convenient, but verify its credential scope:
  - Optimus needs source read/metadata access **and** Context Engine Read in the space **and** read/metadata access on the exact AI Index backing data.
  - A key that worked for Mole may lack AI Index access. The broad Challenge 00 setup key is not a substitute for scoped runtime access.
  - If Mole's connection deliberately excludes AI Index access, create a separately named Optimus connection to the same endpoint with the additional read permissions. Do not overwrite Mole's credential and silently change the baseline.
  - If both agents share an appropriately scoped read-only connection, use separate tool allowlists and inspect traces to ensure Mole does not retrieve KIs.

### Narrow the tool list intentionally

The student list includes `run_automation` and `save_automation`. These are management/execution operations, not required context retrieval. **Coach students to omit them** for this support-analysis task.

For the wire names shown in the current student guide, the recommended read-oriented allowlist is:

```text
platform_context_engine_list_ai_indices,
platform_context_engine_describe_ai_index,
platform_context_engine_query_ai_indices,
platform_core_execute_esql,
platform_core_generate_esql
```

- Use the exact names advertised by the actual MCP server. Kibana's dotted display IDs and Foundry's underscore names differ; check each name if the form reports a missing tool.
- Inspect the current `generate_esql` description/output rather than assuming it only generates text or always executes a query. Measure the behavior actually observed.
- Keep list/describe retrieval tools available even though the student prompt tells Optimus to skip them. Direct querying is a workshop optimization based on a known AI Index ID/target/schema; it can become brittle if the service changes.
  - Confirm `precision-corpus`, the ES|QL target, and KI fields before using the hard-coded prompt.
  - If a schema/target mismatch requires list/describe calls, permit them and explain the deviation. Success does not require exactly one context call.
  - Removing source mapping/listing tools does not guarantee that other tools perform no internal discovery. Inspect what the run reveals.
- Approvals should remain enabled while students learn which tools are called. Only consider auto-approval after the read-only allowlist and credentials are verified, and use the same approval policy for measured runs.
- An allowlist controls available tools, not database permissions. `execute_esql` can query any data its credential authorizes. Prompts and KI descriptions are not security boundaries.
- Adding KIs can expose new tools to a reused connection. If rerunning Mole after Challenge 02, restrict it to its baseline read-only source/discovery tools and check that it does not query the AI Index through a general query tool.

### Preserve answer quality, not just context-first behavior

- The Optimus prompt is shorter and gives more advance information than Mole's prompt. It explicitly names the AI Index/target and discourages discovery, while the allowed tools also differ. This is a comparison of **two configurations**, not a controlled experiment isolating KIs alone.
- The phrase "Show your reasoning" should be coached as **show the evidence, calculations, and a concise explanation of the query approach**. Students do not need private internal model reasoning to verify an answer.
- Optimus still needs to cite customer IDs, ticket IDs, and article IDs/titles; acknowledge missing facts; and treat retrieved text as evidence rather than instructions.
  - Its shorter prompt does not repeat all of Mole's grounding rules. If it starts using unsupported knowledge or inventing citations, apply equivalent grounding requirements and disclose the prompt change in the comparison.
  - A KI describing support tickets cannot prove a particular ticket's current status. A KI describing ARR cannot provide the current total for a selected set of accounts.
  - If a KI has a wrong field or join, fix the KI/owning automation rather than endlessly adding compensating instructions to the agent.

### Verify the retrieval chain

Ask students to expand a run and identify three distinct pieces of evidence:

1. A successful context query returns a relevant KI from the intended AI Index.
2. The agent uses that guidance to run a successful source query against the appropriate workshop indices.
3. The final answer accurately represents the returned records and cites identifying metadata.

- A tool name in the trace is not enough: inspect its arguments and result. A guessed answer after failed retrieval is not successful grounding.
- The strongest learning evidence is a visible relationship between the KI and the source query, such as using the correct `customer_id`/`account_id` relationship or correctly interpreting `arr`.
- Confirm the answer in Kibana with the same filters. KIs, generated queries, and final prose can each introduce errors.
- A valid zero-row renewal query can answer the actual-date question. A failed query or a KI's old count cannot establish zero matches.
- For unsupported data, ask about a latest invoice amount or current product usage. The agent should identify the missing data, not substitute ARR or a billing support ticket as an authoritative answer.

### Compare like with like

- Run the two standalone sample questions in new conversations for each agent. Run the ARR question **as a follow-up to the five identified accounts in the same conversation**, as explained in [the Mole coach guide](./Solution-01.md).
  - Preserve each agent's listed account IDs and verify whether they selected the same set. Different populations can produce different valid ARR totals and are not a token-only comparison.
  - If an agent did not identify five accounts, clarify the set before asking for a total.
- Use the actual event date for the next-60-days window. Record the date/time basis and filter interpretation for both agents; avoid comparing runs across a date-boundary change without noting it.
- Hold the model deployment, source snapshot, question wording, filters, intended answer size, and approval behavior constant where possible. Record KI version/run and any configuration changes.
- Repeat a small, agreed number of runs if time allows. Report variation and failures rather than selecting only the cheapest successful Optimus result.
- Extend the student's results table with useful comparison context:

| Agent / query / run | Discovery / context / source calls | Input / output / total tokens | Elapsed time and approval policy | Correct and supported? |
| --- | --- | --- | --- | --- |
| Mole | Observed values | Service-reported values or unavailable | Observed value and scope | Records checked |
| Optimus | Observed values | Service-reported values or unavailable | Observed value and scope | Records checked |

- Use the same per-run accounting established in Challenge 01. Do not double-count aggregate usage and model spans, treat missing tokens as zero, or compare project-wide metrics to a single run.
- Separate discovery, context retrieval, and source queries. Fewer visible calls do not necessarily mean fewer model turns or lower service cost.
- If expressing a percentage change, use comparable complete totals: `(Mole tokens - Optimus tokens) / Mole tokens * 100`. Do not calculate it when usage is unavailable or the baseline is zero. A negative value means Optimus used more tokens.
- Smaller answers can look cheaper while omitting needed facts or citations. Check quality before interpreting any savings.

### Explain small or negative savings

- KIs and tool schemas add input context. Returning all three lengthy profiles for a question needing one source can cost more than a brief mapping lookup.
- Context calls, retries, source queries, output length, conversation history, caching, and model variation can change totals. A baseline that already understood source metadata has less discovery work to eliminate.
- Omitting list/describe from the prompt and restricting tools can reduce visible discovery independently of KI quality. Explain these configuration effects rather than attributing all change to Context Engine.
- Foundry per-question usage does not include Elastic-side KI generation/refresh or necessarily other Elastic tool-side model work. Include those costs separately when discussing overall economics.
  - Repeated use may amortize generation cost, but only if per-question work genuinely decreases and the KIs remain useful.
  - Refresh context when schemas, business meaning, source scope, or recorded distributions change. Relative-date answers still need fresh source queries even when the KI itself has not changed.
- A correct, well-explained result with equal or greater token use is valid. If retrieval is noisy, inspect and improve the KIs or narrow the returned context, then record that as another configuration rather than replacing the original evidence.

### Completion and debrief

Require at least one answer with both KI retrieval and current source evidence, a side-by-side results table, an honest explanation of the observed tradeoff, and an appropriate unavailable-data response. Ask: "What work moved into reusable context, what work remained at question time, and what evidence supports your conclusion?"

Keep the agents, KIs, and comparison results if the event continues to another challenge. Otherwise coordinate cleanup with the proctor: revoke workshop keys, remove only event-owned cloud resources/connections, and stop or delete Codespaces as appropriate. Deleting sample indices alone does not end all charges.

### Product references for coaches

- [Configure agents to use an AI Index and evaluate the integration](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/use-context-engine-with-agents)
- [Retrieve context: target/schema discovery and access requirements](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/retrieve-context-from-ai-index)
- [Foundry MCP tools, approvals, and connections](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/model-context-protocol)
- [Foundry MCP authentication](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/mcp-authentication)
- [Foundry tracing setup](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/trace-agent-setup)
