# Challenge 02 - Context Engineering (NYC App)

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

In this challenge, you will optimize Copilot context using a real code task in the NYC starter app under Resources/Challenge-02-NYCApp.

The app intentionally includes an oversized global `.github/copilot-instructions.md` file and multiple routes (`events`, `restaurants`, `neighborhoods`) so you can compare broad context (`#Codebase`) against precise, task-focused attachments.

Every token sent to GitHub Copilot has a cost. Context that persists across interactions, such as global instruction files or broad workspace references, can increase recurring spend by adding tokens that are not needed for the current task.

You will audit the over-stuffed global instructions file, restructure it into scoped path-specific files, and replace broad references with pinned attachments to reduce the base cost of each Copilot interaction while maintaining output quality.

## Description

Use the project in:

`Resources/Challenge-02-NYCApp`

### Part 1 - Scope Instructions

1. Audit `.github/copilot-instructions.md` and identify what is:
	 - universally useful
	 - specific to events
	 - irrelevant for this task (for example, restaurants/neighborhoods/frontend/testing rules)
2. Shrink the global file to only truly global guidance.
3. Create scoped instruction files under `.github/instructions/` for rules that should apply only to specific paths/tasks. For example, create an `api.instructions.md` file and an `events.instructions.md` file.
4. Keep the events-specific logic discoverable for work in `src/routes/events.ts`.
5. Create a reusable Copilot skill under `.github/skills/free-events-endpoint/SKILL.md` that captures the pattern for implementing a free events endpoint. This skill should only load when explicitly invoked, making it a conditional cost rather than a recurring one.

### Part 2 - Implement the Baseline Route Task

Implement `GET /events/free-this-week` in `src/routes/events.ts` with this behavior:

- include events where `price === 0`
- include only events within the next 7 days
- sort ascending by date
- return JSON in the shape `{ count, events }`

Important:

- modify `src/routes/events.ts`
- do not modify `src/routes/restaurants.ts`
- do not modify `src/routes/neighborhoods.ts`

### Part 3 - Attachment Precision and Token Usage Check

In the GitHub Copilot Chat interface, run this exact query twice and compare results:

"What data or features does this application support?"

Run it twice and record the token usage each time:

1. Without scoped files (broad context, such as `#Codebase`)
2. With scoped files pinned (only task-relevant files, for example: `src/routes/events.ts`, `src/data/events.ts`, and relevant instruction files)

Capture both token counts from the Copilot Chat usage details/output, compare answer quality, and calculate the difference.

For each run, record context window stats in this format:

- Used tokens / Total context window tokens
- Context window utilization percentage

Example format:

- Run A (broad): 8,200 / 32,000 (25.6%)
- Run B (scoped): 2,100 / 32,000 (6.6%)

Then compute:

- Used-token delta (A - B)
- Utilization delta in percentage points

Use this table to record your measurements:

| Run | Context Strategy | Query | Used Tokens | Total Context Window Tokens | Utilization % | Notes |
|-----|------------------|-------|-------------|-----------------------------|---------------|-------|
| A | Broad (`#Codebase` or equivalent) | What data or features does this application support? | | | | |
| B | Scoped pinned files | What data or features does this application support? | | | | |

| Comparison Metric | Value |
|-------------------|-------|
| Used-token delta (A - B) | |
| Utilization delta percentage points (A - B) | |


## Success Criteria

To complete this challenge successfully, you should be able to:

- Show that `.github/copilot-instructions.md` is significantly smaller than the original
- Show scoped instruction files created in `.github/instructions/`
- Show a reusable skill created at `.github/skills/free-events-endpoint/SKILL.md`
- Demonstrate a correct `/events/free-this-week` implementation in `src/routes/events.ts`
- Demonstrate that `src/routes/restaurants.ts` and `src/routes/neighborhoods.ts` remained unchanged
- Show token comparison between `#Codebase` and pinned attachments for the same task
- Show Part 3 token and context-window comparison for the query "What data or features does this application support?" in Copilot Chat:
	- without scoped files
	- with scoped pinned files
	- with documented context window stats (used / total)
	- with documented utilization percentage for both runs
	- with documented token and utilization deltas
- Show measurable credit reduction while preserving output quality

## Learning Resources

- [GitHub Copilot Instructions Documentation](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
- [GitHub Copilot Prompt Files and Attachments](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide#reference-files-in-your-prompts)
- [GitHub Copilot Skills Overview](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-skills)

## Tips

- Persistent instructions are recurring costs—they load on every call
- Skills are conditional costs—they only load when invoked
- Attachments are per-call costs—you control exactly what's included
- The engineering target: keep always-on global instructions under 1000 tokens
- Scoped instructions should be discoverable: if a rule only applies to `/api`, put the instruction file in `/api/.github/`
