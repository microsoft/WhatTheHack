# Challenge 2 - Build the Anomaly Detector Agent (Real Azure Metrics) - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](../README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

This guide walks coaches and participants through building an agent that monitors real-time Azure metrics and detects anomalies in system performance. It introduces Azure Monitor integration and agentic alerting logic.

---

### Environment Setup

- Use GitHub Codespaces  
  Required packages install automatically when the Codespace initializes:

```bash
pip install azure-monitor-query azure-identity python-dotenv
````

* Create a `.env` file in your project root
  Include the following keys:

```env
AZURESUBSCRIPTIONID=your-subscription-id
AZURERESOURCEGROUP=your-resource-group
AZURERESOURCENAME=your-vm-name
AZURE_METRICS=Percentage CPU,Available Memory Bytes,Disk Read Bytes/sec
```

> **Tip:** Add `.env` to `.gitignore` to protect credentials.

---

### Agent Initialization

Create a file called `anomaly_detector.py` and define the agent:

```python
import os
from azure.identity import DefaultAzureCredential
from azure.monitor.query import MetricsQueryClient
from azure.monitor.query.models import MetricAggregationType
from azure.ai.foundry import Agent, Message, Thread
from dotenv import load_dotenv
from datetime import timedelta

load_dotenv()

class AnomalyDetectorAgent(Agent):
    def init(self):
        super().init(name="anomaly-detector")
        self.client = MetricsQueryClient(credential=DefaultAzureCredential())
        self.resource_id = (
            f"/subscriptions/{os.getenv('AZURESUBSCRIPTIONID')}"
            f"/resourceGroups/{os.getenv('AZURERESOURCEGROUP')}"
            f"/providers/Microsoft.Compute/virtualMachines/{os.getenv('AZURERESOURCENAME')}"
        )
        self.metrics = [m.strip() for m in os.getenv("AZURE_METRICS").split(",")]

    # 🔹 STUDENT MISSING SECTION: Retrieve latest metric
    def get_latest_metric(self, metric_name):
        response = self.client.query_resource(
            resource_uri=self.resource_id,
            metric_names=[metric_name],
            timespan=timedelta(minutes=5),
            aggregations=[MetricAggregationType.AVERAGE]
        )
        for metric in response.metrics:
            for timeseries in metric.timeseries:
                for data in timeseries.data:
                    if data.average is not None:
                        return data.average
        return None

    # 🔹 STUDENT MISSING SECTION: Run method to check for anomalies
    def run(self, thread: Thread, message: Message):
        anomalies = []
        for metric in self.metrics:
            value = self.get_latest_metric(metric)
            print(f"{metric}: {value}")
            if value is None:
                continue
            if (
                ("CPU" in metric and value > 75) or
                ("Memory" in metric and value < 1e9) or
                ("Disk" in metric and value > 5e7)
            ):
                anomalies.append(f"{metric} = {value}")

        if anomalies:
            alert = "⚠️ Anomalies detected:\n" + "\n".join(anomalies)
            thread.send_message(Message(content=alert, role="agent"))
        else:
            print("No anomalies detected.")
```

---

### Register and Test the Agent

#### Register the Agent

```python
# register_anomaly.py
from azure.ai.foundry import AgentClient
from anomaly_detector import AnomalyDetectorAgent

client = AgentClient()
agent = AnomalyDetectorAgent()
client.register_agent(agent)
```

Run:

```bash
python register_anomaly.py
```

#### Test the Agent

```python
# test_anomaly.py
from azure.ai.foundry import AgentClient

client = AgentClient()
thread = client.create_thread()
client.send_message(thread.id, "Run anomaly check", agent_name="anomaly-detector")
```

Run:

```bash
python test_anomaly.py
```

Expected output: Real metric values printed and alerts triggered if thresholds are exceeded.

---

### Next Steps

Proceed to Challenge 03 to build a **Resource Optimizer Agent** that responds to anomalies and simulates Azure-based optimizations.

---

All sections marked with `🔹 STUDENT MISSING SECTION` are **what students were expected to implement themselves** in the student guide. Coaches can reference these for solution verification.

