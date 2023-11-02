# Challenge 09 - Azure Service Operator Connection

[< Previous Challenge](./Challenge-08.md) - **[Home](../README.md)**

## Introduction
You've made it to the last challenge. Congratulations! So now we have a cluster up and running, but what about security? What about other things we may want to add to our cluster? Azure Service Operator helps us provision other Azure resources and connect them to our applications from within ARO.

## Description
In this challenge, we will be installing Azure Service Operator and using it. While we cannot connect it to Azure Key Vault yet, there are other things we can do with it. This challenge is very free-flow so you and your team will decide which features of Azure Service Operator you want to use! Have fun :)

## Success Criteria
To complete this challenge successfully, you should be able to:
- Demonstrate that the Azure Service Operator has been installed in your ARO cluster by using the command `oc get pods -n openshift-operators`

## Learning Resources
- [Using the Azure Service Operator on OpenShift](https://cloud.redhat.com/blog/using-the-azure-service-operator-on-openshift)
- [Azure Service Operator](https://operatorhub.io/operator/azure-service-operator)