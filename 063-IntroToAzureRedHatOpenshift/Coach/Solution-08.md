# Challenge 08 - Microsoft Entra ID Integration - Coach's Guide 

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)** - [Next Solution >](./Solution-09.md)

## Notes & Guidance
- In this challenge, we will be integrating Microsoft Entra ID with Azure Red Hat OpenShift so that Entra ID can be configured as the authentication method for the ARO Web Console. 

## Construct an OAuth Callback URL
- Use the command below where $RESOURCEGROUP is the resource group of your ARO cluster and $CLUSTER is the name of your ARO cluster
```
domain=$(az aro show -g $RESOURCEGROUP -n $CLUSTER --query clusterProfile.domain -o tsv)
location=$(az aro show -g $RESOURCEGROUP -n $CLUSTER --query location -o tsv)
echo "OAuth callback URL: https://oauth-openshift.apps.$domain.$location.aroapp.io/oauth2callback/AAD"
```

## Create Microsoft Entra Application for authentication
- In the Azure portal, navigate to **App Registrations**, and create a new registration
- Fill in redirect URI with the value of the callback URL and select **Web** under **Select a platform**
- After the registration, navigate to **Certificates and Secrets** and create a **New Client Secret** and fill in details
    - **Note:** Make note of the key value
    - **Note:** In **Overview**, make note of the Application (client) ID and Directory (tenant) ID

## Configure OpenShift OpenID Authentication
- Go to *Administration > Cluster Settings > Configuration > OAuth*
- Find **Add** in the dropdown menu near the bottom of the page under Identity Providers, and select **OpenID Connect**
- Fill in the name as **AAD**, the Client ID as the Application ID noted earlier and the Client Secret noted earlier. The Issuer URL is: https://login.microsoftonline.com/(your-tenant-id) with `your-tenant-id` being the Tenant ID noted earlier
- Scroll down to the bottom and click **Add**

## Test it out
- *Note:* This may take a few minutes to work, but after a few minutes, students should be able to log out, and then login with `kube:admin` **or** *AAD*
- Test out **AAD** login option by logging in with your Microsoft credentials

## Integrate using the CLI (Optional)
- If the students decide to, there is a way to complete this challenge in the CLI. Here are docs you can look at to help walk you through that process: [Configure Microsoft Entra authentication for an Azure Red Hat OpenShift 4 cluster (CLI)](https://learn.microsoft.com/en-us/azure/openshift/configure-azure-ad-cli)
