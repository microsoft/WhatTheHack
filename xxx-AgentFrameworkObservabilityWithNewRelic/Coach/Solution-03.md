# Challenge 03 - Add OpenTelemetry Instrumentation - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

Help attendees initialize built-in OpenTelemetry for their agent app, verify telemetry in the console, and then confirm the same telemetry in New Relic.

### Key Points

- Observability setup: Initialize OpenTelemetry using Agent Framework helpers.
- Console verification: Confirm traces/metrics appear locally first.
- New Relic verification: Switch to OTLP and confirm the same signals in New Relic.

### Tips

- Demonstrate the minimal setup (e.g., `configure_otel_providers()` + service resource).
- Encourage console verification before switching to OTLP.
- Remind attendees it can take a few minutes for data to appear in New Relic.
- Reference OpenTelemetry + Agent Framework docs for initialization.

### Pitfalls

- Forgetting to set OTLP endpoint or API key.
- Using the wrong New Relic key type.
- Expecting custom spans before adding manual instrumentation.

### Success Criteria

- App emits built-in traces and metrics to the console.
- Same built-in signals appear in New Relic via OTLP.
- Attendees can explain the difference between auto-generated vs custom telemetry.

### Example solution implementation

The [Example solution implementation](./Solutions/Challenge-03/) folder contains sample implementation of the challenge 3. It contains:

- **[web_app.py](./Solutions/Challenge-03/web_app.py)**: Python Flask web application with Agent framework implementation
- **[templates/index.html](./Solutions/Challenge-03/templates/index.html)**: sample web UI form
- **[templates/result.html](./Solutions/Challenge-03/templates/result.html)**: sample web UI travel planner result view
- **[templates/error.html](./Solutions/Challenge-03/templates/error.html)**: sample web UI error view
- **[static/styles.css](./Solutions/Challenge-03/static/styles.css)**: CSS files for HTML views

---

## Common Issues & Troubleshooting

### Issue 1: No Traces/Spans Appearing

**Symptom:** Code runs but no telemetry data is generated
**Cause:** OpenTelemetry not initialized or exporters not configured
**Solution:**

- Verify `configure_otel_providers()` is called before creating tracer/meter
- Check that `get_tracer()` and `get_meter()` are called after setup
- Add a console exporter temporarily to verify data is being generated

### Issue 2: Import Errors for OpenTelemetry

**Symptom:** `ModuleNotFoundError: No module named 'opentelemetry'`
**Cause:** OpenTelemetry packages not installed
**Solution:**

- Run `pip install opentelemetry-api opentelemetry-sdk`
- Install exporters: `pip install opentelemetry-exporter-otlp`
- Check requirements.txt includes all OTel dependencies
- Restart Python/terminal after installing

### Issue 3: No Data Appearing in New Relic

**Symptom:** App runs, but New Relic shows no traces/metrics
**Cause:** OTLP endpoint or API key misconfigured
**Solution:**

- Verify `OTEL_EXPORTER_OTLP_ENDPOINT` matches your region
- Check `OTEL_EXPORTER_OTLP_HEADERS` includes `api-key=<YOUR_LICENSE_KEY>`
- Ensure the license key is an INGEST key
- Wait 1-2 minutes for data to appear

### Issue 4: 401/403 Authentication Errors

**Symptom:** Exporter logs show authentication failures
**Cause:** Invalid or wrong type of New Relic license key
**Solution:**

- Create a new INGEST license key in New Relic
- Remove whitespace or quotes from the key
- Verify the key matches the account you're viewing
- For EU accounts, use `https://otlp.eu01.nr-data.net`

### Issue 5: gRPC Connection Errors

**Symptom:** `grpc._channel._InactiveRpcError` or connection refused
**Cause:** Firewall blocking gRPC or wrong port
**Solution:**

- Ensure port 4317 (gRPC) is not blocked
- Try HTTP endpoint: `https://otlp.nr-data.net:4318/v1/traces`
- Check proxy/VPN settings

---

## What Participants Struggle With

- **Finding the Right Endpoint:** US vs EU regions and gRPC vs HTTP
- **License Key Types:** Ingest keys vs user keys
- **Waiting for Data:** First data may take 1-2 minutes to appear
- **Navigating New Relic:** APM, Distributed Tracing, Metrics Explorer

---

## Time Management

**Expected Duration:** 45 minutes
**Minimum Viable:** 30 minutes (traces visible in console and New Relic)
**Stretch Goals:** +15 minutes (verify metrics, explore trace details)

---

## Validation Checklist

Coach should verify participants have:

- [ ] OpenTelemetry SDK initialized with service resource attributes
- [ ] Console exporter shows traces/metrics during a request
- [ ] OTLP environment variables set correctly
- [ ] Traces visible in New Relic Distributed Tracing
- [ ] Service name appears correctly in New Relic APM
- [ ] Attendees can explain auto-generated vs custom telemetry
