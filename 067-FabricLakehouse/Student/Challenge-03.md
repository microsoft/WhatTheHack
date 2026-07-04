# Challenge 03 - Swab the Decks!

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

You've dived into an ocean of open datasets, found your data and have raw files sitting in OneLake. You've also started to polish it up into shiny bronze.

Now it's time to turn that bronze into silver - clean and combine your datasets ready for analysis.

Get Your Data Ship Shape!

## Description

In this challenge, you will develop a solution to prep your datasets ready for analysis. (In Lakehouse speak, this is the silver zones).

Remember the requirements from Margie's Travel? You may find gaps in your data, perhaps you need another dataset in order to blend and enrich your data. You may also need to clean your data, keeping some features and discarding others.

You'll want to check out your data along the way, so make use of Fabric's awesome SQL Endpoint to run some ad hoc queries on your silver data so far. You can also use Power BI to make an 'exploratory report' to help you understand your data. Spark notebooks make great exploratory tools too, if coding is your thing.

So, grab your mop and bucket and get cleaning up your data!

## Success Criteria

To complete this challenge successfully, you should be able to:

- Show how you have cleaned and combined your datasets, and explain why you chose a particular method (e.g., a notebook, or a copy data activity)
- Show that you have written your data to one (or more) delta tables in your Lakehouse
- Demonstrate that your data is now ready to build your data story (This could be an exploratory dashboard, or a notebook, or even just some sample queries)

## Learning Resources

- [Use a notebook to load data into your Lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-notebook-load-data)
- [Create your first dataflow to get and transform data](https://learn.microsoft.com/en-us/fabric/data-factory/create-first-dataflow-gen2)
- Power Query (as used in Dataflow2) has connectors for sources such as [XML](https://learn.microsoft.com/en-us/power-query/connectors/xml) (hint hint)
  
## Tips

- Sometimes Spark is the best tool for the job, but sometimes it's not.  Don't be afraid to use more than one tool in the Fabric platform in your solution. Or try solving the same problem with different tools (e.g., notebook and a dataflow).

## Too comfortable?  Eager to do more?  Try an additional challenges!

- You've probably guessed that the weather and water conditions are quite important to divers. Climate models are a great way to look at future predictions, and there are a number of open datasets available. Try adding a climate model to your data for both weather and wave conditions. (Hint: Microsoft Planetary Computer ECMWF)
- OneLake can also store files, not just tables. Maybe your silver dataset can include other unstructured data such as images that would be useful for your data story?
