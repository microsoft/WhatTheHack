```markdown
# Challenge 05 - Orchestrate Agent-to-Agent Communication - Coach's Guide

[< Previous Solution](./Solution-04.md) - **[Home](../README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

This challenge connects all previous agents — **Anomaly Detector**, **Resource Optimizer**, and **Alert Manager** — into a unified system.  
It introduces **message routing**, **shared threads for memory**, and optional **Semantic Kernel planning** for adaptive orchestration.

---

### Environment Setup

Install dependencies:

```bash
pip install python-dotenv azure-ai-foundry
````

Ensure all three agents are already registered and available in your workspace.

---

### Orchestrator Initialization

Create `agent_orchestrator.py`:

```python
from azure.ai.foundry import AgentClient, Thread
from dotenv import load_dotenv
import os

load_dotenv()

class AgentOrchestrator:
    def __init__(self):
        # 🔹 STUDENT MISSING SECTION: Initialize AgentClient and map agent names
        self.client = AgentClient()
        self.agents = {
            "anomaly": "anomaly-detector",
            "optimizer": "resource-optimizer",
            "alert": "alert-manager"
        }

    # 🔹 STUDENT MISSING SECTION: Create a new communication thread for shared state
    def create_thread(self):
        return self.client.create_thread()

    # 🔹 STUDENT MISSING SECTION: Define how messages are routed to each agent
    def send_to_agent(self, thread: Thread, agent_key: str, message: str):
        agent_name = self.agents.get(agent_key)
        if not agent_name:
            print(f"Unknown agent: {agent_key}")
            return
        self.client.send_message(thread.id, message, agent_name=agent_name)

    # 🔹 STUDENT MISSING SECTION: Implement orchestration flow between agents
    def orchestrate(self):
        thread = self.create_thread()
        print(" Step 1: Trigger Anomaly Detector")
        self.send_to_agent(thread, "anomaly", "Check system metrics")

        print(" Step 2: Trigger Resource Optimizer")
        self.send_to_agent(thread, "optimizer", "Respond to detected anomalies")

        print(" Step 3: Trigger Alert Manager")
        self.send_to_agent(thread, "alert", "Notify stakeholders of critical issues")

        print(" Orchestration complete.")
```

---

### Run the Orchestrator

Create `run_orchestrator.py`:

```python
from agent_orchestrator import AgentOrchestrator

orchestrator = AgentOrchestrator()
orchestrator.orchestrate()
```

Run the orchestrator:

```bash
python run_orchestrator.py
```

Expected Output:

```
 Step 1: Trigger Anomaly Detector
 Step 2: Trigger Resource Optimizer
 Step 3: Trigger Alert Manager
 Orchestration complete.
```

---

### Optional: Semantic Kernel Integration

For intelligent planning and adaptive execution, you can integrate **Semantic Kernel**:

```python
from semantickernel import Kernel

kernel = Kernel()
plan = kernel.create_plan("Detect and respond to system anomalies dynamically")
```

This allows your orchestrator to make **context-aware decisions** and support **autonomous collaboration** between agents.

---

### Success Criteria

Students should demonstrate:

* The **Anomaly Detector**, **Resource Optimizer**, and **Alert Manager** agents are registered.
* The orchestrator successfully routes messages across agents using a shared thread.
* Execution produces an ordered flow of operations, simulating anomaly detection, optimization, and alerting.
* Optional: Use of **Semantic Kernel** or similar planning logic for intelligent task sequencing.

---

All sections marked with `🔹 STUDENT MISSING SECTION` are **what students were expected to implement themselves** in the student guide.
Coaches can reference these to verify solution accuracy.

