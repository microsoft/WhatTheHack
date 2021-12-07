# Challenge 6: Data lineage

[< Previous Challenge](./Challenge5.md) - [Home](../readme.md) - [Next Challenge >](./Challenge7.md)

## Introduction

With multiple data sources in your environment, it may become challenging to understand lifecycle of the data sets. As these sources may be dependend on each other, changing one data set can impact whole process of data transformation. So far you have scanned your data sources and you can see individual metadata about these datasets. Time to see dependency and flow of data in your environement. It can be extremly helpful for "what if" analysis, tracing root cause or just to understand the lifecycle of the data. 

In this challenge you will create data movement pipeline within Azure Data Factory and see data flow in Azure Purview Linage. 


## Success Criteria
- Register Azure Data Factory in Azure Purview Studio.
- Create a pipeline in which you will copy data from Data Lake Store to Azure Synapse.
- Understand limitations of Linage feature
- Confirm that you can see data lineage between assets.

## Extended challenge
- SSIS?

## Learning Resources
- https://docs.microsoft.com/en-us/azure/purview/catalog-lineage-user-guide
- https://docs.microsoft.com/en-us/azure/purview/concept-best-practices-lineage-azure-data-factory
