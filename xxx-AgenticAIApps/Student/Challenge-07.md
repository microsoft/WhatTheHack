````markdown
# Challenge 07 - Build the Anomaly & Resolution Tracker

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-08.md)

## Introduction

In this challenge, you will build a **tracking system** to log anomalies detected by your **Anomaly Detector Agent** and resolutions applied by your **Resource Optimizer Agent**.  

This system will help you visualize events in real time and optionally integrate with dashboards like **Streamlit**, **Power BI**, or **Azure Workbooks**.  

You will explore:
- Logging and storing agent actions
- Structuring log data for clarity
- Visualizing agent activity locally or in the cloud
- Optional integration with Azure storage services for persistence

---

## Description

Your task is to **implement anomaly and resolution tracking** for your agent system.  

Key goals:
- Create logging for both anomaly detection and resolution events
- Maintain a **consistent log format** for easy parsing and visualization
- Optionally build a **Streamlit dashboard** to view logs interactively
- Optionally store logs in **Azure Table Storage** or **Cosmos DB** for cloud-based tracking

Skeleton example for logging:

### Anomaly Detector Agent

```python
import logging

logging.basicConfig(filename='agent_log.txt', level=logging.INFO, format='[%(asctime)s] %(message)s')

def log_anomaly(metric, value):
    # TODO: Call this function whenever an anomaly is detected
    logging.info(f"Anomaly Detected: {metric} = {value}")
````

### Resource Optimizer Agent

```python
def log_resolution(action):
    # TODO: Call this function after performing a resolution
    logging.info(f"Resolution Applied: {action}")
```

---

### Log Format Example

```
[2025-08-21 14:32:10] Anomaly Detected: CPU = 92%
[2025-08-21 14:32:15] Resolution Applied: Scaled VM to Standard_DS2_v2
```

> **Tip:** Using timestamps helps track and visualize event sequences effectively.

---

### Optional — Streamlit Dashboard

Create **`dashboard.py`**:

```python
import streamlit as st

st.title("🔍 Anomaly & Resolution Tracker")

with open("agent_log.txt") as f:
    logs = f.readlines()

for line in logs:
    st.text(line.strip())
```

Run the dashboard:

```bash
streamlit run dashboard.py
```

---

### Optional — Azure Storage Integration

**Azure Table Storage**

```bash
pip install azure-data-tables
```

```python
from azure.data.tables import TableServiceClient
from datetime import datetime
import os

service = TableServiceClient.from_connection_string(conn_str=os.getenv("AZURE_STORAGE_CONNECTION_STRING"))
table_client = service.get_table_client(table_name="AgentLogs")

def log_to_table(event_type, detail):
    entity = {
        "PartitionKey": "AgentLogs",
        "RowKey": str(datetime.utcnow().timestamp()),
        "EventType": event_type,
        "Detail": detail
    }
    table_client.create_entity(entity)
```

**Azure Cosmos DB** can also be used to store structured JSON logs for advanced analytics.

---

## Success Criteria

To complete this challenge successfully, you should be able to:

* Validate that the **Anomaly Detector Agent** logs anomalies
* Validate that the **Resource Optimizer Agent** logs resolutions
* Demonstrate that logs are readable and follow a consistent format
* Optionally show the **Streamlit dashboard** displaying live logs
* Optionally store and retrieve logs from **Azure Table Storage** or **Cosmos DB**

---

## Learning Resources

* [Python Logging Module](https://docs.python.org/3/library/logging.html) – Learn how to log messages with timestamps
* [Streamlit Documentation](https://docs.streamlit.io/) – Guide to building interactive dashboards
* [Azure Data Tables](https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-overview) – Overview of Azure Table Storage
* [Azure Cosmos DB Python SDK](https://learn.microsoft.com/en-us/python/api/overview/azure/cosmos-db?view=azure-python) – Learn to store JSON documents in Cosmos DB

---

## Tips

* Start by logging to a local file before moving to cloud storage
* Keep log formats consistent for easier visualization
* Use small sample data to verify the Streamlit dashboard works before scaling

---

## Next Steps

Proceed to **Challenge 08** to extend your tracking system with:

* Persistent memory across agent sessions
* Advanced analytics for anomaly trends
* Automated reporting using Azure AI Foundry

```
