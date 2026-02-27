# What The Hack - AgenticAIApps - Coach Guide

## Introduction

Welcome to the coach's guide for **AgenticAIApps**, a modern **Azure Agentic AI Hack** designed to help participants build, test, and scale intelligent multi-agent systems.  
Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Learning Objectives

This project is designed to teach participants how to build agentic applications using Azure’s AI ecosystem.  
Participants will orchestrate intelligent agents using Semantic Kernel, implement secure communication protocols, and deploy multi-agent workflows with live metric integration via Azure Monitor. By the end, participants will be equipped to design, deploy, and manage scalable, secure, and collaborative AI agents in real-world scenarios.

Participants will learn to:

- Provision and configure a Linux VM in Azure with read/write permissions  
- Deploy and test **Anomaly Detector**, **Resource Optimizer**, and **Alert Manager** agents  
- Orchestrate multi-agent collaboration for real-time decision-making  
- Build and visualize logs locally and in Azure (via Streamlit or Power BI)  
- Spike VM resources to test agent detection and resilience  
- Integrate Azure tools (Monitor, Storage, and AI Foundry) for advanced observability  

---

## Coach's Guides

- **Challenge 00:** [Azure AI Foundry Onboarding & Environment Prep](./Solution-00.md)  
  *Set up your Azure environment and validate permissions.*

- **Challenge 01:** [Semantic Kernel Setup & Configuration](./Solution-01.md)  
  *Deploy a Linux VM with contributor permissions and enable SSH access.*

- **Challenge 02:** [Build the Anomaly Detector Agent (Real Azure Metrics)](./Solution-02.md)  
  *Set up your environment with Python, Bash, and Azure SDKs, and create your first monitoring agent.*

- **Challenge 03:** [Build the Resource Optimizer Agent (Real Azure Integration)](./Solution-03.md)  
  *Implement automated resource adjustments based on detected anomalies.*

- **Challenge 04:** [Build the Alert Manager Agent (Live Azure Integration)](./Solution-04.md)  
  *Design a communication layer to notify or log alerts from your system.*

- **Challenge 05:** [Orchestrate Agent-to-Agent Communication](./Solution-05.md)  
  *Build an orchestrator to coordinate communication between agents.*

- **Challenge 06:** [Enable Agent-to-Agent Communication (A2A)](./Solution-06.md)  
  *Enable agents to share context, pass messages, and coordinate actions dynamically.*

- **Challenge 07:** [Build the Anomaly & Resolution Tracker](./Solution-07.md)  
  *Log and visualize all anomaly and resolution events in real time.*

- **Challenge 08:** [Spike VM Resources & Test Agent Detection](./Solution-08.md)  
  *Simulate CPU and memory spikes to validate your agentic system.*

---

## Coach Prerequisites

Before hosting, coaches should ensure they can perform the following:

- **Active Azure Subscription**  
- **Python 3.7 or higher** *(Python 3.13 preferred)*  
- **Pip** (Python package installer)  
- **GitHub account** with access to the AgenticAIApps repository and **Codespaces**  
- **VS Code** with Python and Azure extensions  
- **Azure CLI** installed and authenticated  
- Basic familiarity with **Linux, SSH, and Bash scripting**  
- (Optional) Azure Monitor, Streamlit, and Power BI for visualization  

Always review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for event-specific instructions.

### Student Resources

Coaches should download and package the `/Student/Resources` folder into a `Resources.zip` file and provide it to students at the start of the hack.

**NOTE:** Students should **not** have access to the repository before or during the hack. 

---

## Azure Requirements

Students require access to an Azure subscription capable of creating and consuming resources used in the challenges.  
This includes:

- VM creation and scaling  
- Storage access (for logs)  
- Permissions to deploy agents and monitoring solutions  

---

## Learning Resources

- [Microsoft Agent Framework – Python User Guide](https://learn.microsoft.com/en-us/agent-framework/user-guide/agents/agent-types/?pivots=programming-language-python)  
- [Connect to a VM using SSH (Azure Docs)](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/mac-create-ssh-keys)  
- [Introduction to Bash and Linux CLI](https://ubuntu.com/tutorials/command-line-for-beginners)  
- [Azure AI Foundry Overview](https://learn.microsoft.com/en-us/azure/ai-foundry/)  

---

## Repository Contents

- `./Coach` – Coach's guide and related files  
- `./Coach/Solutions` – Completed solution files for each challenge  
- `./Student` – Student challenge guide  
- `./Student/Resources` – Resource files, sample code, and scripts for students  

---

## Contributors

- **Esvin Ruiz**  
