# Challenge 04 - Build the Alert Manager Agent (Live Azure Integration)

[< Previous Challenge](./Challenge-03.md) - **[Home](./README.md)** - [Next Challenge >](./Challenge-05.md)

## Pre-requisites

- Completion of Challenge 03 – Resource Optimizer Agent  
- Active Azure subscription with Monitor and Action Groups access  
- `.env` file updated with your Azure subscription, resource group, and action group name  
- Installed dependencies:
  
  ```bash
  pip install azure-monitor-query azure-identity azure-mgmt-monitor python-dotenv
  ```

---

## Introduction

In this challenge, you’ll create the **Alert Manager Agent**, responsible for notifying stakeholders when anomalies or optimization events occur.
This agent integrates with **Azure Monitor** and **Action Groups**, allowing your system to deliver real-time alerts about critical events.

You’ll implement alerting logic, test it in a safe “simulation” mode, and prepare it to handle live alerts in later challenges.

---

## Description

Your goal is to build an agent that listens for incoming messages about anomalies or optimization results, and sends alerts using Azure Monitor or your chosen notification service.

You’ll:

* Create the **Alert Manager Agent**
* Detect when an anomaly or optimization event occurs
* Send (or simulate sending) alerts
* Ensure alerts appear in the terminal or Azure Action Group log

> **Note:** Some code sections are intentionally left incomplete — you’ll implement the core alert logic and message handling yourself.

---

### Create the Agent

Create a new file called `alert_manager.py`:

```python
import os
from azure.identity import DefaultAzureCredential
from azure.mgmt.monitor import MonitorManagementClient
from azure.ai.foundry import Agent, Message, Thread
from dotenv import load_dotenv

load_dotenv()

class AlertManagerAgent(Agent):
    def init(self):
        super().init(name="alert-manager")
        self.subscription_id = os.getenv("AZURESUBSCRIPTIONID")
        self.resource_group = os.getenv("AZURERESOURCEGROUP")

        # TODO: Initialize the Azure Monitor client here
        # Example:
        # self.monitor_client = MonitorManagementClient(
        #     credential=DefaultAzureCredential(),
        #     subscription_id=self.subscription_id
        # )

    def run(self, thread: Thread, message: Message):
        print("Alert Manager received:", message.content)

        # TODO: Detect anomaly or optimization message
        # if "Anomaly" in message.content or "Optimization" in message.content:
        #     alert_msg = f"🚨 Alert triggered: {message.content}"
        #     thread.send_message(Message(content=alert_msg, role="agent"))
        #     print("Sending alert to Azure Monitor action group…")
        #     self.send_alert(alert_msg)

    def send_alert(self, alert_msg):
        # TODO: Implement your alert-sending logic (can be simulated for testing)
        # print(f"Simulated alert sent: {alert_msg}")
        pass
```

---

### Register the Agent

Create a file named `register_alert.py`:

```python
from azure.ai.foundry import AgentClient
from alert_manager import AlertManagerAgent

client = AgentClient()
agent = AlertManagerAgent()
client.register_agent(agent)
```

Run the registration:

```bash
python register_alert.py
```

---

### Test the Agent

Create a file named `test_alert.py`:

```python
from azure.ai.foundry import AgentClient

client = AgentClient()
thread = client.create_thread()

# Simulate a message from the optimizer or anomaly agent
client.send_message(
    thread.id,
    "⚠️ Optimization failed due to high CPU usage",
    agent_name="alert-manager"
)
```

Run the test:

```bash
python test_alert.py
```

 **Expected Output Example:**

```
Alert Manager received: ⚠️ Optimization failed due to high CPU usage
🚨 Alert triggered: ⚠️ Optimization failed due to high CPU usage
Simulated alert sent: 🚨 Alert triggered: ⚠️ Optimization failed due to high CPU usage
```

---

## Learning Resources

* [Azure Monitor Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)
* [Azure Monitor Action Groups](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups)
* [Azure Identity Python SDK](https://learn.microsoft.com/en-us/python/api/overview/azure/identity-readme)
* [Semantic Kernel Python Docs](https://learn.microsoft.com/en-us/semantic-kernel/overview/)

---

## Tips

* Keep your `.env` file clean (no quotes or extra spaces).
* You can safely test alerts by printing them to the terminal before enabling live alerts.
* Once verified, you can extend `send_alert()` to send real alerts through Azure Monitor’s **Action Groups** or webhooks.

---

## Success Criteria

To complete this challenge successfully, you should:

* Create and register an `AlertManagerAgent` class
* Implement message detection for anomalies or optimizations
* Simulate or send an alert through `send_alert()`
* Verify

## Next Steps

Proceed to **Challenge 05** to build the **Agent-to-Agent Communication Layer**, enabling collaboration and orchestration between all agents.

```
