Write-Host "Retrieving cluster credentials"
az aks get-credentials --resource-group ${env:AZURE_RESOURCE_GROUP} --name ${env:AZURE_AKS_CLUSTER_NAME}

# Add required Helm repos
helm repo add aso2 https://raw.githubusercontent.com/Azure/azure-service-operator/main/v2/charts
helm repo add kedacore https://kedacore.github.io/charts
helm repo add jetstack https://charts.jetstack.io
helm repo update

$certmanagerStatus=$(helm status cert-manager -n cert-manager 2>&1)
if ($certmanagerStatus -like "Error: release: not found") {
    Write-Host "cert-manager not installed, installing"
    helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.11.0 --set installCRDs=true
} else {
  Write-Host "cert-manager installed, skipping"
}

Write-Host "Checking if Azure Service Operator is installed"
$aso2Status=$(helm status aso2 -n azureserviceoperator-system 2>&1)
if ($aso2Status -like "Error: release: not found") {
     Write-Host "Azure Service Operator not installed, installing"
     kubectl apply -f ./manifests/aso_crd_v2.6.0.yaml

     helm upgrade --install --devel aso2 aso2/azure-service-operator `
          --create-namespace `
          --namespace=azureserviceoperator-system `
          --set azureSubscriptionID=${env:AZURE_SUBSCRIPTION_ID} `
          --set azureTenantID=${env:AZURE_TENANT_ID} `
          --set azureClientID=${env:ASO_WORKLOADIDENTITY_CLIENT_ID} `
          --set useWorkloadIdentityAuth=true `
          --version 2.6.0
} else {
  Write-Host "Azure Service Operator installed, skipping"
}

# Temporary until KEDA add-on is updated to 2.10 which is needed for workload identity support in Prometheus scaler
Write-Host "Checking if KEDA is installed"
$kedatatus=$(helm status keda -n kube-system 2>&1)
if ($kedatatus -like "Error: release: not found") {
     Write-Host "KEDA not installed, installing"
     helm upgrade --install keda kedacore/keda `
          --namespace kube-system `
          --set podIdentity.azureWorkload.enabled=true
} else {
  Write-Host "KEDA installed, skipping"
}

Write-Host "Retrieving OpenAI Key"
$AZURE_OPENAI_KEY=$(
  az cognitiveservices account keys list `
    --name ${env:AZURE_OPENAI_NAME} `
    --resource-group ${env:AZURE_RESOURCE_GROUP} `
    -o json | ConvertFrom-Json).key1

azd env set AZURE_OPENAI_KEY ${AZURE_OPENAI_KEY}

Write-Host "Retrieving CosmosDB Key"
$AZURE_COSMOS_DB_KEY=$(
  az cosmosdb keys list `
    --name ${env:AZURE_COSMOS_DB_NAME} `
    --resource-group ${env:AZURE_RESOURCE_GROUP} `
    -o json | ConvertFrom-Json).primaryMasterKey

azd env set AZURE_COSMOS_DB_KEY ${AZURE_COSMOS_DB_KEY}

Write-Host "Retrieving CosmosDB Key"
$AZURE_COSMOS_DB_VEC_KEY=$(
  az cosmosdb keys list `
    --name ${env:AZURE_COSMOS_DB_NAME} `
    --resource-group ${env:AZURE_RESOURCE_GROUP} `
    -o json | ConvertFrom-Json).primaryMasterKey

azd env set AZURE_COSMOS_DB_VEC_KEY ${AZURE_COSMOS_DB_VEC_KEY}

Write-Host "Retrieving Storage Connection String"
$AZURE_STORAGE_KEY=$(
  az storage account keys list `
    --account-name ${env:AZURE_STORAGE_ACCOUNT_NAME} `
    --resource-group ${env:AZURE_RESOURCE_GROUP} `
    -o json | ConvertFrom-Json)[0].value

$AZURE_STORAGE_CONNECTION_STRING="DefaultEndpointsProtocol=https;AccountName=${env:AZURE_STORAGE_ACCOUNT_NAME};AccountKey=${AZURE_STORAGE_KEY};EndpointSuffix=core.windows.net"

azd env set AZURE_STORAGE_CONNECTION_STRING ${AZURE_STORAGE_CONNECTION_STRING}

az account set --subscription ${env:AZURE_SUBSCRIPTION_ID}

az storage container create --account-name ${env:AZURE_STORAGE_ACCOUNT_NAME} --name "system-prompt" --only-show-errors
az storage azcopy blob upload -c system-prompt --account-name ${env:AZURE_STORAGE_ACCOUNT_NAME} -s "../data/SystemPrompts/*" --recursive --only-show-errors

az storage container create --account-name ${env:AZURE_STORAGE_ACCOUNT_NAME} --name "memory-source" --only-show-errors
az storage azcopy blob upload -c memory-source --account-name ${env:AZURE_STORAGE_ACCOUNT_NAME} -s "../data/MemorySources/*.json" --recursive --only-show-errors

az storage container create --account-name ${env:AZURE_STORAGE_ACCOUNT_NAME} --name "product-policy" --only-show-errors
az storage azcopy blob upload -c product-policy --account-name ${env:AZURE_STORAGE_ACCOUNT_NAME} -s "../data/MemorySources/*.txt" --recursive --only-show-errors

