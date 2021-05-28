# Final state for the challenges

**[Home](./README.md)** - [Next Challenge >](./solution-00.md)

## Notes & Guidance

The bicep file [allinone.bicep](./Solutions/allinone.bicep) contains all the required resources. You can run it with the following command (requires a recent az cli client).

```shell
CLIENT_IP=`curl -s https://ifconfig.me`
WEBAPP=`az deployment group create -g $RG -f Solutions/allinone.bicep -p clientIp=$CLIENT_IP --query properties.outputs.webAppName -o tsv`
```

Once the resources are created, you first need to build the app.jar file. Change directory to `Students/Resources/spring-petclinic` and run the following command.

```shell
mvnw package
```

Next step is to download the Application Insights jar file.

```shell
APPI_VERSION=3.0.2
wget https://github.com/microsoft/ApplicationInsights-Java/releases/download/$APPI_VERSION/applicationinsights-agent-$APPI_VERSION.jar
```

Now, let's bundle the `app.jar` and the agent jar file for deployment.

```shell
zip -j deployment.zip applicationinsights-agent-$APPI_VERSION.jar target/app.jar
```

And finally, let's do the deployment.

```shell
az webapp deployment source config-zip -g $RG -n $WEBAPP --src deployment.zip
```

You should be able to access the app at `https://$WEBAPP.azurewebsites.net`
