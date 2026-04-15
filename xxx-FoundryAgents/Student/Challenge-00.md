# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Foundry Agents What The Hack. Before you can hack, you will need to set up some prerequisites including local development tools, Azure infrastructure, and Python dependencies.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specific to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

### Install Required Tools

Please ensure the following tools are installed on your workstation:

- **Python 3.10+** — Download from [python.org](https://www.python.org/downloads/)
- **Azure CLI 2.65+** — Install from [aka.ms/installazurecli](https://aka.ms/installazurecli)
- **Azure CLI `ml` extension** — Required for Foundry CLI operations
- **Visual Studio Code** with the [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python)

### Authenticate with Azure

Log in to Azure CLI and set your target subscription:

```bash
az login
az account set --subscription "<your-subscription-id>"
```

Install the Azure CLI ML extension needed for AI Foundry:

```bash
az extension add --name ml --upgrade
```

### Deploy Azure Infrastructure

In the `infra/` folder of the Resources.zip file, you will find a Bicep template that deploys the Azure resources needed for this hack: a **Microsoft Foundry Resource & Project**, **Azure Storage Account**, and **Azure AI Search**.

Deploy the infrastructure by running the deployment script from the `infra/` folder:

**Bash (Linux/macOS/WSL):**
```bash
cd infra
chmod +x deploy.sh
./deploy.sh
```

**PowerShell (Windows):**
```powershell
cd infra
.\deploy.ps1
```

The script will:
1. Verify you are logged in to Azure CLI (and prompt `az login` if not)
2. Confirm your active subscription
3. Register required Azure resource providers
4. Deploy the Bicep template at subscription scope (creating the resource group and all resources)
5. Print the deployment outputs you need for configuration

### Set Up Python Environment

Create a virtual environment and install the Python dependencies:

```bash
python -m venv .venv
```

Activate the virtual environment:
- **Windows:** `.venv\Scripts\activate`
- **Linux/macOS:** `source .venv/bin/activate`

Install the required packages:
```bash
pip install -r requirements.txt
```

### Configure Environment Variables

The deployment script automatically generates a `.env` file in the `Resources/` folder with all values populated from the deployment outputs. Open the `.env` file and verify that the values look correct by comparing them to the `.env.sample` file — each placeholder should now be replaced with a real value (endpoint URLs, resource names, connection strings, etc.).

### Access the Microsoft Foundry Portal

After deployment, navigate to the Microsoft Foundry portal to explore your project:

- Go to [https://ai.azure.com](https://ai.azure.com) and sign in with the same account you used for `az login`
- You should see your Foundry Resource listed — click into it
- Select your **Foundry Project** to access the project workspace where you can manage models, deployments, agents, and other resources throughout this hack

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have Azure CLI installed and are logged in to your Azure subscription.
- Verify that the Bicep deployment has created the following resources in your Azure subscription:
  - Resource Group (e.g., `rg-foundry-agents-hack`)
  - Microsoft Foundry Resource
  - Microsoft Foundry Project (under the Foundry Resource)
  - Azure Storage Account
  - Azure AI Search service
- Verify that the auto-generated `.env` file exists and all values are populated (no `<placeholder>` values remain) by comparing it to `.env.sample`.
- Verify that you can sign in to [ai.azure.com](https://ai.azure.com) and navigate to your Foundry Project.
- Verify that you have a Python 3.10+ virtual environment with all packages from `requirements.txt` installed.

## Learning Resources

- [What is Azure AI Foundry?](https://learn.microsoft.com/azure/ai-studio/what-is-ai-studio)
- [Microsoft Agent Framework SDK overview](https://learn.microsoft.com/azure/ai-services/agents/overview)
- [Azure AI Projects SDK for Python](https://learn.microsoft.com/python/api/overview/azure/ai-projects-readme)
- [MCP (Model Context Protocol) specification](https://modelcontextprotocol.io/)
- [FastMCP — Build MCP servers in Python](https://github.com/jlowin/fastmcp)
- [Azure AI Search documentation](https://learn.microsoft.com/azure/search/)
- [Deploy Azure resources with Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview)
