# Challenge 04 - Custom Instrumentation with OpenTelemetry - Coach's Guide

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

Guide attendees to add custom spans, metrics, and logging to their app, then verify those custom signals in New Relic.

### Key Points

- Manual spans: Add custom spans for tools, routes, and business logic.
- Custom metrics: Record meaningful measurements for the app.
- Structured logging: Correlate logs with spans using trace context.
- Verification: Confirm custom signals appear alongside auto-generated telemetry in New Relic.

### Tips

- Start with one route and one tool to demonstrate custom spans.
- Use `get_tracer()` and `get_meter()` from Agent Framework for consistency.
- Add span attributes for key context (destination, duration, tool name).
- Validate in New Relic by opening a trace and expanding custom spans.

### Pitfalls

- Too many spans or attributes (noise and cardinality).
- Spans created outside of a current context (flat traces).
- Metrics recorded but never emitted due to meter misconfiguration.

### Success Criteria

- Custom spans appear in New Relic traces alongside auto-generated spans.
- Custom metrics appear in New Relic Metrics Explorer.
- Logs correlate with spans using trace context.
- Attendees can explain auto-generated vs custom telemetry.

### Example solution implementation

The [Example solution implementation](./Solutions/Challenge-04/) folder contains sample implementation of the challenge 4. It contains:

- **[web_app.py](./Solutions/Challenge-04/web_app.py)**: Python Flask web application with Agent framework implementation
- **[templates/index.html](./Solutions/Challenge-04/templates/index.html)**: sample web UI form
- **[templates/result.html](./Solutions/Challenge-04/templates/result.html)**: sample web UI travel planner result view
- **[templates/error.html](./Solutions/Challenge-04/templates/error.html)**: sample web UI error view
- **[static/styles.css](./Solutions/Challenge-04/static/styles.css)**: CSS files for HTML views

---

## Common Issues & Troubleshooting

### Issue 1: Spans Not Nested Correctly

**Symptom:** Traces show flat structure instead of parent-child relationships
**Cause:** Context not propagated between spans
**Solution:**

- Use `with` statement for automatic context management
- Ensure child spans are created inside parent span's `with` block
- Don't create new event loops inside span contexts
- Use `tracer.start_as_current_span()` not `tracer.start_span()`

### Issue 2: Metrics Not Recording

**Symptom:** Counters/histograms created but values always zero
**Cause:** Metrics not being called or meter not configured
**Solution:**

- Verify `.add()` or `.record()` is actually being called
- Check that metric names don't have invalid characters
- Ensure meter is created from the same provider as tracer
- Add debug logging to confirm metric recording code executes

### Issue 3: Logs Not Correlating with Traces

**Symptom:** Logs appear but aren't linked to traces in backend
**Cause:** Logger not configured with OpenTelemetry handler
**Solution:**

- Add `LoggingHandler` from opentelemetry to root logger
- Include span context in log records
- Use structured logging with `extra={}` parameter
- Reference solution code for correct logging setup

### Issue 4: Missing Span Attributes

**Symptom:** Spans show up, but lack useful context
**Cause:** Attributes not being set or added too late
**Solution:**

- Add attributes at span creation time
- Use semantic conventions where available
- Avoid high-cardinality attributes (e.g., full prompts)

### Issue 5: Too Many Spans or High Cardinality

**Symptom:** Traces are noisy or slow to query
**Cause:** Too many spans or high-cardinality attributes
**Solution:**

- Keep spans at logical boundaries
- Avoid per-token or per-message spans
- Limit attributes with unbounded values

---

## What Participants Struggle With

- **Understanding Span Hierarchy:** Use diagrams to show parent-child span relationships
- **Where to Add Instrumentation:** HTTP requests, agent runs, tool calls, external API calls
- **Metric Types:** Counters (events) vs. histograms (durations/distributions)
- **Attribute Naming:** Encourage semantic conventions (e.g., `http.method`, `destination.name`)
- **Too Much vs. Too Little:** Balance visibility vs. noise

---

## Time Management

**Expected Duration:** 1 hour
**Minimum Viable:** 45 minutes (custom spans for main request flow)
**Stretch Goals:** +30 minutes (custom metrics and log correlation)

---

## Validation Checklist

Coach should verify participants have:

- [ ] Custom spans wrap key operations (routes, agent run, tools)
- [ ] Spans include relevant attributes (destination, duration, tool name)
- [ ] At least one custom metric (counter or histogram) is recording data
- [ ] Logs include trace context for correlation
- [ ] Traces show both auto-generated and custom spans
- [ ] Custom metrics visible in New Relic Metrics Explorer
- [ ] Logs visible and correlated with spans in New Relic
