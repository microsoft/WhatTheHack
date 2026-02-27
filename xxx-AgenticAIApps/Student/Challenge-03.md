# Challenge 03 - Build the Resource Optimizer Agent (Real Azure Integration)

[< Previous Challenge](./Challenge-02.md) - **[Home](./README.md)** - [Next Challenge >](./Challenge-04.md)

---

## Pre-requisites

- Completion of **Challenge 02 – Anomaly Detection Agent**
- Active **Azure subscription** with access to a **Virtual Machine (VM)**
- `.env` file configured with your Azure details
- Working **Semantic Kernel setup** from previous challenges

---

## Introduction

In this challenge, you will build a **Resource Optimizer Agent** capable of analyzing telemetry data (like CPU, memory, and disk usage) and performing **real optimization actions** in Azure using the **Azure Management SDK**.

Your agent will listen for anomaly alerts and intelligently recommend or perform optimizations (like scaling VMs or restarting services).  

This challenge introduces real-world **Azure SDK integration** — connecting the AI layer (Semantic Kernel) with the **Azure Compute Management API**.

---

## Description

You’ll create and test a **Resource Optimizer Agent** that:
- Receives alerts about CPU, memory, or disk usage  
- Determines an appropriate optimization strategy  
- Executes the optimization using the **Azure SDK**  

> ⚠️ **Note:** Parts of the code are intentionally left incomplete.  
> Fill in the missing functions to make your agent operational.

---

### Environment Setup

Install required SDKs:

```bash
pip install azure-mgmt-compute azure-identity python-dotenv
````

Update your `.env` file with your Azure resource details:

```env
AZURESUBSCRIPTIONID=your-subscription-id
AZURERESOURCEGROUP=your-resource-group
AZUREVMNAME=your-vm-name
```

---

### Create `resource_optimizer.py`

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

        # TODO: Initialize Azure credentials and compute client
        # Hint: Use DefaultAzureCredential() and ComputeManagementClient()
        self.subscription_id = os.getenv("AZURESUBSCRIPTIONID")
        self.resource_group = os.getenv("AZURERESOURCEGROUP")
        self.vm_name = os.getenv("AZUREVMNAME")
        pass

    def run(self, thread: Thread, message: Message):
        print("Optimizer received:", message.content)
        response = ""

        # TODO: Parse the message and decide what optimization to perform
        # Example: if "CPU" in message.content → call self.scale_vm("Standard_DS2_v2")

        thread.send_message(Message(content=response, role="agent"))

    def scale_vm(self, new_size):
        # TODO: Implement VM scaling logic using Azure SDK
        # Hint: Retrieve the VM, modify its hardware profile, and use begin_create_or_update()
        pass
```

---

### Register the Agent

Create a new file named `register_optimizer.py`:

```python
from azure.ai.foundry import AgentClient
from resource_optimizer import ResourceOptimizerAgent

client = AgentClient()
agent = ResourceOptimizerAgent()
client.register_agent(agent)
```

Run the registration script:

```bash
python register_optimizer.py
```

---

### Test the Agent

Create a new test file named `test_optimizer.py`:

```python
from azure.ai.foundry import AgentClient

client = AgentClient()
thread = client.create_thread()
client.send_message(thread.id, "⚠️ Anomaly detected: Percentage CPU = 92", agent_name="resource-optimizer")
```

Then execute:

```bash
python test_optimizer.py
```

---

## Learning Resources

* [Azure SDK for Python Documentation](https://learn.microsoft.com/en-us/python/api/overview/azure/)
* [Azure Compute Management Client](https://learn.microsoft.com/en-us/python/api/overview/azure/compute)
* [Azure Identity SDK](https://learn.microsoft.com/en-us/python/api/overview/azure/identity-readme)
* [Semantic Kernel Overview](https://learn.microsoft.com/en-us/semantic-kernel/overview)
* [Anomaly Detector Overview](https://learn.microsoft.com/en-us/azure/ai-services/anomaly-detector/overview)

---

## Tips

* If you encounter authentication issues, ensure **Azure CLI** is logged in (`az login`).
* Start by **printing** messages before implementing full scaling logic.
* Use **try/except** around Azure SDK calls to handle errors gracefully.
* You can safely simulate optimization responses before executing real operations.

---

## Success Criteria

To successfully complete Challenge 03, you should be able to:

- Register and initialize the **Resource Optimizer Agent** without errors.  
- Receive and display incoming anomaly messages correctly.  
- Demonstrate that the agent can parse telemetry and respond (either by executing or simulating optimization).  
- Confirm the agent is connected to **Semantic Kernel** and the **Azure SDK**.

---

## Next Steps

Once your **Resource Optimizer Agent** is working, move to **Challenge 04**, where you’ll build an **Alert Manager Agent** that coordinates notifications and alert responses across your system.

[< Previous Challenge](./Challenge-02.md) - **[Home](./README.md)** - [Next Challenge >](./Challenge-04.md)

```

