# Challenge 03 — Model Selection — Resources

This folder contains everything you need for Challenge 03. There is **no codebase to run** —
the challenge is about sending two short prompts to two different models and measuring what
comes back.

## What's here

| File | Purpose |
|---|---|
| `prompts.md` | The two exact prompts (easy + hard) and their correct answers |
| `measurements-template.md` | Blank tables to record outcome + tokens for each run |
| `output-constraints.md` | Cheat sheet of output constraints to reduce token cost |

## How to run it (VS Code + GitHub Copilot Chat)

1. Open GitHub Copilot Chat in VS Code. Start a **new conversation for every model/prompt pair**.
2. Use the **model picker** to select a lower-cost model available to your organization.
3. Paste a prompt from `prompts.md` exactly as written. Record the answer and measured token usage.
4. Start another **new conversation**, select a stronger model, and run the **same** prompt.
   Keep attachments and instructions identical to the first run. Record the answer and measured token usage.
5. Repeat this procedure for both prompts, using a fresh conversation for each run.
6. Fill in `measurements-template.md` and answer the Part 3 questions, then do the Part 4
   "classify your own tasks" exercise.

> **Rule:** Do not retry or coach the base model when it gets the hard task wrong. A wrong
> first answer is a valid — and important — result. You'll reason about the cost of retrying
> in Part 2 instead.

> **If your picker shows only one tier:** ask your coach which models map to "base" and
> "premium" for your org, or use the coach's reference numbers as the demonstration.
