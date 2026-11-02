# What The Hack - Context Quest: Optimizing AI Agents with Microsoft Foundry and Elastic Context Engine - Coach Guide

**[Hack Home](../README.md)**

## Introduction

Coach students toward evidence, not a predetermined token-saving result. This workshop uses a fictional customer-support scenario to connect Microsoft Foundry with Elastic MCP, generate reusable context using native Context Engine, and evaluate prompt-injection resistance.

> **Authoring draft - no tests or live deployments have been run.** Do not schedule delivery on the assumption that a generic Elastic trial exposes native Context Engine or that the proposed MCP/evaluator contracts work unchanged. The author explicitly deferred testing for this pass.

The core targets the requested 2-3-hour event format through pre-event account readiness, provided plumbing, and a few student decisions. These are design targets, not pilot-measured completion times. Keep advanced tasks optional. There is no requirement to use the scaffold's unused lecture deck; slide authoring is outside this draft.

## Coach's Guides

- Challenge 00: **[Ready, Set, Connect](./Solution-00.md)**
  - Prepare your own environments and launch the supplied notebook workspace.
- Challenge 01: **[Connect Foundry Agent to Elastic](./Solution-01.md)**
  - Build a Foundry agent with Elastic MCP and collect a discovery baseline.
- Challenge 02: **[Build the Context Engine](./Solution-02.md)**
  - Create an AI Index and Knowledge Indicators, and retrieve the Context Engine MCP endpoint.
- Challenge 03: **[Rise of Agent Optimus](./Solution-03.md)**
  - Build a Foundry agent on the Context Engine and compare it with Agent Mole.

## Coach Prerequisites

