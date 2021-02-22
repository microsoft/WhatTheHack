# Challenge 1: Gathering Open Powerlifting Data

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-load-data.md)

## Introduction

In the challenges ahead, you will need to **[load this data](https://github.com/sstangl/openpowerlifting-static/raw/gh-pages/openpowerlifting-latest.zip)** into a data store from which it can be queried, visualized, and analyzed.  The data comes from [OpenPowerlifting.org](https://www.openpowerlifting.org/) and is [licensed](https://openpowerlifting.gitlab.io/opl-csv/) for Public Domain use.

## Description

In the challenges ahead, you will need to load this data into a data store from which it can be queried, visualized, and analyzed.  You will have broad latitude in choosing the data service you think is most appropriate.  For purposes of Challenge 1, assume that in later challenges you will be loading the data into a relational database.  Choose a ‘landing zone’ storage service that will provide maximum flexibility in further processing of the data, while also meeting basic security and resilience requirements.

Your security requirements include:
1.	Do not expose the uploaded data files to anonymous (Public) internet access.
2.	Support controlling access to folders and files based on Azure Active Directory identity.

## Success Criteria

1. Explain to the coach which storage service will be used and why
2. Show the data uploaded to the storage service of choice

*Bonus*
- Explain how you would store access keys to said storage service without putting sensitive credentials in connection strings/code
- Explain the manageability and security benefits of using Azure Active Directory identity to control access

## Learning Resources

Reference articles:
- https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction
- https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction

- https://docs.microsoft.com/en-us/azure/key-vault/general/basic-concepts
- https://docs.microsoft.com/en-us/azure/key-vault/secrets/overview-storage-keys

- https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/active-directory-authentication
