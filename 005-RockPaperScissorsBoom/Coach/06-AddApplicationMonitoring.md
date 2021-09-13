# Challenge 6 - Add Application Monitoring

[< Previous Challenge](05-RunTheGameContinuously.md) - **[Home](README.md)** - [Next Challenge >](07-CICDWithGithubActions.md)

## Prerequisites

1. [Challenge 5](05-RunTheGameContinuously.md)

## Create Application Insights

```bash
# Add Application insights extension if you don't already have it
az extension add -n application-insights

# Create a new instance of Application Insights
az monitor app-insights component create \
    -g $resourceGroupName \
    -a $appInsightsName \
    -l $location
```

## Configure Webapp settings

```bash
# Provide the instrumentation key via application settings
az webapp config appsettings set \
    -n $appName \
    -g $resourceGroupName \
    --settings APPINSIGHTS_INSTRUMENTATIONKEY=$appInsightsKey
```

## Create a dashboard
