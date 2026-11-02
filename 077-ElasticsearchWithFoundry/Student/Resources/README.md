# Context Quest - Student Resources

> **Draft, not live-validated.** Do not treat these assets as a tested deployment or event-ready workshop. The native Context Engine MCP tools and indirect-attack evaluation mapping require organizer confirmation.

This directory is the root of the student resource package. Your coach supplies it as a resource-only Codespaces workspace or Resources.zip. Follow the published student challenge guide supplied by your coach; this package contains no coach answers.

## Workspace

The `.devcontainer` installs Python, Azure CLI, and Jupyter support. Its configuration assumes **this directory's contents are at the workspace root**. A coach must publish the resource package separately; opening an arbitrary Codespace at the full content repository root does not activate this nested configuration.

For an equivalent local environment, use Python 3.12, install `requirements.txt`, and select that interpreter in Jupyter. Dependencies are draft constraints, not a proven compatibility lock.

## Notebooks

| Notebook | Purpose |
|---|---|
| `00-Setup.ipynb` | Configure your environments, opt into provisioning, seed data, and record readiness. |
| `01-Agent-Mole.ipynb` | Configure a baseline Foundry agent and collect live discovery evidence. |
| `02-Context-Engine.ipynb` | Build the AI Index and KIs, and retrieve the Context Engine MCP endpoint. |
| `04-Evaluate.ipynb` | Retrieve isolated safety fixtures and submit a proposed Foundry evaluation. |
| `99-Cleanup.ipynb` | Review resource ownership and explicitly clean up your workshop. |

Run each notebook from its own beginning. It loads its own configuration, so kernels do not need to share state. Student decision cells are intentionally incomplete; learning means choosing and explaining the configuration, not running every cell unchanged.

## Configuration and credentials

Copy `.env.sample` to `.env` and enter values locally. The sample lists the required inputs. `.env`, notebook checkpoints, and generated `outputs/` are ignored by Git. Restrict local file permissions, for example `chmod 600 .env`. Do not store keys in notebook cells or retain credential-bearing outputs.

Use `az login` and select the intended enabled subscription. Notebooks use `AzureCliCredential` to make this login explicit. The draft provisioning script uses the same selected subscription. Attach an existing Foundry project/model by setting its endpoint and deployment name, or deliberately run the create-new path from the setup notebook.

Elastic setup and agent credentials serve different purposes:

| Credential | Intended scope |
|---|---|
| Setup API key | Create/write only workshop-owned source indices; configure native Context Engine and automations in the intended space. |
| Baseline runtime key | Read and view metadata for the three workshop sources, plus the safety fixture index after activation; use relevant read-only MCP tools. No AI Index read access. |
| Optimus runtime key | Same source permissions, plus Context Engine read privilege and read/metadata access on the exact AI Index backing data. |

Avoid wildcard privileges over an existing project. A Foundry tool allowlist is not a database authorization boundary; enforce scope with Elastic credentials. Serverless role configuration may differ from hosted Stack examples.

Store the runtime keys in **two Foundry remote MCP project connections** targeting the same Elastic endpoint. Use key-based authentication with header name `Authorization` and value `ApiKey <encoded-key>`. Only project users permitted to access these shared credentials should have access to the project. Never put the setup key in either connection.

The MCP URL is `<Kibana base>/api/agent_builder/mcp`, or `<Kibana base>/s/<space>/api/agent_builder/mcp` for a non-default space. Foundry must reach that URL directly. Local `tools/list` is a useful check, not proof that the Foundry service can connect.

Use the notebook's tool discovery to copy exact wire names into `.env`. The baseline uses list-indices, mapping, and ES|QL tools. Optimus additionally needs native context retrieval tools; their external MCP exposure is **not yet confirmed**. Do not grant write or workflow-execution tools to the support agents.

## Resource layout

- `data/`: original, fictional support records and questions; no external downloads.
- `elastic/`: native AI Index source/automation brief and permissions guidance.
- `infra/`: minimal draft Foundry Bicep and explicit create-new provisioning script.
- `workshop.py`: shared configuration, idempotent seeding, MCP discovery, tracing, and local evidence helpers. Agent definitions and evaluator configuration remain visible in notebooks.
- `outputs/`: generated local evidence, never fabricated sample measurements.

Restart-safe checkpoints are configuration, the owned source indices, and exported runs. Inflight response captures are retained if an approval or tool call fails; they are not completed runs. The safety helper requires structured `record_id` and `body` fields in an actual MCP result, not an ID echoed in a query. If the service's output envelope differs, inspect and adapt the parser during author validation rather than weakening that check.

If a service is unavailable, record the blocker and discuss the relevant concepts; do not report live completion from imagined or recorded results.

## Costs and cleanup

Signup, model availability, native-feature access, and free credits are not guaranteed. Inference, KI creation/refresh, Azure resources, and Codespaces can incur charges. KI generation cost is separate from agent answer cost.

Use only bundled synthetic data. Foundry receives source text from Elastic; understand that data flow before connecting other data. Approve only expected read-only calls. Notebook outputs and model responses can contain source text even when API keys are not printed.

Use the cleanup notebook to review exact resource ownership. Remove Foundry agents, responses/conversations, evaluations/datasets, MCP connections, AI Index/workflows, and the dedicated Azure resource group as appropriate. Revoke workshop API keys and stop/delete the Codespace. Deleting indices alone does not stop all charges.

## Learning resources

- [Native Context Engine quickstart](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/quickstart)
- [Elastic MCP authentication](https://www.elastic.co/docs/explore-analyze/ai-features/agent-builder/mcp-server)
- [Foundry MCP connection authentication](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/mcp-authentication)
- [Foundry dataset evaluations](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/cloud-evaluation-datasets)
