# Challenge 0 - Pre-requisites - Setup

**[Home](../readme.md)** - [Next Challenge >](./Challenge1.md)

## Introduction

A well planned and executed deployment will provide a strong foundation for a successful data governance platform. In this challenge you would review the best approaches of deploying Azure Purview and setting up collections based on the requirements below.

## Requirements
- Fabrikam has multi region presence (In US and Europe) and would like to have their governance tool to be able to scan all the data sources from all the regions.
- They would like to have organize their assets and data sources by their region and then by their business's flow (Finance, Marketing and Sales).
- Finance assets should only be accessbile for read by selected users that belong to Finance group.
- The AllUsers group should only have permissions to read all the assets except Finance.

Deploy Azure Purview and create the collection structure based on the above requirements.

## Success Criteria
- Deploy Azure Purview using the portal and be able to access the Purview Studio.
- Create the collection hierarchy built based on the above requirements.
- Setup permissions by adding the relevant groups (Finance and AllUsers) and demonstrate the collections and permissions to the coach.

## Learning Resources
- https://docs.microsoft.com/en-us/azure/purview/deployment-best-practices
- https://docs.microsoft.com/en-us/azure/purview/how-to-create-and-manage-collections
- https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-collections
