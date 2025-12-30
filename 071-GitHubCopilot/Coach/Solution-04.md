# Challenge 04 - Customizing GitHub Copilot in Your IDE - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

This challenge shifts focus from extending Copilot with external tools (MCP) to personalizing Copilot within the IDE itself through custom agent instructions and chat modes. This allows teams and individuals to enforce coding standards and create specialized development workflows.

### Key Concepts to Explain Before the Challenge

**Custom Agent Instructions:**
- Located in `.github/copilot-instructions.md` in the repository root
- Apply to all Copilot interactions within that workspace
- Can specify coding standards, preferred patterns, project context, and best practices
- Instructions should be clear and actionable, with examples where helpful
- Take effect immediately when file is created or modified

**Chat Modes:**
- Custom chat modes are defined in `.github/chatmodes/` directory
- Each mode is a `.chatmode.md` file with YAML frontmatter
- Allows creation of role-specific assistants (e.g., "performance reviewer," "security auditor")
- Can include specialized system prompts, restricted tools, and custom personalities
- Useful for guiding Copilot toward specific development focuses

**Key Differences:**
- **Agent Instructions**: Global guidelines for all Copilot interactions in the workspace
- **Chat Modes**: Optional, specialized modes for specific tasks or roles
- Both can be used together for comprehensive customization

### Setting Up Agent Instructions

**File Structure:**
```
.github/
├── copilot-instructions.md
└── chatmodes/
    └── my-custom-mode.chatmode.md
```

**Example Agent Instructions Content:**
```markdown
# Project Guidelines for GitHub Copilot

## Coding Standards
- Use ES6+ syntax exclusively
- Prefer functional components over class components (React)
- Use TypeScript for type safety
- Follow camelCase for variables and functions

## Project Context
- This is a Whack-a-Mole game built with [your tech stack]
- Game state management: [describe approach]
- Performance is critical; optimize render operations

## Best Practices
- Always include error handling
- Add descriptive comments for complex logic
- Write tests for new features
```

### Building a Custom Chat Mode

**File Format (.chatmode.md):**
```yaml
---
name: "Security Auditor"
description: "Review code for security vulnerabilities and best practices"
---

You are a security-focused code reviewer. When examining code, prioritize:
- OWASP Top 10 vulnerabilities
- Input validation and sanitization
- Authentication and authorization checks
- Data protection and encryption
```

### Common Blockers and Solutions

**Blocker 1: Agent Instructions Not Taking Effect**
- File must be at `.github/copilot-instructions.md` exactly
- Requires VS Code restart or window reload to take effect
- Check that Copilot extension recognizes the workspace
- Verify no syntax errors in the markdown file

**Blocker 2: Unclear What to Put in Instructions**
- Start with 3-5 key principles specific to their project
- Avoid being overly prescriptive
- Use positive language ("prefer X") vs negative ("don't use Y")
- Include concrete examples when helpful

**Blocker 3: Chat Mode Not Showing Up**
- File must be in `.github/chatmodes/` with `.chatmode.md` extension
- Verify YAML frontmatter is correctly formatted
- May require Copilot extension update to support chat modes
- Check VS Code version compatibility

**Blocker 4: Difficulty Testing Instructions**
- Have students ask Copilot to generate code and review results
- Ask Copilot "What guidelines should I follow for this project?" to verify it read instructions
- Test against different code patterns to see if instructions are applied consistently

### Success Criteria Validation

**Custom Instructions File:**
- Student can show `.github/copilot-instructions.md` in their repository
- Instructions are clear, project-specific, and actionable
- Cover at least 3 areas (coding standards, project context, best practices)

**Custom Chat Mode:**
- Student can demonstrate the custom chat mode in action
- Mode file exists in `.github/chatmodes/` with proper formatting
- Mode has a clear purpose and use case for their project

**Evidence of Following Instructions:**
- Generate code with Copilot and show that it follows the guidelines
- Ask Copilot to review itself: "Does this follow the project guidelines?"
- Show before/after comparison (general Copilot vs with custom instructions)

**Understanding Concepts:**
- Student can explain when to use agent instructions vs chat modes
- Understands that instructions apply globally, chat modes are opt-in
- Recognizes the value of standardizing Copilot behavior across teams

### Time Estimate
- 30-45 minutes
- More if students want to create multiple chat modes or complex instructions

### Discussion Points

- **Team Standardization**: How custom instructions help teams work consistently with Copilot
- **Workflow Optimization**: Different chat modes for different development phases (feature dev vs bug fix)
- **Documentation**: Custom instructions serve as living documentation of development standards
- **Evolution**: Instructions should be revisited and updated as project evolves
