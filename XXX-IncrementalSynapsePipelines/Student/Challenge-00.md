# Challenge #0 - Setup the source and target environments

**[Home](../README.md)** - [Next Challenge>](Challenge-01.md)


## Description

We need to setup the proper environment for the Hackathon.  Thus, we need everyone on the team to have access to the Azure SQL, Synapse Environments and also any ancilliaries resources such as the Azure Storage Account and Key Vault.

## Success Criteria

1. An Azure SQL database is created and configured with the AdventureWorks database

2. A Synapse Environment including a SQL Dedicated Pool is created and configured

3. Key Vault is setup

4. All resources exist in one RG and that all team members have the proper access to the assets, including the ability to perform SQL queries in both the Azure SQL and Dedicated Pool environments

5. Establish a Linked Service in Azure Synapse Analytics that can connect to the Azure SQL Databases using Key Vault secret based credentials

6. Setup firewall rules so that only IP Ranges of the team members can access both the Azure SQL and Synapse Analytics envrionments.



## Learning Resources

*The follow links may be useful to achieving the success crieria listed above.*

- [Azure Synapse access control](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-access-control-overview). 

- [Use Azure Key Vault secrets in pipeline activities](https://docs.microsoft.com/en-us/azure/data-factory/how-to-use-azure-key-vault-secrets-pipeline-activities).


- [AdventureWorks sample databases](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms).


## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

- Create an automated shutdown script/process that will pause the dedicated pool during the non-traditional business hours.