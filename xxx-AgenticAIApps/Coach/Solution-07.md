````markdown
# Challenge 07 - Build the Anomaly & Resolution Tracker - Coach's Guide

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes & Guidance

In this challenge, participants will **track anomalies and resolutions** detected by their Azure Agents and visualize the results in real time.  
You’ll implement lightweight logging, optionally add a Streamlit dashboard, and explore Azure-based storage options for enterprise-scale tracking.

---

## Goal

Build a tracking system that:

- Logs anomalies detected by the **Anomaly Detector Agent**  
- Logs resolutions applied by the **Resource Optimizer Agent**  
- Visualizes all events locally or in Azure  
- Optionally integrates with **Streamlit**, **Power BI**, or **Azure Workbooks**  

---

## Log Anomalies and Resolutions

Update each agent to log its actions to a local file (or a database, if desired).  
Python’s built-in `logging` module is perfect for this.

### Example — *Anomaly Detector Agent*

```python
import logging

logging.basicConfig(filename='agent_log.txt', level=logging.INFO, format='[%(asctime)s] %(message)s')

def log_anomaly(metric, value):
    logging.info(f"Anomaly Detected: {metric} = {value}")
````

Use `log_anomaly()` inside your anomaly detection logic whenever an issue is detected.

---

### Example — *Resource Optimizer Agent*

```python
def log_resolution(action):
    logging.info(f"Resolution Applied: {action}")
```

Call `log_resolution()` after each successful optimization or simulated fix.

---

## Structure the Log Format

Maintain a **consistent format** for readability and parsing:

```
[2025-08-21 14:32:10] Anomaly Detected: CPU = 92%
[2025-08-21 14:32:15] Resolution Applied: Scaled VM to Standard_DS2_v2
```

This makes it easy to visualize or analyze later — either manually or with tools like **Streamlit** or **Power BI**.

> **Tip:** Use `logging.basicConfig(..., format='[%(asctime)s] %(message)s')` to automatically include timestamps.

---

## Visualize with Streamlit (Optional)

🔹 **This section is not included in the student guide.**
Coaches can use it to demonstrate how to turn logs into a real-time dashboard.

Create a file named **`dashboard.py`**:

```python
import streamlit as st

st.title("🔍 Anomaly & Resolution Tracker")

with open("agent_log.txt") as f:
    logs = f.readlines()

for line in logs:
    st.text(line.strip())
```

Run the dashboard with:

```bash
streamlit run dashboard.py
```

Then open the local URL Streamlit provides (usually `http://localhost:8501`) to view your live log feed.

---

## (Optional) Store Logs in Azure Table or Cosmos DB

🔹 **This section is not in the student guide.**
It provides advanced options for enterprise-level tracking and cloud persistence.

For a **cloud-based tracking system**, you can log directly into **Azure Table Storage** or **Azure Cosmos DB** for long-term retention and visualization.

### Option A – Azure Table Storage

Install the SDK:

```bash
pip install azure-data-tables
```

Then use:

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

### Option B – Azure Cosmos DB

Use **`azure-cosmos`** for structured, scalable document storage.
Each log can be stored as a JSON document and visualized using **Power BI** or **Azure Workbooks**.

---

## Expected Behavior

When running your system:

* **Anomaly Detector** logs events like:

  ```
  [2025-10-11 14:01:10] Anomaly Detected: CPU = 91%
  ```
* **Resource Optimizer** logs resolutions:

  ```
  [2025-10-11 14:01:15] Resolution Applied: Scaled VM to Standard_DS2_v2
  ```
* Logs can be viewed locally or through your **Streamlit dashboard** (🔹 *dashboard is a coach-only enhancement*).

---

## Success Criteria

A student has successfully completed Challenge 07 when they can:

* Log anomalies detected by the Anomaly Detector Agent to a local file or database.
* Log resolutions applied by the Resource Optimizer Agent consistently.
* View logs in the correct timestamped format.
* Demonstrate that both anomaly detection and resolution events are captured and trackable in real time.

---

🔹 **Coach Extension:**
Encourage students to explore:

* Streamlit for local dashboards
* Azure Table or Cosmos DB for persistent logging
* Power BI or Azure Workbooks for advanced visualization

---

All sections marked with `🔹 STUDENT MISSING SECTION` are **what students were expected to implement themselves** in the student guide. Coaches can reference these for solution verification.


