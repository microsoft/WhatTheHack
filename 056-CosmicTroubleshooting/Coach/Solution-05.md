# Challenge 05 - Going Global - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

For this challenge, the students essentially will need to:
- Configure their Azure Cosmos DB account as a Multi-Master Write account. They should configure in addition to the currently deployed location, another location in a European Azure region.
- They should deploy an Azure Web App in the same additional region as they configured their Azure Cosmos DB account.
- They should deploy Azure Traffic Manager with Performance routing method and register two endpoints: one to the US region deployed Azure Web App and another to the Europe region deployed Azure Web App
- In the web app, each instance of the `CosmosClient` should include a `CosmosClientOptions.ApplicationRegion` property with the region the web app is deployed at as the value (for example, using `ApplicationRegion = Environment.GetEnvironmentVariable("REGION_NAME")`)
- For a reference solution, you can deploy both the configured Azure services and the modified web applications by running the `deploy.sh` (Bash/Azure CLI) or `deploy.ps1` (PowerShell) script in the `/Solutions/Challenge05` folder.