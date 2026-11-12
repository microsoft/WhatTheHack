# Challenge 00 - Prerequisites and Baseline

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the GitHub Copilot Cost Optimization What The Hack. Before you begin optimizing, you need to set up your environment to measure GitHub Copilot usage costs accurately. This challenge establishes your baseline—the "before" measurement that all subsequent challenges will compare against.

Understanding where credits go is essential to optimization. In this challenge, you'll confirm that usage-based billing (UBB) is active, learn how to read token breakdowns in VS Code, and complete a baseline coding task to capture your starting credit spend.

## Description

The GitHub Codespaces option uses this hack's preconfigured development container to set up the development tools and GitHub Copilot extensions needed for the challenges. If you use a local workstation instead, you will need to set up the required tools and extensions there.

The student resources include a starter codebase intentionally configured with sub-optimal GitHub Copilot settings—you'll be optimizing these in later challenges. 

### Use GitHub Codespaces

GitHub Codespaces provides a cloud-hosted Visual Studio Code environment that you can access in your browser. This hack's dev container is configured with Node.js, Python, and the GitHub Copilot extensions.

You need a GitHub account with access to GitHub Copilot and permission to use GitHub Codespaces. Codespaces compute and storage normally incur charges separately from GitHub Copilot, depending on your account's included usage and billing settings.  All personal GitHub.com accounts include a monthly quota of free usage each month. GitHub will provide users in the Free plan 120 core hours, or 60 hours of run time on a 2 core codespace, plus 15 GB of storage each month.

1. Open the Codespace for this hack: [GitHub Copilot Cost Optimization Codespace](https://aka.ms/wth/ghcpcostoptimization/codespace)
2. Sign in with your **personal** GitHub account.
3. Verify the `Dev container configuration` is set to the one for this hack, then click **Create Codespace**.
4. Wait for Visual Studio Code to load in your browser. The first launch takes approximately 3-5 minutes. Once it opens, confirm that the student resources and GitHub Copilot extensions are available.

> **NOTE:** To return to your environment later, open [Your Codespaces](https://github.com/codespaces) and select your existing Codespace.

### Use a local workstation

1. Extract the Resources.zip file provided by your coach.
2. Open the extracted folder in Visual Studio Code and install or update the GitHub Copilot and GitHub Copilot Chat extensions.

### Set up GitHub Copilot

In your chosen environment:

1. Verify your GitHub Copilot subscription by checking your billing settings
2. Confirm you can access your GitHub Copilot usage dashboard to view cumulative credit spend
3. Open the starter codebase in VS Code and familiarize yourself with its structure

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that usage-based billing (UBB) is active on your GitHub Copilot subscription
- Demonstrate that the VS Code Output panel shows token breakdowns for GitHub Copilot interactions
- Show that you can access the GitHub Copilot usage dashboard and view your current credit consumption
- Verify that the starter codebase is open in VS Code through your Codespace or the extracted Resources.zip
- Demonstrate that you have completed the baseline coding task and recorded the credit spend
- Show your documented baseline measurements including total credits and approach used

## Learning Resources

- [GitHub Codespaces Overview](https://docs.github.com/en/codespaces/overview)
- [GitHub Codespaces Billing](https://docs.github.com/en/billing/concepts/product-billing/github-codespaces)
- [GitHub Copilot Usage-Based Billing Overview](https://docs.github.com/en/copilot/about-github-copilot/what-is-github-copilot#pricing-for-github-copilot)
- [Understanding GitHub Copilot Tokens and Credits](https://docs.github.com/en/copilot)
- [Visual Studio Code Output Panel Documentation](https://code.visualstudio.com/docs/getstarted/userinterface#_output-panel)
- [GitHub Copilot Extension for VS Code](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
