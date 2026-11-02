# Challenge 01 - Connect Foundry Agent to Elastic - Coach's Guide

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

The objective is a working Foundry-to-Elastic connection and an evidence-based baseline for Agent Mole. Coach students to distinguish discovering a dataset, executing a query, and grounding an answer. Mole is not supposed to be deliberately inefficient, and a successful baseline may already make few discovery calls. Use the current [student challenge](../Student/Challenge-01.md), not the earlier notebook-based implementation.

### Prepare the Foundry environment

- Verify the current **New Foundry** experience before delivery. Project creation, model deployment, agent tools, and tracing may have moved or been renamed. Keep a coach note of the current navigation and test the Elasticsearch catalog form as well as the generic MCP alternative.
- If two students share an Azure lab subscription, both sign in with the same privately shared, event-provided lab credentials, but **each creates a separate Foundry project**. Include the student's name or initials in its name, such as `precision-support-alex`.
  - Both students can see each other's projects. Verify the selected project before every configuration change, and keep that student's Mole, Optimus, and Elastic connection in their own project.
  - Connect to the student's own Elastic environment: the first student's trial comes from Marketplace; the second student's separate trial comes directly from Elastic.co because the shared subscription supports only one Marketplace trial. See [shared-subscription setup guidance](./Solution-00.md#when-students-share-an-azure-subscription).
- Recommend `gpt-5-mini` with **Global Standard**, subject to availability and quota in the lab. A deployment name is not necessarily the model's catalog name: students must select the deployment they actually created.
  - If unavailable, use a coach-approved supported alternative, record it, and retain it for Optimus. Repeatedly changing regions or models makes troubleshooting and later comparisons harder.
  - Confirm resource group/subscription selection before provisioning. Creating a project does not prove a model is deployed and ready.
- Azure management-plane permissions and Foundry data-plane permissions are separate. Current Microsoft documentation identifies **Foundry User** for creating/testing agents and **Foundry Project Manager** for creating MCP project connections. Older role names beginning with "Azure AI" may still appear during the rename. Ask the lab administrator to resolve permissions rather than treating subscription access as proof of every capability.
- Preflight telemetry, not just the chat UI. Connect an Application Insights resource to the Foundry project and confirm the lab identity can read traces.
  - The current tracing guide describes **Agents > Traces > Connect**, with **Manage > Project details > Connected resources** as an alternative. The student guide's **Observability > Tracing** label may differ.
  - Generate a test run after connecting it and allow ingestion time. Log Analytics Reader access may be needed to query telemetry. Do not promise per-response metrics merely because aggregate model metrics exist.

### Explain and troubleshoot the MCP connection

The agent runs in Foundry; the tools run behind Kibana and access Elasticsearch with the connection's credential. Students do not need to deploy a local MCP server or generate the built-in tools.

- For a generic MCP connection, use the full HTTPS endpoint:
  - Default space: `<Kibana base URL>/api/agent_builder/mcp`
  - Other space: `<Kibana base URL>/s/<space-id>/api/agent_builder/mcp`
- **The catalog form and generic MCP form are not interchangeable.**
  - The student guide's Elasticsearch catalog form requests the Kibana hostname without `https://` and the key in its dedicated field. Verify the form's current labels and whether it supplies the scheme/path/authentication prefix itself.
  - The generic MCP form needs the full endpoint and key-based authentication with header name `Authorization` and value `ApiKey <encoded-runtime-key>`.
  - Do not remove HTTPS from a generic server URL, append the MCP path twice, or add `ApiKey` twice. Never use `Bearer` simply because Azure sign-in uses it elsewhere.
- Prefer a runtime key limited to `read` and `view_index_metadata` on the three exact workshop source indices, plus the required Kibana Agent Builder permissions in the selected space. The Challenge 00 setup key can create/delete data and should not be reused as the agent's unrestricted runtime credential.
  - Follow the current Serverless project key/role configuration. Avoid copying documentation's wildcard index examples into a shared environment.
  - A key that works for Elasticsearch `_count` can still fail at Kibana MCP because it lacks Agent Builder application access.
- Remove **Web search** if present and inspect any other attached tools. The system prompt asks for Elasticsearch-only factual grounding; a web-search connection defeats that intended source restriction.
- Leave approvals enabled while learning. Expand the server, tool name, and arguments and approve only expected read-only workshop queries.
  - "Built-in tools are read-only" in product documentation can mean their **definitions cannot be edited**, not that every tool performs a read-only operation.
  - A prompt is guidance, not authorization. A tool allowlist narrows available operations, while the API key determines which data those operations can access.
- Tool display IDs in Kibana use periods; MCP names may use underscores. Use the names actually advertised to Foundry, not a guessed conversion or an older notebook's tool list.
- Diagnose failures by layer:

| Symptom | Coach check |
| --- | --- |
| Tool listing fails with `401` | Encoded key, expiration, and exact authorization header |
| Tool listing fails with `403` | Agent Builder privilege and correct Kibana space |
| Tool list works, source query fails | Source-index permissions, query syntax, and actual mappings |
| `404` or HTML response | Wrong base URL, path, space, or login/proxy endpoint |
| Local access works but Foundry times out | Service-to-service reachability, network restrictions, and connection configuration |
| No tools used | Saved agent configuration, attached tools, and a genuinely source-dependent question |

