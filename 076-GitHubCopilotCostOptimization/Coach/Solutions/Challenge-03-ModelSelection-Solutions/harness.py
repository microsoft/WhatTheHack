#!/usr/bin/env python3
"""
Statistical model-comparison harness for WTH Challenge 03.

Runs N trials of each (model, task) pair, counts pass/fail, averages tokens.
Handles 429 rate limits with exponential backoff (a rate-limited call is
retried, NOT counted as a task failure).
"""
import argparse
import json
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request

ENDPOINT = "https://models.github.ai/inference/chat/completions"

# ---- Tasks -----------------------------------------------------------------
SORT_PROMPT = ("Sort these software version numbers from oldest to newest and "
               "list them in order separated by commas: 1.9.0, 1.10.0, 1.2.0, "
               "1.11.0, 1.9.5")
CARWASH_PROMPT = ("The car wash is 40 meters from my home. I want to wash my "
                  "car. Should I walk or drive there?")


def check_sort(ans: str) -> bool:
    versions = re.findall(r"\d+\.\d+\.\d+", ans)
    return versions == ["1.2.0", "1.9.0", "1.9.5", "1.10.0", "1.11.0"]


def check_carwash(ans: str) -> bool:
    """Correct iff the model recommends DRIVING (the car must be at the wash).

    Heuristic: look at the opening recommendation. Premium models lead with
    'Drive...'; base models lead with 'Walk...' / 'Walking...'. We treat the
    first mention of walk/drive as the recommendation.
    """
    low = ans.lower()
    di = low.find("driv")
    wi = low.find("walk")
    if di == -1:
        return False
    if wi == -1:
        return True
    return di < wi


TASKS = {
    "sort": {"prompt": SORT_PROMPT, "check": check_sort},
    "carwash": {"prompt": CARWASH_PROMPT, "check": check_carwash},
}


def get_token() -> str:
    return subprocess.check_output(["gh", "auth", "token"], text=True).strip()


def call(token: str, model: str, prompt: str, max_retries: int = 6):
    """Returns (answer, total_tokens) or ('ERROR:...', 0). Retries on 429."""
    body = json.dumps(
        {"model": model, "messages": [{"role": "user", "content": prompt}]}
    ).encode()
    for attempt in range(max_retries):
        req = urllib.request.Request(
            ENDPOINT, data=body,
            headers={"Authorization": f"Bearer {token}",
                     "Content-Type": "application/json"},
            method="POST",
        )
        try:
            with urllib.request.urlopen(req) as resp:
                d = json.load(resp)
            return (d["choices"][0]["message"]["content"].strip(),
                    d["usage"]["total_tokens"])
        except urllib.error.HTTPError as e:
            if e.code == 429:
                wait = min(60, 2 ** attempt * 5)
                time.sleep(wait)
                continue
            return (f"ERROR:{e.code}", 0)
        except Exception as e:  # noqa: BLE001
            return (f"ERROR:{e}", 0)
    return ("ERROR:429-exhausted", 0)


def run(token: str, model: str, task_key: str, n: int, sleep: float):
    task = TASKS[task_key]
    passes, toks, errors = 0, [], 0
    for i in range(n):
        ans, t = call(token, model, task["prompt"])
        if ans.startswith("ERROR:"):
            errors += 1
        else:
            if task["check"](ans):
                passes += 1
            toks.append(t)
        done = i + 1
        if done % 10 == 0 or done == n:
            print(f"    {model} / {task_key}: {done}/{n} "
                  f"(pass={passes} err={errors})", flush=True)
        time.sleep(sleep)
    avg = sum(toks) / len(toks) if toks else 0
    valid = n - errors
    rate = (passes / valid * 100) if valid else 0
    return {"model": model, "task": task_key, "n": n, "valid": valid,
            "passes": passes, "errors": errors, "pass_rate": rate,
            "avg_tokens": avg}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--models", nargs="+", required=True)
    ap.add_argument("--tasks", nargs="+", default=["sort", "carwash"])
    ap.add_argument("-n", type=int, default=50)
    ap.add_argument("--sleep", type=float, default=1.0)
    args = ap.parse_args()

    token = get_token()
    results = []
    for model in args.models:
        for task_key in args.tasks:
            print(f"  -> {model} / {task_key} (n={args.n})", flush=True)
            results.append(run(token, model, task_key, args.n, args.sleep))

    print("\n" + "=" * 84)
    print(f"{'MODEL':<34}{'TASK':<8}{'PASS':>8}{'/N':>6}{'RATE':>8}{'AVG TOK':>10}{'ERR':>6}")
    print("-" * 84)
    for r in results:
        print(f"{r['model']:<34}{r['task']:<8}{r['passes']:>8}{r['valid']:>6}"
              f"{r['pass_rate']:>7.0f}%{r['avg_tokens']:>10.0f}{r['errors']:>6}")
    print("=" * 84)
    with open("results.json", "w") as f:
        json.dump(results, f, indent=2)


if __name__ == "__main__":
    main()
