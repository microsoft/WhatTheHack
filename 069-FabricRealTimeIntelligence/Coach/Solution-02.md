# Challenge 02 - Transforming the Data - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Setup Steps

Steps for MAA Fabric Real-time intelligence setup:

1. Create kql queryset (one is made by default in the KQL DB)

## Notes & Guidance

In this challenge, students should be familiar with KQL and be able to query the real-time data in Stock Table as required with KQL.

Students should first create a KQL Queryset and select the Stock Table stored in the KQL Database.

The query should be similar to the following:
```
stockmarket
| order by timestamp asc
| extend pricedifference = round(price - prev(price, 8), 2)
| extend percentdifference = round(round(price - prev(price, 8), 2) / prev(price, 8), 4)
```

For the advanced challenge part, students should create another KQL Queryset. You can take the following query as a reference:
```
stockmarket
| order by timestamp asc
| extend pricedifference = round(price - prev(price, 8), 2)
| extend percentdifference = round(round(price - prev(price, 8), 2) / prev(price, 8), 4)
| summarize arg_max(pricedifference, timestamp, price) by symbol
```

## Learning Resources

- [Query data in a KQL queryset](https://learn.microsoft.com/en-us/fabric/real-time-analytics/kusto-query-set)
- [Customize results in the KQL Queryset results grid](https://learn.microsoft.com/en-us/fabric/real-time-analytics/customize-results)
- [KQL prev() function](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/prevfunction)
