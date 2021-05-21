---
page_type: sample
languages:
- csharp
products:
- azure-active-directory
- azure-active-directory-b2c
- dotnet
- dotnet-core
- ms-graph
description: ".NET Core console application using Microsoft Graph for Azure AD B2C user account management."
urlFragment: "manage-b2c-users-dotnet-core-ms-graph"
---

# Azure AD B2C user account management with .NET Core and Microsoft Graph

This .NET Core console application demonstrates the use of the Microsoft Graph API to perform user account management operations (create, read, update, delete) within an Azure AD B2C directory. Also shown is a technique for the bulk import of users from a JSON file. Bulk import is useful in migration scenarios like moving your users from a legacy identity provider to Azure AD B2C.

The code in this sample backs the [Manage Azure AD B2C user accounts with Microsoft Graph](https://docs.microsoft.com/azure/active-directory-b2c/manage-user-accounts-graph-api) article on docs.microsoft.com.

## Contents

| File/folder          | Description                                                   |
|:---------------------|:--------------------------------------------------------------|
| `./data`             | Example user data in JSON format.                             |
| `./src`              | Sample source code (*.proj, *.cs, etc.).                      |
| `.gitignore`         | Defines the Visual Studio resources to ignore at commit time. |
| `CODE_OF_CONDUCT.md` | Information about the Microsoft Open Source Code of Conduct.  |
| `LICENSE`            | The license for the sample.                                   |
| `README.md`          | This README file.                                             |
| `SECURITY.md`        | Guidelines for reporting security issues found in the sample. |

## Prerequisites

* [Visual Studio](https://visualstudio.microsoft.com/) or [Visual Studio Code](https://code.visualstudio.com/) for debugging or file editing
* [.NET Core SDK](https://dotnet.microsoft.com/) 3.1+
* [Azure AD B2C tenant](https://docs.microsoft.com/azure/active-directory-b2c/tutorial-create-tenant) with one or more user accounts in the directory
* [Management app registered](https://docs.microsoft.com/azure/active-directory-b2c/microsoft-graph-get-started) in your B2C tenant

## Setup

1. Clone the repo or download and extract the [ZIP archive](https://github.com/Azure-Samples/ms-identity-dotnetcore-b2c-account-management/archive/master.zip)
2. Modify `./src/appsettings.json` with values appropriate for your environment:
    - Azure AD B2C **tenant ID**
    - Registered application's **Application (client) ID**
    - Registered application's **Client secret**
3. Build the application with `dotnet build`:

    ```console
    azureuser@machine:~/ms-identity-dotnetcore-b2c-account-management$ cd src
    azureuser@machine:~/ms-identity-dotnetcore-b2c-account-management/src$ dotnet build
    Microsoft (R) Build Engine version 16.4.0+e901037fe for .NET Core
    Copyright (C) Microsoft Corporation. All rights reserved.

      Restore completed in 431.62 ms for /home/azureuser/ms-identity-dotnetcore-b2c-account-management/src/b2c-ms-graph.csproj.
      b2c-ms-graph -> /home/azureuser/ms-identity-dotnetcore-b2c-account-management/src/bin/Debug/netcoreapp3.0/b2c-ms-graph.dll

    Build succeeded.
        0 Warning(s)
        0 Error(s)

    Time Elapsed 00:00:02.62
    ```
4. Add 2 custom attributes to your B2C instance in order to run all the sample operations with custom attributes involved.
   Attributes to add:
    - FavouriteSeason (string)
    - LovesPets (boolean)

## Running the sample

Execute the sample with `dotnet b2c-ms-graph.dll`, select the operation you'd like to perform, then press ENTER.

For example, get a user by object ID (command `2`), then exit the application with `exit`:

```console
azureuser@machine:~/ms-identity-dotnetcore-b2c-account-management/src$ dotnet bin/Debug/netcoreapp3.0/b2c-ms-graph.dll

Command  Description
====================
[1]      Get all users (one page)
[2]      Get user by object ID
[3]      Get user by sign-in name
[4]      Delete user by object ID
[5]      Update user password
[6]      Create users (bulk import)
[7]      Create user with custom attributes and show result
[8]      Get all users (one page) with custom attributes
[help]   Show available commands
[exit]   Exit the program
-------------------------
Enter command, then press ENTER: 2
Enter user object ID: 064deeb8-0000-0000-0000-bf4084c9325b
Looking for user with object ID '064deeb8-0000-0000-0000-bf4084c9325b'...
{"displayName":"Autumn Hutchinson","identities":[{"signInType":"emailAddress","issuer":"contosob2c.onmicrosoft.com","issuerAssignedId":"autumn@fabrikam.com","@odata.type":"microsoft.graph.objectIdentity"},{"signInType":"userPrincipalName","issuer":"contosob2c.onmicrosoft.com","issuerAssignedId":"064deeb8-0000-0000-0000-bf4084c9325b@contosob2c.onmicrosoft.com","@odata.type":"microsoft.graph.objectIdentity"}],"id":"064deeb8-0000-0000-0000-bf4084c9325b","@odata.type":"microsoft.graph.user","@odata.context":"https://graph.microsoft.com/beta/$metadata#users(displayName,id,identities)/$entity","responseHeaders":{"Date":["Fri, 14 Feb 2020 18:52:56 GMT"],"Cache-Control":["no-cache"],"Transfer-Encoding":["chunked"],"Strict-Transport-Security":["max-age=31536000"],"request-id":["23165c3f-0000-0000-0000-f7fc59669c24"],"client-request-id":["23165c3f-0000-0000-0000-f7fc59669c24"],"x-ms-ags-diagnostic":["{\"ServerInfo\":{\"DataCenter\":\"WEST US 2\",\"Slice\":\"E\",\"Ring\":\"1\",\"ScaleUnit\":\"000\",\"RoleInstance\":\"MW1PEPF00001671\"}}"],"OData-Version":["4.0"]},"statusCode":"OK"}
Enter command, then press ENTER: exit
azureuser@machine:~/ms-identity-dotnetcore-b2c-account-management/src$
```

## Key concepts

The application uses the [OAuth 2.0 client credentials grant](https://docs.microsoft.com/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow) flow to get an access token for calling the Microsoft Graph API. In the client credentials grant flow, the application non-interactively authenticates as itself, as opposed to requiring a user to sign in interactively.

The following libraries are used in this sample:

| Library documentation | NuGet | API reference | Source code |
| ------- | ------------- | ------------- | ------ |
| [Microsoft Authentication Library for .NET (MSAL.NET)][msal-doc] | [Microsoft.Identity.Client][msal-pkg] | [Reference][msal-ref] | [GitHub][msal-src] |
| [Microsoft Graph Client Library for .NET][graph-doc] | [Microsoft.Graph.Auth][graph-auth-pkg] | [Reference][graph-auth-ref] | [GitHub][graph-auth-src] |
| [Microsoft Graph Client Beta Library for .NET][graph-doc] | [Microsoft.Graph.Beta][graph-beta-pkg] | [Reference][graph-auth-ref] | [GitHub][graph-beta-src] |
| [.NET Extensions][config-doc] | [Microsoft.Extensions.Configuration][config-pkg] | [Reference][config-ref] | [GitHub][config-src] |

The Microsoft Graph Client Library for .NET is a wrapper for MSAL.NET, providing helper classes for authenticating with and calling the Microsoft Graph API.

### Creating the GraphServiceClient

After parsing the values in `appsettings.json`, a [GraphServiceClient][GraphServiceClient] (the primary utility for working with Graph resources) is instantiated with following object instantiation flow:

[ConfidentialClientApplication][ConfidentialClientApplication] :arrow_right: [ClientCredentialProvider][ClientCredentialProvider] :arrow_right: [GraphServiceClient][GraphServiceClient]

From [`Program.cs`](./src/Program.cs):

```csharp
// Read application settings from appsettings.json (tenant ID, app ID, client secret, etc.)
AppSettings config = AppSettingsFile.ReadFromJsonFile();

// Initialize the client credential auth provider
IConfidentialClientApplication confidentialClientApplication = ConfidentialClientApplicationBuilder
    .Create(config.AppId)
    .WithTenantId(config.TenantId)
    .WithClientSecret(config.AppSecret)
    .Build();
ClientCredentialProvider authProvider = new ClientCredentialProvider(confidentialClientApplication);

// Set up the Microsoft Graph service client with client credentials
GraphServiceClient graphClient = new GraphServiceClient(authProvider);
```

### Graph operations with GraphServiceClient

The initialized *GraphServiceClient* can then be used to perform any operation for which it's been granted permissions by its [app registration](https://docs.microsoft.com/azure/active-directory-b2c/microsoft-graph-get-started).

For example, getting a list of the user accounts in the tenant (from [`UserService.cs`](./src/Services/UserService.cs)):

```csharp
public static async Task ListUsers(AppSettings config, GraphServiceClient graphClient)
{
    Console.WriteLine("Getting list of users...");

    // Get all users (one page)
    var result = await graphClient.Users
        .Request()
        .Select(e => new
        {
            e.DisplayName,
            e.Id,
            e.Identities
        })
        .GetAsync();

    foreach (var user in result.CurrentPage)
    {
        Console.WriteLine(JsonConvert.SerializeObject(user));
    }
}
```

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

<!-- LINKS -->
[msal-doc]: https://docs.microsoft.com/azure/active-directory/develop/msal-overview
[msal-pkg]: https://www.nuget.org/packages/Microsoft.Identity.Client/
[msal-ref]: https://docs.microsoft.com/dotnet/api/microsoft.identity.client?view=azure-dotnet
[msal-src]: https://github.com/AzureAD/microsoft-authentication-library-for-dotnet

[config-doc]: https://docs.microsoft.com/aspnet/core/fundamentals/configuration
[config-pkg]: https://www.nuget.org/packages/Microsoft.Extensions.Configuration/
[config-ref]: https://docs.microsoft.com/dotnet/api/microsoft.extensions.configuration
[config-src]: https://github.com/dotnet/extensions

[graph-doc]: https://docs.microsoft.com/graph/
[graph-auth-pkg]: https://www.nuget.org/packages/Microsoft.Graph.Auth/
[graph-beta-pkg]: https://www.nuget.org/packages/Microsoft.Graph.Beta/
[graph-auth-ref]: https://github.com/microsoftgraph/msgraph-sdk-dotnet/blob/dev/docs/overview.md
<!--[graph-beta-ref]: USES graph-auth-ref -->
[graph-auth-src]: https://github.com/microsoftgraph/msgraph-sdk-dotnet
[graph-beta-src]: https://github.com/microsoftgraph/msgraph-beta-sdk-dotnet

[ConfidentialClientApplication]: https://docs.microsoft.com/dotnet/api/microsoft.identity.client.iconfidentialclientapplication
[ClientCredentialProvider]: https://github.com/microsoftgraph/msgraph-sdk-dotnet-auth#b-client-credential-provider
[GraphServiceClient]: https://github.com/microsoftgraph/msgraph-sdk-dotnet/blob/dev/docs/overview.md#graphserviceclient