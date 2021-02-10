# Challenge 6 - Add Application Monitoring

[< Previous Challenge](05-RunTheGameContinuously.md) - **[Home](README.md)** - [Next Challenge >](07-CICDWithGithubActions.md)

## Create Application Insights

1. Add Application insights extension if you don't already have it

    ```bash
    az extension add -n application-insights
    ```

2. Create a new instance of Application Insights

    ```bash
    az monitor app-insights component create \
        -g $resourceGroupName \
        -a $appInsightsName \
        -l $location
    ```

## Configure Webapp settings

1. Provide the instrumentation key via application settings

    ```bash
    az webapp config appsettings set \
        -n $appName \
        -g $resourceGroupName \
        --settings APPINSIGHTS_INSTRUMENTATIONKEY=$appInsightsKey
    ```

## Create a dashboard
