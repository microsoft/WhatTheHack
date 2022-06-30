# Challenge 1: Scanning Azure Data Lake Storage - Coach Guide  

[< Previous Solution](./Solution0.md) - [Home](./README.md) - [Next Solution >](./Solution2.md)


## Introduction

Duration: 30 minutes 

Pre-requisites: This challenge needs an Azure Data Lake Store with a container created. Optionally use the PS script provided to deploy ADLS.

The data for the data lake is stored at: https://svcmadls.blob.core.windows.net/purviewhackdata 

Attendees can use Storage Explorer to connect to this location and copy over the data to their ADLS location. Optionally, if the attendees would like to use their own data it should be fine too. We would recommend 30-40 minutes to accomplish this challenge. This challenge is the first one where attendees start scanning data sources into Microsoft Purview. It might be a good idea to ensure all the attendees know how storage and ADLS work and provide some assistance in this space, if needed. Give yourself sufficient time post the challenge to discuss the results. What we find useful in discussing is the outcome of the scan results itself to show where to look for in case scans ran into errors and the importance of RunIDs while creating support tickets. Talk about how to use sub-collections to ingest data from a scan specifically into a sub-collection. Discuss the search functionality and use this opportunity to talk about the various filters to filter on the data. Also, it is useful to discuss various tabs of a given asset, automatic classification, manual classification at an asset level, schema level and how to work with bulk modifications. Talk about basic resource set functionality and how to enable the extended resource set functionality and its cost implication. 

Ensure you touch upon the extended challenge and talk about it if time permits.

##  Resources
- https://docs.microsoft.com/en-us/azure/purview/how-to-search-catalog
- https://docs.microsoft.com/en-us/azure/purview/concept-resource-sets
