# Challenge 08 - Spike VM Resources & Test Agent Detection

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)**

## Introduction

In this challenge, you will temporarily **spike CPU and memory** on the Azure VM you have been maintaining since the initial challenges.  

The goal is to **test your agents** — Anomaly Detector, Resource Optimizer, and Alert Manager — and observe how they respond in real time.

You will use the **provided test scripts** to generate the resource spike, so you do not need to write any additional agent code for this challenge.  

> **Important:** You must be connected to Azure using `az login` before starting this challenge, so your agents can access the VM telemetry and management APIs.

---

## Description

Students are expected to:

- Use the provided stress scripts (`spike_vm.sh` for Linux/macOS or `spike_vm.ps1` for Windows) to create a temporary load on the VM.
- Run your agents using the provided orchestrator or test scripts (`test_anomaly.py` or `run_orchestrator.py`).
- Verify that your agents detect the anomalies and log or respond appropriately.
- Meet the success criteria to complete the What The Hack challenge.

> **Important:** The VM used should be the same one you kept active from the initial challenges. This ensures continuity of testing and monitoring.

---

## Learning Resources

To help you complete this challenge and work with the VM:

* [Connect to an Azure VM using SSH](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/ssh-from-windows) – Step-by-step guide for connecting to Linux VMs from your terminal.
* [Bash Basics for Beginners](https://www.gnu.org/software/bash/manual/bash.html) – Introduction to Bash scripting and commands.
* [Linux Command Line Tutorial](https://ryanstutorials.net/linuxtutorial/) – Learn basic Linux commands and navigation.
* [Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/) – How to interact with Azure resources using `az login` and CLI commands.

---

### Establish a Baseline

Before spiking resources, confirm your agents report **no anomalies**:

```bash
python test_anomaly.py
# or
python run_orchestrator.py
````

This establishes the baseline for detecting changes.

---

### Run the Stress Script

**Linux/macOS – `spike_vm.sh`**

```bash
chmod +x spike_vm.sh
./spike_vm.sh 45 1024
```

**Windows – `spike_vm.ps1`**

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\spike_vm.ps1 -Duration 45
```

These scripts will temporarily increase CPU and memory usage on the VM.

---

### Run Agents During Spike

Immediately after starting the spike:

```bash
python test_anomaly.py
# or
python run_orchestrator.py
```

* **Anomaly Detector Agent** should detect high CPU/memory.
* **Resource Optimizer Agent** may suggest scaling or other resolutions.
* **Alert Manager Agent** may log or simulate alerts.

---

### Verify Logs

```bash
# Linux/macOS
tail -f agent_log.txt

# Windows PowerShell
Get-Content .\agent_log.txt -Wait
```

Expected entries:

```
[2025-10-11 15:22:00] Anomaly Detected: CPU = 98%
[2025-10-11 15:22:05] Resolution Applied: Suggested VM scale-up
```

---

### Stop the Stress Script

**Linux/macOS:**

```bash
pkill -f 'md5sum'
```

**Windows PowerShell:**

```powershell
Get-Job | Where-Object { $_.State -eq 'Running' } | ForEach-Object { Stop-Job -Job $_; Remove-Job -Job $_ }
Remove-Variable memBlocks -ErrorAction SilentlyContinue -Scope Global
[GC]::Collect(); [GC]::WaitForPendingFinalizers()
Write-Host "Stress jobs stopped and memory released."
```

---

## Success Criteria

To successfully complete this challenge (and the What The Hack challenge), students must:

* Run the **provided spike script** on the maintained VM.
* Show that all agents detect anomalies during the spike.
* Demonstrate that resolutions or recommendations are logged correctly.
* Optionally, provide screenshots of agent alerts or Streamlit dashboard updates.

> **Completion of this step successfully indicates that your agents are functioning correctly and the challenge is complete.**

---

