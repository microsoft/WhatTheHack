# Challenge 07 - Implement Azure AD B2C - Coach's Guide

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes & Guidance

### Create Azure AD B2C tenant & create app registration

1.  Create a new Azure AD B2C tenant in the Azure portal.

1.  Navigate to your new B2C tenant resource in the Azure portal & click on `User flows`

1.  Click `New user flow` and select `Sign up and sign in`. Select `Recommended` and click `Create`.

1.  Give it a name like `B2C_1_SignUpAndSignIn`

1.  Select `Email signup`.

1.  Under the `User attributes and token cliams` section, check all the boxes.

1.  Click `Create`.

1.  Copy the `Name` of the new user flow and paste into `Notepad`.

1.  On the main B2C page, click on `App registrations` and then `New registration`.

1.  Give your app a name, select `Web app` for the `Application type` and enter the following for the `Sign-on URL`:

    `https://<app-service-name>.azurewebsites.net/signin-oidc`

1.  Click `Register`

1.  Click on the `Certificates & secrets` blade.

1.  Click `New client secret`, give it a description and an expiration date and click `Add`.

1.  Copy the `Value` of the new secret and paste into `Notepad`.

1.  Click on the `Overview` blade.

1.  Copy the `Application (client) ID` and paste into `Notepad`.

1.  Copy the `Directory (tenant) ID` and paste into `Notepad`.

### Review where to update the OAut2 configuration in the application

1.  Open the `RockPaperScissorsBoom.Server\appsettings.json` file and note the keys that store the OAuth configuration. These are the values we need to modify via environment variables in both the local & Azure deployment.

    ```json
    {
      ...
      "Authentication": {
        "AzureAdB2C": {
          "ClientId": "AADB2C-CLIENT-ID(A Guid)",
          "ClientSecret": "AADB2C-CLIENT-SECRET",
          "Tenant": "AADB2C-TENANT(tenantname.onmicrosoft.com)",
          "SignUpSignInPolicyId": "AADB2C-POLICY(B2C_1_xxxxxx)",
          "RedirectUri": "http://localhost:80/signin-oidc"
        }
      },
      ...
    }
    ```

### Update local application to use Azure AD B2C service principal

1.  Open the `docker-compose.yml` file.

1.  Add following environment variable key value pairs.

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
          "Authentication:AzureAdB2C:ClientId": "AADB2C-CLIENT-ID(A Guid)"
          "Authentication:AzureAdB2C:ClientSecret": "AADB2C-CLIENT-SECRET"
          "Authentication:AzureAdB2C:Tenant": "AADB2C-TENANT(tenantname.onmicrosoft.com)"
          "Authentication:AzureAdB2C:SignUpSignInPolicyId": ""
          "Authentication:AzureAdB2C:RedirectUri": "http://localhost/signin-oidc"
        ports:
          - "80:80"
    ```

### Update the App Service application to use Azure AD B2C service principal

### Test application
