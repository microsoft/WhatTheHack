# Challenge 0 - Pre-requisites - Setup

**[Home](../README.md)** - [Next Challenge >](./Challenge1.md)

## Introduction
A well planned and executed deployment will provide a strong foundation for a successful data governance platform. In this challenge you would review the best approaches of deploying Microsoft Purview and setting up collections based on the requirements below.

## Description
- Fabrikam has multi region presence (in US and Europe) and would like to have their governance tool to be able to scan all the data sources from all the regions.
- They would like to organize their assets and data sources by their region and then by their business's flow (Finance, Marketing and Sales).
- Finance assets should only be accessible for read by selected users that belong to the Finance group.
- The AllUsers group should only have permissions to read all the assets except Finance.
- Setup permissions by adding the relevant groups (Finance and AllUsers)

Deploy Microsoft Purview and create the collection structure based on the above requirements.

## Success Criteria
- Present deployed Microsoft Purview instance and access to the Purview Studio.
- Demonstrate the collection hierarchy built on the requirements above.

## Learning Resources
- [Microsoft Purview deployment best practices](https://docs.microsoft.com/en-us/azure/purview/deployment-best-practices)
- [Create and manage collections in Microsoft Purview](https://docs.microsoft.com/en-us/azure/purview/how-to-create-and-manage-collections)
- [Microsoft Purview collections architectures and best practices](https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-collections)
