# Challenge 3: Keep your secrets safe

[< Previous Challenge](./challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./challenge-04.md)

## Introduction

Things are running fine on App Service, but the _Application Settings_ contain the database credentials in clear text. That's not too secure, let's fix that.

## Description

Create a Key Vault and connect it to App Service. Make sure that all database settings (url, user, password) are in the Key Vault and accessed by the App Service instance through that Key Vault only.

## Success Criteria

1. Verify the application is working by creating a new owner, a new pet and a new visit through the new webapp
1. Verify that Application Settings don't contain any of the database settings in cleartext
1. No files should be modified for this challenge

## Learning Resources

- [Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/general/basic-concepts)
- [Managed identities on Azure](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)
- [Access Policies for Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/general/assign-access-policy-portal)

[Next Challenge - Do you know what’s going on in your application? >](./challenge-04.md)
