# Challenge 04 - Deploy a Hosted Weather Agent - Coach's Guide

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

Students will complete a Jupyter notebook (`CH-04-HostedAgents.ipynb`) that walks them through building a hosted weather agent. The notebook has 10 blanks to fill in across 7 parts. The solution notebook is in `Coach/Solutions/CH-04-HostedAgents-Solution.ipynb`.

### What Students Are Learning

The core lesson is the difference between prompt-based agents (Challenges 01-03) and hosted agents: prompt-based agents are configured through the SDK, while hosted agents are your own code in a container. Students should be able to articulate this distinction by the end.

The 10 blanks focus on:
- Tool function definition (typed parameters, return type, dict lookup)
- Agent instructions (writing a persona string)
- Deployment configuration (protocol, CPU, image URL, environment variables)
- Invocation (agent name, user query)

### Known Blockers

- **Import paths changed**: `HostedAgentDefinition` and `ProtocolVersionRecord` are in `azure.ai.projects.models`, NOT `azure.ai.agents.models`. If students search online they may find outdated examples.

- **container_protocol_versions, not protocol_versions**: The API requires `container_protocol_versions` for image-based agents. Using `protocol_versions` returns a validation error that says exactly this, so the error message is helpful.

- **allow_preview=True**: `AIProjectClient` requires `allow_preview=True` for hosted agent operations. The error message tells students this explicitly.

- **az acr build encoding error on Windows**: The `--no-logs` flag is already in the notebook to avoid Unicode charmap errors when streaming build logs on Windows. If students remove it, they may hit `UnicodeDecodeError`.

- **Repeated runs create new versions**: Each `create_version()` call creates a new version (v1, v2, v3...). The notebook has an idempotency guard using `list_versions()` that skips creation if an active version exists. If students want to force a fresh deploy, they can delete existing versions first.

- **Agent takes time to become active**: After `create_version()`, the agent status starts as `creating` and takes 30-60 seconds to become `active`. The polling cell handles this.

### Coaching Tips

- If a team is stuck on Part 1 (tool function), remind them that `Annotated[str, Field(description="...")]` is the pattern, and `WEATHER_DATA.get(key, default)` is standard Python dict lookup.

- If a team is stuck on Part 6 (deploy), the four blanks map directly to the `HostedAgentDefinition` constructor. Point them to the `AgentProtocol.RESPONSES` enum and the ACR image URL format `{acr_name}.azurecr.io/{image}:{tag}`.

- The `inspect.getsource()` assembly pattern in Part 3 may surprise students. Explain that it captures their function definition from the notebook kernel and writes it into the generated `main.py` file.

- Encourage students to read the generated `main.py` after Part 3 runs. Understanding how their tool function fits into the Agent Framework hosting stack is the key insight.

### Estimated Timing

| Part | Description | Time |
|------|-------------|------|
| Setup | Install + authenticate | 5 min |
| Part 1 | Define weather tool (3 blanks) | 10 min |
| Part 2 | Write instructions (1 blank) | 5 min |
| Part 3 | Assemble main.py | 5 min |
| Part 4 | Configure agent.yaml + Dockerfile | 5 min |
| Part 5 | Build container on ACR | 2-3 min (waiting) |
| Part 6 | Deploy via SDK (4 blanks) | 15 min |
| Part 7 | Invoke agent (2 blanks) | 10 min |
| **Total** | | **~60-90 min** |

Allow extra time for Azure auth issues, ACR permission problems, and general troubleshooting. Teams with less Azure experience may need 2-3 hours.
