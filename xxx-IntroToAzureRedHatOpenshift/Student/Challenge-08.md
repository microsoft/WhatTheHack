# Challenge 08 - Azure Service Operator Connection

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-09.md)

## Introduction
So now we have a cluster up and running, but what about the security? What about other things we may want to add onto our cluster? Azure Serivce Operator help us provision other Azure resources and connect them to our applications from within ARO.

## Description
In this challenge, we will be connecting to Azure Service Operator. While we cannot connect it to Key Vault just yet because Key Vault is not yet supported, we will still learn how to create the Service Operator that we would in theory use to connect to Key Vault and store our passwords, so we can point our environment variables to that instead.

## Success Criteria
To complete this challenge successfully, you should be able to:
- Demonstrate that the Azure Service Operator has been installed in your ARO cluster by using the command `oc get pods -n openshift-operators`

## Learning Resources
- [Using the Azure Service Operator on OpenShift](https://cloud.redhat.com/blog/using-the-azure-service-operator-on-openshift)
- [Azure Service Operator](https://azure.github.io/azure-service-operator/introduction/)
- [Set secret from Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/secrets/quick-create-portal)
- [Store Service Principals in Azure Key Vault](https://learn.microsoft.com/en-us/azure-stack/user/azure-stack-key-vault-store-credentials?view=azs-2206)