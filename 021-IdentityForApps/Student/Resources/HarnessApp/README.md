---
services: active-directory
platforms: dotnet
author: TiagoBrenck
level: 100
client: ASP.NET Core Web App
endpoint: Microsoft identity platform
---
# An ASP.NET Core Web app signing-in users with the Microsoft identity platform in Azure AD B2C

[![Build status](https://identitydivision.visualstudio.com/IDDP/_apis/build/status/AAD%20Samples/.NET%20client%20samples/ASP.NET%20Core%20Web%20App%20tutorial)](https://identitydivision.visualstudio.com/IDDP/_build/latest?definitionId=819)

## Scenario

This sample shows how to build a .NET Core MVC Web app that uses OpenID Connect to sign in users in **Azure AD B2C**. It assumes you have some familiarity with **Azure AD B2C**. If you'd like to learn all that B2C has to offer, start with our documentation at https://aka.ms/aadb2c.

![Sign in with Azure AD](ReadmeFiles/sign-in.png)

## How to run this sample

To run this sample:

> Pre-requisites: Install .NET Core 3.0 or later (for example for Windows) by following the instructions at [.NET and C# - Get Started in 10 Minutes](https://www.microsoft.com/net/core). In addition to developing on Windows, you can develop on [Linux](https://www.microsoft.com/net/core#linuxredhat), [Mac](https://www.microsoft.com/net/core#macos), or [Docker](https://www.microsoft.com/net/core#dockercmd).

### Step 1: Clone or download this repository

From your shell or command line:

```powershell
git clone https://github.com/Azure-Samples/active-directory-aspnetcore-webapp-openidconnect-v2.git
```

> Given that the name of the sample is very long, and so are the names of the referenced NuGet packages, you might want to clone it in a folder close to the root of your hard drive, to avoid file size limitations on Windows.

Navigate to the `"1-5-B2C"` folder

 ```Sh
  cd "1-5-B2C"
  ```

## Option 1 - Run the pre-configured sample

1. Build the solution and run it.
1. Open your web browser and make a request to the app. Accept the IIS Express SSL certificate if needed. Click on **SignIn/Up** button.
1. Click on Sign-In

## Option 2 - Configure the sample with your own B2C app

### Step 2: Get your own Azure AD B2C tenant

If you don't have an Azure AD B2C tenant yet, you'll need to create an Azure AD B2C tenant by following the [Tutorial: Create an Azure Active Directory B2C tenant](https://azure.microsoft.com/documentation/articles/active-directory-b2c-get-started).

### Step 3: Create your own user flow (policy)

This sample uses a unified sign-up/sign-in user flow (policy). Create this policy by following [these instructions on creating an AAD B2C tenant](https://azure.microsoft.com/documentation/articles/active-directory-b2c-reference-policies). You may choose to include as many or as few identity providers as you wish, but make sure **DisplayName** is checked in `User attributes` and `Application claims`.

If you already have an existing unified sign-up/sign-in user flow (policy) in your Azure AD B2C tenant, feel free to re-use it. The is no need to create a new one just for this sample.

Copy this policy name, so you can use it in step 5.

### Step 4: Create your own Web app

Now you need to [register your web app in your B2C tenant](https://docs.microsoft.com/azure/active-directory-b2c/active-directory-b2c-app-registration#register-a-web-application), so that it has its own Application ID.

Your web application registration should include the following information:

- Enable the **Web App/Web API** setting for your application.
- Set the **Reply URL** to `https://localhost:44316/signin-oidc`.
- Copy the Application ID generated for your application, so you can use it in the next step.

### Step 5: Configure the sample with your app coordinates

1. Open the solution in Visual Studio.
1. Open the `appsettings.json` file.
1. Find the assignment for `Instance` and replace the value with your tenant name. For example, `https://fabrikam.b2clogin.com`
1. Find the assignment for `Domain` and replace the value with your Azure AD B2C domain name. For example, `fabrikam.onmicrosoft.com`
1. Find the assignment for `ClientID` and replace the value with the Application ID from Step 4.
1. Find the assignment for `SignUpSignInPolicyId` and replace with the name of the `Sign up and sign in` policy you created in Step 3.

```JSon
{
  "AzureAdB2C": {
    "Instance": "https://<your-tenant-name>.b2clogin.com",
    "ClientId": "<web-app-application-id>",
    "Domain": "<your-b2c-domain>",
    "SignedOutCallbackPath": "/signout/<your-sign-up-in-policy>",
    "SignUpSignInPolicyId": "<your-sign-up-in-policy>"
  }
}
```

### Step 6: Run the sample

1. Build the solution and run it.
1. Open your web browser and make a request to the app. Accept the IIS Express SSL certificate if needed. Click on **SignIn/Up** button.
1. If you don't have an account registered on the **Azure AD B2C** used in this sample, follow the sign up process. Otherwise, input the email and password for your account and click on **Sign in**.

## Troubleshooting

### known issue on iOS 12

ASP.NET core applications create session cookies that represent the identity of the caller. Some Safari users using iOS 12 had issues which are described in [ASP.NET Core #4467](https://github.com/aspnet/AspNetCore/issues/4647) and the Web kit bugs database [Bug 188165 - iOS 12 Safari breaks ASP.NET Core 2.1 OIDC authentication](https://bugs.webkit.org/show_bug.cgi?id=188165).

If your web site needs to be accessed from users using iOS 12, you probably want to disable the SameSite protection, but also ensure that state changes are protected with CSRF anti-forgery mechanism. See the how to fix section of [Microsoft Security Advisory: iOS12 breaks social, WSFed and OIDC logins #4647](https://github.com/aspnet/AspNetCore/issues/4647)

> Did the sample not work for you as expected? Did you encounter issues trying this sample? Then please reach out to us using the [GitHub Issues](../../../../issues) page.

> [Consider taking a moment to share your experience with us.](https://forms.office.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbRz0h_jLR5HNJlvkZAewyoWxUNEFCQ0FSMFlPQTJURkJZMTRZWVJRNkdRMC4u)

## About The code

#### Where is MSAL?
This sample does NOT use MSAL as it only signs-in users (it does not call a Web API). It uses the built-in ASP.NET Core middleware. MSAL is used for fetching access  for accessing protected APIs (not shown here), as well as ID tokens. For logging-in purposes, it is sufficient to obtain an ID Token, and the middleware is capable of doing this on its own.

#### Where is the Account controller?
The `AccountController.cs` used in this sample is part of `Microsoft.Identity.Web.UI` NuGet package, and you can find its implementation [here](https://github.com/AzureAD/microsoft-identity-web/blob/master/src/Microsoft.Identity.Web.UI/Areas/MicrosoftIdentity/Controllers/AccountController.cs). If you want to customize the **Sign-in**, **Sign-up** or **Sign-out** actions, you are encouraged to create your own controller.

#### B2C middleware
This sample shows how to use the OpenID Connect ASP.NET Core middleware to sign in users from a single Azure AD B2C tenant. The middleware is initialized in the `Startup.cs` file by passing the default authentication scheme and `OpenIdConnectOptions.cs` options. The options are read from the `appsettings.json` file. The middleware takes care of:

- Requesting OpenID Connect sign-in using the policy from the `appsettings.json` file.
- Processing OpenID Connect sign-in responses by validating the signature and issuer in an incoming JWT, extracting the user's claims, and putting the claims in `ClaimsPrincipal.Current`.
- Integrating with the session cookie ASP.NET Core middleware to establish a session for the user.

You can trigger the middleware to send an OpenID Connect sign-in request by decorating a class or method with the `[Authorize]` attribute or by issuing a challenge (see the [AccountController.cs](https://github.com/AzureAD/microsoft-identity-web/blob/master/src/Microsoft.Identity.Web.UI/Areas/MicrosoftIdentity/Controllers/AccountController.cs) file).

Here is the middleware example:

```csharp
      services.AddMicrosoftIdentityWebAppAuthentication(Configuration, "AzureAdB2C");
```

Important things to notice:

- The method `AddMicrosoftIdentityWebAppAuthentication` will configure the authentication based on the `MicrosoftIdentityOptions.cs` options. Feel free to bind more properties on `AzureAdB2C` section on `appsettings.json` if you need to set more options.
- The URLs you set for `CallbackPath` and `SignedOutCallbackPath` should be registered on the **Reply URLs** of your application, in [Azure Portal](https://portal.azure.com).

## Next steps

Learn how to:

- Enable your [Web App to call a Web API on behalf of the signed-in user](../../2-WebApp-graph-user)

## Learn more

To understand more about Azure AD B2C see:

- [Azure AD B2C documentation](https://docs.microsoft.com/en-us/azure/active-directory-b2c/)
- [Azure AD B2C sign-in/sign-up user flow](https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-reference-policies)

To understand more about ASP.NET Core and Azure identity integration

- [ASP.NET Core Azure AD samples](https://github.com/aspnet/AspNetCore/tree/master/src/Azure/AzureAD/samples)

To understand more about token validation, see:

- [Validating tokens](https://github.com/AzureAD/azure-activedirectory-identitymodel-extensions-for-dotnet/wiki/ValidatingTokens)

To understand more about app registration, see:

- [Quickstart: Register an application with the Microsoft identity platform (Preview)](https://docs.microsoft.com/azure/active-directory/develop/quickstart-register-app)
- [Quickstart: Configure a client application to access web APIs (Preview)](https://docs.microsoft.com/azure/active-directory/develop/quickstart-configure-app-access-web-apis)
