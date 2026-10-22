# Challenge 04 - Session Configuration (Tools + Cache)

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

Every MCP tool and Skill you enable adds token overhead to every agent step. Each tool's name, description, and parameter schema are advertised to the model on every request—even if the tool is never invoked. A session with many unused tools burns credits before you've written a line of code.

Meanwhile, changing configuration mid-session can trigger cache invalidation, forcing expensive cold restarts where previously cached context must be reprocessed.

In this challenge, you'll measure the real cost of tool sprawl and observe how session hygiene affects your credit spend.

## Description

This challenge has two parts: measuring MCP tool overhead and observing cache invalidation behavior.

### Part 1: Measure MCP Tool and Skills Overhead

Use GitHub Copilot to scan/find something in the `microsoft/TypeScript` repository and report back.

If you don't have MCP servers enabled already, try the GitHub MCP server with all its tools. Complete the task with all tools enabled and record your credit spend.

Next, identify which MCP tools and skills were actually used.

Disable the unused tools and skills, repeat the scan, and measure the credit difference. Each unused tool adds token overhead on every agent step because its schema is included in the system prompt.

### Part 2: Observe Cache Invalidation

Complete the repository scan twice more under different conditions:

**Clean Session:** Configure your tools once, then complete the entire scan without making any configuration changes. Record total credits.

**Messy Session:** Start the scan, but mid-way through deliberately make configuration changes—disable a tool, edit your `.github/copilot-instructions.md` file, or switch to a different reasoning effort level. Finish the scan and record total credits.

Observe which configuration changes cause measurable credit spikes. These spikes indicate cache invalidation—when GitHub Copilot must reprocess previously cached context.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Show which MCP tools were enabled at the start
- Complete the TypeScript repository scan and generate a report with file paths and dependencies
- Identify which tools were actually invoked by examining VS Code Output panel logs
- Demonstrate measurable credit savings from disabling unused tools on the same scan task
- Show comparative credit costs between clean session and messy session approaches
- Explain which configuration changes you observed causing cache invalidation
- Document your findings: tool count before/after, credits before/after, credit difference between clean/messy sessions

## Learning Resources

- [Managing Context in GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management)
- [Model Context Protocol Tools Specification](https://modelcontextprotocol.io/specification/2025-06-18/server/tools.md)
- [Anthropic Prompt Caching](https://claude.com/blog/prompt-caching)
- [GitHub Copilot Usage-Based Billing](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-organizations-and-enterprises)

## Tips

- The VS Code Output panel (View → Output → "GitHub Copilot") shows actual tool invocations
- Each MCP tool's schema (name, description, parameters) is sent to the model on every request
- System prompt changes (like editing instruction files or toggling tools) can invalidate cached context
- The GitHub MCP server typically includes tools like: search_code, get_file_contents, create_issue, search_users, list_pull_requests
- For this scanning task, you likely only need search_code and get_file_contents
