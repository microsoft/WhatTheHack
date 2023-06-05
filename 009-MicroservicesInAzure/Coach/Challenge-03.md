# Challenge 3: Coach's Guide

[< Previous Challenge](./Challenge-02.md) - **[Home](README.md)** - [Next Challenge >](./Challenge-04.md)

## Notes & Guidance

**NOTE:** You will not see a progress status when you are deploying via PowerShell and will take several minutes for the CosmosDB Account to be created.

Commands to run (fill in XXX and YYY with actual names):

Create the CosmosDB account:

```az cosmosdb create --subscription $sub --resource-group $rg --name XXX```

Then pull out the CosmosDB account name and keys:

For Powershell:

```powershell
$cosmosDbAccountName = "XXX"
$cosmosPrimaryKey=az cosmosdb list-keys --resource-group $rg --subscription $sub --name $cosmosDbAccountName --query primaryMasterKey
```

For Bash:

```bash
export cosmosDbAccountName="XXX"
export cosmosPrimaryKey=$(az cosmosdb list-keys --resource-group $rg --subscription $sub --name $cosmosDbAccountName --query primaryMasterKey | tr -d '"') 
```
