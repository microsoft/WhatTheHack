# Challenge 05 - Monitoring Best Practices

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

You're now sending telemetry to New Relic, but raw data alone isn't enough. Without dashboards and alerts, you're manually checking traces all the time, you won't notice problems until customers complain, and you can't track performance trends over time.

In this challenge, you'll learn industry best practices for monitoring AI-driven applications by creating custom dashboards, setting up alerts, and tracking key metrics that matter for your travel planning service.

## Description

Your goal is to build a comprehensive monitoring solution for WanderAI that includes dashboards, alerts, and meaningful metrics collection.

### Part 1: Enhanced Metrics Collection

Add custom metrics to your application using the OpenTelemetry meter:

- **Request Counter** - Track total number of travel plan requests per destination
- **Error Counter** - Track total number of errors, think about different error types
- **Tool Call Counter** - Track how often each tool is called

Emit these metrics from your application code at appropriate points (request handlers, error handlers, tool functions). Check mock application code for examples and hints of how to create and record metrics using the get_meter() helper function.

### Part 2: Create a New Relic Dashboard

Build a dashboard in New Relic called "WanderAI Agent Performance" that visualizes:

- Request rate over time
- Error rate over time
- Average response time
- Tool usage breakdown by tool name
- Trace count by service

Use NRQL queries to power your dashboard widgets.

### Part 3: Set Up Alerts

Configure alerts in New Relic to notify your team when:

- Error rate exceeds a threshold (e.g., 5 errors in 5 minutes)
- Response times are slow (e.g., p95 latency exceeds 25 seconds)
- Specific tools are failing repeatedly

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
- [ ] Show that your team can access and understand the dashboard

## Learning Resources

- [New Relic Dashboards](https://docs.newrelic.com/docs/query-your-data/explore-query-data/dashboards/introduction-dashboards/)
- [NRQL Query Language](https://docs.newrelic.com/docs/query-your-data/nrql-new-relic-query-language/get-started/introduction-nrql-new-relics-query-language/)
- [New Relic Alerts](https://docs.newrelic.com/docs/alerts-applied-intelligence/new-relic-alerts/learn-alerts/introduction-alerts/)
- [OpenTelemetry Metrics](https://opentelemetry.io/docs/concepts/signals/metrics/)
- [Service Level Objectives (SLOs)](https://docs.newrelic.com/docs/service-level-management/intro-slm/)

## Tips

- Use consistent, hierarchical naming for metrics (e.g., `travel_plan.requests.total`, `travel_plan.errors.total`)
- Know what "normal" looks like before problems occur - establish baselines
- Start with conservative alert thresholds and tune as you learn your system's behavior
- Keep dashboards focused - don't overwhelm with too many charts
- Consider adding environment attributes to distinguish between dev/staging/production

## Advanced Challenges (Optional)

- Define Service Level Indicators (SLIs) and Service Level Objectives (SLOs) for your application
- Create alerts for SLO violations to catch issues before they impact customers
- Set up notification channels (Slack, PagerDuty) for your alerts
- Build a dashboard that shows trends over time to identify gradual degradation
