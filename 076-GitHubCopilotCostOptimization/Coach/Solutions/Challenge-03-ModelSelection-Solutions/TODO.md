# Challenge 03 — Author TODO / Deferred

Coach/author notes. The challenge is complete and runnable. This tracks follow-ups.

## Done (this revision)
- [x] **Replaced the hard task** from letter-counting → the **car wash** ("walk or drive 40 m
      to wash my car"). Letter-counting was a tokenization artifact whose results did **not**
      track price (base model could beat premium — we observed Haiku right / Opus wrong). The
      car wash tracks capability and is monotonic. See `results.md`.
- [x] **Switched the base/premium pair** to Copilot-selectable models. The old `gpt-4.1-nano`
      reliably failed the hard task but is **not selectable in the Copilot model picker**, so
      students couldn't use it. New pair: base `gpt-4.1`, premium `gpt-5`.
- [x] **Terminology:** removed "cheap/expensive"; now **base model** / **premium model**
      (matches Copilot's included-vs-premium-request billing language).
- [x] **Added depth:** Part 2 cost-of-retries reasoning ("how many base attempts to exceed one
      premium call?" + capability-ceiling point); Part 4 "classify your own tasks"; a
      "why this matters for coding" paragraph; a token-variance note.
- [x] **Output-constraint section** rebuilt around a verbose task (palindrome function,
      190→66 tokens on gpt-4.1) — the old version-sort example showed no reduction.

## Open
- [ ] **Token-measurement alignment (hack-wide).** The student docs point to
      `View → Output → "GitHub Copilot Chat"` / usage view for token counts, per Challenge 00's
      setup. Verify that Copilot Chat actually surfaces a clean per-request token number in the
      target VS Code/Copilot version. If it does **not**, this is a **Challenge 00** problem
      affecting every challenge — fix it there (or standardize on a token source) rather than
      only in Challenge 03. Coach harness + GitHub Models playground are reliable fallback.
- [ ] **Advanced section (optional).** Add an "Advanced Challenges" block: try a mid-tier /
      reasoning model on the hard task (where's the price/capability knee?); build a two-model
      "base drafts → premium reviews" workflow and measure total cost.
- [ ] **Scope decision — reasoning levels + Auto mode.** The *original* Challenge-03 included
      comparing reasoning-effort levels and explaining when **Auto mode** beats manual
      selection. Decide whether to re-add as optional/Advanced. Needs owner sign-off.

## Validated data (basis for the answer key)
Measured via GitHub Models API (`harness.py`), single-shot, no retries, n=4:

| Model | Easy (version sort) | Hard (car wash) |
|---|---|---|
| gpt-4.1 (base) | ✅ 4/4, ~106 tokens | ❌ 0/4 — says "walk", ~166 tokens |
| gpt-5 (premium) | ✅ 4/4, ~293 tokens | ✅ 4/4 — says "drive", ~1000 tokens |

Output constraint (gpt-4.1, palindrome function): ~190 → ~66 tokens = **−65%**, identical code.
Constraint showed **no** effect on the terse sort task and on gpt-5 (reasoning tokens dominate).

Rejected: letter-count/decimal/"strawberry" (tokenization artifacts — don't track price);
`ministral-3b` (fails easy task too); `gpt-4.1-nano` (not in Copilot picker); coin-change
greedy trap (modern small models pass it).
