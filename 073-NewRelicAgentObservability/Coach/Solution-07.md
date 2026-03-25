# Challenge 07 - AI Security: Platform-Level Guardrails - Coach's Guide

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes & Guidance

This challenge is intentionally focused on **platform-level controls only**. Students should configure and validate Microsoft Foundry Guardrails before writing custom security code.

## Teaching Objectives

By the end of this challenge, students should be able to:

1. Configure guardrails at key intervention points
2. Validate baseline protection with attack and benign prompts
3. Observe guardrail outcomes in New Relic
4. Explain coverage gaps that require application-level controls

## Implementation Path (60-90 minutes)

### Stage 1: Configure Guardrails (25-35 minutes)

Guide students to:

1. Enable input scanning
2. Enable output scanning
3. Configure risk categories (prompt injection, jailbreak, harmful content)
4. Set action policies (block high risk, annotate medium risk)
5. Optionally enable tool call/tool response controls (preview)

### Stage 2: Validate with Test Prompts (20-25 minutes)

Have students run:

- Known prompt injection attempts
- Legitimate travel-planning prompts

Expected outcomes:

- Most obvious attacks are blocked/flagged
- Legitimate prompts are largely unaffected
- Students identify gaps not covered by platform controls

### Stage 3: Observe in New Relic (15-25 minutes)

Ask students to produce a dashboard or query set showing:

- Requests scanned
- Blocks by category
- Input vs output interventions
- Trend over time

## Success Criteria

- [ ] Guardrails configured for input and output
- [ ] Action policy set and documented
- [ ] Baseline detection validated with test prompts
- [ ] Outcomes visible in observability workflow
- [ ] Coverage gaps documented for next challenge

## Common Pitfalls

1. **Skipping validation**
   - Fix: Require both adversarial and benign prompt tests.

2. **Treating platform controls as complete protection**
   - Fix: Emphasize this is baseline coverage only.

3. **No observability handoff**
   - Fix: Require at least one New Relic chart/query for guardrail outcomes.

## Bridge to Challenge 08

Use this transition:

"You now have broad, platform-level protection. Next, implement application-specific controls in `web_app.py` for travel-domain edge cases and business logic defense."

## Resources

- [Guardrails Overview](https://learn.microsoft.com/en-us/azure/ai-foundry/guardrails/guardrails-overview?view=foundry)
- [Create and Configure Guardrails](https://learn.microsoft.com/en-us/azure/ai-foundry/guardrails/how-to-create-guardrails?view=foundry&tabs=python)
- [Intervention Points](https://learn.microsoft.com/en-us/azure/ai-foundry/guardrails/intervention-points?view=foundry&pivots=programming-language-foundry-portal)

---

**Challenge Level:** Advanced (Challenge 07 of 08)
**Prerequisites:** Challenges 01-06
**Next:** [Solution-08.md](./Solution-08.md)
