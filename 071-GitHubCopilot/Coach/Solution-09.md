# Challenge 09 - Automating DevOps Workflows with GitHub Copilot CLI - Coach's Guide

[< Previous Solution](./Solution-08.md) - **[Home](./README.md)**

## Notes & Guidance

This challenge builds on Challenge 08 by putting `gh copilot suggest` to work in a structured, end-to-end DevOps workflow. Students should leave with a concrete understanding of how Copilot CLI accelerates everyday Git/GitHub operations and where its current limitations lie.

### Key Concepts to Reinforce

- Copilot CLI is most effective when prompts are **specific and scoped** to a single action.
- The `--shell`, `--git`, and `--gh` flags (or the interactive type selection) steer Copilot toward the right command family.
- Always review a suggested command before executing it—especially commands that delete, push, or modify remote resources.

### Step-by-Step Guidance

#### Step 1 – Repository and Branch Management

Example prompts and expected outputs:

| Prompt | Expected command |
|---|---|
| "create a new public GitHub repository called copilot-cli-demo with a README" | `gh repo create copilot-cli-demo --public --add-readme` |
| "clone the repository copilot-cli-demo" | `gh repo clone <user>/copilot-cli-demo` |
| "create a new branch called feature/hello-world and switch to it" | `git checkout -b feature/hello-world` |
| "create a shell script that prints Hello Copilot CLI" | `echo 'echo "Hello, Copilot CLI!"' > hello.sh && chmod +x hello.sh` |
| "stage all changes, commit with message 'Add hello world script', and push feature branch" | `git add . && git commit -m "Add hello world script" && git push -u origin feature/hello-world` |

#### Step 2 – Pull Request Automation

| Prompt | Expected command |
|---|---|
| "open a pull request from feature/hello-world to main with title 'Add hello world script'" | `gh pr create --base main --head feature/hello-world --title "Add hello world script" --body "Adds a simple hello world shell script"` |
| "list all open pull requests in this repository" | `gh pr list --state open` |
| "merge the open pull request using squash merge" | `gh pr merge --squash` |

**Note**: Students may need to enable squash merging in the repository settings if it is not already on.

#### Step 3 – Release Management

| Prompt | Expected command |
|---|---|
| "create a git tag v1.0.0 on the latest commit" | `git tag v1.0.0` |
| "push the tag v1.0.0 to GitHub" | `git push origin v1.0.0` |
| "create a GitHub release for v1.0.0 with auto-generated release notes" | `gh release create v1.0.0 --generate-notes` |

#### Step 4 – Operational Tasks

| Prompt | Expected command |
|---|---|
| "find the 10 largest files in the current directory" | `find . -type f -printf '%s %p\n' \| sort -rn \| head -10` (Linux) or `du -sh * \| sort -rh \| head -10` |
| "search git history for commits mentioning 'fix'" | `git log --oneline --grep="fix"` |
| "compress the current directory into a tar.gz archive" | `tar -czf ../copilot-cli-demo.tar.gz .` |

### Common Issues

| Issue | Resolution |
|---|---|
| `gh repo create` fails with permissions error | Ensure `gh auth login` has been run and the token has `repo` scope |
| PR creation fails because branches are not on remote | Student forgot to push the feature branch before creating the PR |
| `gh release create` returns 404 | The tag was not pushed; run `git push origin v1.0.0` first |
| Suggested `find` command uses Linux-only flags on macOS | Prompt refinement: add "on macOS" to the natural-language request, or use `du` variant |

### Success Criteria Validation

- **Repository**: Verify with `gh repo view <user>/copilot-cli-demo` or by browsing to the GitHub URL.
- **PR workflow**: Show `gh pr list` output and the merged PR on GitHub.
- **Release**: Show `gh release view v1.0.0` or the Releases page on GitHub.
- **Operational tasks**: Output from the commands is sufficient—files do not need to be large for the task to succeed.
- **explain usage**: Student should show the `gh copilot explain` output for at least one command they found unfamiliar.
- **Reflection**: Encourage honest discussion—Copilot CLI does not always get the platform-specific flags right; that is a valid and valuable finding.

### Cleanup (Optional)

To avoid leaving demo repositories behind, students can delete the repository when finished:

```bash
gh repo delete copilot-cli-demo --yes
```

Suggest students use `gh copilot suggest` to generate this cleanup command as well!

### Estimated Time

This challenge typically takes 45–60 minutes:
- 15 minutes: Repository setup and branch management
- 15 minutes: PR automation and release management
- 10 minutes: Operational tasks
- 10 minutes: Reflection and discussion

### Additional Discussion Points

- Discuss how Copilot CLI differs from Copilot in the IDE—same underlying model, different interaction surface.
- Ask students: "Could you build a reusable shell script that wraps these `gh` commands to create a project template?" This sets up the Advanced Challenge.
- Point out that `gh copilot suggest` learns from the **type** selection (shell vs. git vs. gh) to provide better scoped suggestions—emphasising command type selection is a useful best practice.
