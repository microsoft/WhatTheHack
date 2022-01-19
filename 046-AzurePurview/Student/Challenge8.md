# Challenge 8: Enhancing Azure Purview with Atlas API

[< Previous Challenge](./Challenge7.md) - [Home](../readme.md)

## Description

Fabrikam team is very happy with current Azure Purview deployment. Although, with enhancing data platform environment, there are parts of solution which are not reflected in the Data Catalog. Recently data team added stored procedures to transform data within Azure SQL Database and this breaks Purview linage. This feature is not available out of the box, but your team really needs this to be working. There are also requests for custom reporting on top of existing Azure Purview Insights. It would be perfect to be able to analyze metadata in Power BI report. Last but not least, there is an ask about loading glossary terms based on definition which your team has already in HR database.

## Introduction

With rich functionality of Azure Purview, there are still some features which are not available yet in the product and may be revelant in the production deployment. Also, there are some tasks you may have in the environemnt, which are not feasible with the typical UX experience. Atlas API can help you enhance your solution with custom features like custom linage. This will allow you to create linage between assets, even if data procesor you are using is not supported out of the box. Atlas API can be also helpful with automation of repetitive tasks like bulk load glossary terms.


## Success Criteria
- Create a custom linage between assets (WWInvoices and Invoice Rank tables) which use Azure SQL DB Stored Procedure (STORED PROCEDURE NAME) as a data processor.
- Bulk load multiple glossary terms based on Azure SQL DB table.
- Export metadata from Azure Purview to .CSV file and create sample Power BI report using this data.

## Learning Resources
- https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-automation
- https://github.com/wjohnson/pyapacheatlas
