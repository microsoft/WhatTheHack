# Challenge 01 - Ingesting the Data and Creating the Database

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

You've been tasked with creating some real time reporting using Power BI based on the data that is constantly being generated every second.

## Description

In this challenge, you will create a data ingestion stream from the Event Hub to Fabric and create a way to store that data inside of Fabric that is conducive to real time reporting. You will also need to make sure the data is being stored in the Fabric OneLake.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Create a data ingestion method for the Event Hub into Fabric
- Create a database and a table to store the Event Hub data
- Verify that data from the Event Hub is entering Fabric and being stored in the OneLake.

## Learning Resources

- [Realtime Analytics in Fabric Tutorial](https://learn.microsoft.com/en-us/fabric/real-time-analytics/tutorial-introduction)
- [Creating an Eventhouse](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/create-eventhouse)
- [Creating a KQL Database](https://learn.microsoft.com/en-us/fabric/real-time-analytics/create-database)
- [Get Data from Event Hubs into KQL](https://learn.microsoft.com/en-us/fabric/real-time-analytics/get-data-event-hub)
- [Creating an Eventstream](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/event-streams/create-manage-an-eventstream?pivots=standard-capabilities)
- [Get Data from Eventstream into KQL](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/get-data-eventstream)


## Tips

- You may find it easier to create the database first, before creating the ingestion stream.
- You can query the database to see how many records it has in total, then query it again moments later to verify that there was an increase in records, since this application generates about seven records every second.
- A KQL database does not automatically store its data in the Fabric OneLake. There is a setting you will need to change to do that.
