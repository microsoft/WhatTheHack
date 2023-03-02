# What The Hack - Modern development and DevOps with GitHub

## Introduction

Increasing developer velocity and implementing proper DevOps procedures is a focus of most organizations in today's world. GitHub offers a suite of tools for developers to streamline code creation, automate tasks, and ensure code security. In this challenge-based hack you'll explore how to implement processes

## The scenario

As part of a give-back campaign, your organization is supporting a local pet shelter by updating, deploying and managing a web application for listing pets available for adoption.

## Learning Objectives

This DevOps with GitHub hack will help you learn how to use:

1. manage source control with GitHub
1. contribute code without installing resources locally with GitHub Codespaces
1. gain the support of an AI pair programmer with GitHub Copilot
1. automate deployment with GitHub Actions
1. ensure code security with GitHub Advanced Security

## Challenges

- [Challenge 0](./Student/challenge00.md) - Setup and introduction
- [Challenge 1](./Student/challenge01.md) - Configure your development environment
- [Challenge 2](./Student/challenge02.md) - Add a feature to the existing application
- [Challenge 3](./Student/challenge03.md) - Setup continuous integration and ensure security
- [Challenge 4](./Student/challenge04.md) - Create a deployment environment
- [Challenge 5](./Student/challenge05.md) - Setup continuous deployment


## Prerequisites

- Your own Azure subscription with **owner** access. See considerations below for additional guidance.
- A GitHub Enterprise account

## Repository Contents

- `../Student`
  - Student Challenge Guides
- `../Student/Resources`
  - Student's resource files, code, and templates to aid with challenges

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
