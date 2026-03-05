# Challenge 08 - AI Security: Application-Level Prompt Injection Controls - Coach's Guide

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)**

## Notes & Guidance

This challenge focuses on **application-level controls** in `web_app.py`. Students implement prompt-injection detection, blocking logic, and telemetry that complements platform guardrails configured in Challenge 07.

## Teaching Objectives

By the end of this challenge, students should be able to:

1. Add prompt injection detection into request flow
2. Enforce threshold-based blocking before agent execution
3. Harden system instructions and sanitize inputs
4. Emit security telemetry for all decisions
5. Validate detection, false positives, and latency

## Implementation Path (90-120 minutes)

### Stage 1: Detection Functions (30-35 minutes)

In `web_app.py`, implement:

- Rule-based pattern matching
- Heuristic checks for obfuscation and anomalies
- Structured output (`risk_score`, `patterns_detected`, `should_block`)

### Stage 2: Blocking in `/plan` (20-25 minutes)

Add pre-agent enforcement:

- Analyze combined input
- Block when risk exceeds threshold
- Return user-friendly error messaging

### Stage 3: Harden and Sanitize (15-20 minutes)

Require students to:

- Strengthen system instructions against injection
- Validate input types and lengths
- Sanitize high-risk input patterns

### Stage 4: Instrument Telemetry (20-25 minutes)

Track with OpenTelemetry/New Relic:

- `security.prompt_injection.app_detected`
- `security.prompt_injection.app_blocked`
- `security.prompt_injection.score`
- `security.detection_latency_ms`

### Stage 5: Test and Validate (15-20 minutes)

Minimum validation:

- 20+ adversarial prompts
- Benign travel prompts for false-positive checks
- Core detection latency <100ms
- Evidence of telemetry in New Relic

## Success Criteria

- [ ] App-level detector integrated in `web_app.py`
- [ ] Blocking logic enforced before agent execution
- [ ] Hardened prompt + input validation implemented
- [ ] Security telemetry visible in New Relic
- [ ] Detection quality and latency targets validated

## Solution Assets

Reference package:

- `Coach/Solutions/Challenge-08/security_detector.py`
- `Coach/Solutions/Challenge-08/web_app_enhanced.py`
- `Coach/Solutions/Challenge-08/test_security_features.py`
- `Coach/Solutions/Challenge-08/README.md`

---

**Challenge Level:** Advanced (Challenge 08 of 08)
**Prerequisites:** Challenges 01-07
