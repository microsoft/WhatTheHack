# Challenge 3: 

[< Previous Challenge](./solution-02.md) - **[Home](../README.md)** - [Next Challenge>](./solution-04.md)

## Notes & Guidance

- First, create an Application Insights instance, there's again many different ways to achieve that, but you can use the included [appinsights.bicep](./assets/appinsights.bicep) file for that. 

    ```shell
    APPI_CONN_STR=`az deployment group create -g $RG -f assets/webapp.bicep --query properties.outputs.appInsights.value -o tsv`
    ```

- This template puts the Application Insights connection string into the Key Vault and displays the reference to be used by the web app. If you don't use the template, you'll have to do that yourself.
- Download the Application Insights agent jar, at the time of this writing the latest version is 3.0.2

    ```shell
    APPI_VERSION=3.0.2
    wget https://github.com/microsoft/ApplicationInsights-Java/releases/download/$APPI_VERSION/applicationinsights-agent-$APPI_VERSION.jar
    ```

- Now zip it together with app.jar and deploy that combination (from the `code/spring-petclinic` directory)

    ```shell
    zip -j deployment.zip applicationinsights-agent-$APPI_VERSION.jar target/app.jar
    az webapp deployment source config-zip -g $RG -n $WEBAPP --src deployment.zip
    ```

- Finally, configure the application settings 

    ```shell
    AGENT_CONFIG="-javaagent:/home/site/wwwroot/applicationinsights-agent-$APPI_VERSION.jar"
    az webapp config appsettings set -g $RG -n $WEBAPP --settings \
        APPLICATIONINSIGHTS_CONNECTION_STRING=$APPI_CONN_STR \
        JAVA_OPTS="-Dspring.profiles.active=mysql $AGENT_CONFIG"    
    ```


