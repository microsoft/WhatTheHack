#!/bin/bash

# Include functions
source ./functions.sh

# Default values
LOCATION="East US"
RESOURCE_GROUP_NAME="newrelic-gameday-wth"
NEW_RELIC_MONITOR_NAME="newrelic-gameday-monitor"
NEW_RELIC_MONITOR_USER_FIRST_NAME="Firstname"
NEW_RELIC_MONITOR_USER_LAST_NAME="Lastname"
NEW_RELIC_MONITOR_USER_EMAIL_ADDRESS="gameday@example.com"
NEW_RELIC_MONITOR_USER_PHONE_NUMBER="+1 800 123456789"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --subscription-id) SUBSCRIPTION_ID="$2"; shift ;;
        --resource-group-name) RESOURCE_GROUP_NAME="$2"; shift ;;
        --location) LOCATION="$2"; shift ;;
        --tenant-id) TENANT_ID="$2"; shift ;;
        --use-service-principal) USE_SERVICE_PRINCIPAL=true ;;
        --service-principal-id) SERVICE_PRINCIPAL_ID="$2"; shift ;;
        --service-principal-password) SERVICE_PRINCIPAL_PASSWORD="$2"; shift ;;
        --new-relic-monitor-user-first-name) NEW_RELIC_MONITOR_USER_FIRST_NAME="$2"; shift ;;
        --new-relic-monitor-user-last-name) NEW_RELIC_MONITOR_USER_LAST_NAME="$2"; shift ;;
        --new-relic-monitor-user-email-address) NEW_RELIC_MONITOR_USER_EMAIL_ADDRESS="$2"; shift ;;
        --new-relic-monitor-user-phone-number) NEW_RELIC_MONITOR_USER_PHONE_NUMBER="$2"; shift ;;
        --skip-local-settings-file) SKIP_LOCAL_SETTINGS_FILE=true; shift ;;
        --silent-install) SILENT_INSTALL=true; shift ;;
        *) error_exit "Unknown parameter passed: $1" ;;
    esac
    shift
done

# Check if Bicep CLI is installed
# if ! command -v bicep &> /dev/null; then
#     error_exit "Bicep CLI not found. Install it using 'az bicep install'."
# fi

echo -e "\n\t\t\e[32mWHAT THE HACK - NEW RELIC GAMEDAY\e[0m"
echo -e "\tcreated with love by the New Relic DevRel Team!\n"

if [[ "$SILENT_INSTALL" == false ]]; then
    # Validate mandatory parameters, if required
    if [[ -z "$SUBSCRIPTION_ID" || -z "$RESOURCE_GROUP_NAME" ]]; then
        error_exit "Subscription ID and Resource Group Name are mandatory."
    fi
    authenticate_to_azure

    # Set the subscription
    az account set --subscription "$SUBSCRIPTION_ID" || error_exit "Failed to set subscription."

    # Display deployment parameters
    echo -e "The resources will be provisioned using the following parameters:"
    echo -e "\t          TenantId: \e[33m$TENANT_ID\e[0m"
    echo -e "\t    SubscriptionId: \e[33m$SUBSCRIPTION_ID\e[0m"
    echo -e "\t    Resource Group: \e[33m$RESOURCE_GROUP_NAME\e[0m"
    echo -e "\t            Region: \e[33m$LOCATION\e[0m"
    echo -e "\e[31mIf any parameter is incorrect, abort this script, correct, and try again.\e[0m"
    echo -e "It will take around \e[32m15 minutes\e[0m to deploy all resources. You can monitor the progress from the deployments page in the resource group in Azure Portal.\n"

    read -p "Press Y to proceed to deploy the resources using these parameters: " proceed
    if [[ "$proceed" != "Y" && "$proceed" != "y" ]]; then
        echo -e "\e[31mAborting deployment script.\e[0m"
        exit 1
    fi
fi
start=$(date +%s)

# Create resource group
echo -e "\n- Creating resource group: "
az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION" || error_exit "Failed to create resource group."

# Install New Relic extension
echo -e "\n- Installing New Relic extension: "
az config set extension.use_dynamic_install=yes_without_prompt

az extension add --name "new-relic" || echo "New Relic extension already installed."

# Create New Relic monitor
echo -e "\n- Creating New Relic monitor: "
result=$(az new-relic monitor create --resource-group "$RESOURCE_GROUP_NAME" --name "$NEW_RELIC_MONITOR_NAME" --location "$LOCATION" \
    --user-info first-name="$NEW_RELIC_MONITOR_USER_FIRST_NAME" last-name="$NEW_RELIC_MONITOR_USER_LAST_NAME" email-address="$NEW_RELIC_MONITOR_USER_EMAIL_ADDRESS" phone-number="$NEW_RELIC_MONITOR_USER_PHONE_NUMBER" \
    --plan-data billing-cycle="MONTHLY" effective-date='2026-1-13T08:00:00+02:00' plan-details="newrelic-pay-as-you-go-free-live@TIDn7ja87drquhy@PUBIDnewrelicinc1635200720692.newrelic_liftr_payg_2025" usage-type="PAYG" \
    --account-creation-source "LIFTR" --org-creation-source "LIFTR"  --identity type=SystemAssigned
    ) || error_exit "Failed to create New Relic monitor."

# Extract outputs
outputs=$(echo "$result" | jq -r '.newRelicAccountProperties')

NEW_RELIC_ACCOUNT_ID=$(echo "$outputs" | jq -r '.accountInfo.accountId')
NEW_RELIC_ORGANIZATION_ID=$(echo "$outputs" | jq -r '.organizationInfo.organizationId')

# Display New Relic account details
echo -e "\n- New Relic Monitor created successfully!"
echo -e "\tNew Relic Account ID: \e[33m$NEW_RELIC_ACCOUNT_ID\e[0m"
echo -e "\tNew Relic Organization ID: \e[33m$NEW_RELIC_ORGANIZATION_ID\e[0m"

# Deploy resources
echo -e "\n- Deploying resources: "
result=$(az deployment group create --resource-group "$RESOURCE_GROUP_NAME" --template-file ./main.bicep \
    --parameters newRelicAccountId="$NEW_RELIC_ACCOUNT_ID" newRelicOrganizationId="$NEW_RELIC_ORGANIZATION_ID" ) || error_exit "Azure deployment failed."

# Deployment completed
end=$(date +%s)
echo -e "\nThe deployment took: $((end - start)) seconds."
