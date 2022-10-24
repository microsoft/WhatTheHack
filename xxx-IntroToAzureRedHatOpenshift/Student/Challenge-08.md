# Challenge 08 - Azure Key Vault Integration

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-09.md)

## Introduction
So now we have a cluster up and running, but what about the security? Key Vault allows us to securely store our passwords so we do not have to worry about any data leaks or potential threats to our information. 

## Description
In this challenge, we will be connecting to Azure Service Operator and using that to create a vault. We will then use the Azure Key Vault to store our MongoDB passwords. Once we store our passwords in Azure Key Vault, we will point our MongoDB environment variables to the key vault. Then we will confirm with the coach that the application works with the Key Vault integration.

## Success Criteria
To complete this challenge successfully, you should be able to:
- Demonstrate that the Azure Service Operator has been installed in your ARO cluster
- Demonstrate that Azure Key Vault got created using the Azure Service Operator
- Demonstrate that MongoDB is using the key we created inside of Azure Key Vault
- Demonstrate that the application works and the database is up and running correctly

## Learning Resources
- [Using the Azure Service Operator on OpenShift](https://cloud.redhat.com/blog/using-the-azure-service-operator-on-openshift)
- [Azure Service Operator](https://azure.github.io/azure-service-operator/introduction/)
- [Set secret from Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/secrets/quick-create-portal)
- [Store Service Principals in Azure Key Vault](https://learn.microsoft.com/en-us/azure-stack/user/azure-stack-key-vault-store-credentials?view=azs-2206)