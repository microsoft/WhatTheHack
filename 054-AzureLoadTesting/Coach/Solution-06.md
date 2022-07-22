# Challenge 06 - Stress Testing - Coach's Guide 

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)** - [Next Solution >](./Solution-07.md)

## Notes & Guidance

I start noticing failures when we reach 6 users.  It seems like 4 users will hit 60% of Cosmos DB consumption assuming a 1k limit.  There is then a sharp jump when you hit 10 users in terms of the number of failures.  Cosmos DB is still the bottleneck as our App Service is still running on one instance and does not appear to be constrained at all.

Sample solution JMeter script is located in the solution directory [here](./Solutions/Challenge6/).