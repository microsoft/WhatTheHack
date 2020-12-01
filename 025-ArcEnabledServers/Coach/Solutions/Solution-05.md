# Challenge 05: Arc Value Add: Azure Lighthouse - Coach's Guide

[< Previous Challenge](./Solution-04.md) - **[Home](../readme.md)**

## Notes & Guidance


Pair with another member of your team and [Oonboard their Azure subscription](https://docs.microsoft.com/en-us/azure/lighthouse/how-to/onboard-customer) into your Azure Lighthouse subscription. 
They should enable delegated access of your Azure Arc enabled server to you.

- In the *provider subscription*, use the Azure portal to identify the Azure AD tenant Id.
- In the *provider subscription*, use the Azure portal to create a new Azure AD group named **LHAdmins** and identify the value of its objectID attribute. Add your account to the group.
- In the *customer subscription*, identify the Id of the **Contributor** built-in RBAC role by running the following from a PowerShell session of in the Cloud Shell pane of the Azure portal.

   ```pwsh
   (Get-AzRoleDefinition -name 'Contributor').Id   
   ```

- In the *customer subscription*, verify that the user account used to onboard the service provider is explicitly assigned the **Owner** role in the subscription. If not, make sure to assign it.
- In the browser window displaying the *customer subscription* in the Azure portal, open another tab, navigate to the [Azure Lighthouse samples](https://github.com/Azure/Azure-Lighthouse-samples), and select the **Deploy to Azure** button next to the **Azure Lighthouse - Subscription Deployment** entry. On the **Custom deployment** blade, perform a deployment with the following settings (leave others with their default values):

    | Setting | Value | 
    | --- | --- |
    | Subscription | the name of the *customer subscription*  |
    | Region | the name of the Azure region where you deployed all of the resources |
    | Msp Offer Name | **ArcChallenge5Offer** |
    | Msp Offer Description | **Arc Challenge5 offer** |
    | Managed by Tenant Id | the Id of the Azure Ad tenant associated with the *provider subscription* |
    | Authorizations | [{"principalId":"<objectId of the LHAdmins group>,"roleDefinitionId":"<Id of the Contributor role>","principalIdDisplayName":"LHAdmins"}]

### Success Criteria

In Azure Lighthouse -> Manage Resources you should see the delegated resources from your team members subscription.

   >**Note**: Alternatively, navigate to the **Service providers** blade of the *customer subscription*, select **Service provider offers** entry, and verify that it includes the offer you created in this challenge.

   >**Note**: When using the *provider subscription* for valiadation, make sure that you are using an account that is a member of the **LHAdmins** group.