# Challenge 04 - Session Configuration (Tools + Cache) - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

This challenge teaches students that MCP tools add token overhead on every request, and that configuration changes can invalidate cached context. The TypeScript repository scan scenario provides a simple, measurable task to observe these effects.

### Key Concepts to Explain

**MCP Tool Overhead:**
- Each MCP tool's definition (name, description, parameter schema) is included in the system prompt
- This overhead applies to every LLM request, even if the tool is never invoked
- The GitHub MCP server typically enables 6-8 tools by default
- For the repository scan task, students likely only need `search_code` and `get_file_contents`
- Unused tools like `create_issue`, `search_users`, `list_pull_requests` add unnecessary overhead

**Cache Invalidation:**
- GitHub Copilot CLI uses Anthropic Claude models with prompt caching
- Cache invalidation occurs when the system prompt changes (e.g., tool definitions, instructions)
- Common triggers: toggling MCP tools, editing `.github/copilot-instructions.md`, switching models
- Clean sessions maintain stable configuration = higher cache reuse = lower costs
- Messy sessions with mid-task changes = cache invalidation = reprocessing overhead

**Important Note on Documentation:**
GitHub's official documentation doesn't explicitly list cache invalidation triggers. Students discover these through experimentation by observing credit spikes after configuration changes. The underlying Anthropic prompt caching technology invalidates cache when the prompt prefix changes.

### The Scenario

Students use GitHub Copilot CLI to scan `microsoft/TypeScript` repository:
- Find all `package.json` files
- Find all `tsconfig.json` files
- Read main package.json for dependencies
- Generate a formatted report

This is a multi-turn task (5-10 agent steps) that provides multiple measurement opportunities.

### Expected Time

60 minutes:
- 15 minutes: Complete initial scan with all tools, record baseline
- 10 minutes: Identify unused tools via VS Code Output panel
- 15 minutes: Disable unused tools, repeat scan, measure savings
- 15 minutes: Clean vs. messy session comparison
- 5 minutes: Document findings

### Expected Measurements

**Tool Overhead Savings:**
- Baseline: 6-8 GitHub MCP tools enabled
- Optimized: 2 tools enabled (search_code, get_file_contents)
- Removed: 4-6 unused tools
- Each unused tool: ~100-300 tokens per agent step
- Scan task: ~5-10 agent steps
- **Expected savings: 2,000-15,000 tokens (20-150 credits)**

Actual savings vary based on:
- Model selected (Sonnet vs Haiku have different base costs)
- Number of tools initially enabled
- Complexity of tool schemas
- Number of agent steps taken

**Cache Invalidation Impact:**
- Clean session: Configure once, complete scan = stable cache
- Messy session: Toggle tool mid-scan + edit instructions = cache invalidations
- **Expected difference: 10-30% higher cost for messy session**

The difference may be subtle since the scan task is relatively short. Longer tasks show more dramatic cache invalidation penalties.

### Common Blockers

**Students Can't Find MCP Tool Configuration:**
- MCP servers are configured in Copilot CLI settings (platform-specific)
- On macOS/Linux: `~/.copilot/mcp.json` or via CLI settings
- On Windows: `%USERPROFILE%\.copilot\mcp.json`
- Students can also use `copilot mcp` command to manage servers

**Students Don't See Tool Invocations:**
- VS Code Output panel: View → Output → select "GitHub Copilot" from dropdown
- Tool calls appear as JSON-RPC messages showing tool name and parameters
- If no tools appear, they may not have GitHub MCP server configured
- Provide example output so they know what to look for

**Students Can't Measure Credits Accurately:**
- Use `/usage` command after each task to see credit breakdown
- GitHub Copilot usage dashboard shows cumulative spend (may be delayed)
- Encourage students to record: task name, timestamp, credits used
- Focus on relative differences (before/after) rather than absolute numbers

