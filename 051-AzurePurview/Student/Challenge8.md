# Challenge 8: Enhancing Microsoft Purview with Atlas API

[< Previous Challenge](./Challenge7.md) - [Home](../README.md)

## Introduction
With rich functionality of Microsoft Purview, there are still some features which are not available yet in the product and may be relevant in the production deployments. Also, there are some tasks you may have in the environment, which cannot be performed with the typical UX experience. Atlas API can help you enhance your solution with custom features like custom lineage. This will allow you to create lineage between assets , even if data processor you are using is not supported out of the box. Atlas API can be also helpful with automation of repetitive tasks like bulk load glossary terms. 

## Description
Fabrikam team is very happy with current Microsoft Purview deployment. Yet, there are parts of their overall solution which are not reflected in the Data Catalog. Particularly, Fabrikam has a custom developed database solution called CustomDB. They would like to create entities pertaining to their CustomDB within Microsoft Purview and would like to show the lineage between these custom entities created in Purview. As part of a POC, you are requested to create a type definition for CustomDB, create 2 source entities (Customers, Orders), create a destination entity (reporting). Once the entities have been created, create a lineage which shows data from Customers and Orders table transform into Reporting table (similar to the below):

![screenshot](./screenshotChallenge8.png)

## Success Criteria
- Validate new type definitions and entities for CustomDB.
- Validate linage between assets (Orders, Customers and Reporting tables). 

## Learning Resources
- https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-automation
- https://github.com/wjohnson/pyapacheatlas
