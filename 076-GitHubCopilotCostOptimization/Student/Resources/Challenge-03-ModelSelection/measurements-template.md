# Challenge 03 — Measurement Template

Fill in the tables as you run each prompt. Get token counts from
`View → Output → "GitHub Copilot Chat"` and/or your Copilot usage view. If exact per-request
counts aren't shown, record *roughly* how much more text the premium model produced.

> Token counts vary run to run (premium reasoning models especially). Focus on the **pattern /
> ratio**, not the absolute number.

Record the **base-tier** and **premium-tier** model names you actually used:

- Base model: `____________________`
- Premium model: `____________________`

---

## Part 1 — Easy task (version sort)

| | Base model | Premium model |
|---|---|---|
| Answer given | | |
| Correct? (Y/N) | | |
| Total tokens | | |

**Observation:** _Were both correct? Which used fewer tokens for the same answer?_

---

## Part 2 — Hard task (the car wash)

| | Base model | Premium model |
|---|---|---|
| Answer (walk / drive) | | |
| Correct? (Y/N) | | |
| Total tokens | | |

**Observation:** _Did the base model say "walk"? Each attempt was low-cost — but was it useful?_

### Cost-of-retries reasoning

- Base model cost per attempt: `__________`  |  Premium model cost (one call): `__________`
- **How many base-model attempts equal one premium call?** `__________`
- On this task, would *any* number of base-model attempts reliably get the right answer? `__________`

---

## Optional — Output constraint (verbose task, base model)

| | Base model (no constraint) | Base model (code/answer only) |
|---|---|---|
| Total tokens | | |
| Token reduction | — | |

---

## Part 3 — Decision table

| Task | Base correct? | Base tokens | Premium correct? | Premium tokens | Use which model? |
|------|---------------|-------------|------------------|----------------|------------------|
| Part 1 (easy) | | | | | |
| Part 2 (hard) | | | | | |

### Answers

1. Easy task — better value (correct + fewest tokens)? →
2. Hard task — what did the base model's wrong answer really cost? →
3. At 10,000 runs/day, how does your choice differ for Part 1 vs Part 2? →
4. How do you decide *up front* whether a task is "easy → base" or "hard → premium"? →

---

## Part 4 — Classify your own tasks

| Your task | Predicted tier | Actual best tier | Prediction right? |
|---|---|---|---|
| 1. | | | |
| 2. | | | |
