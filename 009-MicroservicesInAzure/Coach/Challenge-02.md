# Challenge 2: Coach's Guide

[< Previous Challenge](./Challenge-01.md) - **[Home](README.md)** - [Next Challenge >](./Challenge-03.md)

## Notes & Guidance

Commands to run (fill in XXX and YYY with actual names)

Run this first:

```az group deployment create --name XXX --template-file azuredeploy-appinsights.json --parameters name=YYYY regionId=southcentralus --resource-group $rg --subscription $sub```

Then pull out the app insights key:

For Powershell:

```powershell
$appInsightsKey=az resource show --resource-group $rg --subscription $sub --resource-type Microsoft.Insights/components --name YYYY --query "properties.InstrumentationKey" 
```

For Bash:

```bash
export appInsightsKey=$(az resource show --resource-group $rg --subscription $sub --resource-type Microsoft.Insights/components --name YYYY --query "properties.InstrumentationKey" | tr -d '"') 
```
