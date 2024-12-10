#! /usr/bin/pwsh

Param(
    [parameter(Mandatory=$false)][string]$name = "ms-openai-cosmos-db",
    [parameter(Mandatory=$false)][string]$resourceGroup,
    [parameter(Mandatory=$false)][string]$acrName,
    [parameter(Mandatory=$false)][string]$acrResourceGroup=$resourceGroup,
    [parameter(Mandatory=$false)][string]$tag="latest"
)

function validate {
    $valid = $true

    if ([string]::IsNullOrEmpty($resourceGroup))  {
        Write-Host "No resource group. Use -resourceGroup to specify resource group." -ForegroundColor Red
        $valid=$false
    }

    if ([string]::IsNullOrEmpty($acrLogin))  {
        Write-Host "ACR login server can't be found. Are you using right ACR ($acrName) and RG ($resourceGroup)?" -ForegroundColor Red
        $valid=$false
    }

    if ($valid -eq $false) {
        exit 1
    }
}

Write-Host "--------------------------------------------------------" -ForegroundColor Yellow
Write-Host " Deploying images on Aca"  -ForegroundColor Yellow
Write-Host " "  -ForegroundColor Yellow
Write-Host " Additional parameters are:"  -ForegroundColor Yellow
Write-Host " Images tag: $tag"  -ForegroundColor Yellow
Write-Host " --------------------------------------------------------" 

if ($acrName -ne "bydtochatgptcr") {
    $acrLogin=$(az acr show -n $acrName -g $acrResourceGroup -o json| ConvertFrom-Json).loginServer
    Write-Host "acr login server is $acrLogin" -ForegroundColor Yellow
}
else {
    $acrLogin="bydtochatgptcr.azurecr.io"
}

$deploymentOutputs=$(az deployment group show -g $resourceGroup -n cosmosdb-openai-azuredeploy -o json --query properties.outputs | ConvertFrom-Json)

validate

Push-Location $($MyInvocation.InvocationName | Split-Path)

Write-Host "Deploying images..." -ForegroundColor Yellow

Write-Host "API deployment - api" -ForegroundColor Yellow
$command = "az containerapp update --name $($deploymentOutputs.apiAcaName.value) --resource-group $resourceGroup --image $acrLogin/chat-service-api:$tag"
Invoke-Expression "$command"

Write-Host "Webapp deployment - web" -ForegroundColor Yellow
$command = "az containerapp update --name $($deploymentOutputs.webAcaName.value) --resource-group $resourceGroup --image $acrLogin/chat-web-app:$tag"
Invoke-Expression "$command"

Write-Host " --------------------------------------------------------" 
Write-Host "Entering holding pattern to wait for proper backend API initialization"
Write-Host "Attempting to retrieve status from https://$($deploymentOutputs.apiFqdn.value)/status every 20 seconds with 50 retries"
Write-Host " --------------------------------------------------------" 
$apiStatus = "initializing"
$retriesLeft = 50
while (($apiStatus.ToString() -ne "ready") -and ($retriesLeft -gt 0)) {
    Start-Sleep -Seconds 20
    try {
        $apiStatus = Invoke-RestMethod -Uri "https://$($deploymentOutputs.apiFqdn.value)/status" -Method GET
    }
    catch {
        Write-Host "The attempt to invoke the API endpoint failed. Will retry."
    }
    finally {
        Write-Host "Last known API endpoint status: $($apiStatus)"
    }
    
    $retriesLeft -= 1
} 

if ($apiStatus.ToString() -ne "ready") {
    throw "The backend API did not enter the ready state."
}

Pop-Location

Write-Host "MS OpenAI Chat deployed to ACA" -ForegroundColor Yellow