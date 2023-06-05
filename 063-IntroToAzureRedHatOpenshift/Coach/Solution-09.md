# Challenge 09 - Azure Service Operator Connection - Coach's Guide 

[< Previous Solution](./Solution-08.md) - **[Home](./README.md)**

## Notes & Guidance
In this challenge, we will be connecting to Azure Service Operator.

## Prerequisites Before Installing Azure Service Operator
- Find account information using the command `az account show` in the Azure CLI. Set the following environment variables to your Azure Tenant ID and Subscription ID with your values:
    ```
    AZURE_TENANT_ID=<your-tenant-id-goes-here>
    AZURE_SUBSCRIPTION_ID=<your-subscription-id-goes-here>
    ```
- Create a Service Principal with *Contributor* permissions in your subscription. This can be done with the following command
    ```
    az ad sp create-for-rbac -n "azure-service-operator" --role contributor \ --scopes /subscriptions/$AZURE_SUBSCRIPTION_ID
    ```
- Gather the following values
    ```
    AZURE_TENANT_ID
    AZURE_SUBSCRIPTION_ID
    AZURE_CLIENT_ID
    AZURE_CLIENT_SECRET
    AZURE_CLOUD_ENV
    ```
- Create a **Secret** called `azureoperatorsettings` within the `operators` namespace and use the values gathered above
    ```
    apiVersion: v1
    kind: Secret
    metadata:
        name: azureoperatorsettings
        namespace: operators
    stringData:
        AZURE_TENANT_ID: <your-tenant-id-goes-here>
        AZURE_SUBSCRIPTION_ID: <your-subscription-id-goes-here>
        AZURE_CLIENT_ID: <your-client-id>
        AZURE_CLIENT_SECRET: <your-client-secret>
        AZURE_CLOUD_ENV: <your-azure-cloud-environment>
    ```

## Install Azure Service Operator
- Go to *Operators > OperatorHub > Search `Azure Service Operator` > Select `Azure Service Operator` > Install*

## Confirm Installation
- Check that operators are installed using the command `oc get pods -n openshift-operators` or by going to *Operators > Installed Operators*
