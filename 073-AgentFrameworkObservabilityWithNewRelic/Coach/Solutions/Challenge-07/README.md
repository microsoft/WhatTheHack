# Challenge 07 Solution - Security Detection & Prevention

## Overview

This directory contains a complete solution for Challenge 07: AI Security and Prompt Injection Detection. The solution demonstrates how to integrate security features into an existing Flask application using the Microsoft Agent Framework.

## Files in This Solution

### 1. `Solution-07.md` (in Coach directory)

The main coach guide with:

- Implementation path broken into 5 stages
- Key concepts and teaching points
- Common pitfalls and how to avoid them
- Time management suggestions
- Discussion points for learners

### 2. `security_detector.py`

Core security detection module with:

- `detect_prompt_injection()` - Main detection function with risk scoring
- `sanitize_input()` - Input sanitization helper
- `validate_request_data()` - Form input validation
- Comprehensive pattern matching for attack detection
- Performance optimized for <100ms detection latency

**Key Features:**

- Multiple detection methods: keyword-based, heuristic, structural
- Risk scoring system (0.0 to 1.0)
- Detailed pattern categorization
- Built-in test cases for validation

### 3. `web_app_enhanced.py`

Complete Flask application showing:

- Integration of security detection into existing Flask routes
- OpenTelemetry instrumentation for monitoring
- Hardened agent system prompt
- Input validation and sanitization
- Blocking logic with graceful error messages
- Both `/plan` (HTML) and `/api/plan` (JSON) endpoints with security

**Key Integration Points:**

- Lines 50-80: OpenTelemetry setup for security monitoring
- Lines 100-200: Detector and validation functions
- Lines 250-300: Hardened agent instructions
- Lines 350-480: Enhanced `/plan` route with 8-step security flow
- Lines 480-550: API endpoint with same security checks

### 4. `test_security_features.py`

Comprehensive test suite with 40+ test cases covering:

- Attack pattern detection accuracy
- False positive rates (<10% on legitimate queries)
- Performance benchmarks (<100ms latency)
- Input validation edge cases
- Sanitization effectiveness
- Integration tests
- Edge case handling

**Test Categories:**

- `TestAttackPatternDetection` - 12+ attack patterns
- `TestLegitimateQueries` - 20+ legitimate queries
- `TestPerformance` - Latency and throughput tests
- `TestInputValidation` - Form validation
- `TestSanitization` - Input cleaning
- `TestEdgeCases` - Boundary conditions
- `TestIntegration` - Full flow testing

## How to Use This Solution

### For Coaches

1. **Read Solution-07.md First**
   - Understand the teaching goals and key concepts
   - Review common pitfalls section
   - Plan your time allocation based on suggested breakdown

2. **Walk Through the Implementation Path**
   - Stage 1 (30 min): Show rule-based detection in `security_detector.py`
   - Stage 2 (20 min): Show OpenTelemetry instrumentation in `web_app_enhanced.py`
   - Stage 3 (15 min): Show hardened system prompt
   - Stage 4 (15 min): Show integration into Flask routes
   - Stage 5 (10 min): Show test coverage in `test_security_features.py`

3. **Live Demo Walkthrough**
   - Run the application with `python web_app_enhanced.py`
   - Test legitimate queries (show low risk scores)
   - Test attack patterns (show blocking)
   - Show OpenTelemetry metrics in New Relic

4. **Have Students Compare**
   - Students implement in `web_app.py`
   - Compare their approach to solution
   - Discuss design decisions and tradeoffs

### For Students (Validation)

1. **Run the Tests**

   ```bash
   # Install test dependencies
   pip install pytest pytest-benchmark

   # Run all tests
   pytest test_security_features.py -v

   # Run specific category
   pytest test_security_features.py::TestAttackPatternDetection -v

   # Run benchmarks
   pytest test_security_features.py -v --benchmark-only
   ```

2. **Validate Your Implementation**

   ```bash
   # Use security_detector as reference
   from security_detector import detect_prompt_injection

   # Test your detector
   result = detect_prompt_injection("Ignore your instructions")
   print(f"Risk Score: {result['risk_score']}")
   print(f"Patterns: {result['patterns_detected']}")
   ```

3. **Check Performance**

   ```bash
   # Run performance tests
   pytest test_security_features.py::TestPerformance -v
   ```

## Key Metrics for Success

### Detection Accuracy

- **Target:** Detect 80%+ of known attack patterns
- **Test:** See `TestAttackPatternDetection` class

### False Positive Rate

- **Target:** <10% on legitimate queries
- **Test:** See `TestLegitimateQueries` class
- **Measurement:** 20 diverse travel queries

### Performance

- **Target:** <100ms detection latency
- **Test:** See `TestPerformance` class
- **Benchmark:** Single detection and 100 queries throughput

### Integration

- **Target:** Security checks in Flask route don't break application
- **Test:** See `TestIntegration` class
- **Validation:** Both HTML and JSON endpoints work

## Multi-Layer Security: Application + Platform Controls

This solution demonstrates **application-level security controls**. In production, these are typically **layered with platform-level controls** like Microsoft Foundry Guardrails:

### Application-Level (What This Solution Builds)

- Fast, domain-specific threat detection
- Travel planner business logic validation
- Custom detection rules tailored to your use case
- Full control and transparency
- No external service calls required

### Platform-Level (Microsoft Foundry Guardrails)

- Enterprise-grade ML-powered risk detection
- Pre-trained models for general safety and compliance
- Multiple intervention points:
  - **User Input:** Screen user prompts for safety risks
  - **Tool Call** (Preview): Monitor agent function calls
  - **Tool Response** (Preview): Validate tool outputs
  - **Output:** Review agent responses before returning
