# Challenge 01 - Connect Foundry Agent to Elastic - Coach's Guide

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

Explain discovery versus retrieval before discussing tokens. A competent baseline might answer efficiently already. The workshop compares architecture, not an intentionally wasteful prompt.

### One solution path

In the student's configuration cell, one appropriate selection is `selected_tools = tool_names('baseline')` after inspecting each advertised schema and verifying the `.env` entries identify list-indices, mapping, and ES|QL tools. Use the baseline connection, never the setup credential.

The supplied `base_prompt()` scopes exact source names, caps retrieval results, requests record IDs, and acknowledges unknown facts. The notebook creates a Foundry prompt-agent version and invokes it through the Responses API. It uses an API-safe `Agent-Mole-<workshop>` name.

Run the common questions in fresh conversations and keep the exported evidence. Let the model choose normal discovery; do not add instructions to inspect every mapping.

### Answer anchors

The complete reference is in `Solutions/expected-answers.json`. Useful anchors are Gold support for Lumen Bikes, 5000 records per export batch, TK-201 open with a reduce-batch-size workaround, and the Gold one-business-hour initial-response target. The invoice amount is unavailable.

Ask students to point to an actual MCP result containing a supporting record, not only a final answer or local Elasticsearch query. A service error or guessed answer does not establish retrieval.

### Progressive hints

- No tools used: inspect the agent's selected tools and instructions, then ask a source-dependent question.
- Tool not found: wire names can differ from Elastic internal dotted IDs. Use `tools/list`.
- Unsupported ES|QL: inspect the actual mapping and use the language reference; do not hide errors behind a plausible answer.
- No invoice data: the expected outcome is an explanation of the boundary, not a fabricated amount.

### Measurement interpretation

The helper captures all response objects, including approval continuations, and sums available usage once per response ID. Missing usage remains `None`, not zero. Inspect cache details and tool outputs. Source-query calls are not the same thing as model turns.

The elapsed measurement includes manual approvals. It must not be described as service-only latency. The measured scope excludes KI generation and any Elastic-side model work. Correctness and citations are checked manually by students/coaches, not inferred from a small token count.

Use the [Elastic built-in tool reference](https://www.elastic.co/docs/explore-analyze/ai-features/agent-builder/tools/builtin-tools-reference) for purpose/schema guidance.
