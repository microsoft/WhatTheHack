# Challenge 08 - Azure Key Vault Integration - Coach's Guide 

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)** - [Next Solution >](./Solution-09.md)

## Notes & Guidance
In this challenge, we will be connecting to Azure Service Operator.

## Create a namespace called `operators`
- Use the command `az feature register --namespace Microsoft.RedHatOpenShift --name operators`

## Connect to Azure Service Operator
- Find account information using the command `az account show` in the Azure CLI
    - Make sure that the following environment variables are set
    ```
    AZURE_TENANT_ID=<your-tenant-id-goes-here>
    AZURE_SUBSCRIPTION_ID=<your-subscription-id-goes-here>
    ```
- Create a Service Principal with *Contributor* permissions in your subscription
    - This can be done with the command
    ```
    az ad sp create-for-rbac -n "azure-service-operator" --role contributor \ --scopes /subscriptions/$AZURE_SUBSCRIPTION_ID
    ```
- Gather the following values to set in a **Secret** called `azureoperatorsettings` within the `operators` Namespace
    ```
    AZURE_TENANT_ID
    AZURE_SUBSCRIPTION_ID
    AZURE_CLIENT_ID
    AZURE_CLIENT_SECRET
    AZURE_CLOUD_ENV
    ```
    - The values should be set like this:
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
- Check that operators are installed using the command `oc get pods -n openshift-operators` or going to the web console **Operators Installed** tab
