# Challenge 05 - Identify & Remediate Bottlenecks - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance
- This link goes into the issues in detail
https://docs.microsoft.com/en-us/azure/load-testing/tutorial-identify-bottlenecks-azure-portal

- The students should be seeing many errors and that Cosmos DB RU are maxed out.  If they are not, have them increase the amount of load in their tests.
- Make sure the students have configured monitoring integration from Azure Load Test with the services such as App Service, App Insights, and Cosmos DB.
    https://docs.microsoft.com/en-us/azure/load-testing/how-to-appservice-insights
- Cosmos DB can either be scaled up manually or set to auto-scale.
- Post scale tests should show a drastic decrease in errors and Cosmos DB RU nowhere near the max. You may still see some errors which was normal.