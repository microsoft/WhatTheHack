# Challenge 04 - Build the Alert Manager Agent (Live Azure Integration) - Coach's Guide

[< Previous Solution](./Solution-03.md) - **[Home](../README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

In this challenge, participants build an **Alert Manager Agent** that notifies stakeholders when anomalies or optimizations occur.  
This involves integrating with **Azure Monitor Action Groups** and simulating real-world alert handling within an agentic workflow.

---

### Environment Setup

Install required dependencies:

```bash
pip install azure-monitor-query azure-identity azure-mgmt-monitor python-dotenv
````

Update your `.env` file to include alert group settings:

```env
AZURESUBSCRIPTIONID=your-subscription-id
AZURERESOURCEGROUP=your-resource-group
AZUREACTIONGROUP_NAME=your-action-group-name
```

> ⚠️ Ensure you have **Contributor permissions** to the resource group for managing alerts and action groups.

---

### Create the Alert Manager Agent

Create `alert_manager.py`:

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

        # 🔹 STUDENT MISSING SECTION: Initialize subscription ID, resource group, and Azure Monitor client
        self.subscription_id = os.getenv("AZURESUBSCRIPTIONID")
        self.resource_group = os.getenv("AZURERESOURCEGROUP")
        self.monitor_client = MonitorManagementClient(
            credential=DefaultAzureCredential(),
            subscription_id=self.subscription_id
        )

    # 🔹 STUDENT MISSING SECTION: Define agent behavior when receiving anomaly or optimization messages
    def run(self, thread: Thread, message: Message):
        print("Alert Manager received:", message.content)

        if "Anomaly" in message.content or "Optimization" in message.content:
            alert_msg = f"🚨 Alert triggered: {message.content}"
            thread.send_message(Message(content=alert_msg, role="agent"))
            print("Sending alert to Azure Monitor action group…")
            self.send_alert(alert_msg)

    # 🔹 STUDENT MISSING SECTION: Implement method to simulate sending alert to Azure Monitor
    def send_alert(self, alert_msg):
        # Simulated alert sending for demonstration
        print(f"Simulated alert sent: {alert_msg}")
```

---

### Register and Test the Agent

#### Register the Agent

```python
# register_alert.py
from azure.ai.foundry import AgentClient
from alert_manager import AlertManagerAgent

client = AgentClient()
agent = AlertManagerAgent()
client.register_agent(agent)
```

Run:

```bash
python register_alert.py
```

#### Test the Agent

```python
# test_alert.py
from azure.ai.foundry import AgentClient

client = AgentClient()
thread = client.create_thread()
client.send_message(thread.id, "⚠️ Optimization failed due to high CPU usage", agent_name="alert-manager")
```

Run:

```bash
python test_alert.py
```

Expected Output:

```
Alert Manager received: ⚠️ Optimization failed due to high CPU usage
Alert triggered: ⚠️ Optimization failed due to high CPU usage
Simulated alert sent: 🚨 Alert triggered: ⚠️ Optimization failed due to high CPU usage
```

---

### Next Steps

Once the Alert Manager Agent is complete, proceed to **Challenge 05**, where students will build the **Agent-to-Agent Communication Layer** that enables collaboration and orchestration among the Anomaly Detector, Resource Optimizer, and Alert Manager agents.

---

All sections marked with `🔹 STUDENT MISSING SECTION` are **what students were expected to implement themselves** in the student guide. Coaches can reference these for solution verification.

