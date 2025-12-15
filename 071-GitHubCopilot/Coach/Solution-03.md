# Challenge 03 - Extending GitHub Copilot with Model Context Protocol - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

This challenge introduces students to the Model Context Protocol (MCP), custom agent instructions, and chat modes - powerful ways to extend and customize GitHub Copilot beyond its default capabilities. This is a more advanced topic that builds on their foundational Copilot knowledge.

### Key Concepts to Explain Before the Challenge

**Model Context Protocol (MCP):**
- MCP is an open protocol that allows GitHub Copilot to connect to external data sources and tools
- Think of it as a way to give Copilot access to information beyond the code in the workspace
- MCP servers act as bridges between Copilot and external context sources (APIs, databases, documentation, etc.)
- This is particularly valuable for providing domain-specific knowledge or organization-specific context

**Custom Agent Instructions:**
- These are user-defined instructions that modify how GitHub Copilot behaves
- Can be used to enforce coding standards, specify preferred frameworks, or provide project context
- Persists across chat sessions within a workspace
- Located in `.github/copilot-instructions.md` or configured in VS Code settings

**Chat Modes:**
- **Workspace Mode (@workspace)**: Copilot has context of the entire workspace
- **Editor Mode**: Focused on the currently open file
- **Agent Mode**: Specialized agents for specific tasks (e.g., @terminal, @vscode)
- Each mode has different strengths for different scenarios

### Setting Up MCP Servers

Students will need to configure an MCP server. Here are recommended starting points:

**Easy MCP Servers to Start With:**
1. **Filesystem Server**: Provides file system access beyond the workspace
2. **Fetch Server**: Allows Copilot to fetch content from URLs
3. **SQLite Server**: Connects to local SQLite databases

**Configuration Location:**
- VS Code: Settings → Extensions → GitHub Copilot → Model Context Protocol
- Or manually edit `settings.json` with MCP server configurations

**Example MCP Server Configuration (settings.json):**
```json
{
  "github.copilot.chat.mcp.enabled": true,
  "github.copilot.chat.mcp.servers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/directory"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
```

### Custom Agent Instructions

Guide students to create `.github/copilot-instructions.md` in their project root:

**Example Instructions:**
```markdown
# Project Instructions for GitHub Copilot

This is a Whack-a-Mole game project built with HTML, CSS, and JavaScript.

## Coding Standards
- Use ES6+ JavaScript syntax
- Follow camelCase naming conventions
- Add JSDoc comments for all functions
- Prefer const over let, avoid var

## Project Context
- Game state is managed in gameState object
- All timing functions use milliseconds
- DOM manipulation should be vanilla JS (no jQuery)

## Preferences
- When suggesting code, include error handling
- Prioritize readability over brevity
- Add accessibility attributes to HTML elements
```

### Chat Mode Demonstrations

**Recommended: Demonstrate all chat modes at the end** - Some students may not be aware of all the different chat modes available. Going through each mode helps ensure everyone understands when to use each one.  In addition if you have experience with another MCP server like Azure MCP, feel free to demo.

Help students understand when to use each mode:

**@workspace Mode:**
- Use when the question relates to multiple files or the overall project structure
- Example: "How is the game state managed across different files?"
- Copilot will analyze all files in the workspace for context

**Editor Mode (default):**
- Use for file-specific questions or when adding code to the current file
- More focused and faster responses
- Example: "Add a function to increase difficulty"

**Agent Modes:**
- **@terminal**: For shell commands and terminal operations
- **@vscode**: For VS Code settings and configuration questions
- These are specialized for specific tools

### Common Blockers and Solutions

**Blocker 1: MCP Server Not Connecting**
- Ensure Node.js is installed (MCP servers often use npx)
- Check that the MCP server path is correct
- Verify the MCP feature is enabled in Copilot settings
- Look at VS Code's Output panel → GitHub Copilot Chat for error messages

**Blocker 2: Custom Instructions Not Taking Effect**
- Instructions must be in `.github/copilot-instructions.md`
- Restart VS Code or reload the window after creating the file
- Instructions work best when specific and actionable
- Test by asking Copilot about the project context

**Blocker 3: Understanding Which Chat Mode to Use**
- If stuck, students can just ask Copilot! "Should I use @workspace for this question?"
- Generally: specific file questions → editor mode, multi-file questions → @workspace
- Remind students they can experiment - switching modes is quick

**Blocker 4: No Obvious Use Case for MCP**
- Suggest practical scenarios:
  - Connecting to API documentation for libraries they're using
  - Accessing database schemas
  - Reading from configuration files outside the workspace
  - Fetching example code from GitHub gist or documentation sites

### Success Criteria Validation

**MCP Server Working:**
- Student can show Copilot accessing external context
- For fetch server: ask Copilot to fetch and summarize content from a URL
- For filesystem: demonstrate accessing files outside the workspace
- Check VS Code settings show configured MCP servers

**Custom Instructions:**
- Student can show the `.github/copilot-instructions.md` file
- Demonstrate that Copilot follows the instructions (e.g., coding style preferences)
- Test by asking Copilot to write a function and verify it follows the guidelines

**Chat Modes:**
- Student can explain the difference between @workspace and editor mode
- Show examples of when each would be most useful
- Demonstrate using at least one specialized agent (@terminal or @vscode)

**Practical Application:**
- Student used the enhanced Copilot setup to add a feature or solve a problem
- Can articulate how the external context helped
- Example: Used MCP to access documentation and implemented a feature based on it

### Advanced Challenge Guidance

**Custom MCP Server:**
- Point students to the MCP SDK documentation
- A simple custom server could provide game configuration data
- Could create an MCP server that serves game tips or achievement data

**Multiple MCP Servers:**
- Students can configure several servers simultaneously
- Example: filesystem + fetch + custom server
- Copilot will use whichever is relevant to the question

**Team Coding Standards:**
- Instructions can encode team preferences
- Include linting rules, naming conventions, architecture patterns
- This becomes a "team knowledge base" for Copilot

**Internal Documentation Server:**
- For enterprise scenarios, build MCP server serving company docs
- Could connect to Confluence, internal wikis, or API documentation
- Makes Copilot aware of organization-specific patterns

### Estimated Time

This challenge typically takes 45 minutes:
- 15 minutes: Understanding MCP and configuration
- 15 minutes: Setting up custom instructions and exploring chat modes
- 15 minutes: Applying to practical task

### Tips to Share If Teams Are Stuck

- Start simple with the fetch or filesystem server before building custom ones
- Custom instructions are powerful but need to be specific - vague instructions don't help much
- MCP is most valuable when you have domain-specific knowledge to inject
- Don't overthink chat modes - they're just different scopes of context
- The Resources.zip may contain example MCP configurations to get started quickly

### Reference Links

- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [MCP Servers Repository](https://github.com/modelcontextprotocol/servers)
- [GitHub Copilot Chat Documentation](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide)
- [Customizing Copilot](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
