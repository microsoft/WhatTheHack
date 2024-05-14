# Challenge 04 - Time to Analyze Data

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

Stuff and More Stuff Co. has decided that it needs to introduce ML capabilities in their platform to assist their users to discover more products that are of interest to them based on their interactions with the site. 

For this, they are capturing ClickStream data in the `clickstream` container. However, when trying to leverage that dataset, they have seen that they would need to scale the container to a high amount of RU/s for their queries to be effective. They will need a different strategy to do analytics over that data set.

## Description

In this challenge, you will properly configure the `clickstream` container to enable Analytical queries.

You will need to run the deployment script under the `/Challenge04/` folder of the Resources.zip file given by your coach. To do this, please run the respective PowerShell or Bash script as below:

- Powershell: 
  ``` 
  # Update your Az Powershell commandlets
  Update-Module Az

  # Connect to your Azure Account
  Connect-AzAccount
  
  # Deploy the infrastructure
  # Please make sure you are using Powershell v7.2 or newer
  # You might need to unblock the file
  # You will need to provide your user's Principal Id (objectId) in you Azure AD tenant
  .\deploy.ps1 
  ```
- Bash:
  ```
  # Login to you Azure subscription via the Azure CLI
  az login

  # Run the deployment script
  ./deploy.sh
  ```

> ⚠️ Please remember to use the same Resource Group you used in Challenge 00

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that after running the deployment script, you see the following additional services:
  - Another Managed Identity
  - Azure Container Instance
  - Your Azure Cosmos DB account has an additional container named `clickstream`
  - Azure Key Vault
- Show an Analytical query over the data collected in the `clickstream` container that runs without consuming the container's RU/s.

## Learning Resources

- [Azure Synapse Link for Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link)


## Advanced Challenge

Too comfortable?  Eager to do more?  Try this additional challenge:

- Are the analytical queries you are running optimized? Is there a way to further optimize them?
