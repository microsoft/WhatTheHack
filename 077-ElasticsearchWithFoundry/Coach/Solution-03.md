# Challenge 03 - Rise of Agent Optimus - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

Students build Optimus in the Foundry UI, mirroring Challenge 01, using the Context Engine MCP endpoint from Challenge 02. The Elastic API key can be the same key, provided it has read access to the AI Index and source indices. Optimus still queries source data for current facts.

### Evaluate the comparison

Confirm the trace includes a native context tool and uses KI guidance before querying source data. Compare identical question text, model deployment, source snapshot, and result limits using fresh conversations. Record the extra KI description and tool-schema overhead honestly. Do not cherry-pick runs, require a fixed percentage improvement, or attribute every difference solely to context.

Ask: "What changed between reusable context and current evidence?" A current TK-201 answer should use the ticket source. The payment question should still acknowledge missing data.

### Progressive hints

- Missing Optimus source access: Context Engine read is separate from source-index authorization.
- Tool list errors: re-check the Challenge 02 URL and the `ApiKey` header value.
- Negative savings: inspect context/tool overhead, repeated discovery, source queries, and model variation. A negative result with a correct explanation is valid.
- No token telemetry: check that tracing/Application Insights is configured, as in Challenge 01.
