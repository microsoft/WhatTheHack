# Challenge 00 - Azure AI Foundry Onboarding & Environment Prep

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Pre-requisites 

- Active Azure Subscription  
- Python 3.7 or higher (Python 3.13 preferred)  
- Pip (Python package installer)  
- GitHub account with access to the Agentic AI Apps repository  

*This challenge assumes you have completed the What The Hack onboarding and have access to GitHub Codespaces.*

---

## Introduction

In this challenge, you will set up your development environment for Azure AI Foundry. You will learn how to:

- Create Azure resources necessary for agent development
- Launch GitHub Codespaces for a cloud-hosted development environment
- Prepare a VM to test agent workloads
- Authenticate your Codespaces session with Azure

Completing this challenge ensures you have a fully functional workspace for building and running intelligent agents in subsequent challenges.

---

## Description

Your goal is to prepare an environment capable of running the Azure AI Foundry agents. This includes:

- Creating an Azure AI Foundry resource in your subscription
- Setting up GitHub Codespaces connected to your Azure account
- Installing required Python SDKs and dependencies
- Provisioning a Linux VM (`agentic-vm-test`) with contributor permissions to allow for read/  write operations
- Verifying your environment can run Python scripts and connect to Azure services

> **Note:** This challenge focuses on environment preparation. You are not yet building agents.

---

## Learning Resources

- [Azure AI Foundry Overview](https://learn.microsoft.com/en-us/azure/ai-foundry/what-is-azure-ai-foundry)  
- [GitHub Codespaces Documentation](https://docs.github.com/en/codespaces/about-codespaces/what-are-codespaces)  
- [Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/)  
- [Python `pip` Documentation](https://pip.pypa.io/en/stable/)

---

## Tips

- Ensure you keep your `.env` and Foundry configuration secure — you will reuse them in all subsequent challenges  
- Codespaces automatically installs dependencies; if something fails, check your terminal for installation errors  
- Use SSH keys carefully when configuring the VM for secure access

---

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify you can authenticate to Azure from GitHub Codespaces using `az login`
- Show that Python and required packages (`azure-ai-projects`, `azure-identity`) are installed
- Demonstrate that the VM is deployed, accessible via SSH, and has contributor permissions
- Confirm that your Codespaces terminal can interact with Azure AI Foundry resources

---

## Advanced Challenges (Optional)

If you want to go beyond the baseline setup:

- Experiment with different VM sizes and regions
- Enable additional managed identities and role assignments for advanced testing
- Configure the Codespace to mount external repositories for agent collaboration
