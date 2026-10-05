# Challenge 03 — Coach Solution Assets

Reference data and tooling for the coach. **Not** distributed to students — students use the
VS Code Copilot Chat model picker + Output panel.

## Contents

| File | Purpose |
|---|---|
| `harness.py` | Measurement harness: runs N trials of each (model, task), counts pass/fail, averages tokens, with rate-limit backoff |
| `results.md` | The measured answer-key tables referenced in `Solution-03.md` |
| `TODO.md` | Author follow-ups / deferred enhancements |

## Running the harness

The harness calls the **GitHub Models inference API** and authenticates with your
`gh auth token`.

```bash
# default: gpt-4.1 (base) vs gpt-5 (premium), both tasks, n=4
python harness.py --models "openai/gpt-4.1" "openai/gpt-5" --tasks sort carwash -n 4 --sleep 2
```

Output is a summary table of pass rate + average tokens per (model, task), and a
`results.json` dump.

### Tasks

- `sort` — easy (version sort). Both tiers pass; the differentiator is tokens.
- `carwash` — hard (the "walk or drive to the car wash" trap). Base models recommend *walking*
  (wrong); premium models recommend *driving* (correct). The `carwash` check marks an answer
  correct when the model's leading recommendation is to **drive**.

### Notes

- The free GitHub Models tier is rate-limited; the harness backs off on HTTP 429. For large N,
  expect it to run slowly. n=4 is sufficient to demonstrate the pattern.
- Premium models (e.g. `gpt-5`) throttle the most. Increase `--sleep` if you see many retries.
- Premium reasoning models also produce highly variable token counts — focus on the pattern.
- **Do not use temperature with `gpt-5`** via this API — it rejects non-default temperature
  (HTTP 400). The harness omits the temperature parameter for this reason.
