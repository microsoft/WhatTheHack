# Challenge 04 - Azure AD Identity - Azure AD and SAP principal propagation

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

# Introduction

This time we already have a working geode cache and ASP.NET Application running on Azure, but what about if our user credentials are all stored in Azure Active Directory? 

In this challenge, you'll wire up your MVC application/APIM combination to handle login via Azure Active Directory and use APIM to perform user Principal Mapping to SAP user identities via Azure AAD.

## Description

Now you can propagate Azure Active Directory user principals into SAP S4 or ECC

- Review these two Blog Posts on [SAP Principal Propagation](https://blogs.sap.com/2020/07/17/principal-propagation-in-a-multi-cloud-solution-between-microsoft-azure-and-sap-cloud-platform-scp/), - [SAP Principal Propagation II](https://blogs.sap.com/2020/10/01/principal-propagation-in-a-multi-cloud-solution-between-microsoft-azure-and-sap-cloud-platform-scp-part-ii/) to understand the concepts of what we are going to enable. You do NOT need to complete the setup described in the blog posts - the APIM policy will take care of the complexities of the token acquisition/SAML exchange dance and token caching for you.
- Return to step 10 of [Azure SAP OData Reader](https://github.com/MartinPankraz/AzureSAPODataReader#azure-api-management-config) and configure the principal propagation setup and the APIM policy to automagically handle this for you! Simple!

## Success Criteria

- At the end of this hack you will have deployed and run an ASP.NET MVC Core app that can view and edit data in SAP S/4 HANA via RESTful OData calls, that have been secured and routed via an Azure API Management gateway, whilst your users have been authenticated via Azure Active Directory using OpenID Connect.

## Learning Resources

- [Azure SAP OData Reader](https://github.com/MartinPankraz/AzureSAPODataReader)
- [SAP Principal Propagation I](https://blogs.sap.com/2020/07/17/principal-propagation-in-a-multi-cloud-solution-between-microsoft-azure-and-sap-cloud-platform-scp/)
- [SAP Principal Propagation II](https://blogs.sap.com/2020/10/01/principal-propagation-in-a-multi-cloud-solution-between-microsoft-azure-and-sap-cloud-platform-scp-part-ii/)
