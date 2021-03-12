# Challenge 2: 

[< Previous Challenge](./solution-01.md) - **[Home](../README.md)** - [Next Challenge>](./solution-03.md)

## Notes & Guidance

- There's a number of different methods to deploy an App Services instance, you can use the included [webapp.bicep](./assets/webapp.bicep) file for that. 

```shell
az deployment group create -g $RG -f webapp.bicep -p \
    mysqlUser="$MYSQL_USER" \
    mysqlPassword="$MYSQL_PASS" \
    mysqlUrl="$MYSQL_URL" \
    --query properties.outputs
```

- Once the App Service is up and running, the easiest way to deploy the application is through the CLI. Make sure that the `app.jar` has been created.

```shell
mvnw package
zip -j deployment.zip target/app.jar
az webapp deployment source config-zip -g $RG -n $WEBAPP --src deployment.zip
```
