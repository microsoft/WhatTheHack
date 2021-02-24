# Challenge 4: Route messages and do time-series analysis

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

Now that we have device connectivity, and data if flowing to Azure IoT Hub. We should try to explore way to visualize this data in a dashboard and investigate the patterns. Azure Time Series Insights is an end-to-end PaaS offering to ingest, process, store, and query highly contextualized, time-series-optimized, IoT-scale data

Azure Time Series Insight is/can useful in a number of scenarios including:

  - Ad-hoc data exploration to enable the IoT analytics needs
  - Time Series Insights provides rich asset-based operational intelligence
  - Ability to store multi-layered date , time series modeling, and cost-effective queries over decades of data

## Description
In this challenge we'll be creating an Azure Time Series Insights service, TSI service will connect to Azure IoT instance we stood up in the previous lab and consume the data, define the industrial IoT asset model, visualize the data

Azure Time Series Insights is a fully managed analytics, storage, and visualization service that simplifies how to explore and analyze billions of IoT events simultaneously. It gives you a global view of your data so that you can quickly validate your IoT solution and avoid costly downtime to mission-critical devices. Azure Time Series Insights helps you to discover hidden trends, spot anomalies, and conduct root-cause analyses in near real time.

## Success Criteria

  - Stand up Azure Time Series Insight Instance 
  - Define the asset model 
  - Connect the TSI instance with IoT Hub and consume the events in real time
  - Create visualization with the time series data
  - Create dashboard to show multiple charts.

## Taking it Further

Time Series Insights provides a query service, both in the TSI explorer and by using APIs that are easy to integrate for embedding your time series data into custom applications.

[Integrate TSI with your C# app](https://github.com/Azure-Samples/Azure-Time-Series-Insights)
