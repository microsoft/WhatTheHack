# Challenge 03 - Extending GitHub Copilot with Model Context Protocol - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

This challenge introduces students to the Model Context Protocol (MCP), a powerful way to extend GitHub Copilot beyond its default capabilities by connecting it to external data sources and tools.

### Key Concepts to Explain Before the Challenge

**Model Context Protocol (MCP):**
- MCP is an open protocol that allows GitHub Copilot to connect to external data sources and tools
- Think of it as a way to give Copilot access to information beyond the code in the workspace
- MCP servers act as bridges between Copilot and external context sources (APIs, databases, documentation, etc.)
- This is particularly valuable for providing domain-specific knowledge or organization-specific context
- Unlike IDE-level customization (covered in Challenge 04), MCP is about accessing external resources

**Authentication Best Practices:**
- **OAuth is recommended** for GitHub MCP server - provides secure, seamless authentication
- OAuth allows users to authorize without exposing long-lived tokens
- Personal Access Tokens (PATs) are an alternative but require manual token management and rotation
- Students should configure GitHub MCP using OAuth for better security and user experience

### Setting Up MCP Servers

Students will need to configure an MCP server. Here are recommended starting points:

**Easy MCP Servers to Start With:**
1. **GitHub MCP Server**: Provides access to GitHub repositories, issues, PRs (recommended for this challenge)
2. **Filesystem Server**: Provides file system access beyond the workspace
3. **Fetch Server**: Allows Copilot to fetch content from URLs
4. **SQLite Server**: Connects to local SQLite databases

**Configuration Location:**
- VS Code: Settings → Extensions → GitHub Copilot → Model Context Protocol
- Or manually edit `settings.json` with MCP server configurations

**Example MCP Server Configuration with OAuth (Recommended):**
```json
{
  "github.copilot.chat.mcp.enabled": true,
  "github.copilot.chat.mcp.servers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
      // OAuth authentication will be handled automatically via VS Code
      // No need to manually provide tokens
    },
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

**Alternative: Personal Access Token (Not Recommended):**
If OAuth is not available, students can use a PAT, but this requires manual token management:
```json
{
  "github.copilot.chat.mcp.servers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxx"
      }
    }
  }
}
```

### GitHub Repository Setup

For this challenge, students should:
- Create a GitHub repository for their Whack-a-Mole project (or use existing)
- Add at least 5 sample issues with different labels (e.g., "bug," "enhancement," "documentation," "question," "good first issue")
- Optionally add pull requests, project boards, or milestones to practice more MCP queries

This setup provides realistic data for students to query via MCP.

### Common Blockers and Solutions

**Blocker 1: MCP Server Not Connecting**
- Ensure Node.js is installed (MCP servers often use npx)
- Check that the MCP server path is correct
- Verify the MCP feature is enabled in Copilot settings
- Look at VS Code's Output panel → GitHub Copilot Chat for error messages

**Blocker 2: OAuth Authentication Issues**
- GitHub MCP server should use OAuth authentication (recommended approach)
- When first using GitHub MCP, VS Code will prompt to authorize via OAuth
- If OAuth prompt doesn't appear, check that GitHub Copilot extension is up to date
- If students must use PAT (not recommended), ensure token has scopes: `repo`, `read:org`, `read:user`
- Generate PAT at: https://github.com/settings/tokens (only if OAuth fails)
- **Emphasize OAuth is the preferred and more secure approach**

**Blocker 3: Understanding Which Chat Mode to Use**
- MCP works with Copilot Chat - students can ask questions in natural language
- Example queries: "List all open issues in my repo," "What are the recent PRs?"
- Can use @workspace for multi-file context or editor mode for focused queries
- Remind students to experiment - MCP responses may take slightly longer

**Blocker 4: No Obvious Use Case for MCP**
- Suggest practical scenarios:
  - Connecting to API documentation for libraries they're using
  - Accessing database schemas
  - Reading from configuration files outside the workspace
  - Fetching example code from GitHub gist or documentation sites

### Success Criteria Validation

**MCP Server Working:**
- Student can show Copilot accessing external context via MCP
- For GitHub MCP: ask Copilot to list issues, check PR status, or query repository information
- **Verify OAuth authentication** - student should NOT have GITHUB_PERSONAL_ACCESS_TOKEN in settings.json
- Student can explain why OAuth is preferred (security, no token management, automatic refresh)
- For fetch server: ask Copilot to fetch and summarize content from a URL
- For filesystem: demonstrate accessing files outside the workspace
- Check VS Code settings show configured MCP servers

**GitHub Repository Setup:**
- Repository exists with Whack-a-Mole code pushed to GitHub
- At least 5 issues created with varied labels
- Student can demonstrate querying this data via Copilot with MCP

**MCP Queries:**
- Student successfully uses Copilot to query external data
- Example: "What are all the bug issues in my repo?"
- Example: "Show me the most recently updated pull request"
- Demonstrates understanding of how MCP extends Copilot's reach

**Understanding MCP:**
- Student can explain what MCP does and why it's useful
- Understands difference between local workspace context and external MCP context
- Can articulate when MCP adds value vs when it's unnecessary

### Advanced Challenge Guidance

**Custom MCP Server:**
- Point students to the MCP SDK documentation
- A simple custom server could provide game configuration data
- Could create an MCP server that serves game tips or achievement data

**Multiple MCP Servers:**
- Students can configure several servers simultaneously
- Example: GitHub + filesystem + fetch
- Copilot will use whichever is relevant to the question

**Custom MCP Servers:**
- Point students to the MCP SDK documentation for building their own
- A simple custom server could provide game configuration data
- Could create an MCP server that serves game tips or achievement data

**Enterprise Use Cases:**
- For enterprise scenarios, build MCP server serving company docs
- Could connect to Confluence, internal wikis, or API documentation
- Makes Copilot aware of organization-specific patterns and data

### Estimated Time

This challenge typically takes 45 minutes:
- 15 minutes: Understanding MCP concepts and configuration
- 15 minutes: Setting up GitHub repository with issues and MCP server
- 15 minutes: Testing MCP queries and understanding capabilities

### Tips to Share If Teams Are Stuck

- Start with the GitHub MCP server since it aligns with the challenge requirements
- **Use OAuth authentication** - don't configure with PAT tokens unless OAuth is unavailable
- When configuring GitHub MCP, VS Code should prompt for OAuth authorization on first use
- Create diverse issues (bugs, features, questions) to make MCP queries interesting
- Use descriptive labels and titles for issues to practice filtering queries
- MCP is most valuable when you have external data or APIs to connect
- The Resources.zip may contain example MCP configurations to get started quickly
- If MCP setup is problematic, focus on understanding concepts and trying simpler servers (fetch)

### Reference Links

- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [GitHub MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/github)
- [MCP Servers Repository](https://github.com/modelcontextprotocol/servers)
- [GitHub Copilot Chat Documentation](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide)
