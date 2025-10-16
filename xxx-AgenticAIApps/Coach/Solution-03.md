````markdown
# Challenge 03 - Build the Resource Optimizer Agent (Real Azure Integration) - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](../README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

In this challenge, participants create a **Resource Optimizer Agent** that responds to anomalies detected by the Anomaly Detector Agent and performs simulated or real Azure optimizations.  
The agent demonstrates integration between **Semantic Kernel**, **Azure Monitor**, and the **Azure Management SDK**.

---

### Environment Setup

- Provision a Linux VM (`agentic-vm-test`) with **Contributor permissions** to ensure read/write access.  
- Install required SDKs:

```bash
pip install azure-mgmt-compute azure-identity python-dotenv
````

* `.env` file should include:

```env
AZURESUBSCRIPTIONID=your-subscription-id
AZURERESOURCEGROUP=your-resource-group
AZUREVMNAME=your-vm-name
```

> Ensure your VM has **read/write permissions** — necessary for optimization actions.

---

### Create the Resource Optimizer Agent

Create `resource_optimizer.py`:

```python
import os
from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient
from azure.ai.foundry import Agent, Message, Thread
from dotenv import load_dotenv

load_dotenv()

class ResourceOptimizerAgent(Agent):
    def init(self):
        super().init(name="resource-optimizer")

        # 🔹 STUDENT MISSING SECTION: Initialize Azure credentials & ComputeManagementClient
        self.subscription_id = os.getenv("AZURESUBSCRIPTIONID")
        self.resource_group = os.getenv("AZURERESOURCEGROUP")
        self.vm_name = os.getenv("AZUREVMNAME")
        self.credential = DefaultAzureCredential()
        self.compute_client = ComputeManagementClient(self.credential, self.subscription_id)

    # 🔹 STUDENT MISSING SECTION: Run method to process anomaly messages
    def run(self, thread: Thread, message: Message):
        print("Optimizer received:", message.content)
        response = ""

        # Example logic: check message content for CPU/memory/disk anomalies
        if "CPU" in message.content:
            response = self.scale_vm("Standard_DS2_v2")
        elif "Memory" in message.content:
            response = self.scale_vm("Standard_DS3_v2")
        elif "Disk" in message.content:
            response = self.scale_vm("Standard_DS4_v2")
        else:
            response = "No actionable anomalies detected."

        thread.send_message(Message(content=response, role="agent"))

    # 🔹 STUDENT MISSING SECTION: Scale VM method using Azure SDK
    def scale_vm(self, new_size):
        vm = self.compute_client.virtual_machines.get(self.resource_group, self.vm_name)
        vm.hardware_profile.vm_size = new_size
        poller = self.compute_client.virtual_machines.begin_create_or_update(
            self.resource_group,
            self.vm_name,
            vm
        )
        poller.wait()
        return f"VM scaled to {new_size}"
```

---

### Register and Test the Agent

#### Register the Agent

```python
from azure.ai.foundry import AgentClient
from resource_optimizer import ResourceOptimizerAgent

client = AgentClient()
agent = ResourceOptimizerAgent()
client.register_agent(agent)
```

Run:

```bash
python register_optimizer.py
```

#### Test the Agent

```python
from azure.ai.foundry import AgentClient

client = AgentClient()
thread = client.create_thread()
client.send_message(thread.id, "⚠️ Anomaly detected: Percentage CPU = 92", agent_name="resource-optimizer")
```

Expected behavior: The agent prints the message, identifies the anomaly, and scales the VM according to the logic.

---

### Next Steps

Once the **Resource Optimizer Agent** is working:

* Move to Challenge 04 to build an **Alert Manager Agent** that coordinates notifications and alert responses across your system.
* Explore logging, visualization, and orchestration for multi-agent workflows.

---

All sections marked with `🔹 STUDENT MISSING SECTION` are **what students were expected to implement themselves** in the student guide. Coaches can reference these for solution verification.


