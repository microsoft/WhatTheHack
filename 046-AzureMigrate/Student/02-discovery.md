# Challenge 2: Discovery and Assessment

[< Previous Challenge](./01-design.md) - **[Home](../README.md)** - [Next Challenge >](./03-prepare.md)

## Introduction

During this challenge we will perform the discovery stage of a migration.  At the end of the challenge you should have a clear understanding of the on-premises environment and a detailed plan for migrating each component of the workload.

## Pre-requisites

For this challenge you should have already completed all the previous challenges.  You will need access to the Azure and on-premises environment created for this hack, and should have a high-level migration plan.

## Description

During this challenge we'll deploy and configure tooling to help us assess the on-premises environment. We'll use this information to plan the migration.

- How will you collect information about the current configuration of all on-premises VMs?
  - Consider that in a typical environment there may be hundreds or thousands of VMs
- Produce an estimate of the costs of running the migrated VMS in Azure
- Verify that the chosen migration approach will work for each resource
- Explore which other tools and solutions you could use to collect additional information in the source environment

## Success Criteria

- An assessment of the on-premises digital estate has been performed:
  - Migration readiness to Azure IaaS has been evaluated
  - A cost estimation has been performed
  - Application dependencies have been discovered
- You are aware of any differences in approach that might be needed if workloads are running on VMware or physical hosts

## Learning Resources

- [Assess Hyper-V VMs for migration to Azure](https://docs.microsoft.com/azure/migrate/tutorial-assess-hyper-v)
- [Agentless software inventory and dependency analysis](https://techcommunity.microsoft.com/t5/azure-migration-and/build-high-confidence-migration-plans-using-azure-migrate/ba-p/3248554)
- [Create Virtual Network in Azure Portal](https://docs.microsoft.com/azure/virtual-network/quick-create-portal)

## Tips

Here is some information about the nested VMs you will find in the simulated environment:

- smarthotelweb1 (192.168.0.4): web tier (IIS)
- smarthotelweb2 (192.168.0.5): application tier (IIS)
- smarthotelsql1 (192.168.6): database tier (SQL Server). Inbound traffic on port 1433 on the host VM is forwarded to this VM
- UbuntuWAF (192.168.8): nginx reverse proxy. Inbound traffic on port 80 on host VM is forwarded to this VM. It then forwards traffic to the web tier (smarthotelweb1)

Credentials to all Windows machines are `Administrator`/`demo!pass123`. For the Ubuntu VM, it is `demouser`/`demo!pass123`.
