````markdown
# Challenge 05 - Orchestrate Agent-to-Agent Communicatio

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

In this challenge, you will connect all of your agents—**Anomaly Detector**, **Resource Optimizer**, and **Alert Manager**—into a unified communication system using an **Agent Orchestrator**.  

This orchestrator will serve as the bridge that enables agents to pass messages, share context, and execute tasks in sequence.  

You will explore:
- How agents communicate through threads using the Azure AI Foundry SDK
- How to design message routing between independent components
- The foundations of semantic coordination for intelligent multi-agent workflows

By completing this challenge, you’ll be able to design scalable, modular agent architectures where autonomous components work together in real time.

---

## Description

Your task is to **implement the Agent Orchestrator** that manages the communication between your existing agents.  

## Learning Resources


You will create two files:
- `agent_orchestrator.py` — defines the orchestration logic
- `run_orchestrator.py` — runs the orchestrator to test communication between agents

The orchestrator should:
- Create a shared communication thread
- Trigger the **Anomaly Detector Agent** to check system metrics
- Trigger the **Resource Optimizer Agent** to respond to detected issues
- Trigger the **Alert Manager Agent** to notify stakeholders
- Display console messages confirming each step

Below is the incomplete code you will build upon:

```python
from azure.ai.foundry import AgentClient, Thread
from dotenv import load_dotenv
import os

load_dotenv()

class AgentOrchestrator:
    def __init__(self):
        self.client = AgentClient()
        self.agents = {
            "anomaly": "anomaly-detector",
            "optimizer": "resource-optimizer",
            "alert": "alert-manager"
        }

    def create_thread(self):
        # TODO: Create and return a new Thread
        pass

    def send_to_agent(self, thread: Thread, agent_key: str, message: str):
        # TODO: Send a message to a specific agent using the client
        pass

    def orchestrate(self):
        # TODO: Implement the orchestration flow:
        # 1. Trigger anomaly detector
        # 2. Trigger resource optimizer
        # 3. Trigger alert manager
        pass
````

To execute your orchestrator, create a new script called `run_orchestrator.py`:

```python
from agent_orchestrator import AgentOrchestrator

orchestrator = AgentOrchestrator()
orchestrator.orchestrate()
```

When you run this file, your output should look similar to:

```
    Step 1: Trigger Anomaly Detector
    Step 2: Trigger Resource Optimizer
    Step 3: Trigger Alert Manager
    Orchestration complete.
```

---


## Learning Resources

* [Azure AI Foundry Overview](https://learn.microsoft.com/en-us/azure/ai-services/)
* [Azure Anomaly Detector Overview](https://learn.microsoft.com/en-us/azure/ai-services/anomaly-detector/overview)
* [Microsoft Semantic Kernel Documentation](https://learn.microsoft.com/en-us/semantic-kernel/)
* [Threading in Python (Real Python)](https://realpython.com/intro-to-python-threading/)
* [Introduction to Multi-Agent Systems (Microsoft Learn)](https://learn.microsoft.com/en-us/azure/ai-services/)

---

## Tips

* Ensure your previous agents (Anomaly Detector, Resource Optimizer, Alert Manager) are correctly registered
* Test each message exchange individually before running the full orchestration
* Use logging statements to visualize the flow of messages between agents
* If you encounter threading errors, print the thread ID after creation to confirm proper initialization

---

## Success Criteria

To complete this challenge successfully, you should be able to:

* Validate that the orchestrator successfully creates a thread
* Verify that each agent receives and processes its assigned message
* Demonstrate that the console output confirms all three agent triggers
* Optionally, extend the orchestrator with a planning mechanism to dynamically decide which agent to trigger next

---

## Next Steps

After completing the Agent Orchestrator, you are ready to move on to **Challenge 06**, where you will implement **multi-agent planning and dynamic task scheduling** using Semantic Kernel.  

This next challenge will build on your orchestrator to enable agents to make intelligent decisions, prioritize tasks, and collaborate autonomously based on real-time data.

```
