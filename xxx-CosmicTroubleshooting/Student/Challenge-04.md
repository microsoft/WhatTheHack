# Challenge 04 - Time to analyze data

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

XXX has decided that it needs to introduce ML capabilities in their platform to assist their users to discover more products that are of interest to them based on their interactions with the site. 

For this, they are capturing ClickStream data in the `clickstream` container. However, when trying to leverage that dataset, they have seen that they would need to scale the container to a high amount of RU/s for their queries to be effective. They will need a different strategy to do analytics over that data set.

## Description

In this challenge, you will properly configure the `clickstream` container to enable Analytical queries.

You will need to run the deployment script under the `Challenge04` folder in your Resources.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that after running the deployment script, you see the following additional services:
  - Another Managed Identity
  - Azure Container Instance
  - Your Azure Cosmos DB account has an additional container named `clickstream`
  - Azure Key Vault
  - Azure Storage Account
  - Azure Synapse Analytics Workspace
- Demonstrate how you would be able to run Analytical queries over the data in the `clickstream` container without scaling up the container's RU/s

## Learning Resources

- [Azure Synapse Link for Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link)

## Tips

## Advanced Challenges (Optional)

Too comfortable?  Eager to do more?  Try these additional challenges!

- Are the analytical queries you are running optimized? Is there a way to further optimize them?
