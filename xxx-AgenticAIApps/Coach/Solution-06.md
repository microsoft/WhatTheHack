# Challenge 06 - Enable Agent-to-Agent Communication (A2A) - Coach's Guide

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)** - [Next Solution >](./Solution-07.md)

## Notes & Guidance

In this challenge, participants enable **real-time communication between Azure Agents**, allowing them to exchange context and coordinate actions. This marks the transition from isolated automation to a **collaborative, agentic network** powered by shared threads and dynamic planning.

---

## Goal

Build a communication layer that enables agents to:

- Share context through **shared threads**
- Exchange messages dynamically
- Coordinate actions using **shared memory**
- Optionally leverage **Semantic Kernel** or **Autogen v2** for autonomous planning

---

## 🧩 Shared Thread Communication

Enhance your orchestrator to support **dynamic interaction** between agents.

Create or update `agent_orchestrator.py`:

```python
# 🔹 STUDENT MISSING SECTION: Implement dynamic orchestration method
def orchestrate_dynamic(self, user_input):
    thread = self.create_thread()

    # Step 1: Trigger Anomaly Detector
    self.send_to_agent(thread, "anomaly", user_input)

    # Step 2: Retrieve anomaly message
    messages = self.get_thread_messages(thread)
    anomaly_msg = next((m.content for m in messages if "Anomaly" in m.content), None)

    # Step 3: Trigger Resource Optimizer if anomaly detected
    if anomaly_msg:
        self.send_to_agent(thread, "optimizer", anomaly_msg)

    # Step 4: Retrieve optimization message
    messages = self.get_thread_messages(thread)
    optimization_msg = next((m.content for m in messages if "🛠️" in m.content), None)

    # Step 5: Trigger Alert Manager if optimization succeeded
    if optimization_msg:
        self.send_to_agent(thread, "alert", optimization_msg)

    return self.get_thread_messages(thread)
````

### Explanation

* **Shared thread**: Keeps all agent messages in the same context.
* **Sequential routing**: Each agent reads and reacts to prior messages.
* **Dynamic flow**: The orchestrator adapts based on actual responses.

---

## Update the App to Use Dynamic Orchestration

Update `app.py` so user input triggers your new dynamic orchestration:

```python
# 🔹 STUDENT MISSING SECTION: Integrate orchestrator into app logic
async def handle_user_input(user_input):
    messages = orchestrator.orchestrate_dynamic(user_input)
    return [msg.content for msg in messages]
```

> 💡 The `async` keyword ensures compatibility with future streaming or concurrent message handling.

---

## Add Agent Role Awareness (Optional)

To improve clarity in logs and dashboards, tag messages by agent role.

```python
return [f"{msg.role}: {msg.content}" for msg in messages]
```

Example output:

```
anomaly-detector: High CPU detected
resource-optimizer: Scaling VM to Standard_DS2_v2
alert-manager: Notification sent to admin
```

---

## Optional: Semantic Kernel Integration

For adaptive task routing, integrate **Microsoft Semantic Kernel**:

```python
# 🔹 STUDENT MISSING SECTION: Implement dynamic planning via Semantic Kernel
from semantickernel import Kernel

kernel = Kernel()
plan = kernel.create_plan("Detect and respond to system anomalies")
for step in plan.steps:
    orchestrator.send_to_agent(thread, step.plugin_name, step.description)
```

This enables **goal-driven orchestration**, allowing agents to decide which should act next based on current system state and context.

---

## Expected Behavior

When running the system:

* **Anomaly Detector** identifies anomalies from Azure metrics
* **Resource Optimizer** responds and applies optimizations
* **Alert Manager** notifies users and stakeholders
* All messages and context flow through **shared threads**

Example output:

```
anomaly-detector: Anomaly detected: CPU = 92%
resource-optimizer: Scaling VM to Standard_DS2_v2
alert-manager:  Alert sent: VM scaled successfully
```

---

## Next Steps

Proceed to **Challenge 07** to extend your agentic system with:

* Persistent memory between sessions
* Historical anomaly tracking
* Context-aware planning using Azure AI Foundry or Semantic Kernel

---

All sections marked with `🔹 STUDENT MISSING SECTION` are **what students were expected to implement themselves** in the student guide.
Coaches can reference these to confirm the correctness of submitted solutions.
