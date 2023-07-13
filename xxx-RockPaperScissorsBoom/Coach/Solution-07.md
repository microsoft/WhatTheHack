# Challenge 07 - Implement Azure AD B2C - Coach's Guide

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes & Guidance

### Create Azure AD B2C tenant & create app registration

1.  Create a new Azure AD B2C tenant in the Azure portal.

1.  Navigate to your new B2C tenant resource in the Azure portal & click on `User flows`

1.  Click `New user flow` and select `Sign up and sign in`. Select `Recommended` and click `Create`.

1.  Give it a name like `B2C_1_SignUpAndSignIn`

1.  Select `Email signup`.

1.  Under the `User attributes and token claims` section, check all the boxes.

1.  Click `Create`.

1.  Copy the `Name` of the new user flow and paste into `Notepad`.

1.  On the main B2C page, click on `App registrations` and then `New registration`.

1.  Give your app a name, select `Web app` for the `Application type` and enter the following for the `Sign-on URL`:

    `https://<app-service-name>.azurewebsites.net/signin-oidc`

1.  Click `Register`

1.  Click on the `Certificates & secrets` blade.

1.  Click `New client secret`, give it a description and an expiration date and click `Add`.

1.  Copy the `Value` of the new secret and paste into `Notepad`.

1.  Click on the `Authentication` blade.

1.  Click `Add URI` and add the localhost values for your web app when it is running locally. The port numbers may vary.

    ```text
      http://localhost/signin-oidc

      https://localhost:55134/signin-oidc
    ```

1.  Click `Save`

1.  Make sure both the `Access tokens` & `ID tokens` check boxes are selected for the `Implicit grant` section.

1.  Click on the `Manifest` blade. Modify the following settings:

    - Modify the `accessTokenAcceptedVersion` property to be `2`
    - Modify the `signInAudience` property to be `AzureADandPersonalMicrosoftAccount`

1.  Click `Save`

1.  Click on the `Overview` blade.

1.  Copy the `Application (client) ID` and paste into `Notepad`.

1.  Copy the `Directory (tenant) ID` and paste into `Notepad`.

### Review where to update the OAuth2 configuration in the application

1.  Open the `RockPaperScissorsBoom.Server\appsettings.json` file and note the keys that store the OAuth configuration. These are the values we need to modify via environment variables in both the local & Azure deployment.

    ```json
    {
      ...
      "AzureAdB2C": {
        "Instance": "https://AADB2C-TENANTNAME.b2clogin.com",
        "ClientId": "AADB2C-CLIENT-ID(A Guid)",
        "ClientSecret": "AADB2C-CLIENT-SECRET",
        "Tenant": "AADB2C-TENANT(tenantname.onmicrosoft.com)",
        "SignUpSignInPolicyId": "AADB2C-POLICY(B2C_1_xxxxxx)",
        "RedirectUri": "http://localhost:80/signin-oidc"
      },
      ...
    }
    ```

### Update local application to use Azure AD B2C service principal

1.  Remove your existing local development self-signed certificate.

    ```shell
    dotnet dev-certs https --clean
    ```

1.  Create a new local development self-signed certificate.

    ```powershell
    dotnet dev-certs https -ep $env:USERPROFILE/.aspnet/https/aspnetapp.pfx -p <password>

    dotnet dev-certs https --trust
    ```

1.  Open the `docker-compose.yml` file.

1.  Add following environment variable key value pairs (note the double underscores for each of the nested environment values). You will also need to add the ones for the SSL certificate & the HTTPS (including the password).

    ```yaml
    version: "3"
    services:
      rockpaperscissors-server:
        build:
          context: .
          dockerfile: Dockerfile-Server
        container_name: rockpaperscissors-server
        environment:
          ...
          "AzureAdB2C__Instance": "https://aadb2c-tenantname.b2clogin.com"
          "AzureAdB2C__ClientId": "AADB2C-CLIENT-ID(A Guid)"
          "AzureAdB2C__ClientSecret": "AADB2C-CLIENT-SECRET"
          "AzureAdB2C__Domain": "AADB2C-TENANT(tenantname.onmicrosoft.com)"
          "AzureAdB2C__SignUpSignInPolicyId": "AADB2C-policyname"
          "ASPNETCORE_URLS": "https://+;http://+"
          "ASPNETCORE_Kestrel__Certificates__Default__Password": ""
          "ASPNETCORE_Kestrel__Certificates__Default__Path": "/https/aspnetapp.pfx"
        ports:
          - "80:80"
          - "443:443"
        volumes:
          - ~/.aspnet/https:/https
    ...
    ```

### Test locally

1.  Run the application locally.

    ```shell
    docker compose up
    ```

1.  Navigate to `https://localhost` in your browser and click the `Sign-in` button.

### Update the App Service application to use Azure AD B2C service principal

1.  Use the following command to export all the existing App Service settings into a JSON file to make it easier to bulk upload new values.

    ```shell
    az webapp config appsettings list --name <app-name> --resource-group <resource-group-name> > settings.json
    ```

1.  Modify the `settings.json` file to add all the AzureAdB2C values (note the double underscore between all the nested values).

    ```json
    ...
    {
      "name": "AzureAdB2C__Instance",
      "slotSetting": false,
      "value": "https://aadb2c-tenantname.b2clogin.com"
    },
    {
      "name": "AzureAdB2C__ClientId",
      "slotSetting": false,
      "value": "AADB2C-CLIENT-ID(A Guid)"
    },
    {
      "name": "AzureAdB2C__ClientSecret",
      "slotSetting": false,
      "value": "AADB2C-CLIENT-SECRET"
    },
    {
      "name": "AzureAdB2C__Domain",
      "slotSetting": false,
      "value": "AADB2C-TENANT(tenantname.onmicrosoft.com)"
    },
    {
      "name": "AzureAdB2C__SignUpSignInPolicyId",
      "slotSetting": false,
      "value": "AADB2C-policyname"
    }
    ...
    ```

1.  Use the following command to bulk upload the new settings.

    ```shell
    az webapp config appsettings set --name <app-name> --resource-group <resource-group-name> --settings @settings.json
    ```

### Test application

1.  Deploy the application to Azure.

    ```shell
    docker build -f Dockerfile-Server -t rockpaperscissors-server .

    docker tag rockpaperscissors-server <acr-name>.azurecr.io/rockpaperscissors-server:latest

    docker push <acr-name>.azurecr.io/rockpaperscissors-server:latest
    ```

1.  Navigate to the web app and test the application sign-in flow.
