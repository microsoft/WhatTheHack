# Challenge 06 - LLM Evaluation & Quality Gates - Coach's Guide

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)**

## Notes & Guidance

Guide attendees to implement the core of New Relic's AI Monitoring platform: custom events that unlock model inventory, comparison, and LLM-based quality evaluation (toxicity, negativity, safety).

## Core Concept: Custom Events as Foundation

OpenTelemetry defines an [Event](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#events) as a `LogRecord` with a non-empty [EventName](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-eventname). [Custom Events](https://docs.newrelic.com/docs/data-apis/custom-data/custom-events/report-custom-event-data/) are a core signal in the New Relic platform. However, despite using the same name, OpenTelemetry Events and New Relic Custom Events are not identical concepts:

- OpenTelemetry `EventName`s do not share the same format or [semantics](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/general/events.md) as Custom Event types. OpenTelemetry Event names are fully qualified with a namespace and follow lower snake case, e.g. `com.acme.my_event`. Custom Event types are pascal case, e.g. `MyEvent`.
- OpenTelemetry Events can be thought of as an enhanced structured log. Like structured logs, their data is encoded in key-value pairs rather than free form text. In addition, the `EventName` acts as an unambiguous signal of the class / type of event which occurred. Custom Events are treated as an entirely new event type, accessible via NRQL with `SELECT * FROM MyEvent`.

Because of these differences, OpenTelemetry Events are ingested as New Relic `Logs` since most of the time, OpenTelemetry Events are closer in similarity to New Relic `Logs` than New Relic Custom Events.

However, you can explicitly signal that an OpenTelemetry `LogRecord` should be ingested as a Custom Event by adding an entry to `LogRecord.attributes` following the form: `newrelic.event.type=<EventType>`.

For example, a `LogRecord` with attribute `newrelic.event.type=MyEvent` will be ingested as a Custom Event with `type=MyEvent`, and accessible via NRQL with: `SELECT * FROM MyEvent`.

The `newrelic.event.type` attribute in logger.info() calls is THE mechanism that:

- **Populates Model Inventory** - Tracks every LLM and version
- **Enables Model Comparison** - Compares performance across models
- **Powers Quality Dashboards** - Shows AI behavior and trends
- **Unlocks LLM Evaluation** - Integrates toxicity/negativity checks

## Key Points

1. **Custom Events First** - Emit `LlmChatCompletionMessage` (2x) and `LlmChatCompletionSummary`
2. **LLM-Based Evaluation** - Use another LLM to check responses for toxicity, negativity, safety
3. **Rule-Based Checks** - Add business logic validation (structure, completeness, etc.)
4. **CI/CD Integration** - Automate quality gates and block bad responses

## Implementation Path

- Reference: `web_app.py` lines 439-509 (custom events template)
- Create `evaluation.py` with TravelPlanEvaluator class
- Integrate evaluation into Flask routes
- Add metrics/counters for New Relic dashboard
- Test with different models and prompts

## Tips

- Start with the custom events—everything else builds on them.
- Show attendees how to view events in New Relic.
- Demonstrate LLM evaluation catching toxicity/negativity (run with `NEGATIVITY_PROMPT_ENABLE=true`).
- Explain model inventory and comparison features.

## Common Pitfalls

- Skipping custom events (missing the core value).
- Not testing LLM-based evaluation thoroughly.
- Overcomplicating rule-based checks.
- Not setting up metrics in New Relic.

## Success Criteria

- Custom events are emitted for every LLM interaction.
- Model inventory and comparison visible in New Relic.
- LLM-based evaluation detects toxicity/negativity.
- Rule-based checks work for business logic.
- Quality metrics displayed in dashboard.
- Attendees understand how New Relic AI Monitoring works.

---

## Common Issues & Troubleshooting

### Issue 1: AI Monitoring Section Not Visible in New Relic

**Symptom:** Can't find AI Monitoring in New Relic navigation
**Cause:** Feature not pinned or custom events not being received
**Solution:**

- Click "All Capabilities" in New Relic sidebar
- Search for "AI Monitoring" and pin it to navigation
- Verify custom events are being sent (check Logs for `[agent_response]`)
- Ensure `newrelic.event.type` attribute is set correctly
- Wait 2-3 minutes for data to populate

### Issue 2: Model Inventory Empty

**Symptom:** AI Monitoring shows but no models listed
**Cause:** `LlmChatCompletionMessage` events missing required attributes
**Solution:**

- Verify both user and assistant messages are logged
- Check `response.model` attribute is set correctly
- Ensure `vendor` attribute is set (e.g., "openai")
- Verify `completion_id` is unique per interaction
- Check NRQL: `FROM LlmChatCompletionMessage SELECT * LIMIT 10`

### Issue 3: LLM Evaluation Returns Parse Errors

**Symptom:** Evaluation fails with JSON decode errors
**Cause:** LLM response not valid JSON or includes markdown formatting
**Solution:**

- Add explicit instruction: "Return ONLY valid JSON, no markdown"
- Strip markdown code blocks from response before parsing
- Use try/except with fallback evaluation result
- Consider using structured output if model supports it
- Reference `evaluation.py` for robust JSON extraction

### Issue 4: Evaluation Takes Too Long

**Symptom:** Each request takes 10+ seconds due to evaluation
**Cause:** LLM evaluation adds latency for every request
**Solution:**

- Use `skip_llm=True` for real-time requests, run LLM evaluation async
- Cache evaluation results for similar responses
- Use a faster/smaller model for evaluation (gpt-5-mini)
- Run rule-based checks first, only LLM evaluate if needed
- Consider batch evaluation for non-real-time use cases

### Issue 5: Quality Metrics Not Showing in Dashboard

**Symptom:** Evaluation counters/histograms not visible
**Cause:** Metrics not exported or wrong metric names
**Solution:**

- Verify meter is configured with OTLP exporter
- Check metric names match dashboard queries
- Use `FROM Metric SELECT * WHERE metricName LIKE 'travel%'`
- Ensure `.add()` and `.record()` are being called
- Check for typos in metric attribute names

### Issue 6: Toxicity/Negativity Not Being Detected

**Symptom:** Clearly problematic content passes evaluation
**Cause:** Evaluation prompt not specific enough or wrong thresholds
**Solution:**

- Review and refine the evaluator agent's instructions
- Lower passing thresholds (e.g., score >= 7 instead of >= 6)
- Test with known-bad examples to calibrate
- Check LLM evaluation raw response for debugging
- Use `NEGATIVITY_PROMPT_ENABLE=true` to test detection

---

## What Participants Struggle With

- **Custom Event Structure:** Walk through the exact attributes needed for `LlmChatCompletionMessage` and `LlmChatCompletionSummary`
- **Understanding newrelic.event.type:** Explain this is the magic attribute that unlocks AI Monitoring features
- **Evaluation Design:** Help them think about what "quality" means for their travel planner
- **Async Evaluation:** Guide them on when to evaluate synchronously vs. asynchronously
- **CI/CD Integration:** Show how pytest and GitHub Actions work together for quality gates

---

## Time Management

**Expected Duration:** 1 hour
**Minimum Viable:** 45 minutes (custom events + rule-based evaluation)
**Stretch Goals:** +30 minutes (LLM evaluation, CI/CD pipeline, advanced metrics)

---

## Validation Checklist

Coach should verify participants have:

- [ ] Custom events emitting `LlmChatCompletionMessage` for user and assistant
- [ ] Custom events emitting `LlmChatCompletionSummary` for each interaction
- [ ] AI Monitoring section accessible in New Relic
- [ ] Model inventory shows their model (gpt-5-mini or similar)
- [ ] Rule-based evaluation checking response structure and content
- [ ] Evaluation results logged/exported to New Relic
- [ ] Can demonstrate evaluation catching a bad response (optional: LLM evaluation)
- [ ] Can explain how quality gates would work in production
