# Challenge 1: Scanning Azure Datalake Storage

[< Previous Challenge](./Challenge0.md) - [Home](../readme.md) - [Next Challenge >](./Challenge2.md)


## Introduction

Now that we have successfully setup Azure Purview we need to start scanning the data sources into Azure Purview to create the Data Map and the Data Catalog. In this challenge you will start with scanning Fabrikam's Data Lake Store to ingest the metadata successfully by performing a full scan, review the scan results, setup weekly incremental scans. Finally login using a user account with Reader permissions to ensure that the search results from the catalog shows the assets from the Data Lake.

## Success Criteria
- Register the Data Lake store under a collection that is accessible to all users.
- Run a successful scan of the data lake using the Azure Purview Managed Identity.
- Review the successful scan results.
- Setup a weekly incremental scan.
- Ensure the search results are accessible for the users that belong to the AllUsers group.

## Extended challenge
- Thoughts?

## Learning Resources
- https://docs.microsoft.com/en-us/azure/purview/manage-data-sources
- https://docs.microsoft.com/en-us/azure/purview/register-scan-adls-gen2
- https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-scanning
