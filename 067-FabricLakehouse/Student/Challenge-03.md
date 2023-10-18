# Challenge 03 - Swab the Decks!

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

You've found your data and have raw files sitting in OneLake. Now it's time to clean and combine your datasets ready for analysis.

Get Your Data Ship Shape!

## Description

In this challenge, you will develop a solution to prep your datasets ready for analysis. (In lakehouse speak, this is the bronze and silver zones).

You may find gaps in your data, perhaps you need another dataset in order to blend and enrich your data. You may also need to clean your data, for example, remove duplicates or missing values, or convert data types, extract features and discard others.

At each stage, you might want to write your data to your Lakehouse. For example, you've processed the raw data into several tables (bronze zone) then you combine these tables into a subset of tables that you can build your report from (silver zone). 

So, grab your mop and bucket and get cleaning up your data!

## Success Criteria

To complete this challenge successfully, you should be able to:

- Show how you have cleaned and combined your datasets, and explain why you chose a particular method (eg a notebook, or a copy data activity)
- Demonstrate that your data is now ready to build your data story (This could be an exploratory dashboard, or a notebook, or even just some sample queries)

## Learning Resources

- [Use a notebook to load data into your Lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-notebook-load-data)
- [Create your first dataflow to get and transform data](https://learn.microsoft.com/en-us/fabric/data-factory/create-first-dataflow-gen2)
- Power Query (as used in Dataflow2) has connectors for sources such as [XML](https://learn.microsoft.com/en-us/power-query/connectors/xml), [CSV](https://learn.microsoft.com/en-us/power-query/connectors/text-csv) and [JSON](https://learn.microsoft.com/en-us/power-query/connectors/json)
  
## Tips

- Sometimes Spark is the best tool for the job, but sometimes it's not.  Don't be afraid to use more than one tool in the Fabric platform in your solution. Or try solving the same problem with different tools (eg. notebook and a dataflow).

## Too comfortable?  Eager to do more?  Try an additional challenges!

- We're implicitly creating our lakehouse bronze, silver and gold zones but not focusing on the details. Try adding some formal structure to your lakehouse.
- You've probably guessed that the weather and water conditions are quite important to divers. Climate models are a great way to look at future predictions, and there are a number of open datasets available. Try adding a climate model to your data for both weather and wave conditions. (Hint: Microsoft Planetary Computer ECMWF)
