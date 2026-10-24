# Challenge 08 - Getting Started with GitHub Copilot in the CLI - Coach's Guide

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)** - [Next Solution >](./Solution-09.md)

## Notes & Guidance

This challenge introduces students to the `gh copilot` CLI extension. It is intentionally exploratory—there is no single correct answer. The goal is to get students comfortable using natural language at the terminal and to help them understand how Copilot CLI fits into their day-to-day workflow.

### Key Concepts to Explain Before the Challenge

**GitHub Copilot CLI (`gh copilot`):**
- Distributed as a `gh` extension: `gh extension install github/gh-copilot`
- Two primary commands:
  - `gh copilot suggest` – generates a shell, `git`, or `gh` command from a plain-English description
  - `gh copilot explain` – explains what a given command does in plain English
- Copilot CLI supports an interactive **refine** flow that lets students iterate on a suggestion without re-typing the full prompt
- Requires GitHub CLI (`gh`) to be installed and authenticated

### Installation

Students must have:
1. [GitHub CLI](https://cli.github.com/) installed (`gh --version` to verify)
2. Authenticated via `gh auth login`
3. Extension installed: `gh extension install github/gh-copilot`
4. A GitHub Copilot subscription (Individual, Business, or Enterprise)

Common install issue: if `gh auth status` shows the user is authenticated but `gh copilot` returns a permissions error, they may need to refresh the token scope:
```bash
gh auth refresh -s read:user
```

### Guidance for `gh copilot explain`

Students should try a variety of command types. Example prompts and expected topics to discuss:

| Command | What students should notice |
|---|---|
| `git rebase -i HEAD~3` | Interactive rebase; squashing/editing commits |
| `find . -name "*.log" -mtime +7 -delete` | Deleting old log files; `-mtime` flag |
| `gh pr list --state open --label bug` | Listing PRs filtered by label via `gh` CLI |
| `awk '{print $1}' access.log \| sort \| uniq -c \| sort -rn \| head -10` | Top IP addresses in a log file |

Encourage students to pick commands from their own projects—real-world context makes the explanations more meaningful.

### Guidance for `gh copilot suggest`

Remind students to select the right command type at the interactive prompt (shell, git, or gh). If they are unsure, `shell` works as a safe default.

Example prompts and expected suggestions:

| Prompt | Expected suggestion (approximate) |
|---|---|
| "list all git branches sorted by last commit date" | `git branch --sort=-committerdate` |
| "create a GitHub issue titled 'Add dark mode' in my repo" | `gh issue create --title "Add dark mode" --body "..."` |
| "find all files larger than 10 MB in the current directory" | `find . -size +10M -type f` |
| "delete all local git branches that have been merged" | `git branch --merged \| grep -v main \| xargs git branch -d` |
| "show the last 5 commits with their author and date" | `git log --oneline --format="%h %an %ad %s" -5` |

### The Refine Flow

After Copilot returns a suggestion, the interactive prompt offers:
- **Copy command to clipboard** – pastes into the terminal
- **Explain command** – inline explanation
- **Revise command** – re-prompts with the original context; students can type corrections
- **Rate response** – optional feedback

Make sure students use **Revise** at least once so they experience iterative refinement.

### Common Issues

| Issue | Resolution |
|---|---|
| `gh copilot: command not found` | Run `gh extension install github/gh-copilot` |
| `Error: your token does not have the required scopes` | Run `gh auth refresh -s read:user` |
| Copilot returns generic or incorrect commands | Prompt is likely too vague—encourage students to add more context |
| Interactive prompt does not appear | Ensure terminal supports interactive mode; avoid piping stdout |

### Success Criteria Validation

- **Installation**: `gh copilot --version` should return a version string.
- **explain**: Student should show screenshots or live demo of at least three `explain` invocations with a brief verbal summary of each.
- **suggest**: Student should show five or more suggestions and demonstrate that they read and understood each before running it.
- **Refine**: Student should show the revised prompt and the updated suggestion side by side.
- **Reflection**: Accept any genuine scenario—this is a discussion, not a graded answer.

### Estimated Time

This challenge typically takes 30–45 minutes:
- 10 minutes: Installation and authentication
- 15 minutes: Exploring `explain` and `suggest`
- 10 minutes: Refining suggestions and reflection
