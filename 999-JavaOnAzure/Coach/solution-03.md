# Challenge 3: 

[< Previous Challenge](./solution-02.md) - **[Home](../README.md)** - [Next Challenge>](./solution-04.md)

## Notes & Guidance

- First, create an Application Insights instance, there's again many different ways to achieve that, but you can use the included [appinsights.bicep](./assets/appinsights.bicep) file for that. 

```shell
az deployment group create -g $RG -f webapp.bicep --query properties.outputs
```

This template puts the Application Insights connection string into the Key Vault and displays the reference to be used by the web app.

- Download the Application Insights agent jar, at the time of this writing is the latest version 3.0.2

```shell
wget https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.0.2/applicationinsights-agent-3.0.2.jar
```

- Now zip it together with app.jar and deploy that combination

```shell
zip -j deployment.zip applicationinsights-agent-3.0.2.jar target/app.jar
az webapp deployment source config-zip -g $RG -n $WEBAPP --src deployment.zip
```

- Finally, configure the application settings 

```shell
AGENT_CONFIG="-javaagent:/home/site/wwwroot/applicationinsights-agent-3.0.2.jar"
az webapp config appsettings set -g $RG -n $WEBAPP --settings \
    APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONN_STR \
    JAVA_OPTS="-Dspring.profiles.active=mysql $AGENT_CONFIG"    
```


