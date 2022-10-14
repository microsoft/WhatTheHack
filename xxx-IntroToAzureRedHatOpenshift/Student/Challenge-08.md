# Challenge 08 - Azure Key Vault Integration

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-09.md)

## Introduction


## Description
In this challenge, we will be connecting to Azure Service Operator and using that to create a vault. We will then use the Azure Key Vault to store our Mongo DB passwords. Once we store our passwords in Azure Key Vault, we will point our mongo db env variables to the key vault. Then we will confirm to the coach that the application works with the key vault integration.

## Success Criteria
To complete this challenge successfully, you should be able to:
- Demonstrate that the Azure Service Operator has been installed in your ARO cluster
- Demonstrate that Azure Key Vault got created using the Azure Service Operator
- Demonstrate that Mongo DB is using the key we created inside of Azure Key Vault
- Demonstrate that the application works and the database is up and running correctly

## Learning Resources
- [Using the Azure Service Operator on OpenShift](https://cloud.redhat.com/blog/using-the-azure-service-operator-on-openshift)
- [Azure Service Operator](https://azure.github.io/azure-service-operator/introduction/)