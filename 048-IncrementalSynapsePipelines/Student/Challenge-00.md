# Challenge 0 - Setup the source and target environments

**[Home](../README.md)** - [Next Challenge>](Challenge-01.md)

## Introduction

We need to setup the proper environment for the Hackathon.  Thus, we need everyone on the team to have access to the Azure SQL and Synapse Environments.  Also, any ancilliaries resources such as the Azure Storage Account and Key Vault.  

## Description

For this challenge the following resources will need to be setup within your group environment.

- An Azure SQL database is created and configured with either the AdventureWorks or World-Wide-Importers database.
- A Synapse Environment including a SQL Dedicated Pool is created and configured.
- Key Vault is setup and configured and all users can see the secrets in the Key Vault.
- Establish a Linked Service in Azure Synapse Analytics that can connect to the Azure SQL Databases using Key Vault based secrets.
- Setup firewall rules so that only IP Ranges of the team members can access both the Azure SQL and Synapse Analytics envrionments.
- All resources are tagged appropriately. 

## Success Criteria

1. Validate that all resources exist in one Resource Group and are tagged appropriately.  

2. Validate that all team members have the proper access to all the assets, including the ability to perform SQL queries in both the Azure SQL and Dedicated Pool environments.


## Learning Resources

*The following links may be useful to achieving the success crieria listed above.*

- [Azure Synapse access control](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-access-control-overview) 

- [Use Azure Key Vault secrets in pipeline activities](https://docs.microsoft.com/en-us/azure/data-factory/how-to-use-azure-key-vault-secrets-pipeline-activities)

- [AdventureWorks sample databases](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)

- [World-Wide-Importers sample databases](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers)


## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

- Create an automated shutdown script/pipeline that will pause the dedicated pool during the non-traditional business hours.  Here are some samples:
   - [How to pause and resume dedicated SQL pools with Synapse Pipelines](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/how-to-pause-resume-pipelines)
   - [Automatic pause all Synapse Pools and keeping your subscription costs under control](https://www.drware.com/automatic-pause-all-synapse-pools-and-keeping-your-subscription-costs-under-control/)