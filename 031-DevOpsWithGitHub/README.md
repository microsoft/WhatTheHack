# What The Hack - DevOps with GitHub

## Introduction
DevOps is a journey not a destination. Our goal when writing this challenged based hack is to introduce you to GitHub and some common DevOps practices. We also understand that your choice of programming language and DevOps processes might differ from the ones we will be using in this hack, that is OK. Our intent was to select some of the most common programming languages and highlight industry best practices, with an emphasis on showing how GitHub can help you on your DevOps journey, so that you can apply this in your environment with the languages and tools that you use.

## Learning Objectives

This DevOps with GitHub hack will help you learn:
1. How to use GitHub to manage source control
2. How to use GitHub for Cloud based Development Environments
3. How to use GitHub for Project Management
4. How to use GitHub Actions for CI & CD
5. How to use GitHub for Advanced Security (Code Scanning & Dependabot)
6. Monitoring apps with Application Insights

## Challenges
 - Challenge 00: [Setup Azure & Tools](./Student/Challenge-00.md)
 - Challenge 01: [Setup Your Repository](./Student/Challenge-01.md)
 - Challenge 02: [Setup a Codespace](./Student/Challenge-02.md)
 - Challenge 03: [Track Your Work with GitHub Project Boards](./Student/Challenge-03.md)
 - Challenge 04: [First GitHub Actions Workflow](./Student/Challenge-04.md)
 - Challenge 05: [Infrastructure as Code](./Student/Challenge-05.md)
 - Challenge 06: [Continuous Integration](./Student/Challenge-06.md)
 - Challenge 07: [Build and Push Docker Image to Container Registry](./Student/Challenge-07.md)
 - Challenge 08: [Continuous Delivery](./Student/Challenge-08.md)
 - Challenge 09: [Branching & Policies](./Student/Challenge-09.md)
 - Challenge 10: [Security](./Student/Challenge-10.md)
 - Challenge 11: [Monitoring: Application Insights](./Student/Challenge-11.md)

## Prerequisites
- Your own Azure subscription with **owner** access. See considerations below for additional guidance.
- [Visual Studio Code](https://code.visualstudio.com)
- [Git SCM](https://git-scm.com/download)

## Repository Contents
- `../Student`
  - Student Challenge Guides
- `../Student/Resources`
  - Student's resource files, code, and templates to aid with challenges

## Considerations

If you are running this hack with a group, here are some options for providing access to Azure:
- Each person/team uses their own subscription
- Use a single subscription with each person/team using a different resource group
- Use a single subscription and resource group, with each person/team creating resources within the single resource group (less ideal)

Regardless of the option you choose, you'll have to consider:
- [Azure default quotas and resource limits](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits) (for example, # of VMs allowed per region or subscription)
- Unique naming of resources - many services may require a globally unique name, for example, App service, container registry.

## Contributors
- [Kevin M. Gates](https://github.com/kevinmgates)
- Will Fox
- [Andy Huang](https://github.com/whowong)
- Julia Nathan
- [Colin Beales](https://github.com/colinbeales/)
