# Challenge 03 - Extending GitHub Copilot with Model Context Protocol

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction
GitHub Copilot is a powerful coding assistant, but what if you could make it even smarter by connecting it to external tools, databases, or APIs? This challenge introduces you to the Model Context Protocol (MCP), which allows you to extend Copilot's capabilities by integrating both custom context sources and tools. 

## Description

The Model Context Protocol (MCP) allows GitHub Copilot to connect to external tools and data sources, giving it access to live context beyond your local codebase. In this challenge, you will use MCP to connect Copilot to GitHub and apply it to your Whack-a-Mole project.

You will:

- **Create a GitHub Repository**  
  Create a new GitHub repository for your Whack-a-Mole game and push your existing code.

- **Populate GitHub Context**  
  Create sample GitHub Issues and labels that represent planned features or improvements to the game.

- **Configure the GitHub MCP Server**  
  Configure and connect the GitHub MCP server using OAuth so Copilot can securely access repositories, issues, labels, and pull requests.

- **Use MCP in Copilot Chat**  
  Use Copilot Chat with MCP enabled to interact with your GitHub repository and its data.

## Success Criteria
You will have successfully completed this challenge when you:

- Verify that your Whack-a-Mole project is stored in a GitHub repository
- Show multiple GitHub Issues with labels that represent planned work for the project
- Demonstrate a working GitHub MCP server connection authenticated using OAuth
- Demonstrate Copilot Chat interacting with your GitHub repository using MCP

## Learning Resources
- [Customizing GitHub Copilot](https://docs.github.com/en/copilot/customizing-copilot)
- [GitHub MCP Server](https://github.com/github/github-mcp-server)
- [MCP Registry](https://github.com/mcp)
- [VS Code Chat Modes and Custom Agents](https://code.visualstudio.com/docs/copilot/copilot-chat)