**Cache Invalidation Effects Are Subtle:**
- Short tasks may not show dramatic differences
- Encourage students to make obvious changes: toggle multiple tools, edit instructions significantly
- Credit spikes may be small (10-30%) but still measurable
- The learning goal is awareness of the pattern, not hitting specific numbers

### Hints to Share

**If students struggle to identify unused tools:**
- "Look for tools that never appear in the Output panel during your scan"
- "Ask yourself: did I create any issues? Did I search for users? If no, you don't need those tools"
- "For a read-only repository scan, you only need search and read tools"

**If students can't see cache invalidation effects:**
- "Try making more dramatic changes mid-session—edit instructions significantly, toggle 2-3 tools"
- "The effect is more visible on longer tasks; your short scan may show smaller differences"
- "Focus on observing the pattern, not hitting a specific percentage"

**If students question why this matters:**
- "In production, developers run hundreds of Copilot interactions per day"
- "Small per-request overhead × hundreds of requests = significant monthly cost"
- "Clean session hygiene is like good Git hygiene—prevents accumulated waste"

### Technical Deep Dive (If Asked)

**How MCP Tools Add Overhead:**

From the Model Context Protocol specification, each tool includes:
```json
{
  "name": "get_weather",
  "description": "Get current weather information for a location",
  "inputSchema": {
    "type": "object",
    "properties": {
      "location": {
        "type": "string",
        "description": "City name or zip code"
      }
    },
    "required": ["location"]
  }
}
```

This full schema is sent to the LLM on every request so the model knows:
- What tools are available
- What each tool does
- How to call them correctly

A simple tool uses ~100-150 tokens; complex tools with many parameters use 300-500+ tokens.

**Why Cache Invalidation Happens:**

GitHub Copilot CLI uses Anthropic Claude models. Anthropic's prompt caching works by caching the "prompt prefix" (system instructions + tool definitions + conversation history up to a cache marker).

If anything in that prefix changes—even one token—the cache is invalidated and must be rebuilt. This means:
- Toggling a tool → system prompt changes → cache invalidated
- Editing instructions → system prompt changes → cache invalidated
- Switching models → different model has its own cache space

Reference: [Anthropic Prompt Caching](https://claude.com/blog/prompt-caching)

### Success Criteria Validation

Students successfully complete when they can show:

1. ✅ **Tool audit documentation:**
   - Screenshot or text output showing enabled tools before optimization
   - Evidence of which tools were actually invoked (VS Code Output panel)
   - Screenshot showing reduced tool list after optimization

2. ✅ **Measurable savings:**
   - Credit spend for baseline scan (all tools enabled)
   - Credit spend for optimized scan (unused tools disabled)
   - Calculated savings (even if small)

3. ✅ **Cache invalidation observation:**
   - Credit spend for clean session
   - Credit spend for messy session
   - Description of which changes they made mid-session
   - Observation that messy session cost more

4. ✅ **Learning articulation:**
   - Can explain why unused tools cost tokens
   - Can name at least 2-3 configuration changes that invalidate cache
   - Understands that stable configuration = better cache reuse

### Extension Challenges

For teams that finish early:

**Advanced Tool Audit:**
- Configure 3-4 different MCP servers (GitHub, filesystem, HTTP, database)
- Complete a task using only one server
- Measure overhead from all the extra unused servers

**Model Comparison:**
- Complete the scan with Sonnet (all tools) vs Haiku (minimal tools)
- Observe that cheaper model + clean config can beat expensive model + bloated config

**Long Session Test:**
- Use Copilot CLI for 30+ minutes of varied tasks
- Observe compaction behavior when context window fills (~80% capacity)
- Measure whether frequent configuration changes trigger more compaction

### Additional Resources for Students

Share after they complete the challenge:

- [Managing Context in GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management) - Official docs on context window and compaction
- [MCP Tools Specification](https://modelcontextprotocol.io/specification/2025-06-18/server/tools.md) - Details on what's included in tool schemas
- Research report saved during hack preparation with detailed citations and technical validation
