# Challenge 06 - Enable Agent-to-Agent Communication (A2A)

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

In this challenge, you will enhance your multi-agent system by enabling **direct communication between agents**.  

Your agents—**Anomaly Detector**, **Resource Optimizer**, and **Alert Manager**—will now share context and coordinate actions dynamically through a **shared thread**.  

This step transforms your system from a static orchestration sequence into a **fully agentic network**, allowing agents to collaborate intelligently and make decisions based on previous outputs.  

You will also explore optional **Semantic Kernel integration** for dynamic planning and goal-driven agent behavior.

---

## Description

Your task is to extend the orchestrator from Challenge 05 to enable **agent-to-agent communication**.

You will:

- Update `agent_orchestrator.py` to implement dynamic routing through shared threads.
- Ensure agents can read messages from the thread, respond appropriately, and pass results to the next agent.
- Optionally integrate Semantic Kernel for intelligent, goal-based agent planning.
- Modify `app.py` (if using a UI) to call the new dynamic orchestrator method.

Below is a partial skeleton for your orchestrator logic. Complete the missing functionality:

```python
def orchestratedynamic(self, user_input):
    thread = self.create_thread()

    # Step 1: Anomaly Detector
    self.send_to_agent(thread, "anomaly", user_input)

    # Step 2: Read anomaly message
    messages = self.get_thread_messages(thread)
    anomaly_msg = next((m.content for m in messages if "Anomaly" in m.content), None)

    # Step 3: Resource Optimizer
    if anomaly_msg:
        self.send_to_agent(thread, "optimizer", anomaly_msg)

    # Step 4: Read optimization message
    messages = self.get_thread_messages(thread)
    optimization_msg = next((m.content for m in messages if "🛠️" in m.content), None)

    # Step 5: Alert Manager
    if optimization_msg:
        self.send_to_agent(thread, "alert", optimization_msg)

    return self.get_thread_messages(thread)
````

### Optional: Semantic Kernel Planning

You may optionally add **goal-driven orchestration**:

```python
from semantickernel import Kernel

kernel = Kernel()
plan = kernel.create_plan("Detect and respond to system anomalies")
for step in plan.steps:
    orchestrator.send_to_agent(thread, step.plugin_name, step.description)
```

This enables your orchestrator to decide dynamically which agent to call next based on the context.

---


## Learning Resources

* [Azure AI Foundry Overview](https://learn.microsoft.com/en-us/azure/ai-services/)
* [Python Threading & Concurrency](https://realpython.com/intro-to-python-threading/)
* [Introduction to Multi-Agent Systems](https://learn.microsoft.com/en-us/azure/architecture/guide/ai/design-multi-agent-systems)
* [Empowering Multi-Agent Apps with the Open Agent2Agent (A2A) Protocol](https://www.microsoft.com/en-us/microsoft-cloud/blog/2025/05/07/empowering-multi-agent-apps-with-the-open-agent2agent-a2a-protocol/?utm_source=chatgpt.com)

---

## Tips

* Test each agent individually before running the full orchestrator.
* Use logging statements to visualize message flow in the shared thread.
* Make sure thread messages are correctly tagged with agent names to aid debugging.
* Start simple: first pass static messages, then add dynamic routing logic.


---

## Success Criteria

To complete this challenge successfully, you should be able to:

* Verify that all three agents communicate through a shared thread.
* Confirm that messages from one agent are correctly routed to the next.
* Demonstrate console output showing step-by-step interactions:

```
anomaly-detector: Anomaly detected: CPU = 92%
resource-optimizer: Scaling VM to Standard_DS2_v2
alert-manager: Alert sent: VM scaled successfully
```

* Optionally, show dynamic routing with Semantic Kernel if implemented.
---

## Next Steps

Proceed to **Challenge 07** to implement **memory persistence**, long-term knowledge storage, and context-aware planning to make your agents even more autonomous and intelligent.

```
