# Spektra Labs Setup Instructions

This hack requires each student to have an Azure subscription with access to Azure OpenAI services.

When running this hack in a labs environment, we have a deployment script the deploys several resources in the student's Azure subscription. You can follow these instructions to run the script.

## Deployment Script

The deployment script can be found in the Codespace repo for this hack.  We recommend cloning the Codespace repo to wherever you will run the deployment script from.

[Azure OpenAI Apps Codespace Repo](https://github.com/perktime/wth-aiapps-codespace)

This sample code should kick off the deployment script:

```
# Clone the repo to deployment VM or Cloud Shell
git clone https://github.com/perktime/wth-aiapps-codespace.git

# Authenticate Azure CLI
az login

# Navigate to the /infra folder and execute the script
cd infra
chmod +x deploy.sh
./deploy.sh --skip-local-settings-file --subscription-id "[subscription-id]" --resource-group-name "wth-aoai-apps-rg" --tenant-id "[tenant-id]"

```
The deployment script requires the following parameters:
- `subscription-id`: The ID of the Azure Subscription where you want to deploy the resources
- `resource-group-name`: The name of the resource group where you want to deploy the resources. Please use "wth-aoai-apps-rg" for this value for all students.
- `tenant-id`: The Tenant ID associated with your Azure subscription where you want to deploy the resources

The deployment script requires the following CLIs to be available wherever it is run:
- Azure CLI
- Bicep
- jq

The deployment takes 25-30 minutes on average to complete.

If the deployment script runs into any errors, please see the [Challenge 0 Coach Guide](Solution-00.md) for troubleshooting tips.

