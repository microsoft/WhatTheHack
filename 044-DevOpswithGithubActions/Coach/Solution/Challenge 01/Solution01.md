# Create Service Principal with contributor role

**[Reference 1 : Workflow Syntax for Github Actions ](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions)**


**Reference 2 : Connecting to Azure**

Service Principal is used to Authenticate and perform task on Azure subscription.
Here is command line reference to create one service principal for you.

**Giving access to Complete Subscription**

az ad sp create-for-rbac --name "myApp" --role contributor --scopes /subscriptions/{subscription-id} --sdk-auth

**If you want scope of service principal retricted to resource Group follow command below**

az ad sp create-for-rbac --name "myApp" --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} --sdk-auth

Output of this will be similar 


  {
  
    "clientId": "<GUID>",
  
    "clientSecret": "<GUID>",
    
    "subscriptionId": "<GUID>",
    
    "tenantId": "<GUID>",
    
    (...)
    
  }

Copy Complete Parenthesis and create Github Secret , This will be our First Github Secret !
