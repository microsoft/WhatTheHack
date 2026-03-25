# Challenge 05 - Monitoring Best Practices - Coach's Guide

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

Help attendees set up dashboards, alerts, and monitoring best practices for their agent app.

### Key Points

- Dashboards: Create meaningful dashboards for key metrics/traces.
- Alerts: Set up alerts for errors, latency, and critical events.
- Best practices: Discuss what to monitor in agent-powered apps.

### Tips

- Demonstrate dashboard/alert setup in New Relic.
- Focus on actionable data for dashboards.
- Reference monitoring best practices docs.

### Pitfalls

- Too many metrics in dashboards.
- Not testing alerts.

### Success Criteria

- Dashboards and alerts are set up and tested.
- Attendees can explain their monitoring strategy.

---

## Common Issues & Troubleshooting

### Issue 1: NRQL Query Returns No Data

**Symptom:** Dashboard widget shows "No data" or query returns empty
**Cause:** Wrong attribute names, time range, or data not ingested
**Solution:**

- Check attribute names match exactly (case-sensitive)
- Expand time range to "Last 24 hours" to find data
- Use `FROM Span SELECT *` to see available attributes
- Verify data is being sent (check Challenge 04 validation)
- Wait a few minutes if data was just sent

### Issue 2: Alert Not Triggering

**Symptom:** Condition met but no alert notification
**Cause:** Alert policy not configured or notification channel missing
**Solution:**

- Verify alert condition is in an active policy
- Check notification channel (email/Slack) is configured and verified
- Review condition threshold—may be set too high
- Test with artificially low threshold to verify pipeline works
- Check alert condition preview to see if it would have triggered

### Issue 3: Dashboard Permissions Error

**Symptom:** Can't share dashboard or others can't view it
**Cause:** Dashboard visibility settings or account permissions
**Solution:**

- Change dashboard visibility: Edit → Settings → Permissions
- For cross-account sharing, dashboard must be "Public"
- Verify recipient has access to the New Relic account
- Consider using dashboard JSON export/import for sharing

### Issue 4: Metric Aggregation Confusion

**Symptom:** Numbers don't match expectations or seem wrong
**Cause:** Wrong aggregation function for the metric type
**Solution:**

- Counters: use `sum()` or `rate()`
- Histograms: use `average()`, `percentile()`, or `histogram()`
- For request counts: `count(*)` not `sum(*)`
- Check time bucket size (TIMESERIES clause)

### Issue 5: Too Many Alerts (Alert Fatigue)

**Symptom:** Receiving too many alert notifications
**Cause:** Thresholds too sensitive or missing incident preferences
**Solution:**

- Add minimum duration (e.g., "for at least 5 minutes")
- Use sliding window aggregation to smooth out spikes
- Configure incident preference: "By condition" vs "By condition and signal"
- Consider warning thresholds before critical alerts

---

## What Participants Struggle With

- **NRQL Syntax:** Provide a cheat sheet with common queries for their use case
- **Choosing What to Monitor:** Guide them to the "four golden signals": latency, traffic, errors, saturation
- **Dashboard Design:** Encourage starting with 3-5 key metrics, not everything at once
- **Alert Threshold Selection:** Help them think about "what number means I need to wake up?"
- **Understanding Percentiles:** Explain why p99 latency matters more than average for user experience

---

## Time Management

**Expected Duration:** 1 hour
**Minimum Viable:** 45 minutes (basic dashboard with 3-5 widgets, one alert)
**Stretch Goals:** +30 minutes (advanced NRQL, multiple alert conditions, shared dashboard)

---

## Validation Checklist

Coach should verify participants have:

- [ ] Dashboard created with at least 3 meaningful widgets
- [ ] Request latency visualization (histogram or timeseries)
- [ ] Error rate or error count widget
- [ ] Agent/tool call breakdown or performance widget
- [ ] At least one alert condition configured
- [ ] Alert notification channel set up (email or Slack)
- [ ] Can explain what each dashboard widget shows and why it matters
- [ ] Alert has been tested (either triggered or threshold logic verified)
