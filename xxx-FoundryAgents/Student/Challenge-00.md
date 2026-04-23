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

### Setup Development Environment

You will need a set of developer tools to work with the sample application for this hack.

You can use GitHub Codespaces where we have a pre-configured development environment set up and ready to go for you, or you can setup the developer tools on your local workstation.

A GitHub Codespace is a development environment that is hosted in the cloud that you access via a browser. All of the pre-requisite developer tools for this hack are pre-installed and available in the codespace.

- [Use GitHub Codespaces](#use-github-codespaces)
- [Use Local Workstation](#use-local-workstation)

**NOTE:** We highly recommend using GitHub Codespaces to make it easier to complete this hack.

#### Use GitHub Codespaces

You must have a GitHub account to use GitHub Codespaces. If you do not have a GitHub account, you can [Sign Up Here](https://github.com/signup).

GitHub Codespaces is available for developers in every organization. All personal GitHub.com accounts include a monthly quota of free usage each month. GitHub will provide users in the Free plan 120 core hours, or 60 hours of run time on a 2 core codespace, plus 15 GB of storage each month.

You can see your balance of available codespace hours on the [GitHub billing page](https://github.com/settings/billing/summary).

The GitHub Codespace for this hack will host the developer tools, sample application code, configuration files, and other data files needed for this hack. Here are the steps you will need to follow:

- A GitHub repo containing the student resources and Codespace for this hack is hosted here:
  - [WTH Foundry Agents Codespace Repo](https://aka.ms/wth/foundryagents/codespace/)
  - Please open this link and sign in with your personal Github account.

**NOTE:** Make sure you do not sign in with your enterprise managed Github account.

Once you are signed in:

- Verify that the `Dev container configuration` drop down is set to `xxx-FoundryAgents`
- Click on the green "Create Codespace" button.

Your Codespace environment should load in a new browser tab. It will take approximately 3-5 minutes the first time you create the codespace for it to load.

- When the codespace completes loading, you should find an instance of Visual Studio Code running in your browser with the files needed for this hackathon.

##### Open Codespace Locally in VS Code (Recommended)

Our guidance is to open the Codespace locally in VS Code on your device/laptop. This ensures that `az login` browser authentication works correctly.

Once the Codespace is running, open a terminal in VS Code and set the following environment variable:

```bash
# This ENV 'tricks' VS Code to think this is not a Codespace, so it will pop a browser auth window.
export CODESPACES=false
```

Now you can run `az login` from the terminal in VS Code on your laptop and the browser pop-up authentication should work as expected.

Your developer environment is ready, hooray! Skip to section: [Authenticate with Azure](#authenticate-with-azure)

**NOTE:** If you close your Codespace window, or need to return to it later, you can go to [GitHub Codespaces](https://github.com/codespaces) and you should find your existing Codespaces listed with a link to re-launch it.

**NOTE:** GitHub Codespaces time out after 20 minutes if you are not actively interacting with it in the browser. If your codespace times out, you can restart it and the developer environment and its files will return with its state intact within seconds. If you want to have a better experience, you can also update the default timeout value in your personal setting page on Github. Refer to this page for instructions: [Default-Timeout-Period](https://docs.github.com/en/codespaces/setting-your-user-preferences/setting-your-timeout-period-for-github-codespaces#setting-your-default-timeout-period)

**NOTE:** Codespaces expire after 30 days unless you extend the expiration date. When a Codespace expires, the state of all files in it will be lost.

#### Use Local Workstation

**NOTE:** You can skip this section if you are using GitHub Codespaces!

If you want to setup your environment on your local workstation, expand the section below and follow the requirements listed.

<details markdown=1>
<summary markdown="span">Click to expand/collapse Local Workstation Requirements</summary>

##### Install Required Tools

Please ensure the following tools are installed on your workstation:

- **Python 3.10+** — Download from [python.org](https://www.python.org/downloads/)
- **Azure CLI 2.65+** — Install from [aka.ms/installazurecli](https://aka.ms/installazurecli)
- **Azure CLI `ml` extension** — Required for Foundry CLI operations
- **Visual Studio Code** with the [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python)

##### Set Up Python Environment

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

</details>

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

### Set Up Python Environment (Local Workstation Only)

**NOTE:** Skip this section if you are using GitHub Codespaces — your Python environment is already configured!

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
