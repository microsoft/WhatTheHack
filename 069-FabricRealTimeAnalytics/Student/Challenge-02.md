# Challenge 02 - Transforming the Data

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)


## Pre-requisites

* Ingest the Event Hub data into Fabric KQL Database successfully
* Have Stock Table ready

## Introduction

You've been tasked with creating some real time reporting using Power BI based on the data that is constantly being generated every second. In this challenge, you will learn how to query and transform the data with Fabric. 

## Description
In this challenge, you need to get the price difference and price difference percent between stock price and its previous price at different timestamps in Stock Table. The data in the new table should be in ascending time stamp order.


## Success Criteria

To complete this challenge successfully, you should be able to:
- Create a KQL Queryset
- Query the original Stock Table in ascending time stamp order
- Calculate the stock price difference and price difference percent at each timestamp

## Learning Resources

- [Query data in a KQL queryset](https://learn.microsoft.com/en-us/fabric/real-time-analytics/kusto-query-set)
- [Customize results in the KQL Queryset results grid](https://learn.microsoft.com/en-us/fabric/real-time-analytics/customize-results)
- [KQL prev() function](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/prevfunction)


## Tips

- Start with ordering the stocks in ascending timestamp order is very beneficial
- You should add two columns in Stock Table: one for "pricedifference", and one for "percentpricedifference"
- You can keep the price difference to two decimal places, and keep the price difference percent to four decimal places

## Advanced Challenges (Optional)

Too comfortable?  Eager to do more?  Try these additional challenges!

<!-- Group stocks by a certain grouping TDB-->
- Create another KQL queryset and find out the biggest price difference for each stock, and at what time it occurred
