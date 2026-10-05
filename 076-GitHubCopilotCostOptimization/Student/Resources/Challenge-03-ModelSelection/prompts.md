# Challenge 03 — Prompts

Run each prompt **verbatim**. Do not add context, attachments, or instructions — keeping the
input identical across models is what makes the token comparison fair.

---

## Part 1 — Easy task (version sort)

```
Sort these software version numbers from oldest to newest and list them in
order separated by commas: 1.9.0, 1.10.0, 1.2.0, 1.11.0, 1.9.5
```

✅ **Correct answer:** `1.2.0, 1.9.0, 1.9.5, 1.10.0, 1.11.0`

A wrong answer usually sorts the versions as text (so `1.10.0` and `1.11.0` land before
`1.9.0`). Modern models — base or premium — almost always get this right. The differentiator
here is **token cost**, not correctness.

---

## Part 2 — Hard task (the car wash)

```
The car wash is 40 meters from my home. I want to wash my car.
Should I walk or drive there?
```

✅ **Correct answer:** **Drive.** You can't wash a car that isn't there — the car has to be
*at* the car wash. The "40 meters" is a deliberate distraction; the base model tends to fixate
on the short distance and tell you to **walk** (leaving your car, and the whole point, at home).

A premium model reasons about the actual goal — *the car must be present to be washed* — and
answers **drive**. The wrong answer is obvious to any human in one second: that is exactly why
this task works.

---

## Optional — Output constraint variant (verbose coding task)

Pick a task the model is verbose about by default, then constrain the output:

```
Write a Python function that checks whether a string is a palindrome.
```

then

```
Write a Python function that checks whether a string is a palindrome.
Output only the code. No explanation, no markdown fences.
```

Run both on the **base model** and compare total tokens. The code is the same; the constrained
run drops the surrounding explanation, cutting cost.
