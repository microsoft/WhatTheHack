# Challenge 01 - Master the Foundations - Coach's Guide

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

**Read these resources:**

1. [Microsoft Agent Framework GitHub](https://github.com/microsoft/agent-framework)
2. [Agent Framework Documentation](https://learn.microsoft.com/en-us/agent-framework/overview/agent-framework-overview)
3. [ChatAgent Concepts](https://learn.microsoft.com/en-us/agent-framework/tutorials/agents/run-agent?pivots=programming-language-python#create-the-agent-1)
4. [OpenTelemetry Concepts](https://opentelemetry.io/docs/concepts/)
5. [Why Observability Matters](https://docs.newrelic.com/docs/using-new-relic/welcome-new-relic/get-started/introduction-new-relic/#observability)

---

## Common Issues & Troubleshooting

### Issue 1: Confusion Between Agent Framework and Semantic Kernel/AutoGen

**Symptom:** Participants referencing old Semantic Kernel or AutoGen patterns
**Cause:** Prior experience with older Microsoft AI frameworks
**Solution:**

- Explain that Agent Framework unifies and supersedes both
- Point to migration guides in the documentation
- Emphasize the new unified API patterns

### Issue 2: Misunderstanding Tools vs. Plugins

**Symptom:** Participants confused about how to extend agent capabilities
**Cause:** Different terminology across AI frameworks
**Solution:**

- Clarify that "tools" in Agent Framework are Python functions the agent can call
- Show simple tool examples with type hints and docstrings
- Explain how the agent decides which tool to use

### Issue 3: OpenTelemetry Concept Overload

**Symptom:** Participants overwhelmed by traces, spans, metrics, logs terminology
**Cause:** Observability is a new concept for many developers
**Solution:**

- Start with the analogy: traces = story, spans = chapters, metrics = measurements
- Focus on practical value: "You'll see exactly what your agent is doing"
- Show a real trace in New Relic to make it concrete

---

## What Participants Struggle With

- **Understanding ChatAgent:** Help them see it as a conversation manager that can use tools to answer questions
- **Grasping Observability Value:** Use concrete examples like "knowing why a travel plan took 10 seconds vs 2 seconds"
- **Async/Await Concepts:** Some may need a quick refresher on Python async patterns
- **Connecting Theory to Practice:** Keep referring back to "you'll implement this in the next challenge"

---

## Time Management

**Expected Duration:** 30 minutes
**Minimum Viable:** 20 minutes (quick overview with references for later)
**Stretch Goals:** +15 minutes (for deeper discussion and Q&A)

---

## Validation Checklist

Coach should verify participants can:

- [ ] Explain what the Microsoft Agent Framework is and its relationship to Semantic Kernel/AutoGen
- [ ] Describe what a ChatAgent does and how tools extend its capabilities
- [ ] Define traces, spans, metrics, and logs in their own words
- [ ] Articulate why observability matters for AI applications
- [ ] Identify at least 3 things they'd want to observe in an AI travel planner
