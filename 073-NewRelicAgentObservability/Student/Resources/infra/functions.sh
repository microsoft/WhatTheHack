# Function to display error messages
function error_exit {
    echo -e "\e[31mERROR: $1\e[0m"
    exit 1
}

# Function to authenticate to Azure
function authenticate_to_azure {
    # Authenticate with Azure
    if [[ "$USE_SERVICE_PRINCIPAL" == true ]]; then
        if [[ -z "$TENANT_ID" || -z "$SERVICE_PRINCIPAL_ID" || -z "$SERVICE_PRINCIPAL_PASSWORD" ]]; then
            error_exit "Service Principal ID, Password, and Tenant ID are required for Service Principal authentication."
        fi
        if ! az account show > /dev/null 2>&1; then
            az login --service-principal -u "$SERVICE_PRINCIPAL_ID" -p "$SERVICE_PRINCIPAL_PASSWORD" --tenant "$TENANT_ID" || error_exit "Failed to authenticate using Service Principal."
        fi
    else
        if ! az account show > /dev/null 2>&1; then
            az login || error_exit "Failed to authenticate with Azure."
        fi
    fi
}