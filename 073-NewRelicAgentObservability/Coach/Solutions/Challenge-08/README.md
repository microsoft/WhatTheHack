# Challenge 08 Solution Package - Application-Level Prompt Injection Controls

## Overview

This package provides the **application-level** reference implementation for Challenge 08.

## Included Files

- `security_detector.py` - Detection and scoring helpers
- `web_app_enhanced.py` - Route integration, blocking, and telemetry patterns
- `test_security_features.py` - Detection, false-positive, and performance tests

## Coach Usage

1. Review `Coach/Solution-08.md`
2. Walk through detector design and scoring strategy
3. Demonstrate route-level enforcement in `/plan`
4. Validate telemetry in New Relic
5. Run tests to verify target thresholds

## Validation Targets

- 80%+ attack detection on provided adversarial set
- <10% false-positive rate on benign prompts
- <100ms core detection latency
- Observable security metrics/events/spans

## Layering Context

- Challenge 07: Platform baseline with Foundry Guardrails
- Challenge 08: Application-specific controls in `web_app.py`

Together: defense in depth.
