# Challenge 01 - Semantic Kernel Setup & Configuration

[< Previous Challenge](./Challenge-00.md) - **[Home](./README.md)** - [Next Challenge >](./Challenge-02.md)

---

## Pre-requisites

- Completion of **Challenge 00 – Azure AI Foundry Onboarding & Environment Prep**
- Active **Azure AI Foundry** resource
- **GitHub Codespaces** environment ready
- `.env` file configured with your **Azure OpenAI** keys

---

## Introduction

In this challenge, you will set up **Semantic Kernel** inside your GitHub Codespaces environment.  
Semantic Kernel provides the **cognitive layer** for your AI agents, enabling them to interpret instructions, generate structured plans, and execute actions.  

You’ll configure your environment to connect to Azure OpenAI services and prepare to create your first **agent skills**.  
Later, these skills will be extended to work with live Azure telemetry data.

---

## Description

Your goal is to configure **Semantic Kernel** and establish the foundation for skill development.  
This includes:

- Initializing the kernel with **Azure OpenAI** credentials  
- Testing a simple **prompt** to confirm connectivity  
- Creating a `skills/` folder for skill development  
- Preparing a skeleton for a **live Azure Monitor skill** (students implement core functionality)

> **Note:** Some code sections are intentionally left incomplete for you to implement. Follow the hints and references below to complete the skill.

---

### Skeleton Example (`azure_monitor_skill.py`)

```python
# students complete building this section

class AzureMonitorSkill:
    def __init__(self):
        # TODO: Initialize Azure credentials and MetricsQueryClient
        pass

    def get_vm_cpu(self) -> str:
        # TODO: Query Azure Monitor for VM CPU usage and return a string
        pass
````

---


## Learning Resources

* [Semantic Kernel Documentation](https://learn.microsoft.com/en-us/semantic-kernel/overview)
* [Azure Monitor Metrics Query SDK](https://learn.microsoft.com/en-us/python/api/overview/azure/monitor-query-readme)
* [Azure Identity Python SDK](https://learn.microsoft.com/en-us/python/api/overview/azure/identity-readme)
* [GitHub Codespaces Basics](https://docs.github.com/en/codespaces/getting-started/quickstart)

---

## Tips

* Ensure your `.env` file has **no extra spaces or quotes** around values
* Test prompts incrementally to confirm **connectivity** before implementing skills
* Use the learning resources to guide your **Azure Monitor queries**
* Keep your class methods small, modular, and focused for easier debugging

---

## Success Criteria

To complete this challenge successfully, you should be able to:

1. Validate that **Semantic Kernel** initializes correctly with Azure OpenAI credentials
2. Verify that a **test prompt** returns a meaningful response
3. Demonstrate that the `skills/` folder exists and contains at least one skill skeleton (`AzureMonitorSkill`)
4. Explain how the kernel can be extended to pull **live telemetry** from Azure


[< Previous Challenge](./Challenge-00.md) - **[Home](./README.md)** - [Next Challenge >](./Challenge-02.md)

```
