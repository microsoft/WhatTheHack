# Challenge #0 - Setup the source and target environments

**[Home](../README.md)** - [Next Challenge>](Challenge-01.md)


## Description

We need to setup the proper environment for the Hackathon.  Thus, we need everyone on the team to have access to the Azure SQL, Synapse Environments and also any ancilliaries resources such as the Azure Storage Account and Key Vault.

## Success Criteria

1. An Azure SQL database is created and configured with either the AdventureWorks or World-Wide-Importers database.

2. A Synapse Environment including a SQL Dedicated Pool is created and configured.

3. Key Vault is setup and configured and all users can see the secrets in the Key Vault.

4. Establish a Linked Service in Azure Synapse Analytics that can connect to the Azure SQL Databases using Key Vault based secrets.

5. Setup firewall rules so that only IP Ranges of the team members can access both the Azure SQL and Synapse Analytics envrionments.

6. All resources exist in one RG and that all team members have the proper access to all the assets, including the ability to perform SQL queries in both the Azure SQL and Dedicated Pool environments.

7. All resources are tagged appropriately. 


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