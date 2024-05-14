# What The Hack - Modern development and DevOps with GitHub

## Introduction

Increasing developer velocity and implementing proper DevOps procedures is a focus of most organizations in today's world. GitHub offers a suite of tools for developers to streamline code creation, automate tasks, and ensure code security. In this challenge-based hack you'll explore how to implement processes

## The scenario

As part of a give-back campaign, your organization is supporting a local pet shelter by updating, deploying and managing a web application for listing pets available for adoption.

## Learning Objectives

This DevOps with GitHub hack will help you learn how to:

1. Manage source control with GitHub
1. Contribute code without installing resources locally with GitHub Codespaces
1. Gain the support of an AI pair programmer with GitHub Copilot
1. Automate deployment with GitHub Actions
1. Ensure code security with GitHub Advanced Security

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Gather the necessary resources and create the repository to store the project
- Challenge 01: **[Configure Your Development Environment](Student/Challenge-01.md)**
	 - Setup your development environment in the cloud
- Challenge 02: **[Add A Feature To The Existing Application](Student/Challenge-02.md)**
	 - Leverage GitHub Copilot to help you add features to your application
- Challenge 03: **[Setup Continuous Integration And Ensure Security](Student/Challenge-03.md)**
	 - Setup continuous integration and integrate GitHub Advanced Security into your pipeline
- Challenge 04: **[Create A Deployment Environment](Student/Challenge-04.md)**
	 - Use CaC/IaC to provision your cloud environment
- Challenge 05: **[Setup Continuous Deployment](Student/Challenge-05.md)**
	 - Deploy your application to Azure with Continuous Delivery

## Prerequisites

- Your own Azure subscription with **owner** access. See considerations below for additional guidance.
- A GitHub Enterprise account if using internal repositories, or a standard GitHub account if using public repositories.

## Considerations

If you are running this hack with a group, here are some options for providing access to Azure:

- Each person/team uses their own subscription (ideal)
- Use a single subscription with each person/team using a different resource group
- Use a single subscription and resource group, with each person/team creating resources within the single resource group (less ideal)

Regardless of the option you choose, you'll have to consider:

- [Azure default quotas and resource limits](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits) (for example, # of VMs allowed per region or subscription)
- Unique naming of resources - many services may require a globally unique name, for example, App service, container registry.
  
## Contributors

- [Christopher Harrison](https://github.com/geektrainer)
