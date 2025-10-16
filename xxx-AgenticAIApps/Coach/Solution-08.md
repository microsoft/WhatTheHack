````markdown
# Challenge 008 – Spike VM Resources & Test Agent Detection – Coach's Guide

[< Previous Solution](./Solution-005.md) - **[Home](./README.md)**

## Goal
Temporarily spike CPU and memory on your VM to test agent detection.  
Participants will observe the **Anomaly Detector**, **Resource Optimizer**, and **Alert Manager** responding to real-time changes.

---

## Important Pre-Step: Establish a Baseline
Before creating the spike:
1. Connect to your Azure environment.
2. Run your agents **without any artificial load**:

```bash
python test_anomaly.py
# or
python run_orchestrator.py
````

* Confirm no anomalies are logged — this is your baseline reference.

---

## Choose the Appropriate Stress Script

### Linux/macOS – Bash or Zsh Users (`spike_vm.sh`)

```bash
#!/usr/bin/env bash
# CPU + Memory stress test for Linux/macOS

DURATION=${1:-30}  # default duration in seconds
MEMORY_MB=${2:-1024} # default memory allocation

echo "🔁 Spiking CPU and memory for $DURATION seconds (Memory: $MEMORY_MB MB)..."

# CPU spike: spawn a background loop per CPU core
CPU_CORES=$(nproc)
for i in $(seq 1 $CPU_CORES); do
  ( while :; do 1..200000 | xargs -n1 echo | md5sum > /dev/null; done ) &
done

# Memory spike: allocate arrays
MEM_BLOCKS=()
BLOCK_SIZE_MB=64
BLOCKS_TO_ALLOCATE=$(( (MEMORY_MB + BLOCK_SIZE_MB - 1) / BLOCK_SIZE_MB ))
for i in $(seq 1 $BLOCKS_TO_ALLOCATE); do
  MEM_BLOCKS+=( $(python3 -c "a = ['x'*1024*1024 for _ in range($BLOCK_SIZE_MB)]; input()") )
done

echo "CPU+Memory stress running. Stop manually by killing background jobs or closing terminal."
```

Run:

```bash
chmod +x spike_vm.sh
./spike_vm.sh 45 1024
```

---

### Windows – PowerShell Users (`spike_vm.ps1`)

```powershell
# Set CPU threads and memory allocation
$cpuThreads = [int](Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
$memoryMB = 1024

Write-Host "`nStarting CPU spike with $cpuThreads threads and allocating $memoryMB MB of RAM..."

# Start CPU jobs
$jobs = for ($i=1; $i -le $cpuThreads; $i++) {
    Start-Job -ScriptBlock {
        while ($true) { 1..200000 | ForEach-Object { [math]::Sqrt($_) } > $null }
    }
}

# Allocate memory
try {
    $global:memBlocks = @()
    $blockSizeMB = 64
    $toAllocate = [int]([math]::Ceiling($memoryMB / $blockSizeMB))
    for ($i=0; $i -lt $toAllocate; $i++) {
        $b = New-Object Byte[] ($blockSizeMB * 1MB)
        for ($j=0; $j -lt $b.Length; $j += 4096) { $b[$j] = 0x1 }
        $global:memBlocks += ,$b
    }
    Write-Host "Memory allocation succeeded."
} catch {
    Write-Warning "Memory allocation failed or reached system limit: $_"
}

Write-Host "`nCPU+Memory stress running. To stop run the STOP block shown below."
```

Run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\spike_vm.ps1 -Duration 45
```

---

## Run Agents During Stress

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

## Verify Logs

```powershell
# On Windows
Get-Content .\agent_log.txt -Wait

# On Linux/macOS
tail -f agent_log.txt
```

Expected entries:

```
[2025-10-11 15:22:00] Anomaly Detected: CPU = 98%
[2025-10-11 15:22:05] Resolution Applied: Suggested VM scale-up
```

---

## Stop the Stress Script

**Linux/macOS:**

```bash
pkill -f 'md5sum'  # stops CPU loops
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

* Appropriate spike script in your repo (`spike_vm.sh` or `spike_vm.ps1`)
* Logs showing baseline and spike detection
* Optional screenshot of agent alerts or Streamlit dashboard

---

🔹 **Coach-Only Troubleshooting Guide**

If agents fail to detect or respond to the spike:

* **Verify Environment Variables:**
  Ensure `.env` includes all required Azure credentials (`AZURESUBSCRIPTIONID`, `AZURERESOURCEGROUP`, etc.).
* **Check Agent Registration:**
  Run `python -m azure.ai.foundry list-agents` to confirm `anomaly-detector`, `resource-optimizer`, and `alert-manager` are registered.
* **Inspect Thread Flow:**
  Add print statements or use logging to verify message propagation between agents in shared threads.
* **Validate Log Permissions:**
  Confirm `agent_log.txt` exists and the process has write access.
* **Simulate Manual Alerts:**
  Send a test message directly to `alert-manager`:

  ```bash
  python -c "from azure.ai.foundry import AgentClient; c=AgentClient(); t=c.create_thread(); c.send_message(t.id, '⚠️ Manual test alert', agent_name='alert-manager')"
  ```
* **Check VM Monitoring Limits:**
  If Azure Monitor metrics are delayed, manually confirm with:

  ```bash
  az monitor metrics list --resource <resource_id> --metric "Percentage CPU"
  ```
* **Restart Agents:**
  Occasionally agents hold stale threads; restarting clears cached state.

---

All sections marked with `🔹 STUDENT MISSING SECTION` are **what students were expected to implement themselves** in the student guide. Coaches can reference these for solution verification.
