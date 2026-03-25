# Challenge 05 - Monitoring Best Practices

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

You're now sending telemetry to New Relic, but raw data alone isn't enough. Without dashboards and alerts, you're manually checking traces all the time, you won't notice problems until customers complain, and you can't track performance trends over time.

In this challenge, you'll learn industry best practices for monitoring AI-driven applications by creating custom dashboards, setting up alerts, defining Service Level Objectives (SLOs), tracking deployment changes, and collecting key metrics that matter for your travel planning service.

## Description

Your goal is to build a comprehensive monitoring solution for WanderAI that includes dashboards, alerts, SLOs, deployment tracking, and meaningful metrics collection.

### Part 1: Enhanced Metrics Collection

Add custom metrics to your application using the OpenTelemetry meter:

- **Request Counter** - Track total number of travel plan requests per destination
- **Error Counter** - Track total number of errors, think about different error types
- **Tool Call Counter** - Track how often each tool is called

Emit these metrics from your application code at appropriate points (request handlers, error handlers, tool functions). Check mock application code for examples and hints of how to create and record metrics using the get_meter() helper function.

### Part 2: Create a New Relic Dashboard

Build a dashboard in New Relic called "WanderAI Agent Performance" that visualizes:

- Request rate over time, e.g. `SELECT rate(count(*), 1 minute) FROM Metric WHERE metricName = 'travel_plan.requests.total' TIMESERIES SINCE TODAY`
- Error rate over time
- Average response time
- Tool usage breakdown by tool name

Use [New Relic Query Language (NRQL)](https://docs.newrelic.com/docs/nrql/get-started/introduction-nrql-new-relics-query-language/) queries to power your dashboard widgets.

### Part 3: Set Up Alerts

Configure alerts in New Relic to notify your team when:

- Error rate exceeds a threshold (e.g., 5 errors in 5 minutes)
- Response times are slow (e.g., p95 latency exceeds 25 seconds)
- Specific tools are failing repeatedly

### Part 4: Define Service Level Objectives (SLOs)

SLOs shift your monitoring mindset from reactive ("something broke, let's fix it") to proactive ("are we meeting our promises to users?"). Define Service Level Indicators (SLIs) and their corresponding objectives for WanderAI:

- **Availability SLO** — Define an SLI based on successful (non-5xx) responses. Set an objective such as 99.5% over a rolling 7-day window.
- **Latency SLO** — Define an SLI based on response time. For example, 95% of requests should complete in under 10 seconds over a rolling 7-day window.
- **AI Quality SLO** (stretch) — If you instrumented an AI quality score in earlier challenges, define an SLI for it (e.g., 90% of responses score above a quality threshold).

Create these SLOs in New Relic using the [Service Level Management](https://docs.newrelic.com/docs/service-level-management/intro-slm/) UI. Then:

- Add an **SLO summary widget** to your dashboard showing remaining error budget.
- Configure an **alert on SLO burn rate** so you're notified when you're consuming error budget too fast (e.g., a fast-burn alert that fires when your burn rate exceeds 10x normal).

### Part 5: Change Tracking & Deployment Markers

When performance degrades, the first question is always: "Did we deploy something?" Deployment markers let you correlate regressions with specific changes.

- **Record a deployment marker** using the [New Relic Change Tracking API](https://docs.newrelic.com/docs/change-tracking/change-tracking-introduction/). Include attributes like version, commit SHA, and deployer.
- **Visualize deployments on your dashboard** — Add a billboard or timeline widget that shows recent deployments alongside your performance charts.
- **Correlate a change** — After recording a marker, trigger a few requests and confirm you can see the deployment event overlaid on your metrics charts in New Relic.

A simple example using `curl`:

```bash
curl -X POST "https://api.newrelic.com/graphql" \
  -H "Content-Type: application/json" \
  -H "API-Key: YOUR_USER_API_KEY" \
  -d '{
    "query": "mutation { changeTrackingCreateDeployment(deployment: {version: \"1.0.1\", entityGuid: \"YOUR_ENTITY_GUID\", description: \"Added custom metrics and SLOs\"}) { entityGuid deploymentId } }"
  }'
```

### Key Metrics to Monitor

For a travel planning agent, focus on:

| Metric | Why It Matters | Target |
| -------- | ---------------- | -------- |
| Response Time (p95) | Speed affects user experience | < 3 seconds |
| Error Rate | Reliability | < 1% |
| Token Usage (avg) | Cost per request | < 500 tokens |
| Tool Success Rate | Accuracy | > 95% |

## Success Criteria

To complete this challenge successfully, you should be able to:

- [ ] Demonstrate that custom metrics are being collected and exported to New Relic
- [ ] Show a dashboard with at least 5 widgets visualizing different aspects of your application
- [ ] Verify that at least 2 alerts are configured and working
- [ ] Demonstrate that you can write custom NRQL queries to analyze your data
- [ ] Show at least one SLO defined with a corresponding error budget alert
- [ ] Record a deployment marker and show it correlated with your metrics on the dashboard
- [ ] Show that your team can access and understand the dashboard

## Learning Resources

- [New Relic Dashboards](https://docs.newrelic.com/docs/query-your-data/explore-query-data/dashboards/introduction-dashboards/)
- [New Relic Query Language (NRQL)](https://docs.newrelic.com/docs/nrql/get-started/introduction-nrql-new-relics-query-language/)
- [New Relic Alerts](https://docs.newrelic.com/docs/alerts-applied-intelligence/new-relic-alerts/learn-alerts/introduction-alerts/)
- [OpenTelemetry Metrics](https://opentelemetry.io/docs/concepts/signals/metrics/)
- [Service Level Objectives (SLOs)](https://docs.newrelic.com/docs/service-level-management/intro-slm/)
- [New Relic Change Tracking](https://docs.newrelic.com/docs/change-tracking/change-tracking-introduction/)

## Tips

- Use consistent, hierarchical naming for metrics (e.g., `travel_plan.requests.total`, `travel_plan.errors.total`)
- Know what "normal" looks like before problems occur - establish baselines
- Start with conservative alert thresholds and tune as you learn your system's behavior
- Keep dashboards focused - don't overwhelm with too many charts
- Consider adding environment attributes to distinguish between dev/staging/production

## Advanced Challenges (Optional)

- Define an AI Quality SLO based on evaluation scores from your agent responses
- Set up notification channels (Slack, PagerDuty) for your alerts
- Build a dashboard that shows trends over time to identify gradual degradation
- Automate deployment marker creation in a CI/CD pipeline (e.g., GitHub Actions) so every deploy is tracked automatically
- Create a "Change Impact" dashboard page that compares error rate and latency before vs. after each deployment
