# Challenge 05 - AzureLoadTesting - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

- The students should be seeing a large number of errors and that cosmos db RU are maxed out.  If they are not, have them increase the amount of load in  their tests.
- Cosmos DB can either be scaled up manually or set to auto scale.
- Post scale tests should show a drastic decrease in errors and Cosmos DB RU no where near the max.  You may still see some errors which was normal.