# Challenge 3: Scan a on-premise SQL Server

[< Previous Challenge](./Challenge2.md) - [Home](../README.md) - [Next Challenge >](./Challenge4.md)

## Introduction

As part of scanning data sources, in this challenge we will scan an on-prem SQL Server. Fabrikam's has its Finance data on the on-prem SQL Server which we will scan as part of this challenge.

## Success Criteria
- Restore the WideWorldImporters database (https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak) 
- Register the on-prem SQL Server under a collection that is accessible to the Finance users.
- Run a successful scan of the SQL Server using a SQL Server authenticated user that has only reader access to the Finance database.
- Review the successful scan results.
- Setup a weekly incremental scan.
- Ensure the search results are accessible only for the users that belong to the Finance group.

## Learning Resources
- https://docs.microsoft.com/en-us/azure/purview/register-scan-on-premises-sql-server
- https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-scanning
