# Challenge 04 - Customizing GitHub Copilot in Your IDE - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

This challenge focuses on customizing GitHub Copilot behavior **within the IDE** using custom instructions and custom agents. The goal is to show how a small amount of guidance can immediately change Copilot’s output in a meaningful way.  We aren't expecting long lengthy instruction files to be built

Students should focus on **simple, high-impact rules** that are easy to observe during the hackathon.

---

## Key Concepts to Explain Before the Challenge

### Custom Agent Instructions

- Defined in `.github/copilot-instructions.md` at the repository root
- Apply to **all Copilot interactions** in the workspace
- Used to guide coding standards, testing expectations, and project conventions
- Changes take effect immediately after file creation or modification

### Chat Modes (Usage Only)

- Chat modes are selected explicitly in the IDE
- They provide a focused interactive experience
- They do **not** override or replace agent instructions
- Instructions always apply, regardless of the selected chat mode

---

Sample Instruction File below, many other examples in Awesome Copilot repo.


### Example Agent Instructions (.NET)

Keep instructions short and concrete so behavior changes are obvious.

```markdown
# GitHub Copilot Project Instructions

## Coding Standards
- Use C# and modern .NET conventions
- Prefer explicit types over `var` unless the type is obvious
- Use meaningful method and variable names
- Keep methods small and focused on a single responsibility

## Testing Expectations
- New game logic should include unit tests
- Use xUnit for testing
- Test names should describe behavior, not implementation
- Avoid testing UI code directly; focus on game logic

