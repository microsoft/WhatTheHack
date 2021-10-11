# Challenge 1: Design And Planning - Coach's Guide

[< Previous Challenge](./00-lab_setup.md) - **[Home](./README.md)** - [Next Challenge >](./02-discovery.md)

## Notes and Guidance

- Approximate duration: 30-60 minutes (depends on how deep you go with the participants)
- Make participants develop a design for your target architecture in Azure and a plan for migrating the on-premises workload
- Use this opportunity to talk a bit about landing zones
- Ensure they're doing an IaaS lift & shift not something whacky involving App Service, AKS, Azure Functions, etc
- Verify they're planning on using Azure Migrate not ASR
- Potentially discuss other Lift & Shift alternatives (5 Rs)
- Some points to discuss:
    - Agent-based vs the agent-less approach
    - Replication using the private or public endpoint
    - Network sizing for replication
    - Reserved IP addresses in Azure (the first 3 IP addresses of each subnet)
    - Identity migration (Domain Controllers, AAD Connect, etc)
- You can share these links as further reading:
    - [Cloud Adoption Plan and Azure DevOps](https://docs.microsoft.com/azure/cloud-adoption-framework/plan/template)
