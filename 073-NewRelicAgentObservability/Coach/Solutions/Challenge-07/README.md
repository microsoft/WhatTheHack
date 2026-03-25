# Challenge 07 Solution Package - Platform-Level Guardrails

## Overview

This package supports **Challenge 07 (platform-level controls)**. It is focused on Microsoft Foundry Guardrails configuration, validation, and observability.

## Scope

### In Scope

- Configure guardrail intervention points
- Set block vs annotate policy
- Validate behavior with attack and benign prompts
- Capture guardrail outcomes in New Relic

### Out of Scope (Challenge 08)

- `web_app.py` code changes
- Custom prompt-injection detector logic
- Route-level blocking and app-side telemetry

## Student Deliverables

- Guardrail configuration evidence (screenshots/notes)
- Prompt test matrix with outcomes
- New Relic query/chart showing guardrail activity
- Gap analysis to motivate app-level controls

## Success Checklist

- [ ] Input/output guardrails enabled
- [ ] Risk actions configured and documented
- [ ] Baseline detection validated
- [ ] Guardrail outcomes visible in observability
- [ ] Gaps documented for Challenge 08

## Related Files

- Coach guide: `Coach/Solution-07.md`
- Next challenge: `Coach/Solution-08.md`
- Student challenge: `Student/Challenge-07.md`
