# Challenge 1: Scanning Azure Data Lake Storage

[< Previous Challenge](./Challenge0.md) - [Home](../README.md) - [Next Challenge >](./Challenge2.md)

## Introduction
An empty Purview instance doesn't bring much value. The whole magic starts when you start scanning your first data sources. Filling Purview with metadata will be fundamental of your Data Governance solution.

## Description
Now that we have successfully setup Microsoft Purview we need to start scanning the data sources into Microsoft Purview to create the Data Map and the Data Catalog. In this challenge you will start with scanning Fabrikam's Data Lake Store to ingest the metadata successfully by performing a full scan, review the scan results, setup weekly incremental scans. Finally login using a user account with Reader permissions to ensure that the search results from the catalog shows the assets from the Data Lake. 

Sample data files for your Data Lake can be found here: https://wthpurview.blob.core.windows.net/wthpurview

## Success Criteria
- Data Lake store registered under a collection that is accessible to all users.
- Completed a successful scan of the data lake using the Microsoft Purview Managed Identity.
- Validate scanned assets.
- Ensure the search results are accessible for the users that belong to the AllUsers group.

## Extended challenge
- Review the Policy Authoring support (link in the Learning Resources below) for enabling access to data stored in Blob and Azure Data Lake Storage (ADLS) Gen2. This is a Preview feature available only in storage accounts deployed in certain regions and hence not covered in the scope of this hack. But it is highly recommended to review and get a good understanding of this feature along with the coaches.

## Learning Resources
- [Manage data sources in Microsoft Purview](https://docs.microsoft.com/en-us/azure/purview/manage-data-sources)
- [Connect to Azure Data Lake Gen2 in Microsoft Purview](https://docs.microsoft.com/en-us/azure/purview/register-scan-adls-gen2)
- [Microsoft Purview scanning best practices](https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-scanning)
- [Tutorial: Access provisioning by data owner to Azure Storage datasets (preview)](https://docs.microsoft.com/en-us/azure/purview/how-to-access-policies-storage)
