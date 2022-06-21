# Challenge 04 - Securing Backends APIs


[<Previous Challenge](./Challenge-03.md) - **[Home](../README.md)**

## Pre-requisites

- You should have completed Challenge 03

## Introduction
You would like to be able to secure your backend APIs in one of the two ways:
- Secure Hello API in a private network
- Test end-to-end authorization to Hello API via OAuth.  

## Description

### Scenario 01: Configure secured backend APIs in a private network
- Create a new Function App in Elastic Premium plan which will be imported to APIM as Hello Internal API.  
- The existing API - Hello API - will now become the public/external API.  The new path should be configured in APIM as: `https://apim-{{unique_id}}.azure-api.net/external/hello`
- Secure internal Hello Function App by enabling networking feature by either:
    - Only accepts traffic coming from the APIM subnet
    - Assigning a private endpoint to the Function App
- Import the new Function App as Hello Internal API to APIM.  The new path should be: `https://apim-{{unique_id}}.azure-api.net/internal/hello`
- Secure external Hello API so that it would only accept requests routed from Application Gateway, which includes setting-up an APIM policy.
- To allow routes to external Hello API only, you should configure URL redirection mechanism in Application Gateway so that:
    - All calls to the AGW endpoint with the path /external/* (`http://pip-{{unique_id}}.australiaeast.cloudapp.azure.com/external`)  would go to `https://api.{{unique_id}}.azure-api.net/external/hello`
    - While calls to the default path `http://pip-{{unique_id}}.australiaeast.cloudapp.azure.com/` returns HTTP 404.

### Scenario 02: Configure OAuth2 authorization when calling Hello API
- Configure OAuth 2.0 authorization in APIM 
    - Register a client application (e.g. APIM Developer Portal or [Postman](https://www.postman.com/)) in Azure AD.  This will be used to make calls to Hello API via APIM.
    - Configure JWT validation policy to pre-authorize requests to Hello API. 
    - Register Hello API Function app as an AD application.
- Call Hello API from your client application successfully.

## Success Criteria
### Scenario 01:
- Verify that you can send GET and POST requests to the public endpoint (`https://apim-{{unique_id}}.azure-api.net/external/hello`) and get a HTTP 200 response.
- Verify that you can send GET and POST requests to the internal endpoint (`https://apim-{{unique_id}}.azure-api.net/internal/hello`) over the private network (e.g. from a jumpbox VM) and get HTTP 200 response.

### Scenario 02:
- Verify that you are able to get an access token via the OAuth 2.0 authorization code flow.
- Verify that you are able to send GET and POST requests to Hello API (passing the access token into the Authorization header) via the public endpoint and get a HTTP 200 response.


## Learning Resources
Scenario 01:
- [Azure Functions networking options](https://docs.microsoft.com/en-us/azure/azure-functions/functions-networking-options)
  - [IP restriction list](https://docs.microsoft.com/en-us/azure/azure-functions/functions-networking-options#inbound-access-restrictions)
  - [Private endpoint](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-vnet)
- [API Management access restriction policies](https://docs.microsoft.com/en-us/azure/api-management/api-management-access-restriction-policies)
- [Rewrite URL with Azure Application Gateway - Azure portal](https://docs.microsoft.com/en-us/azure/application-gateway/rewrite-url-portal)
- [Protect APIs with Application Gateway and API Management](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/apis/protect-apis)

Scenario 02:
- [Protect a web API backend in Azure API Management using OAuth 2.0 authorization with Azure Active Directory](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-protect-backend-with-aad)
- [Protect API's using OAuth 2.0 in APIM](https://techcommunity.microsoft.com/t5/azure-paas-blog/protect-api-s-using-oauth-2-0-in-apim/ba-p/2309538)
- [Configure your App Service or Azure Functions app to use Azure AD login](https://docs.microsoft.com/en-us/azure/app-service/configure-authentication-provider-aad?toc=/azure/azure-functions/toc.json)
- [Calling an Azure AD secured API with Postman](https://dev.to/425show/calling-an-azure-ad-secured-api-with-postman-22co)
- [Postman - Authorizing requests](https://learning.postman.com/docs/sending-requests/authorization/)


## Advanced Challenges
Scenario 02:
- You can try to do end-to-end AAD authentication by either:
    - Configuring your Function App to use AAD login. Use the [existing backend app AAD registration](https://docs.microsoft.com/en-us/azure/app-service/configure-authentication-provider-aad?toc=/azure/azure-functions/toc.json#-option-2-use-an-existing-registration-created-separately) created earlier.
    ![Function App AAD Auth 1](../Coach/images/Solution04_FunctionApp_AADAuth_1.jpg)

    For the issuer URL, usually this would be the AAD Tenant where you created the backend app registration.  However, to be sure, I suggest that you check the issuer claim of the Access Token by decoding it using [jwt.io](https://jwt.io/).
    - Enable [Managed Identities in APIM](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-use-managed-service-identity) and then authenticate to backend using that identity using [authentication-managed-identity](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-use-managed-service-identity#authenticate-to-the-back-end-by-using-a-user-assigned-identity) policy.
     ![Enable Managed Identity in APIM 2](../Coach/images/Solution04_Enable_ManagedIdentity_APIM_2.jpg)

[Back to Top](#challenge-04---securing-backends-apis)
