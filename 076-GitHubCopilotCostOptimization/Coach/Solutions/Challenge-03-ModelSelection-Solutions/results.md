# Challenge 03 — Measured Results (Answer Key)

Source: GitHub Models inference API. Method: `harness.py`, **n=4 trials per (model, task)**,
single-shot (no retries). Exact token counts vary by model version; the **pattern is stable.**

Models used as the demonstration pair:
- **Base:** `openai/gpt-4.1` (included tier, no premium multiplier — selectable in Copilot Chat)
- **Premium:** `openai/gpt-5` (frontier/reasoning tier)

## Summary

| Model | Task | Pass rate | Avg total tokens |
|---|---|---|---|
| `openai/gpt-4.1` (base) | sort (easy) | **4/4 — 100%** | ~106 |
| `openai/gpt-4.1` (base) | car wash (hard) | **0/4 — 0%** (answers "walk") | ~166 |
| `openai/gpt-5` (premium) | sort (easy) | **4/4 — 100%** | ~293 |
| `openai/gpt-5` (premium) | car wash (hard) | **4/4 — 100%** (answers "drive") | ~1000 |

## Interpretation

- **Easy task (version sort):** both models 100% correct. The base model produced the identical
  answer using **~2.8× fewer tokens** (106 vs 293). Paying for the premium model here buys
  nothing → **use the base model.**
- **Hard task (the car wash):** the base model recommended **walking** every single time —
  fixating on "40 meters" and missing that the car has to be *at* the wash. The premium model
  reasoned about the goal and answered **drive** every time. Retrying the base model can't fix
  this — it's a reasoning ceiling → **pay for capability.**

## Monotonicity check (why the car wash, not letter-counting)

We require a task where success tracks **capability** (and therefore price). The car wash does;
tokenization "gotchas" do not. Measured examples:

| Task | gpt-4o-mini (base) | gpt-4.1 (base) | gpt-5 (premium) | Tracks capability? |
|---|---|---|---|---|
| Car wash (walk/drive) | ❌ walk | ❌ walk | ✅ drive | ✅ yes — monotonic |
| Letter count ("l" in "parallel lullaby") | mixed | ✅ 6 | ✅ 6 | ❌ no — base passes |
| Letter count (Claude, observed in Copilot) | Haiku ✅ | — | Opus ❌ | ❌ no — **inverts** |

The letter-count row is why we dropped it: a base model (Haiku) was correct while a premium
model (Opus) was wrong — the opposite of the lesson. Letter-counting, decimal comparison, and
"strawberry"-style tasks are tokenization artifacts and must not be used here.

## Output constraint (optional section)

Constraints reduce **output** tokens, so they show best on a **verbose-by-default** task, on a
non-reasoning (base) model. Measured on `openai/gpt-4.1`:

| Prompt | Avg total tokens |
|---|---|
| "Write a Python function that checks whether a string is a palindrome." | ~190 |
| same + "Output only the code. No explanation, no markdown fences." | ~66 |

→ **~65% fewer tokens** for the identical function.

Note: the constraint did **not** help on the already-terse version-sort task (~103 → ~104 on
gpt-4.1), and did not reduce `gpt-5`'s totals (reasoning/"thinking" tokens dominate and aren't
constrained). Pick a verbose task to demonstrate the lever.

## Models / tasks we evaluated and rejected

| Candidate | Why rejected |
|---|---|
| `mistral-ai/ministral-3b` as the base pick | Too weak — failed the **easy** task too, breaking the "base wins Part 1" story |
| `gpt-4.1-nano` as the base pick | Reliably fails the hard task, **but is not selectable in the Copilot model picker** — students can't use it |
| Letter-count / decimal / "strawberry" tasks | Tokenization artifacts — results don't track price (base can beat premium); see monotonicity table |
| Coin-change "greedy trap" | Modern small models pass it — no longer discriminates |

## Reproduce

```bash
# easy + hard, base vs premium, n=4
python harness.py --models "openai/gpt-4.1" "openai/gpt-5" --tasks sort carwash -n 4 --sleep 2
```
