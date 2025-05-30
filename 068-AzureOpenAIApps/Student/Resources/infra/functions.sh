# Function to display error messages
function error_exit {
    echo -e "\e[31mERROR: $1\e[0m"
    exit 1
}

function generate_local_settings_file {

    # Create settings file
    echo -e "\n- Creating the settings file:"
    settings_file="../ContosoAIAppsBackend/local.settings.json"
    example_file="../ContosoAIAppsBackend/local.settings.json.example"

    if [[ ! -f "$example_file" ]]; then
        error_exit "Example settings file not found at $example_file."
    fi
    if [[ -f "$settings_file" ]]; then
        random_chars=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 5)
        cp "$settings_file" "${settings_file}-${random_chars}.bak"
        echo -e "\e[33mWarning: Existing settings file found. Backed up to ${settings_file}-${random_chars}.bak\e[0m"
    else
        cp "$example_file" "$settings_file"
    fi
    # Populate settings file
    jq --arg openAIKey "$(echo "$outputs" | jq -r '.openAIKey.value')" \
    --arg openAIEndpoint "$(echo "$outputs" | jq -r '.openAIEndpoint.value')" \
    --arg searchKey "$(echo "$outputs" | jq -r '.searchKey.value')" \
    --arg searchEndpoint "$(echo "$outputs" | jq -r '.searchEndpoint.value')" \
    --arg redisHost "$(echo "$outputs" | jq -r '.redisHostname.value')" \
    --arg redisPassword "$(echo "$outputs" | jq -r '.redisPrimaryKey.value')" \
    --arg cosmosConnection "$(echo "$outputs" | jq -r '.cosmosDBConnectionString.value')" \
    --arg cosmosDatabase "$(echo "$outputs" | jq -r '.cosmosDBDatabaseName.value')" \
    --arg documentEndpoint "$(echo "$outputs" | jq -r '.documentEndpoint.value')" \
    --arg documentKey "$(echo "$outputs" | jq -r '.documentKey.value')" \
    --arg webjobsConnection "$(echo "$outputs" | jq -r '.webjobsConnectionString.value')" \
    --arg storageConnection "$(echo "$outputs" | jq -r '.storageConnectionString.value')" \
    --arg appInsightsConnection "$(echo "$outputs" | jq -r '.appInsightsConnectionString.value')" \
    --arg serviceBusConnection "$(echo "$outputs" | jq -r '.serviceBusConnectionString.value')" \
    --arg modelName "$(echo "$outputs" | jq -r '.modelName.value')" \
    --arg modelVersion "$(echo "$outputs" | jq -r '.modelVersion.value')" \
    --arg embeddingModel "$(echo "$outputs" | jq -r '.embeddingModel.value')" \
    --arg embeddingModelVersion "$(echo "$outputs" | jq -r '.embeddingModelVersion.value')" \
    '.Values.AZURE_OPENAI_API_KEY = $openAIKey |
        .Values.AZURE_OPENAI_ENDPOINT = $openAIEndpoint |
        .Values.AZURE_AI_SEARCH_ADMIN_KEY = $searchKey |
        .Values.AZURE_AI_SEARCH_ENDPOINT = $searchEndpoint |
        .Values.REDIS_HOST = $redisHost |
        .Values.REDIS_PASSWORD = $redisPassword |
        .Values.COSMOS_CONNECTION = $cosmosConnection |
        .Values.COSMOS_DATABASE_NAME = $cosmosDatabase |
        .Values.DOCUMENT_INTELLIGENCE_ENDPOINT = $documentEndpoint |
        .Values.DOCUMENT_INTELLIGENCE_KEY = $documentKey |
        .Values.AzureWebJobsStorage = $webjobsConnection |
        .Values.DOCUMENT_STORAGE = $storageConnection |
        .Values.APPLICATIONINSIGHTS_CONNECTION_STRING = $appInsightsConnection |
        .Values.SERVICE_BUS_CONNECTION_STRING = $serviceBusConnection |
        .Values.AZURE_OPENAI_MODEL_DEPLOYMENT_NAME = $modelName |
        .Values.AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME = $embeddingModel' \
    "$settings_file" > tmp.json && mv tmp.json "$settings_file"

    echo -e "\e[32mSettings file created successfully.\e[0m"

}

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