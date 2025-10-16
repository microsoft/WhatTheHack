# Challenge 01 - Semantic Kernel Setup & Configuration – Coach's Guide

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

---

## Notes & Guidance

This guide walks coaches and participants through setting up Semantic Kernel using Azure OpenAI services inside GitHub Codespaces. It enables orchestration of intelligent agents for planning and task execution.

---

### Environment Setup

* Use **GitHub Codespaces**

  * Launch directly from the **Agentic AI Apps** GitHub repository.
  * Dependencies install automatically when the Codespace initializes.

---

### Secure Your Credentials

* Create a `.env` file in your project root and add the following keys:

```env
OPENAIAPIKEY=your-azure-openai-api-key
OPENAIENDPOINT=your-azure-openai-endpoint
OPENAIDEPLOYMENTNAME=your-model-deployment
OPENAIMODEL_NAME=gpt-4o
AZURE_SUBSCRIPTION_ID=your-subscription-id
AZURE_RESOURCE_GROUP=your-resource-group
AZURE_VM_NAME=your-vm-name
```

* Add `.env` to `.gitignore` to protect sensitive credentials.
* Avoid spaces around `=` — they prevent variables from loading correctly.

---

### Kernel Initialization

Create a file called `test_kernel.py`:

```python
import os
import asyncio
from dotenv import load_dotenv
from semantic_kernel.kernel import Kernel
from semantic_kernel.connectors.ai.open_ai import AzureChatCompletion

load_dotenv()

api_key = os.getenv("OPENAIAPIKEY")
endpoint = os.getenv("OPENAIENDPOINT")
deployment_name = os.getenv("OPENAIDEPLOYMENTNAME")

kernel = Kernel()
kernel.add_service(
    AzureChatCompletion(
        service_id="chatcompletion",
        deployment_name=deployment_name,
        endpoint=endpoint,
        api_key=api_key
    )
)

# 🔹 STUDENT MISSING SECTION: Prompt testing
async def run():
    result = await kernel.invoke_prompt_async("What is Semantic Kernel?")
    print(result)

asyncio.run(run())
```

✅ **Expected Output:**

```
"Semantic Kernel is an open-source SDK that lets you build AI-first apps..."
```

---

### Organize Your Skills

Create a `skills/` folder to store Semantic Kernel plugins. Each skill should include:

* `config.json` — defines the skill’s name, description, and inputs.
* `skprompt.txt` — contains the prompt template or logic.

This structure lets you modularize functionality and invoke skills dynamically.

Example skills:

* `MonitorSkill`
* `AnomalySkill`
* `AzureMonitorSkill` *(new — for live data)*

---

### Add a Live Azure Monitor Skill

Create a file named `azure_monitor_skill.py` in the `skills/` folder:

```python
import os
from azure.monitor.query import MetricsQueryClient
from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv
from semantic_kernel.skill_definition import sk_function

load_dotenv()

class AzureMonitorSkill:
    def __init__(self):
        self.credential = DefaultAzureCredential()
        self.client = MetricsQueryClient(self.credential)
        self.subscription_id = os.getenv("AZURE_SUBSCRIPTION_ID")
        self.resource_group = os.getenv("AZURE_RESOURCE_GROUP")
        self.vm_name = os.getenv("AZURE_VM_NAME")

    # 🔹 STUDENT MISSING SECTION: Function to retrieve CPU metric
    @sk_function(name="get_vm_cpu", description="Retrieve current CPU usage for a VM")
    def get_vm_cpu(self) -> str:
        resource_id = (
            f"/subscriptions/{self.subscription_id}/resourceGroups/"
            f"{self.resource_group}/providers/Microsoft.Compute/virtualMachines/{self.vm_name}"
        )

        response = self.client.query_resource(
            resource_id=resource_id,
            metric_names=["Percentage CPU"],
            timespan="PT1H"
        )

        for metric in response.metrics:
            if metric.timeseries and metric.timeseries[0].data:
                last_point = metric.timeseries[0].data[-1]
                if last_point.average is not None:
                    return f"Current CPU usage: {last_point.average:.2f}%"

        return "No CPU data available."
```

Then register it inside your main kernel file (`test_kernel.py`):

```python
# 🔹 STUDENT MISSING SECTION: Skill registration
from skills.azure_monitor_skill import AzureMonitorSkill

kernel.import_skill(AzureMonitorSkill(), "azure_monitor")

async def run():
    cpu_data = await kernel.skills.azure_monitor.get_vm_cpu()
    print(cpu_data)
```

**Expected Output (example):**

```
Current CPU usage: 21.43%
```

---

### Why This Matters

By connecting Semantic Kernel to Azure Monitor:

* Agents can react to **live telemetry** instead of mock anomalies.
* Lays the foundation for Challenge 02, where your **Anomaly Detector Agent** will use these metrics for proactive monitoring.
* Aligns Foundry agents with **real Azure resources**, enabling autonomous cloud management.

---

### Next Steps

After completing this setup, your agents can interpret, plan, and act on **real data** within your Azure environment.

---

Proceed to **[Challenge 02 – Build the Anomaly Detector Agent (Real Azure Metrics)](./Solution-02.md)** to:

* Connect your Semantic Kernel agents to **Azure Monitor metrics**.
* Detect real-time anomalies in **CPU, memory, and disk I/O**.
* Trigger optimization and orchestration flows using **live telemetry**.
* Build a foundation for intelligent, self-healing cloud agents.

🧩 *Keep your Azure credentials and Foundry session active — Challenge 02 builds directly on this configuration.*

---

All sections marked with `🔹 STUDENT MISSING SECTION` are **what students were expected to implement themselves** in the student guide. Coaches can reference these for solution verification.

