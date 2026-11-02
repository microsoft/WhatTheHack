# Challenge 02 - Build the Context Engine - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

An AI Index is a managed store of reusable context, not a merged table or a magical replacement for current source records. One AI Index can describe multiple sources without granting access to those sources automatically.

### One solution path

Use the native Context UI and the supplied automation brief. Register exactly the three clean workshop sources. Review the generated Index/Table Metadata automation and run it. If it generates metadata for only one source, configure the remaining sources' automations into the same AI Index. Do not create a raw index and claim native completion.

Inspect source coverage, business definitions, limitations, and verified example queries. The provided field relationships and `_meta.description` values are intended to improve generation quality. Capture a validated native automation export before delivery; this draft contains a generation brief, not an importable tested YAML workflow.

Set `ELASTIC_AI_INDEX_ID`. Use native `_describe` to obtain the actual destination/fields and the native `_query` API to inspect KIs. An appropriate inspection query, **only after replacing the destination/fields from the actual description**, has this shape:

```esql
FROM <actual_destination>
| KEEP title, description, content, type
| LIMIT 5
```

For question-based retrieval, use the supported semantic/text fields and named parameters. Do not assume current schemas match the older blog notebook.

Inspect native context MCP tools using the Optimus key and record the context tool names and the MCP endpoint URL. Students carry that URL into Challenge 03.

### External integration release gate

Native Context Engine APIs and Elastic Agent Builder assignment are documented, but this draft does not prove the dedicated tools are available through the external MCP endpoint. If absent, investigate a native API-backed custom tool as a future authoring change. Do not conceal this gap with a local tool, ordinary index, or different agent harness.

### Progressive hints

- Empty KIs: installing an automation is not running it. Inspect execution status and generation/provider access.
- Poor routing: inspect source descriptions and KI accuracy rather than endlessly lengthening the agent prompt.
- Cannot find the MCP URL: it is printed at the end of the notebook; otherwise use Agent Builder in Kibana.

See [native retrieval](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/retrieve-context-from-ai-index) and [agent configuration guidance](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/use-context-engine-with-agents).
