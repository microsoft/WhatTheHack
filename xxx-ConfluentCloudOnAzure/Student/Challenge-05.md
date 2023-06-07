# Challenge 05 - Realtime Visualization of Streams

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

Power BI with real-time streaming helps you stream data and update dashboards in real time. 

Any visual or dashboard created in Power BI can display and update real-time data and visuals. 

The devices and sources of streaming data can be factory sensors, Azure data stores, social media sources, service usage metrics, or many other time-sensitive data collectors or transmitters.

With Azure services and Power BI, you can turn your data processing efforts into analytics and reports that provide real-time insights into your business. Whether your data processing is cloud-based or on-premises, straightforward, or complex, single-sourced or massively scaled, warehoused, or real-time, Azure and Power BI have the built-in connectivity and integration to bring your business intelligence efforts to life.

Power BI has a multitude of Azure connections available, and the business intelligence solutions you can create with those services are as unique as your business. You can connect as few as one Azure data source, or a handful, then shape and refine your data to build customized reports.

## Description

Now that we have all these streams, we need to visualize the streams. 

- Create a PowerBI dashboard that displays the top 5 products as well as the inventory on hand for all 10 products at any given time.
- Create a PowerBI dashboard that displays the top 3 products returned in the last 5 minutes.
- Create a PowerBI dashboard that displays the top 3 products purchased in the last 15 minutes.
- Create a PowerBI dashboard that displays the top 3 products supplied via inventory replenishment in the last 10 minutes.
- Create a PowerBI dashboard for all out of stock products.
- Create a PowerBI dashboard for all products whose inventory counts are critical (below minimum count but above zero)

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that the events from the topics are visible within 3 seconds of landing in Cosmos DB and Cognitive Search
- Verify that there is no decline in performance after a certain amount of time.

## Learning Resources
- [Power BI Desktop](https://learn.microsoft.com/en-us/power-bi/fundamentals/desktop-getting-started)
- [Visualize Cosmos DB Data with PowerBI](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/powerbi-visualize)
- [Using Cognitive Search in Power BI](https://learn.microsoft.com/en-us/power-bi/connect-data/service-tutorial-use-cognitive-services)
- [PowerBI and Knowledge Stores](https://learn.microsoft.com/en-us/azure/search/knowledge-store-connect-power-bi)
- [Streaming Dataasets in PowerBi](https://learn.microsoft.com/en-us/power-bi/connect-data/service-real-time-streaming)
