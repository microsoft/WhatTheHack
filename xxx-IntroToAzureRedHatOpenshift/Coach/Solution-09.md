# Challenge 09 - Azure Active Directory Integration - Coach's Guide 

[< Previous Solution](./Solution-08.md) - **[Home](./README.md)** - [Next Solution >](./Solution-10.md)

## Notes & Guidance
- In this challenge, we will be integrating Azure Active Directory with ARO so that Azure AD can be configured as authentication for our cluster. 

## Retrieve OAuth callback URL
- Use the command 
```
domain=$(az aro show -g $RESOURCEGROUP -n $CLUSTER --query clusterProfile.domain -o tsv)
location=$(az aro show -g $RESOURCEGROUP -n $CLUSTER --query location -o tsv)
echo "OAuth callback URL: https://oauth-openshift.apps.$domain.$location.aroapp.io/oauth2callback/AAD"
```

## Create Azure AD Application for authentication
- In Azure portal, navigate to **App Registrations**, and create a new registration to create the new application
- Fill in redirect URI with the value of the callback URL
- In **Certificates and Secrets** and create **New Client Secret** and fill in details
    - *Note:* Make note of the key value
    - *Note:* In **Overview**, make note of the Application (client) ID and Directory (tenant) ID

## Configure OpenShift OpenID Authentication
- In the ARO portal, navigate to **Administration** and click on **Cluster Settings**, then select **Global Configuration**, and then and in that tab, select **OAuth**
- Find **Add** in the dropdown menu near the bottom of the page, and under Identity Providers, and select **OpenID Connect**
- Replace Client ID and Tenant ID with values from earlier

## Test it out
- *Note:* This may take a few minutes to work, but after a few minutes, students should be able to log out, and then login with kube:admin **or** AAD
- Test out **AAD** login option by logging in with AAD