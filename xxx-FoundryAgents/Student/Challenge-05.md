# Challenge 05 - Implement End-to-End Observability for Foundry Agents

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Pre-requisites

- Complete [Challenge 03](./Challenge-03.md) and [Challenge 04](./Challenge-04.md) so you already have agents deployed that you can observe.
- Ensure your Foundry project is connected to Application Insights.
- Ensure you can authenticate with Azure CLI from your development environment.
- Have at least one existing agent ID available from previous challenges (for example: `TravelAgent`, `NewsAgent`, or your hosted weather agent).

## Introduction

Building an AI agent is only the first step. In production, teams need to answer harder questions: Why did the agent respond this way? Where is latency coming from? How many tokens are being consumed? Is response quality improving or degrading over time? Observability is how you answer those questions with data.

In this challenge, you will implement observability end to end in your Challenge 05 notebook, following the same lifecycle demonstrated in the `azure-ai-foundry-observability-demo` repository: tracing, monitoring, continuous evaluation, and batch evaluation. You will instrument interactions on agents you already created in earlier challenges, inspect telemetry in Foundry and Azure Monitor, and evaluate quality with built-in evaluators.

By the end of this challenge, you will move from basic agent development to operational readiness, where behavior, safety, quality, and performance can be measured and improved continuously.

## Description

In this challenge, you will implement observability capabilities yourself in the Challenge 05 notebook provided by your coach.

Important: You should apply this work to an existing agent from prior challenges. Do not create a brand new Challenge 05-only agent unless your coach explicitly asks you to.

Use the notebook to complete the following implementation goals:

### Environment and Readiness

- Validate that required environment variables, project endpoint configuration, authentication, and model deployment are available.
- Validate that you can reference at least one previously deployed agent ID from earlier challenges.
- Confirm your Foundry project and Application Insights connection are ready to receive and display traces.

### Client-Side Tracing and Traceability

- Add OpenTelemetry instrumentation to your agent client workflow.
- Execute traceable interactions against your previously created agent.
- Execute at least one real SDK run against that existing agent and capture the `thread_id` and `run_id` for evidence.
- Enable trace propagation so related spans across client and service calls can be correlated.
- Capture key telemetry, including run-level latency and token usage.
- Record prompts, responses, and tool arguments in traces for learning purposes, and explain the privacy implications.

### Monitoring and Operational Visibility

- Inspect agent telemetry in Foundry monitoring views.
- Analyze key health indicators such as success rate, latency patterns, and usage trends.
- Cross-check telemetry in Application Insights to understand how trace data flows into Azure Monitor.

### Continuous Evaluation

- Configure a continuous evaluation rule for your agent.
- Generate test traffic so evaluations execute automatically against live responses.
- Review evaluation outcomes in monitoring charts and identify at least one improvement opportunity.

### Batch Evaluation

- Run a batch evaluation using a curated test dataset in your notebook.
- Evaluate results with built-in evaluators such as task adherence, coherence, and safety-related checks.
- Compare per-query outcomes and summarize quality patterns you observe.

### Reflection

- Summarize what the observability signals reveal about your agent's behavior.
- Identify concrete next steps to improve quality, reliability, or cost efficiency.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Demonstrate observability on at least one agent created in a previous challenge (not a new throwaway agent).
- Show evidence of a real run against that existing agent, including captured `thread_id` and `run_id`.
- Verify that traces are emitted from your notebook workflow and visible in Foundry trace views.
- Demonstrate traceability by showing correlated spans for a multi-turn interaction.
- Verify monitoring views display token usage, latency, and success signals for your agent.
- Demonstrate continuous evaluation is configured and produces results on generated traffic.
- Verify batch evaluation runs successfully against a dataset and returns evaluator-level results.
- Show at least one actionable insight derived from your telemetry and evaluation outputs.
- Explain to your coach how tracing, monitoring, continuous evaluation, and batch evaluation complement each other in production operations.

## Learning Resources

- [Azure AI Foundry Observability Demo Repository](https://github.com/darkanita/azure-ai-foundry-observability-demo/tree/master)
- [Set up tracing in Azure AI Foundry](https://learn.microsoft.com/azure/ai-studio/how-to/develop/trace-local-sdk)
- [Add client-side tracing for Foundry agents](https://learn.microsoft.com/azure/ai-studio/how-to/develop/trace-production-sdk)
- [Configure tracing for AI agent frameworks](https://learn.microsoft.com/azure/ai-studio/how-to/develop/trace-agent-framework)
- [Monitor agents with the Agent Monitoring Dashboard](https://learn.microsoft.com/azure/ai-studio/how-to/develop/monitor-agents-dashboard)
- [Evaluate your AI agents](https://learn.microsoft.com/azure/ai-studio/how-to/develop/evaluate-agent)
- [Application Insights and Azure Monitor overview](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview)

## Tips

- If traces do not appear immediately, wait a few minutes and verify your Application Insights connection and project permissions.
- Use synthetic prompts and test data only. Do not place secrets or sensitive user data in prompts, tool arguments, or trace metadata.
- Content recording is useful for learning and debugging but may not be appropriate for production workloads with strict compliance requirements.
- Keep your test dataset small and explicit at first so evaluator outcomes are easy to inspect and discuss.
- When reviewing failures, focus on patterns across multiple runs instead of single outlier responses.

## Advanced Challenges (Optional)

Too comfortable? Eager to do more? Try these additional challenges!

- Build a custom dashboard or workbook in Azure Monitor that highlights your top operational KPIs.
- Add alerts for latency or failure-rate anomalies and define an incident response workflow.
- Extend batch evaluation with additional test cases for adversarial prompts and edge-case behavior.
- Compare two prompt or tool configurations using the same batch dataset to measure quality deltas.