# Challenge 5: Process Steaming Data

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

Now that we have data streaming into Azure and we are able to gather general insights about the data coming from our Industrial IoT environment it is important to be able to analyze real-time telemetry streams, perform geospatial analysis, and perform advanced anomaly detection. Complex event-processing engines are designed to analyze high volumes of fast streaming data from multiple sources simultaneously. At times these run in the cloud but they can also run at the edge.

Stream processing is useful in a number of scenarios including:

  - Triggering actions and initiating workflows such as creating alerts, feeding information to a reporting tool, or storing transformed data in a data lake for later use.
  - Reducing the amount of data sent to the cloud for bandwidth constrained scenarios.
  - Low latency filtering, aggregation or anomaly detection at the edge.

## Description
In this challenge we'll be creating an Azure Stream Analytics job, using that job to read from the message route coming from IoT Hub, filtering or aggregating data, writing the output data to the data lake and then visualizing the data with Microsoft Power BI.

1. In your Azure resource group create a Stream Analytics job.
2. Set the input of the Stream Analytics job to be the route defined in your IoT Hub.
3. Create 1 output to save a copy of all data into your data lake.
4. Create a Query that filters or aggregates your data based upon business requirements. Test this filter/aggregation (HAVING clause for example) but don't save in the query, only test.
5. Test the query to ensure it is functioning as expected.
6. Create a Power BI workspace (or identify an existing workspace for this workload).
7. Create an additional output to the previously created/identified Power BI workspace.
8. Run the Stream Analytics job and note the output files created in the data lake & data in the Power BI dataset.

## Success Criteria

  - IoT messages flowing from Edge module to `$upstream` route
  - Stream Analytics job setup & running with input reading data from `$upstream`
  - Stream Analytics job setup & running with output being written to Data Lake Store Gen2
  - Stream Analytics job filtering or aggregating data that is output
  - Visualizing the data in a Power BI report.

## Learning Resources
1. [Azure Stream Analytics Introduction](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction)
2. [Common query patterns in Azure Stream Analytics](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-stream-analytics-query-patterns)
3. [Stream Analytics Query Language Reference](https://docs.microsoft.com/en-us/stream-analytics-query/stream-analytics-query-language-reference)
4. [Stream Analytics and Power BI: A real-time analytics dashboard for streaming data](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-power-bi-dashboard)
5. [Blob storage and Azure Data Lake Gen2 output from Azure Stream Analytics](https://docs.microsoft.com/en-us/azure/stream-analytics/blob-storage-azure-data-lake-gen2-output)


## Taking it Further

There are other What The Hack hackathons that explore using data in a data lake for other purposes like data warehousing, machine learning. Below are some recommended follow-up hackathons to keep learning:

1. [This Old Data Warehouse](https://github.com/microsoft/WhatTheHack/tree/master/019-ThisOldDataWarehouse)
2. [Databricks Intro ML](https://github.com/microsoft/WhatTheHack/tree/master/008-DatabricksIntroML)