A loaded Kibana page or a local query is not proof that Foundry successfully invoked MCP. Require a successful tool result in the agent's run.

### Clarify the questions before measuring

- Start each **standalone** question in a new conversation. Run **"What is the total ARR of the five accounts you just listed?" as a follow-up** to the at-risk-account answer in that same conversation. This resolves the student guide's conflicting new-conversation instruction.
  - Ensure the preceding answer actually identifies five accounts. If it does not, ask for five explicitly or clarify the set before requesting a total.
  - Record the follow-up as a separate turn, including its conversation history. Use the same procedure for Optimus; a context-bearing turn is not comparable to a fresh standalone turn.
- "Highest churn risk" does not specify a number or tie-break rule, and "mostly calling us about" does not specify a ticket time window. Have students state their interpretation and query filters.
  - A useful reproducible check is the top five Enterprise accounts by `churn_risk_score`, breaking ties with `customer_id`, followed by ticket categories for those account IDs.
  - Company names can repeat. Match accounts by CRM `customer_id` and tickets by `account_id`, not by company name.
  - Summaries of ticket patterns do not establish a cause of churn or prove that a historical resolution applies to a current ticket.
- For the renewal question, use the **actual event date** and a window from today through the next 60 days; an upper bound alone also includes overdue renewals.
  - The bundled renewal dates are all in 2026. As the event date advances, the result can become empty. Accept an empty result only after a successful, correctly filtered source query.
  - The prompt says **open critical** tickets: check `status == "open"` and `priority == "critical"`. If students instead interpret "unresolved," they should explicitly include `in_progress` and disclose that change.
  - The displayed heading mentions integration issues, but the actual question does not impose an integration-category filter. Judge the submitted question, not the heading.
  - Find relevant KB articles by documented topic/content. Tickets and KB articles do not share a direct account-ID relationship, and their category vocabularies are not identical.
- A useful unavailable-data question is an account's latest invoice amount or current product usage. Billing-related tickets and an ARR field do not provide an invoice ledger, contracts, or usage telemetry.

### Check answers against sources

Do not rely on the old coach expected-answer JSON: it describes a different fixture. Build a pilot reference from the loaded records and the agreed question interpretation.

For the top-five interpretation above, a useful Kibana ES|QL check is:

```esql
FROM precision-crm-accounts
| WHERE account_tier == "Enterprise"
| SORT churn_risk_score DESC, customer_id ASC
| KEEP customer_id, company_name, churn_risk_score, arr
| LIMIT 5
```

- Verify the actual customer IDs, relevant ticket IDs/categories, and KB article titles/IDs returned in MCP results. Citations in the final answer must point to supporting records, not merely name an index.
- Sum ARR **once per unique account**. Joining each account to many tickets and summing the repeated ARR values overstates revenue. ARR is annual recurring revenue in USD, not realized revenue or an invoice amount.
- Sequential source queries are a valid way to combine records. Do not assume arbitrary SQL joins work in ES|QL: `LOOKUP JOIN` requires a lookup-mode index, and the supplied generators do not create these source indices in lookup mode.
- Tool errors require an explicit verification failure. They are not evidence that the dataset has no matching records.

### Make the baseline useful

- Record query text, agent/model deployment, conversation/turn, filters, answer support, MCP calls, and available input/output/total tokens. Keep enough run identification to revisit the trace.
- Separate discovery calls (such as index listing/mapping) from source queries. A generated query is not necessarily an executed query; inspect tool descriptions and outputs.
- Count actual MCP invocations, including retries and failed calls, and avoid counting the same parent/child trace event twice. Report failed runs as failed rather than attractive low-token results.
- Use per-run service-reported usage where available. Do not add a run's aggregate token total to its individual model-span totals. Missing telemetry is **unavailable**, not zero.
- If measuring elapsed time, disclose whether human approval waiting is included. Keep approval behavior consistent for the comparison.
- Aggregate deployment metrics can include other students' requests, and Cost Management data can lag. They are not a substitute for this question's usage.
- A baseline need not rediscover everything on every turn. Metadata, tool schemas, model choices, and conversation history affect behavior. Preserve a competent baseline instead of forcing unnecessary calls.

### Completion and debrief

Ask students to show one supported answer with a successful Foundry MCP result, verify it in Kibana, explain an unavailable-data response, and retain their baseline table. They may identify unavailable telemetry rather than invent measurements. Ask: "Which calls taught Mole where to look, and which returned the facts?"

### Product references for coaches

- [Foundry MCP setup, roles, approvals, and troubleshooting](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/model-context-protocol)
- [Foundry MCP authentication and shared project connections](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/mcp-authentication)
- [Foundry server-side tracing setup](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/trace-agent-setup)
- [Elastic MCP endpoint and authentication](https://www.elastic.co/docs/explore-analyze/ai-features/agent-builder/mcp-server)
- [Elastic built-in tool reference](https://www.elastic.co/docs/explore-analyze/ai-features/agent-builder/tools/builtin-tools-reference)
- [ES|QL LOOKUP JOIN requirements](https://www.elastic.co/docs/reference/query-languages/esql/esql-lookup-join)
