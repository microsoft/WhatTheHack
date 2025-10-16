# Challenge 00 - Azure AI Foundry Onboarding & Environment Prep - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-00.md)

```markdown
# Challenge 00 - Azure AI Foundry Onboarding & Environment Prep - Coach's Guide

**[Home](./README.md)** - [Next Solution >](./Solution-00.md)

## Notes & Guidance

This guide walks you through setting up your development environment and Azure subscription for working with Azure AI Foundry. It is designed to help coaches and participants prepare their cloud-based workspace for the challenges ahead.

### Prerequisites

- Python (Version 3.7 or higher, Python 3.13 preferred)
- Pip (package installer for Python)
- Active Azure Subscription
- Azure Developer CLI

Reference documentation:
- [Azure AI Foundry Overview](https://learn.microsoft.com/en-us/azure/azure-ai-foundry/overview)

---

### Create Azure AI Foundry Resource in Azure Account

- Log in to your Azure portal
- Create a new Azure AI Foundry resource
- Note down your resource endpoint URL (you'll need this later)

---

### Set Up GitHub Codespaces

GitHub Codespaces provides a cloud-hosted development environment that eliminates the need for local setup.

- Navigate to the project repository:  
  [Agentic AI Apps GitHub Repository](https://github.com/WhatTheHack/tree/xxx-AgenticAIApps)
- Click the green **Code** button and select **Codespaces > Create codespace on main**
- Wait for the environment to initialize. It will automatically install dependencies and configure your workspace.
- Use the integrated terminal to run commands and interact with Azure resources.
- Authenticate your Codespace CLI session with Azure by running:

  ```bash
  az login
  ```

  - This will open a browser window to complete the login process
  - Once authenticated, your Codespace CLI will be connected to your Azure subscription

---

### Install Required Packages

Once your Codespace is ready, open the terminal and run:

```bash
pip install azure-ai-projects azure-identity
```

Verify installation:

```bash
pip list
```

---

### Create a Virtual Machine with Permissions

To support later stages of the project, you'll need a Linux-based virtual machine with read/write permissions.

- Open the Azure Portal and navigate to **Virtual Machines**
- Click **Create > Virtual Machine**
- Use the following configuration:
  - **Resource Group:** Same as your Azure AI Foundry project
  - **Virtual Machine Name:** `agentic-vm-test`
  - **Region:** West US 2
  - **Availability Zone:** Zone 1
  - **Image:** Ubuntu 22.04 LTS
  - **Size:** Standard B2pts v2 (2 vCPUs, 1 GiB memory)
  - **Authentication Type:** SSH public key
  - **Inbound Ports:** Allow SSH (port 22)
- Click **Next: Disks** and accept the default settings
- Click **Next: Networking** and ensure the VM is assigned a public IP
- Click **Next: Management**, then enable **System Assigned Managed Identity**
- After deployment, go to **Access Control (IAM)** for the VM and assign the **Contributor** role

> ⚠️ This VM is intended for testing purposes only. Do not use it for production workloads.

---

### Repository Usage Notes

The [Agentic AI Apps GitHub Repository](https://github.com/WhatTheHack/tree/xxx-AgenticAIApps) contains all the source code and configuration files needed for this challenge.

- **Codespaces Ready:** Preconfigured for GitHub Codespaces—launch and start coding immediately
- **Project Structure:** Each challenge is organized into its own folder. Start with `Challenge-01`
- **Auto-Setup:** Dependencies install automatically when the Codespace launches
- **Customization:** Modify `.devcontainer` files to adjust the environment
- **Sync with Azure:** Use the terminal to authenticate and interact with Foundry resources

---

## Next Steps: 
Your Azure AI Foundry development environment is now fully configured.  
You’ve installed the required SDKs, authenticated with Azure, and confirmed that your workspace can register and run agents.

Tip: Keep your `.env` and Foundry configuration handy — you’ll reuse them throughout every subsequent challenge.

---

Proceed to **[Challenge 001 – Semantic Kernel Setup & Configuration](./Solution-001.md)** to:
- Integrate **Semantic Kernel** for planning and reasoning.  
- Explore how prompts, skills, and plugins form the cognitive layer of your agents.  
- Learn how agents interpret natural language requests and turn them into structured actions.  
- Prepare the foundation for multi-agent collaboration in future challenges.

---

All sections marked with `🔹 STUDENT MISSING SECTION` are **what students were expected to implement themselves** in the student guide. Coaches can reference these for solution verification.
