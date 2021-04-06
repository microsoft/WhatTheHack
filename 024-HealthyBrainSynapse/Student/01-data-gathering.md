# Challenge 1: Gathering Open Powerlifting Data

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-load-data.md)

## Introduction
In the challenges ahead, the coach will provide you with data to load into a data store from which it can be queried, visualized, and analyzed. The [data](https://github.com/sstangl/openpowerlifting-static/raw/gh-pages/openpowerlifting-latest.zip) comes from [OpenPowerlifting.org](https://www.openpowerlifting.org/) and is [licensed](https://openpowerlifting.gitlab.io/opl-csv/) for Public Domain use.

## Description
In the challenges ahead, you will need to load this data into a data store from which it can be queried, visualized, and analyzed.  You will have broad latitude in choosing the data service you think is most appropriate.  For purposes of Challenge 1, assume that in later challenges you will be loading the data into a relational database.  Choose a ‘landing zone’ storage service that will provide maximum flexibility in further processing of the data, while also meeting basic security and resilience requirements.

Your security requirements include:
- Do not expose the uploaded data files to anonymous (Public) internet access.
- Support controlling access to folders and files based on Azure Active Directory identity.

## Success Criteria
- Explained to the coach which storage service will be used and why
- Show the data uploaded to the storage service of choice
- Explained to the coach how you would store access keys to said storage service without putting sensitive credentials in connection strings/code
- Explained the manageability and security benefits of using Azure Active Directory identity to control access

## Learning Resources
- [Introduction to Azure Blob storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)
- [Introduction to Azure Data Lake Storage Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)
- [Manage storage account keys with Key Vault and the Azure CLI](https://docs.microsoft.com/en-us/azure/key-vault/secrets/overview-storage-keys)
- [Use Azure Active Directory Authentication for authentication with Synapse SQL](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/active-directory-authentication)