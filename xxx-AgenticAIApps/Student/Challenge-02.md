````markdown
# Challenge 02 - Build the Anomaly Detector Agent (Real Azure Metrics)

**[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

---

## Introduction

In this challenge, you’ll build your first **intelligent agent** — the **Anomaly Detector Agent**. This agent will use **Semantic Kernel** to analyze **live Azure Monitor metrics** and detect when your virtual machine experiences performance anomalies (for example, high CPU or memory usage).  

By the end of this challenge, you’ll have a functional AI-driven process that monitors your Azure resources and flags abnormal behavior — forming the foundation for your next, self-healing agent.

---

## Description

You will extend your existing environment (from Challenge 01) by creating a new skill and agent capable of:

- Reading **real telemetry data** (CPU, Memory, Disk I/O) from your Azure VM  
- Comparing metric values to defined thresholds  
- Reporting an **anomaly detected** message when metrics exceed limits  

This challenge focuses on **logic building**, **skill registration**, and **data reasoning** using Semantic Kernel.

---


### Confirm Your Setup

Before building your agent:

- Ensure your `.env` file includes your Azure credentials.  
- Confirm that your **Azure Monitor Skill** from Challenge 01 works and returns live metrics.

You can quickly test it by running:

```bash
python test_kernel.py
````

✅ You should see something like:

```
Current CPU usage: 23.54%
```

---

### Create the Anomaly Detector Skill

In the `skills/` folder, create a new file named `anomaly_detector_skill.py`.

Inside this file, you will:

* Define a class called `AnomalyDetectorSkill`
* Set threshold values for CPU and Memory
* Add a function called `detect_anomaly()` that checks for high usage and returns a message

Start with the following structure and fill in the logic where marked:

```python
from semantic_kernel.skill_definition import sk_function

class AnomalyDetectorSkill:
    def __init__(self, cpu_threshold: float = 80.0, memory_threshold: float = 85.0):
        self.cpu_threshold = cpu_threshold
        self.memory_threshold = memory_threshold

    @sk_function(name="detect_anomaly", description="Detect if system metrics exceed normal thresholds")
    def detect_anomaly(self, cpu_usage: float, memory_usage: float) -> str:
        """
        TODO: Compare metric values against thresholds.
        If CPU or memory usage exceeds their threshold,
        return a message describing the anomaly.
        Otherwise, return a message that the system is normal.
        """
```

---

### Create the Anomaly Detector Agent

Now, in the `agents/` folder, create a file called `anomaly_detector_agent.py`.

This agent will:

* Initialize the Semantic Kernel
* Register both the `AzureMonitorSkill` and your new `AnomalyDetectorSkill`
* Retrieve CPU and memory data
* Pass it into your anomaly detection skill and print the result

Use this as your starter template:

```python
import asyncio
from semantic_kernel import Kernel
from skills.azure_monitor_skill import AzureMonitorSkill
from semantic_kernel.connectors.ai.open_ai import AzureChatCompletion

# TODO: Import your new AnomalyDetectorSkill here

async def main():
    kernel = Kernel()
    kernel.add_service(
        AzureChatCompletion(
            service_id="chatcompletion",
            deployment_name="your-deployment",
            endpoint="your-endpoint",
            api_key="your-api-key"
        )
    )

    kernel.import_skill(AzureMonitorSkill(), "azure_monitor")

    # TODO:
    # 1. Import and register the AnomalyDetectorSkill.
    # 2. Retrieve live metrics using the Azure Monitor skill.
    # 3. Pass the metrics to your anomaly detection function.
    # 4. Print the result.

if __name__ == "__main__":
    asyncio.run(main())
```

---

### Test Your Agent

Run your agent script:

```bash
python agents/anomaly_detector_agent.py
```

✅ Expected Output:

```
CPU anomaly detected: 91.3% exceeds 80.0%
```

or

```
System metrics are within normal range.
```

---

### Learning Resources

These resources will help you complete the challenge:

* [Semantic Kernel Documentation](https://learn.microsoft.com/en-us/semantic-kernel/)
* [Azure Monitor Python SDK](https://learn.microsoft.com/en-us/python/api/overview/azure/monitor-query-readme)
* [Anomaly Detection in Azure](https://learn.microsoft.com/en-us/azure/ai-services/anomaly-detector/overview)
* [AsyncIO in Python](https://docs.python.org/3/library/asyncio.html)

---

## Success Criteria

To successfully complete Challenge 02, you should be able to:

- Verify that the **Anomaly Detector Agent** initializes without errors.
- Confirm that live metrics from your Azure VM (CPU, Memory, Disk I/O) are retrieved correctly.
- Demonstrate that the agent **detects anomalies** when metrics exceed defined thresholds.
- Show that the agent prints appropriate messages for both normal and anomalous states.
- Ensure that the skill and agent are **registered and callable** via Semantic Kernel.


---

## Next Steps

Proceed to **[Challenge 03 – Build the Resource Optimizer Agent](./Challenge-03.md)** to:

* Respond to detected anomalies with remediation actions
* Enable multi-agent communication (Agent-to-Agent protocol)
* Begin orchestrating self-healing AI systems in Azure

```