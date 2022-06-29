# Challenge 3: Scan an On-Prem SQL Server

[< Previous Challenge](./Challenge2.md) - [Home](../README.md) - [Next Challenge >](./Challenge4.md)

## Introduction
As part of scanning data sources, in this challenge we will scan an on-prem SQL Server. Fabrikam's has its Finance data on the on-prem SQL Server which we will scan as part of this challenge.

## Description
In this challenge, you need to first restore the database to your SQL Server. The backup will be found here - [https://stpurviewfasthack.blob.core.windows.net/purviewfasthack](https://wthpurview.blob.core.windows.net/wthpurview). Then, register on-premises SQL Server under a collection that is accessible to the Finance users and scan it.


## Success Criteria
- Successful scan of the on-premises SQL Server assets in Purview Studio.
- Ensure the search results are accessible only for the users that belong to the Finance group.

## Learning Resources
- [Connect to and manage an on-premises SQL server instance in Microsoft Purview](https://docs.microsoft.com/en-us/azure/purview/register-scan-on-premises-sql-server)
- [Microsoft Purview scanning best practices](https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-scanning)
