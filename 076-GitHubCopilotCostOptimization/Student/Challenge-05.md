# Challenge 05 - Context Window Management

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Pre-requisites

- Complete Challenge 02 (Context Engineering) — you will extend the CityScout NYC App from that challenge
- Complete Challenge 04 (Session Configuration: Tools + Cache)

## Introduction

Context windows grow with every interaction. As a session accumulates messages, attachments, and generated code, the model has more history to process each turn.

When context grows too large, quality often drops: missed requirements, repeated questions, inconsistent edits, and higher credit spend. In this challenge, you will compare unmanaged context growth against proactive context management and measure the credit difference.

## Description

You will extend the **CityScout NYC App** (from Challenge 02) with four new features, then compare two session strategies side-by-side: one where you let context grow unchecked, and one where you actively manage it. The features deliberately span all three routes and force topic switching—exactly the conditions that grow context fast.

### The Task: CityScout Feature Sprint

Using the NYC App you worked with in Challenge 02 (in `Resources/Challenge-02-NYCApp`), implement these four features in order:

- **Feature 1 – Restaurant Filtering:** Add query-parameter support to `GET /restaurants` so callers can filter by `borough` and/or `cuisine` (e.g., `/restaurants?borough=Brooklyn&cuisine=Mexican`). Return the full list when no filters are provided.
- **Feature 2 – Neighborhood Detail with Restaurants:** Add `GET /neighborhoods/:name` that returns the matching neighborhood object plus an embedded array of restaurants in that neighborhood (a cross-file join between `neighborhoods.ts` and `restaurants.ts` data).
- **Feature 3 – Pagination (cross-cutting):** Add `?page=N&limit=N` support to all three list endpoints (`/events/free-this-week`, `/restaurants`, `/neighborhoods`). Default to page 1, limit 10. Return `{ page, limit, total, data }`.
- **Feature 4 – Input Validation & Error Handling:** Add proper `400 Bad Request` responses for invalid query parameters and `404 Not Found` for missing resources across all routes.

These four features touch multiple files, require cross-file references, and create natural breakpoints between each feature—ideal for testing context management strategies.  We recommend not committing these files to make it easier to revert.

### Run A – Unmanaged Context Growth

Implement all four features in a single session without ever using `/compact`:

- Let context accumulate naturally as you move from feature to feature
- Do not start new sessions between features
- Track credit usage after each feature completes
- Watch for quality degradation signals as context grows:
  - Copilot forgets earlier requirements (e.g., pagination format differs between routes)
  - Contradictory suggestions (e.g., different error shapes in different routes)
  - Repeated clarifying questions you already answered
  - Increased rework or manual corrections

Record a brief evidence note after each feature: what worked, what degraded.

### Run B – Proactive Context Management

Implement the same four features, but actively manage context throughout. You choose your own strategy:

- `/compact` to summarize and continue in the same session
- `/clear` to wipe and restart with a fresh prompt
- Start a new session (`/new`) at any breakpoint you choose

The goal is to keep context lean and credit spend low. Track total credits across the entire sprint (including any new sessions you start) and compare with Run A. Document which context management actions you took and why.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Demonstrate at least two concrete quality degradation signals from Run A
- Show a side-by-side credit comparison between Run A and Run B for the same four features
- Verify that your Run B context management strategy reduced total credit spend compared to Run A
- Explain the trade-offs between `/compact`, `/clear`, and starting a new session
- Show a concise evidence log for both runs (context management actions taken, credits per feature, total credits)

## Learning Resources

- [Understanding Context Windows and Token Limits](https://www.anthropic.com/index/prompting-long-context)
- [GitHub Copilot Chat Commands Documentation](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-chat)
- [Managing Long Conversations with AI Assistants](https://www.promptingguide.ai/)

## Tips

- Do not optimize for speed first; optimize for clean credit comparisons between runs
- Keep the four features identical between Run A and Run B so the credit comparison is meaningful
- Record credits after each feature, not just at the end — this shows where costs accelerate
- There is no single "right" strategy for Run B; `/compact`, `/clear`, and `/new` all have trade-offs
- `/compact` preserves some context continuity but costs tokens to summarize
- `/clear` and `/new` give you a cold start — cheap per-turn but you re-establish context from scratch
- The best strategy often mixes approaches depending on how much earlier context the next feature needs
