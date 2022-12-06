# Challenge 5: Coach's Guide

[< Previous Challenge](./Challenge-04.md) - **[Home](README.md)**

## Notes & Guidance

**NOTE:** You will not see a progress status when you are deploying via PowerShell or CLI.

Commands to run (fill in XXX and YYY with the actual names):

```bash
az appservice plan create --name XXX --resource-group $rg --is-linux --location $loc --sku S1 --number-of-workers 1 --subscription $sub
az webapp create --subscription $sub --resource-group $rg --name YYY --plan XXX -i microservicesdiscovery/travel-web 
az webapp config appsettings set --resource-group $rg --subscription $sub --name YYY --settings DataAccountName=$cosmosDbAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey DataServiceUrl="http://$dataServiceUri/" ItineraryServiceUrl=http://$itineraryServiceUri/
```

**NOTE:** Students might try to use raw FQDNs to pass in for the “*ServiceUrl” application settings. These instead need to be fully addressable URLs with the http schema. Let them struggle through figuring that out.
