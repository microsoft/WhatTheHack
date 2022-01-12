# Challenge 6: Configure external and internal API access


[<Previous Challenge](./Challenge-05.md) - **[Home](../readme.md)** 

## Pre-requisites

- You should have completed Challenge 05

## Introduction

There would be requirements from other integration projects where they need to be able to call backend APIs over a private network.  

## Description
You should be able to secure another backend API services over the virtual network. 


## Success Criteria

You should be able to:
1. Configure OAuth 2.0 authorization in APIM 
    1. Register a client application (e.g. APIM Developer Portal or [Postman](https://www.postman.com/)) in Azure AD.  This will be used to make calls to Hello API via APIM.
    1. Configure JWT validation policy to pre-authorize requests to Hello API. 
    1. Register Hello API Function app as an AD application.
1. Call Hello API from your client application successfully.


## Learning Resources
- [Protect a web API backend in Azure API Management using OAuth 2.0 authorization with Azure Active Directory](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-protect-backend-with-aad)


## Tips
[TODO]

## Advanced Challenges 
[TODO]