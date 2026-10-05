# Challenge 03 - Model Selection & Output Constraints - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

This challenge teaches one durable idea: **total cost = token rate × tokens × attempts**, so
*lower cost per request is not lower cost per result.* Students prove it by running the same
prompt on a **base model** and a **premium model** across an **easy** task and a **hard** task,
measuring outcome and tokens. The magic is the contrast: opposite winners on the two tasks.

> **Terminology:** we use **base model** (included, no premium-request multiplier — e.g.
> GPT-4.1, GPT-4o) and **premium model** (frontier/reasoning model billed as a premium request
> with a multiplier — e.g. GPT-5, Claude Sonnet, o-series). Avoid "cheap/expensive" with
> students — it's imprecise and the whole point is that "cheap" can be the costliest choice.

### The core mechanic

| | Easy task (version sort) | Hard task (the car wash) |
|---|---|---|
| Base model | ✅ correct, **fewer tokens** | ❌ confidently wrong ("walk"), looks low-cost (a trap) |
| Premium model | ✅ correct, more tokens | ✅ correct ("drive"), more tokens |
| **Lesson** | Use the base model → save credits | Base model's wrong answer is the costliest option → pay for capability |

### Reference answer key (measured)

Measured via the GitHub Models inference API, single-shot, **n=4 per cell** (see
`Solutions/Challenge-03-ModelSelection-Solutions/`). Exact numbers vary by model/version; the
**pattern** is what matters.

| Model | Easy: pass rate | Easy: avg tokens | Hard: pass rate | Hard: avg tokens |
|---|---|---|---|---|
| `gpt-4.1` (base) | **4/4 (100%)** | ~106 | **0/4 (0%)** — answers "walk" | ~166 |
| `gpt-5` (premium) | **4/4 (100%)** | ~293 | **4/4 (100%)** — answers "drive" | ~1000 |

Takeaways to draw out:
- Easy task: identical correct answer, but the base model used **~2.8× fewer tokens.**
- Hard task: the base model was wrong **every** time (recommends walking, leaving the car at
  home). It was not even lower-cost to be wrong here — and no number of retries reliably fixes a
  reasoning-ceiling failure. The premium model was the only correct option.

### Why these specific tasks

- **Version sort (easy):** real, practical, and both tiers get it right — so the only
  differentiator is token cost. Clean "base model wins" demonstration.
- **The car wash (hard):** a pragmatic-reasoning trap. The "40 meters" bait makes base models
  fixate on distance ("walk, it's greener") and miss that *the car must be present to be
  washed.* The right answer (**drive**) is obvious to any human in a second — so students can
  *see* the base model is wrong without trusting us. Crucially this tracks **capability**, so
  results are monotonic with model strength.
- **Rejected — letter-counting / "gotcha" tasks** (e.g. "count the l's"): these are
  **tokenization artifacts, not reasoning tests.** We measured them and results do **not** track
  price — a base model can pass while a premium model fails (we observed Claude Haiku correct
  and Claude Opus wrong on the same letter-count). That would teach the *opposite* of the
  lesson. Do not use letter-counts, decimal-comparison, or "strawberry"-style traps.
- **Rejected — coin-change "greedy trap":** modern small models pass it; no longer discriminates.

### The "no retry" rule, and the cost-of-retries reasoning (Part 2)

Tell students explicitly: when the base model fails Part 2, **do not coach or retry it** for the
measurement. Then have them reason about retries:
- *How many base-model attempts would cost more than one premium call?* (Plug in token counts or
  your organizations multipliers.)
- *Would any number of attempts reliably get the right answer here?* (No — it's a capability
  ceiling. This is the key insight: retrying the lower-cost model is throwing good money after
  bad on tasks it can't reason through.)

### Part 4 — classify your own tasks

This is where the skill becomes transferable. Students write two real tasks from their own work,
predict the tier, run both, and check. Push them to articulate *why* a task is base- vs
premium-tier (well-defined/low-ambiguity vs multi-step reasoning/judgment) — that predictive
rule of thumb is the real deliverable.

## How students run it

No codebase. Students use the **VS Code Copilot Chat model picker** to switch between a
base-tier and premium-tier model, paste the two prompts from
`Student/Resources/Challenge-03-ModelSelection/prompts.md`, and read tokens from the Output
panel / usage view. They fill in `measurements-template.md`.

> Organizations expose different models. Coach students to pick *any* base-tier vs premium-tier pair
> their picker offers — the pattern holds. If your organization only exposes one tier, use the coach
> answer key above as the demonstration, or run the harness live.

> **Token visibility caveat:** depending on Copilot version/organization, the Output panel may not show a
> clean per-request token number. If so, students can still observe the *pattern* (premium model
> emits much more text). For exact counts, the coach harness (or the GitHub Models playground)
> reports `usage.total_tokens` directly. See `TODO.md` — aligning the token-measurement
> instructions across the whole hack (Challenge 00 sets this up) is tracked there.

## Expected Time

~45 minutes:
- 10 min: Part 1 (easy) on both models
- 10 min: Part 2 (hard) on both models + cost-of-retries reasoning
- 10 min: Part 3 compare + discussion
- 10 min: Part 4 classify-your-own-tasks
- 5 min: optional output-constraint run

## Success Criteria Validation

Students should produce a completed Part 3 table showing **opposite winners**: base model wins
the easy task on tokens; premium model is the only correct option on the hard task. They should
articulate the retry math (attempts-to-break-even) and the capability-ceiling point, and
classify two of their own tasks by tier. Bonus: a measurable token drop from an output
constraint on a verbose task.

## Common Blockers

- **Student retries the base model until it's right.** Stop them — that defeats the lesson.
  Redirect to the cost-of-retries reasoning instead.
- **Base model happens to say "drive" once.** It's stochastic; have them run it 2–3×. It
  recommends walking the large majority of the time. (If a student's base model reliably gets it
  right, their "base" model may actually be fairly strong — have them drop to the smallest model
  the picker offers.)
- **Organization exposes only one model tier.** Fall back to the answer key, or use the coach harness.
- **Token counts not visible.** Premium model still visibly produces much more text — record the
  pattern. For exact numbers use the harness. (See token-visibility caveat above.)
- **Premium model token counts vary a lot.** Reasoning models have variable hidden token use;
  emphasize ratio/pattern over absolute numbers.

## Hints to Share

- "Base" vs "premium" is about *total* cost, not per-request price. A wrong answer you have to
  redo is the costliest outcome.
- Match the model to the task: base for well-defined/low-ambiguity work, premium for anything
  needing real reasoning or judgment.
- Output constraints cut cost on any model — but they don't make a wrong model right.
- The car-wash distance is bait. The task is testing whether the model reasons about the *goal*.

## Reference Data & Reproduction

See `Solutions/Challenge-03-ModelSelection-Solutions/`:
- `harness.py` — measurement harness (counts pass/fail + tokens, with rate-limit backoff)
- `results.md` — the measured tables above
- `TODO.md` — author follow-ups (token-measurement alignment, advanced/Auto-mode scope)