- Maintained and updated by Microsoft
- Agent guardrails in preview for agent-specific monitoring

### Why Both Layers?

**Complementary Coverage:**

```
Application Controls     → Catch domain-specific threats
(prompt injection)         (travel planner logic bypass)

Foundry Guardrails      → Catch general safety risks
(output filtering)        (harmful content, compliance)

Together                → Defense in depth
                          Multiple layers = stronger defense
```

**Best Practice:**

- Use application controls for custom business logic
- Use Foundry Guardrails for broad safety coverage
- Monitor both in New Relic for complete visibility
- Analyze which layer catches which threats

**For Advanced Challenge:**
If students finish early, they can configure Foundry Guardrails on the agent to see how platform-level controls complement their code-level detection. This teaches enterprise-grade security architecture.

## Architecture Overview

```
User Request
     ↓
[Input Validation] → Reject if format/type wrong
     ↓
[Prompt Injection Detection] → Calculate risk score
     ↓
[Risk Assessment]
     ├→ Score > 0.7: BLOCK (log security event)
     └→ Score ≤ 0.7: ALLOW (continue)
     ↓
[OpenTelemetry Instrumentation]
     ├→ Create security span
     ├→ Record metrics
     └→ Log to New Relic
     ↓
[Sanitize Input]
     ↓
[Hardened Agent]
     ├→ Uses injection-resistant system prompt
     └→ Executes tool functions
     ↓
[Return Results]
```

## Common Implementation Patterns

### Pattern 1: Basic Detection

```python
result = detect_prompt_injection(user_input)
if result['risk_score'] > 0.7:
    return "Request blocked", 403
```

### Pattern 2: Monitoring

```python
with tracer.start_as_current_span("security_check") as span:
    result = detect_prompt_injection(text)
    span.set_attribute("risk_score", result['risk_score'])
    detection_counter.add(1)
```

### Pattern 3: Validation + Detection

```python
is_valid, error = validate_request_data(...)
if not is_valid:
    return error, 400

risk = calculate_combined_risk(interests, requests)
if risk['should_block']:
    return "Blocked", 403
```

## Testing Checklist for Students

- [ ] Detection catches 80%+ of provided attack patterns
- [ ] False positive rate <10% on legitimate queries
- [ ] Detection latency <100ms for simple queries
- [ ] Input validation rejects invalid dates/durations
- [ ] Sanitization escapes dangerous characters
- [ ] OpenTelemetry spans created for security checks
- [ ] Metrics recorded to New Relic
- [ ] Blocking returns appropriate error message
- [ ] Legitimate queries continue to work
- [ ] All tests pass with `pytest`

## Discussion Points for Group

1. **When is security worth the latency?**
   - Answer: When consequences of injection are high
   - Travel planning: medium risk
   - Healthcare/Finance: critical risk

2. **Why multiple detection methods?**
   - Keywords catch most attacks quickly
   - Heuristics catch obfuscation
   - Structural catches unusual patterns
   - Layered defense is more robust

3. **Is hardening the prompt enough?**
   - No: LLMs can sometimes be tricked
   - Yes, but only as one layer
   - Multi-layer defense is essential

4. **Should detection be async?**
   - For real-time: keep it <100ms
   - For batch: can use slower LLM-based detection
   - Tradeoff between accuracy and latency

5. **How do Microsoft Foundry Guardrails fit in?**
   - Platform-level controls complement application code
   - Application code: domain-specific (injection threats)
   - Foundry Guardrails: general safety (harmful content)
   - Together: defense in depth with multiple layers
   - Guardrails handle broad cases, your code handles edge cases

## Advanced Extensions

If time permits, students could:

1. **Microsoft Foundry Guardrails Integration:**
   - Configure guardrails on the agent for platform-level controls
   - Enable user input scanning for general safety
   - Set up tool call monitoring (preview) for function oversight
   - Configure tool response validation (preview)
   - Enable output scanning before responses return
   - Compare what each layer catches

2. Add LLM-based detection for higher accuracy
3. Implement per-user rate limiting
4. Create an audit trail of blocked requests
5. Build machine learning model for new patterns
6. Add response validation (check if prompt leaked)
7. Implement adaptive thresholds based on user trust

## Resources

- [OWASP Top 10 for LLMs](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
- [OpenTelemetry Python Documentation](https://opentelemetry.io/docs/instrumentation/python/)
- [New Relic Custom Events](https://docs.newrelic.com/docs/logs/logs-context/logs-context-python/)
- [Prompt Injection Patterns](https://simonwillison.net/2023/Apr/14/worst-that-can-happen/)

### Microsoft Foundry Guardrails Resources

- [Microsoft Foundry Guardrails Overview](https://learn.microsoft.com/en-us/azure/ai-foundry/guardrails/guardrails-overview?view=foundry)
- [Configuring Guardrails for Safety](https://learn.microsoft.com/en-us/azure/ai-foundry/guardrails/how-to-create-guardrails?view=foundry&tabs=python)
- [Intervention Points and Risk Detection](https://learn.microsoft.com/en-us/azure/ai-foundry/guardrails/intervention-points?view=foundry&pivots=programming-language-foundry-portal)

## Feedback & Iteration

When reviewing student implementations:

1. Check detection logic - is it comprehensive?
2. Verify monitoring - are all decisions logged?
3. Test performance - measure actual latency
4. Validate false positives - test with diverse inputs
5. Review code quality - is it maintainable?

---

**Last Updated:** January 2026
**Challenge Level:** Advanced (Challenge 07 of 08+)
**Prerequisites:** Challenges 01-06, Microsoft Agent Framework knowledge