Read the [What The Hack hosting guide](https://aka.ms/wthhost) and `.github/Agents/WTHAuthor.chatmode.md` in the authoring checkout. Challenges describe goals, not recipes. Keep answers out of student notebooks and ask students to explain their evidence before marking a challenge complete.

### Student Resources

Package only `Student/Resources` for students. The provided `package_resources.py` uses an explicit file allowlist and refuses notebooks with saved outputs. It has not been run or tested in this draft.

```bash
python Coach/package_resources.py --output /your/staging/directory/Resources.zip
```

Run that command from the hack directory. Publish the archive's contents at the root of an organizer-controlled **student-only** repository for Codespaces, or distribute the archive. That root must contain `.devcontainer`, `requirements.txt`, and `notebooks`. The nested config is not automatically activated by launching a generic Codespace at the full What The Hack root.

Give students the hosted student guide and resource-only Codespaces launch path, not links to the full WTH source repository or coach solutions. Source is public and determined attendees can find it; do not rely on obscurity. Share completed reference content after the event.

### Required pre-event readiness

- Students bring their own accounts. Confirm signup, enabled Azure subscription, appropriate quota/permissions, Codespaces availability, and native Elastic access before the event.
- The author must verify **trial entitlement**. If a trial lacks native Context Engine, revise Challenge 00 and event onboarding before delivery. Do not present an ordinary index as equivalent.
- Confirm one working region/model/service combination and provide it to students. The draft does not establish a tested default.
- Use separate expiring setup, baseline runtime, and Optimus runtime credentials. Keep data-plane authorization distinct from tool visibility.

### Release gates

| Gate | Current status | Required evidence before delivery |
|---|---|---|
| Native Context Engine in a representative trial | Unverified | AI Index registration, multiple sources, KI generation, and retrieval in the intended space. |
| KI automation export | Not supplied | Capture a native generated workflow/template export for the confirmed feature version; test its safe rerun behavior. |
| Native context tools through external Elastic MCP | Unverified | Actual advertised wire names and successful Foundry KI retrieval, not only an Elastic Agent Builder demo. |
| Foundry SDK and deployment assets | Untested | Resolve/pin compatible dependencies and prove deployment/attach, connection, and agent paths. |
| Indirect-attack evaluator | Unverified | Hosted precomputed-response evaluation with full tool-context messages; confirm that scores mean resistance rather than attack presence. |
| Codespaces package | Untested | A student-only package launches its root devcontainer and selects the intended kernel. |
| Measurement and event flow | Untested | Correct source-grounded answers, complete usage capture, recovery, cleanup, and a pilot within the target format. |

Do not "fix" a release blocker by suppressing errors. The proposed indirect-attack notebook is intentionally guarded until an author confirms its schema/target semantics. A custom rubric or local marker check would be a different implementation and must not silently replace the stated Foundry evaluator.

If native context tools are not externally exposed, investigate an Elastic-hosted custom tool wrapping native Context Engine APIs as a separate authoring change. The current draft does not include that adapter or claim it exists.

## Azure Requirements

The create-new template proposes a dedicated resource group, current-generation Foundry account/project, one model deployment, and role assignments. It deliberately does not copy the unrelated Azure AI Search, document processing, storage, or classic hub architecture from other hacks.

Students attaching existing resources need agent/evaluation permissions, a supported model, and connection-management access. Creating infrastructure and role assignments needs additional management-plane permissions. An administrator supplies the project role GUID rather than assuming an Azure ML role applies.

Verify evaluation-specific permissions and storage requirements for the chosen path. Public endpoints are the proposed core for synthetic data; enterprise private-network setups are not in scope. Document Azure, Elastic generation/inference, and Codespaces charges and cleanup.

## Suggested Hack Agenda

Use these coach-only facilitation budgets after accounts are ready. Adjust from pilot evidence; do not expose speed-based success criteria to students.

| Activity | Compact session | Extended session |
|---|---|---|
| Intro and learning goals | 10 minutes | 10 minutes |
| Challenge 00 | 15 minutes | 20 minutes |
| Challenge 01 | 20 minutes | 30 minutes |
| Challenge 02 | 20 minutes | 30 minutes |
| Challenge 03 | 20 minutes | 30 minutes |
| Challenge 04 | 30 minutes | 45 minutes |
| Evidence demos and optional extensions | 10 minutes | 20 minutes |
| Cleanup | 5 minutes | 10 minutes |
| Total | 120 minutes | 180 minutes |

For the compact format, use the core questions and postpone multi-source reasoning, KI refresh, and harmful-content screening. If account access fails, triage it rather than consuming the entire session on permissions.

## Facilitation and Recovery

The notebooks use predict, configure, observe, and explain sections. Each core challenge has only a few configuration decisions; setup scripts and trace formatting are provided. Full reference code stays in Coach resources.

Use local exported runs to resume a student's own work after a kernel restart. Re-running agent creation creates versions; it is not a reason to erase the student's source data. Never seed into an index that lacks matching ownership metadata.

Before delivery, record sanitized traces/reports from the real pilot as clearly labeled teaching checkpoints. **No such recordings or benchmark results are included in this draft.** During an outage, use conceptual discussion or an explicitly recorded demonstration. That does not prove the student's live objective.

Explain that manual approvals add human time to latency. Do not compare those durations as if they were pure service latency. Do not disable approvals until credentials, read-only tool allowlists, and the implications have been reviewed for the lab.

## Repository Contents

- `Student/Challenge-00.md` through `Challenge-04.md`: student goals, criteria, and resources.
- `Student/Resources`: resource-only notebook environment, synthetic data, helper code, and draft infrastructure.
- `Coach/Solution-00.md` through `Solution-04.md`: guidance and progressive hints.
- `Coach/Solutions/Reference.ipynb`: parameterized reference flow and proposed evaluation, not a tested golden run.
- `Coach/Solutions/expected-answers.json`: evidence anchors, never distributed in the student package.

## Research and Attribution

The structure follows the resource/notebook layout in the repository's OpenAI Fundamentals hack. The KI idea is informed by Elastic's walkthrough; this draft uses original synthetic data and does not copy its Deep Agents/OpenRouter harness or destructive index resets.

- [Elastic KI walkthrough](https://www.elastic.co/search-labs/blog/ai-index-building-context-agents)
- [Elastic companion notebook](https://github.com/elastic/elastic-labs/blob/main/supporting-blog-content/building-context-technical-walkthrough-part-1/index-metadata-kis.ipynb)
- [Native Context Engine quickstart](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/quickstart)
- [Foundry MCP integration](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/model-context-protocol)
- [Foundry evaluator scope and inputs](https://learn.microsoft.com/en-us/azure/foundry/concepts/evaluation-evaluators/risk-safety-evaluators)
- [Foundry precomputed-response evaluation](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/cloud-evaluation-datasets)
