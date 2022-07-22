# Challenge 4: Coach's Guide

[< Previous Challenge](./Challenge-03.md) - **[Home](README.md)** - [Next Challenge >](./Challenge-05.md)

## Notes & Guidance

**NOTE:** These containers are stored in a Docker Hub repository named: `microservicesdiscovery` that holds container images specific to this hack.

Commands to run (fill in XXX1, XXX2 and XX3 with the actual names):

### Data API

Create the container instance
```az container create --subscription $sub --resource-group $rg --name XXX1 --image microservicesdiscovery/travel-data-service --dns-name-label XXX1 --environment-variables DataAccountName=$cosmosDbAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey```

For Powershell:

```powershell
$dataServiceUri=az container show -g $rg -n XXX1 --query "ipAddress.fqdn" 
```

For Bash:

```bash
export dataServiceUri=$(az container show -g $rg -n XXX1 --query "ipAddress.fqdn" | tr -d '"') 
```

### Itinerary API

Create the container instance

```az container create --subscription $sub --resource-group $rg --name XXX2 --image microservicesdiscovery/travel-itinerary-service --dns-name-label XXX2 --environment-variables DataAccountName=$cosmosDbAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey```

For Powershell:

```powershell
$itineraryServiceUri=az container show -g $rg -n XXX2 --query "ipAddress.fqdn" 
```

For Bash:

```bash
export itineraryServiceUri=$(az container show -g $rg -n XXX2 --query "ipAddress.fqdn" | tr -d '"')
```

### DataLoader

Create the container instance

```az container create --subscription $sub --resource-group $rg --name XXX3 --image microservicesdiscovery/travel-dataloader --environment-variables DataAccountName=$cosmosDbAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey --restart-policy OnFailure```

Check the logs

```az container logs --resource-group $rg --name XXX3```
