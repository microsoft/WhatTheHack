# Challenge 02 - Striving for Silver

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

*This page is currently being worked on*

## Introduction
In this challenge we will begin to transform the data we loaded "as is" to the Bronze layer into more "standardized" and "integrated" datasets that are then loaded into the Silver layer.


## Description
Some of the things we try to achieve within the Silver layer are
- __Data Lake Storage Formats__  
  In the Bronze layer the data is usually stored in its native source format, such as CSV or TXT for file-based sources. In the Silver layer we make sure all the different data sources are converted into a file format better suited for the Data Lake, such as Parquet or Delta.
- __Domain Separation__  
  An important point to keep in mind is that in the Bronze layer, the data is often organized based on the Source System or source object name, on the contrary, in the Silver layer the data is organized by Domain, such as Customer or Product. 
- __Consolidation__  
  We also try and consolidate the disparate data structures on the source side into a more conformed structure. For example, we could have 10 different sources bringing in various kinds of Customer data but in the Silver layer we try and keep one consistent structure for our Customer data and mold our source data accordingly.
- __Data Type Standardization__  
  As part of the new consolidation, we try and standardize the data types in our Silver layer structures and mold our source data accordingly.
- __Formatting__  
  Continuing with the trend of standardizing, we make sure our Silver layer data does not have different kinds of formatting within the data. We could do that by doing things such as enforcing NULLs if needed, cleaning up blank spaces, syncing up decimal points across the sources etc.
- __Partitioning and Sharding__  
  Although optional for this challenge, this is highly recommended for more production focused use cases. Making sure the data is appropriately physically arranged ensures efficient access when doing ad-hoc analysis or when pulling to the Gold Layer.
  
The above steps can be achieved using Azure Databricks Spark/SQL or Azure Synapse Pipelines.  
__Bonus Challenge__: Brainstorm about how Azure Databricks and Azure Synapse can work together to help deliver this use case more efficiently.

## Success Criteria
To complete this challenge successfully, you should be able to:
- Validate that all the data has been transformed and has been loaded into the Silver layer in the appropriate storage hierarchies based on the discussion above.
- Showcase the data copied into the Silver layer and be able to articulate the transformations performed and the reasons for your choices.
- Showcase how this data can also be accessed for ad-hoc analysis and reporting, if the need be.


## Learning Resources
The following links may be useful to achieving the success crieria listed above.
- [Placeholder Link](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-access-control-overview) 




