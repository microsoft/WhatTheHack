# Challenge 2: Scan Azure SQL Database and Azure Synapse Analytics (Serverless and Dedicated)

[< Previous Challenge](./Challenge1.md) - [Home](../readme.md) - [Next Challenge >](./Challenge3.md)

## Introduction

We will continue scanning more deta sources in and in this challenge we will scan in the serverless and dedicated pools of Fabrikam's Azure Synapse Analytics and continue to populate the Data Catalog. As before, after performing a successfully full scan, review the scan results, and like before setup weekly incremental scans. Finally login using a user account with Reader permissions to ensure that the search results from the catalog shows the assets from the Data Lake.

## Success Criteria
- Register the Azure under a collection that is accessible to all users.
- Run a successful scan of the serverless and dedicated pools using the Azure Purview Managed Identity.
- Review the successful scan results.
- Setup a weekly incremental scan.
- Ensure the search results are accessible for the users that belong to the AllUsers group.

## Extended challenge
- Thoughts?

## Learning Resources
- https://docs.microsoft.com/en-us/azure/purview/register-scan-synapse-workspace
- https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-scanning
