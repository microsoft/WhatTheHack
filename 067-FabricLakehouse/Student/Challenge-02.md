# Challenge 02 - Land ho!

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Now you've found your data sources, it's time to land your data in OneLake.

## Description

In this challenge you will develop a solution to land your raw data in OneLake. You will need to consider how you will retrieve your data and where you will store in OneLake.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Provisioned any Fabric resources required to land your data
- Demonstrate that each dataset can retrieved automatically (but not necessarily on a schedule)
- Data is stored as-is in raw format in OneLake following a naming convention/location of your choice
- Error handling is always good, but not required for this challenge

## Background - Lakehouse Design

This section provides some background on the design of the Lakehouse for this challenge.

A Fabric Lakehouse [can be defined](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview) as a data architecture platform for storing, managing, and analyzing structured and unstructured data in a single location. Fabric leverages [Delta Lake](https://delta.io/) to store data in a lakehouse and expose as tables, similar to a more traditional database. It's these tables we can use query with SQL, Python or other tools like Excel and Power BI.

One of the key decisions when building a data lake / Lakehouse is _how_ to arrange your data - we're wanting to go diving in the ocean, not squelching in the [swamp](https://en.wikipedia.org/wiki/Data_lake#Criticism). 

A standard way of organising your Lakehouse is to use a "pattern" that divides your data in to different zones - typically these would be top level folders.
  - Raw - The data landed as-is
  - Bronze - Some basic processing, eg. data type conversion and loaded into a table but very similar in appearance to the raw data. (Sometimes raw and bronze are amalgamated into a single zone)
  - Silver - Pieces of Eight! Now we're talking. The data is cleaned, transformed and ready for us to use. 
  - Gold - Ah, Doubloons! Even more valuable, this is large scale data sets that have been aggregated, modelled and locked up in a chest for safe keeping. X marks the spot!



In this challenge, we will be landing our data in the "raw" zone, ready to turn into something more precious in [the next Challenge](./Challenge-03.md).

For more info on Lakehouses, check out the Learning Resources below.

## Learning Resources

- What is [OneLake](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview)?
- [Fabric Notes](https://aka.ms/FabricNotes)
- [What is the medallion lakehouse architecture?](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion)

- Fabric has dozens of connectors eg.
  [HTTP](https://learn.microsoft.com/en-us/fabric/data-factory/connector-http), [REST](https://learn.microsoft.com/en-us/fabric/data-factory/connector-rest-overview) and [OData](https://learn.microsoft.com/en-us/fabric/data-factory/connector-odata-overview)
- Python's [``urllib``](https://docs.python.org/3/library/urllib.html) supports a number of protocols including HTTP and FTP
  
## Tips

- Data providers are often very helpful and may be able to provide you with a code sample if you hunt around their web sites.
- Landing the data automatically is the goal, but you may want to start by manually downloading the data and then work on automating the process. If coding automated retrieval really doesn't float your boat, don't fall overboard, it's fine to manually download the data and then upload it to OneLake.

## Advanced Challenges (Optional)

Too comfortable?  Eager to do more?  Try these additional challenges!

- Schedule your data retrieval
- Archive your raw data before downloading the latest version
- Add some notification logic to alert you on what's going on with your process