# Challenge 02 - Land ho!

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Now you've found and documented your data sources, it's time to land your data in OneLake and to start to process it into something more valuable.

## Description

In this challenge you will develop a solution to:

- Land your raw data in OneLake.
- Process this data. You will need to consider how you will process the data (notebook, dataflow etc) and where you will store it in OneLake.

First, start by reading the background on Lakehouse design below. 

Next, you will need to download your source data and land it in OneLake. For this step, you're free to write code, a pipeline and/or dataflow to retrieve your data, or, if you prefer, you can manually download the data and upload it to OneLake. 

Finally, you will need to process your data - gently. At this stage you should only be doing some basic processing, eg. data type conversion and possibly loaded into a table (or stored in some other suitable format) but very similar in appearance to the source data.

If you get really stuck, don't worry! Your Coach is here to help and has provided you with a little something to unstick you. Remember we said no peeking in [Challenge 0](./Challenge-00.md)? If you're really stuck, talk to your coach and go have a peek at the notes at the end of [Challenge 0](./Challenge-00.md).

## Success Criteria

To complete this challenge successfully, you should:

- Have provisioned any Fabric resources required to land your data
- Demonstrate how you have retrieved each dataset (automatically, manually or a combination of both)
- Show that your data is stored as-is in OneLake following a naming convention/location of your choice
- Show that you have processed your data (eg. data type conversion, renaming columns, removing rows with errors, etc) and stored it in OneLake following your Lakehouse naming convention
  
Error handling is always good, but not required for this challenge

## Background - Lakehouse Design

This section provides some background on the design of the Lakehouse for this challenge.

A [Fabric Lakehouse] (https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview) can be defined as a data architecture platform for storing, managing, and analyzing structured and unstructured data in a single location. Fabric leverages [Delta Lake](https://delta.io/) to store data in a lakehouse and expose as tables, similar to a more traditional database. It's these tables we can use query with SQL, Python or other tools like Excel and Power BI. Fabric can also store plain files (text, docx, png etc) in the Lakehouse, useful for use cases like data science and machine learning.

One of the key decisions when building a data lake / Lakehouse is _how_ to arrange your data - we're wanting to go diving in the ocean, not squelching in the [swamp](https://en.wikipedia.org/wiki/Data_lake#Criticism). 

A standard way of organising your Lakehouse is to use a "pattern" that divides your data in to different zones:

- Raw - The data landed as-is
- Bronze - Some basic processing, eg. data type conversion and possibly loaded into a table (or stored in some other suitable format) but very similar in appearance to the raw data. (Sometimes raw and bronze are amalgamated into a single zone)
- Silver - Pieces of Eight! Now we're talking. The data is cleaned, transformed and ready for us to use. Silver zones are nearly always tables (for structured data) and the data is often aggregated and/or enriched with other data sources.
- Gold - Ah, Doubloons! Even more valuable, this is large scale data sets that have been aggregated, modelled and locked up in a chest for safe keeping. X marks the spot! In the Fabric world, this is often a Semantic model (aka Power BI dataset), with measures and relationships built-in

(Sometimes you might also see a "Platinum" zone for data that has been further enriched with external data sources, but we'll leave that for another day.)

Typically these would be top level folders, but may also be more of a logical grouping, for example by schema or naming convention.

**In this challenge**, it sounds like you should be landing our data in the "Raw" Files zone and cleaning it to a "Bronze" zone ;) ready to turn into something more precious in [the next Challenge](./Challenge-03.md).

For more info on Lakehouses, check out the Learning Resources below.

## Learning Resources

- What is [OneLake](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview)?
- [Fabric Notes](https://aka.ms/FabricNotes)
- [What is the medallion lakehouse architecture?](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion)

- Fabric has dozens of connectors eg. [HTTP](https://learn.microsoft.com/en-us/fabric/data-factory/connector-http), [REST](https://learn.microsoft.com/en-us/fabric/data-factory/connector-rest-overview) and [OData](https://learn.microsoft.com/en-us/fabric/data-factory/connector-odata-overview)
- Python's [``urllib``](https://docs.python.org/3/library/urllib.html) supports a number of protocols including HTTP and FTP
  
## Tips

- Data providers are often very helpful and may be able to provide you with a code sample if you hunt around their web sites.
- Landing the data automatically with code is great, but you may want to start by downloading the data using a browser first. If coding automated retrieval really doesn't float your boat, don't fall overboard, it's fine to manually download the data and then upload it to OneLake.

## Advanced Challenges (Optional)

Too comfortable?  Eager to do more?  Try these additional challenges!

- Schedule your data retrieval
- Archive your raw data before downloading the latest version
- Add some notification logic to alert you on what's going on with your process
- Error handling!  What happens if your data source is unavailable?  What happens if your data source changes format?  What happens if your data source is updated while you're processing it? 
