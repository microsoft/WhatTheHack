# Output Constraints — Cheat Sheet

Output tokens usually cost more than input tokens. Constraining what the model *produces* is
a cost lever you control on **every** model. Use these patterns when you don't need narration.

| Goal | Add to your prompt | Effect |
|---|---|---|
| Answer only | "Answer with only the number/value, nothing else." | Removes restated reasoning + preamble |
| Code only | "Output only the code. No explanation, no markdown fences." | Cuts the "Here's how it works..." paragraphs |
| Cap verbosity | "Explain in 50 words or fewer." | Hard ceiling on output length |
| Structured output | "Respond as JSON matching: `{ \"result\": number }`" | Prevents rambling; easy to parse |
| No restatement | "Do not repeat the question or summarize the task." | Removes echo of the input |
| Bounded list | "List at most 3 items." | Stops over-generation |

## Why it matters

A model asked a question it would normally *explain* will spend most of its tokens narrating an
answer you already trust. The constraint keeps the correctness and drops the cost. The effect is
biggest on **verbose-by-default** tasks (e.g. "write a function") — there the model otherwise
wraps the answer in explanation and markdown.

## Try it

Take a verbose task on the base model and re-run it with an output constraint appended:

```
Write a Python function that checks whether a string is a palindrome.
Output only the code. No explanation, no markdown fences.
```

Compare total tokens — the code is identical, the cost is much lower.

> Notes:
> - Constraints reduce **output** tokens. They do little when the output is already terse
>   (e.g. a one-line answer) or when a reasoning model's hidden "thinking" tokens dominate.
> - Constraints do **not** fix a model that is *wrong* (see Part 2). For a task the base model
>   can't reason through, a constraint just gives you a wrong answer faster — model selection,
>   not output shape, is the fix there.
