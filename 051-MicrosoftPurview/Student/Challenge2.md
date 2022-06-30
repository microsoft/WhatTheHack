# Challenge 2: Scan Azure SQL Database and Azure Synapse Analytics (Serverless and Dedicated)

[< Previous Challenge](./Challenge1.md) - [Home](../README.md) - [Next Challenge >](./Challenge3.md)

## Introduction
After successfully scanning the first data source, it is time to scan other services. The more sources that are scanned, the more information Purview can provide.

## Description
We will continue scanning more data sources. In this challenge we will scan the Azure SQL Database, serverless and dedicated pools of Fabrikam's Azure Synapse Analytics and continue to populate the Data Catalog. Similar to the previous challenge, you will perform a full scan, review the results and setup weekly incremental scans. Finally login using a user account with Reader permissions to ensure that the search results from the catalog shows the assets from the databases.

## Success Criteria
- Successful registration of Azure SQL DB, Azure Synapse Analytics workspace under a collection that is accessible to all users.
- Present a successful scan of the Azure SQL DB, serverless and dedicated pools using the Microsoft Purview Managed Identity.
- Validate scanned assets by ensuring that the serverless database tables appear as assets within Micorosft Purview.
- Ensure the search results are accessible for the users that belong to the AllUsers group.

## Extended challenge
- Register an Microsoft Purview Account to a Synapse workspace. Explore how to discover Purview assets from Azure Synapse workspace and interact with them using Synapse capabilities

## Learning Resources
- [Connect to and manage Azure Synapse Analytics workspaces in Microsoft Purview](https://docs.microsoft.com/en-us/azure/purview/register-scan-synapse-workspace)
- [Microsoft Purview scanning best practices](https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-scanning)
- [QuickStart: Connect a Synapse workspace to a Microsoft Purview account](https://docs.microsoft.com/en-us/azure/synapse-analytics/catalog-and-governance/quickstart-connect-azure-purview)
- [Discover, connect, and explore data in Synapse using Microsoft Purview](https://docs.microsoft.com/en-us/azure/synapse-analytics/catalog-and-governance/how-to-discover-connect-analyze-azure-purview)
