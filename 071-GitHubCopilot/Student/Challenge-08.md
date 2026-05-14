# Challenge 08 - Getting Started with GitHub Copilot in the CLI

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-09.md)

## Introduction

GitHub Copilot is not limited to your IDE. With the **GitHub Copilot CLI** extension (`gh copilot`), you can bring the power of Copilot directly into your terminal. Whether you need to recall the exact syntax for a complex command, understand what an unfamiliar shell script does, or generate commands from natural language, Copilot CLI has you covered.

In this challenge, you will install the `gh copilot` extension and explore its two core commands:
- `gh copilot suggest` – generate shell, `git`, or `gh` commands from a plain-English description
- `gh copilot explain` – get a plain-English explanation of any command

## Description

### Step 1 – Install the GitHub Copilot CLI Extension

The Copilot CLI extension is distributed as a GitHub CLI (`gh`) extension. Make sure the [GitHub CLI](https://cli.github.com/) is installed and that you are authenticated, then run:

```bash
gh extension install github/gh-copilot
```

Verify the installation:

```bash
gh copilot --version
```

### Step 2 – Explore `gh copilot explain`

Pick a shell command you find confusing or have never used before and ask Copilot to explain it. For example:

```bash
gh copilot explain "git rebase -i HEAD~3"
```

Try at least **three** different commands across different categories (e.g., `git`, Linux shell, `gh` CLI).

### Step 3 – Explore `gh copilot suggest`

Use natural language to ask Copilot to generate a command for you. For example:

```bash
gh copilot suggest "list all git branches sorted by the date of their last commit"
```

Experiment with at least **five** different requests, covering:
- A `git` operation
- A `gh` CLI operation (e.g., creating an issue, cloning a repo)
- A generic shell operation (e.g., file manipulation, process management)
- A multi-step task that results in a script or pipeline

### Step 4 – Refine and Revise

After Copilot provides a suggestion, explore the **refine** option that lets you iterate on the suggestion. Modify your request and observe how the output changes.

## Success Criteria

You will have successfully completed this challenge when you:

- Demonstrate that `gh copilot` is installed and accessible from the terminal
- Show `gh copilot explain` output for at least three different commands and describe what Copilot told you
- Show `gh copilot suggest` output for at least five different natural-language requests
- Demonstrate using the **refine** option to improve or adjust a suggestion
- Explain a scenario from your own day-to-day work where `gh copilot suggest` or `gh copilot explain` would save you time

## Learning Resources

- [GitHub Copilot in the CLI Documentation](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)

## Tips

- If Copilot's first suggestion is not quite right, use the **refine** option instead of starting over—iterative refinement often yields better results than a single detailed prompt.
- You can alias `gh copilot suggest` and `gh copilot explain` to shorter commands in your shell profile to speed up your workflow.
- Try asking Copilot CLI to explain commands from scripts you have inherited—it is a great way to onboard onto unfamiliar codebases.

## Advanced Challenges (Optional)

- Configure shell aliases so that `??` runs `gh copilot suggest` and `git?` runs `gh copilot explain "git ..."` for a faster CLI workflow.
- Ask Copilot CLI to help you write a Bash one-liner that automates a repetitive task in your current project.
