# Challenge 7 - Unified Data Governance

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)**

## Introduction

WWI wants to get a centralized view of all data assets and offer data sources discoverable and understandable to enterprise users and customers. Currently, a group of data analysts and data engineers are spending more time on manual processes to annotate, catalog and find trusted data sources. There's no central location to register data sources. Data consumers spend a lot of time tracing root cause problems created by upstream data pipelines that are owned by other teams.

They also want to address all below (not easy to answer) questions,

- How do users know what data is available?
- Does the data contain sensitive or personal information (PII, PCI, PHI etc.)?
- How do administrators manage data when they may not know what type of data exists and where it's stored?
- How can one derive the end-to-end data flow while compiling reports or data products?

## Description

The objective of this challenge is to implement Purview core features such as data map, data catalog and lineage using resources (Data sources) deployed part of previous challenges. This challenge involves configuring various resources such as Microsoft Purview account, Purview collection, Key Vault, Purview integration with Azure Data Factory and Synapse, ADF copy sample job etc.

**NOTE:** If you haven't completed previous challenges, then you can bring your own or register any data sources you have in your subscription. Provision a basic tier SQL database (Use existing data option) with AdventureWorksLT sample data pre-loaded.

## Success Criteria

- Verify all the data sources (For example. Resources such as ADLS Gen2, SQL Dedicated Pool, SQL Database etc.) are registered and associated with appropriate collection hierarchy in Purview data map
- Verify the scanning works fine for the registered data sources.
- Validate the synapse and ADF is integrated with Microsoft Purview account
- Validate the catalog search works fine using Synapse Workspace and Microsoft Purview portal.
- Verify the Table Dimension.Employee column "WWI Employee ID" classified with custom classification rule. Show the total number of columns classified (Auto or custom) to coach. Note: Use employee table in a Dedicated SQL pool or use product table (productnumber column) in a sample Adventure Works SQL Database.
- Verify the label applied to sensitive fields for your registered data sources, validate using catalog search and filtering.
- Verify the lineage captured for an ADF copy job.

## Learning Resources

- [Quickstart: Create a Microsoft Purview (formerly Azure Purview) account - Microsoft Purview | Microsoft Docs](https://docs.microsoft.com/en-us/azure/purview/create-catalog-portal)
- [How to manage multi-cloud data sources - Microsoft Purview | Microsoft Docs](https://docs.microsoft.com/en-us/azure/purview/manage-data-sources)
- [Lineage from SQL Server Integration Services - Microsoft Purview | Microsoft Docs](https://docs.microsoft.com/en-us/azure/purview/how-to-lineage-sql-server-integration-services)
- [Connect a Data Factory to Microsoft Purview - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/connect-data-factory-to-azure-purview)
- [Connect to and manage dedicated SQL Pools in Microsoft Purview - Microsoft Purview | Microsoft Docs](https://docs.microsoft.com/en-us/azure/purview/register-scan-azure-synapse-analytics)
- [Connect to and manage Azure Synapse Analytics workspaces - Microsoft Purview | Microsoft Learn](https://learn.microsoft.com/en-us/azure/purview/register-scan-synapse-workspace?tabs=MI)
- [Connect to ADLS in Microsoft Purview - Microsoft Purview | Microsoft Docs](https://docs.microsoft.com/en-us/azure/purview/register-scan-adls-gen2?tabs=MI)
- [Quickstart: Connect to Synapse Workspace - Microsoft Purview | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/catalog-and-governance/quickstart-connect-azure-purview)
- [Create a custom classification - Microsoft Purview | Microsoft Docs](https://docs.microsoft.com/en-us/azure/purview/create-a-custom-classification-and-classification-rule)
- [Tutorial: Register and scan an on-premises SQL Server - Microsoft Purview | Microsoft Learn](https://learn.microsoft.com/en-us/azure/purview/tutorial-register-scan-on-premises-sql-server)
- [The future of compliance and data governance is here: Introducing Microsoft Purview - Microsoft Security Blog](https://www.microsoft.com/security/blog/2022/04/19/the-future-of-compliance-and-data-governance-is-here-introducing-microsoft-purview/)

## Tips

- Provision Microsoft Purview (not Azure purview) account in a same subscription, region and resource group as other previously deployed lab resources. Refer rebranding blog in learning resources.
- Register SQL Dedicated Pool as a data source, not Synapse Analytics Workspace.
- Pick the appropriate authentication option while registering data sources in Purview account.
- For SQL Server data source registration, turn off lineage extraction (preview).
- Setup manage identity on Data Lake Storage Gen2 for Purview access
- Setup collection specific data curator role for Synapse in Purview portal
- Setup collection specific data curator role for ADF in Purview portal.
- Do not use private endpoint or restricted network settings (This is recommended for demo/learning purpose only)
- Name the Purview account wisely to simplify permission assignment and overall search.
- While integrating ADF or Synapse with Purview, If the integration status is "Disconnected OR Unknown", then you need further troubleshooting in order to capture the lineage successfully.
- Create a sample copy job (without stored procedure) to test the lineage feature, sample copy job example – Copy fact.sale to fact.salecopy table using ADF or Synapse Pipeline.
- Create a custom classification to classify employee ID column in a Dimension.Employee table. Use the sample data .csv file for regular expression configuration and testing.  `wwiemployee.csv` is the employee sample data .csv file and is located in the `Resources.zip` file under the `Challenge07` folder.  For further classification, the file `productnum-sample.csv` in the same location as employee data can be executed for your knowlege but not as a success criteria.
- Re-scan the data asset to see the effect of custom classification.
- Use advanced filters in the data catalog to identify the table / column classification, use "\*" or specific keywords "City" based searching.

## Additional Challenges

- Setup scanning for containerized SQL Server databases.
