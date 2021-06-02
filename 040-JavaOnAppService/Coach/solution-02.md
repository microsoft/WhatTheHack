# Challenge 2: Azure App Services &#10084;&#65039; Spring Boot

[< Previous Challenge](./solution-01.md) - **[Home](./README.md)** - [Next Challenge >](./solution-03.md)

## Notes & Guidance

- There's a number of different methods to deploy an App Services instance, you can use the included [webapp.bicep](./Solutions/webapp.bicep) file for that.

    ```shell
    WEBAPP=`az deployment group create -g $RG -f Solutions/webapp.bicep -p \
        mysqlUser="$MYSQL_USER" \
        mysqlPassword="$MYSQL_PASS" \
        mysqlUrl="$MYSQL_URL" \
        --query properties.outputs.webAppName.value -o tsv`
    ```

- On the Azure Marketplace App Service could be difficult to find, make sure that students are looking for Web App by Microsoft. It's important that a production tier is chosen as we'd like to utilize auto scale later on. And JavaSE (Embedded Web Server) must be chosen for Spring Boot.
- Once the App Service is up and running, the easiest way to deploy the application is through the CLI. Make sure that the `app.jar` has been created. You can achieve that running the following commands from the `spring-petclinic` directory.

    ```shell
    mvnw package
    zip -j deployment.zip target/app.jar
    az webapp deployment source config-zip -g $RG -n $WEBAPP --src deployment.zip
    ```
