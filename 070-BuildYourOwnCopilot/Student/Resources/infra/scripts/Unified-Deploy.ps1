#! /usr/bin/pwsh

Param(
    [parameter(Mandatory=$false)][string]$acrName=$null,
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$true)][string]$location,
    [parameter(Mandatory=$true)][string]$subscription,
    [parameter(Mandatory=$false)][string]$armTemplate=$null,
    [parameter(Mandatory=$false)][string]$openAiName=$null,
    [parameter(Mandatory=$false)][string]$openAiRg=$null,
    [parameter(Mandatory=$false)][string]$openAiCompletionsDeployment=$null,
    [parameter(Mandatory=$false)][string]$openAiEmbeddingsDeployment=$null,
    [parameter(Mandatory=$false)][bool]$stepDeployArm=$true,
    [parameter(Mandatory=$false)][bool]$stepDeployOpenAi=$true,
    [parameter(Mandatory=$false)][bool]$deployAks=$false,
    [parameter(Mandatory=$false)][bool]$stepBuildPush=$true,
    [parameter(Mandatory=$false)][bool]$stepDeployCertManager=$true,
    [parameter(Mandatory=$false)][bool]$stepDeployTls=$true,
    [parameter(Mandatory=$false)][bool]$stepDeployImages=$true,
    [parameter(Mandatory=$false)][bool]$stepUploadSystemPrompts=$true,
    [parameter(Mandatory=$false)][bool]$stepImportData=$true,
    [parameter(Mandatory=$false)][bool]$stepLoginAzure=$true,
    [parameter(Mandatory=$false)][string]$resourcePrefix=$null
)

$gValuesFile="configFile.yaml"

Push-Location $($MyInvocation.InvocationName | Split-Path)

# Update the extension to make sure you have the latest version installed
az extension add --name aks-preview
az extension update --name aks-preview

az extension add --name  application-insights
az extension update --name  application-insights

az extension add --name storage-preview
az extension update --name storage-preview

az extension add --name containerapp
az extension update --name containerapp

if ($stepLoginAzure) {
    # Write-Host "Login in your account" -ForegroundColor Yellow
    az login
}

# Write-Host "Choosing your subscription" -ForegroundColor Yellow
az account set --subscription $subscription

$rg = $(az group show -g $resourceGroup -o json | ConvertFrom-Json)
if (-not $rg) {
    $rg=$(az group create -g $resourceGroup -l $location --subscription $subscription)
}

if (-not $resourcePrefix) {
    $crypt = New-Object -TypeName System.Security.Cryptography.SHA256Managed
    $utf8 = New-Object -TypeName System.Text.UTF8Encoding
    $hash = [System.BitConverter]::ToString($crypt.ComputeHash($utf8.GetBytes($resourceGroup)))
    $hash = $hash.replace('-','').toLower()
    $resourcePrefix = $hash.Substring(0,5)
}

if ($stepDeployOpenAi) {
    if (-not $openAiRg) {
        $openAiRg=$resourceGroup
    }

    if (-not $openAiName) {
        $openAiName = "$($resourcePrefix)-openai"
    }

    if (-not $openAiCompletionsDeployment) {
        $openAiCompletionsDeployment = "completions"
    }

    if (-not $openAiEmbeddingsDeployment) {
        $openAiEmbeddingsDeployment = "embeddings"
    }

    & ./Deploy-OpenAi.ps1 -name $openAiName -resourceGroup $openAiRg -location $location -completionsDeployment $openAiCompletionsDeployment -embeddingsDeployment $openAiEmbeddingsDeployment
}

## Getting OpenAI info
if ($openAiName) {
    $openAi=$(az cognitiveservices account show -n $openAiName -g $openAiRg -o json | ConvertFrom-Json)
} else {
    $openAi=$(az cognitiveservices account list -g $resourceGroup -o json | ConvertFrom-Json)
    $openAiRg=$resourceGroup
}

$openAiKey=$(az cognitiveservices account keys list -g $openAiRg -n $openAi.name -o json --query key1 | ConvertFrom-Json)

if ($stepDeployArm) {

    if ([string]::IsNullOrEmpty($armTemplate))
    {
        if ($deployAks)
        {
            $armTemplate="azuredeploy.json"
        }
        else
        {
            $armTemplate="azureAcaDeploy.json"
        }
    }
    # Deploy ARM
    & ./Deploy-Arm-Azure.ps1 -resourceGroup $resourceGroup -location $location -template $armTemplate -deployAks $deployAks -openAiEndpoint $openAi.properties.endpoint -openAiKey $openAiKey -openAiCompletionsDeployment $openAiCompletionsDeployment -openAiEmbeddingsDeployment $openAiEmbeddingsDeployment
}

if ($deployAks)
{
    # Connecting kubectl to AKS
    Write-Host "Retrieving Aks Name" -ForegroundColor Yellow
    $aksName = $(az aks list -g $resourceGroup -o json | ConvertFrom-Json).name
    Write-Host "The name of your AKS: $aksName" -ForegroundColor Yellow

    # Write-Host "Retrieving credentials" -ForegroundColor Yellow
    az aks get-credentials -n $aksName -g $resourceGroup --overwrite-existing
}
else
{
    if ([string]::IsNullOrEmpty($cosmosDbAccountName))
    {
        $cosmosDbAccountName=$(az deployment group show -g $resourceGroup -n cosmosdb-openai-azuredeploy -o json --query properties.outputs.cosmosDbAccountName.value | ConvertFrom-Json)
    }
}

# Generate Config
New-Item -ItemType Directory -Force -Path $(./Join-Path-Recursively.ps1 -pathParts ..,__values)
$gValuesLocation=$(./Join-Path-Recursively.ps1 -pathParts ..,__values,$gValuesFile)
& ./Generate-Config.ps1 -resourceGroup $resourceGroup -openAiName $openAiName -openAiRg $openAiRg -openAiDeployment $openAiDeployment -outputFile $gValuesLocation

# Create Secrets
if ([string]::IsNullOrEmpty($acrName))
{
    $acrName = $(az acr list --resource-group $resourceGroup -o json | ConvertFrom-Json).name
}

Write-Host "The Name of your ACR: $acrName" -ForegroundColor Yellow
# & ./Create-Secret.ps1 -resourceGroup $resourceGroup -acrName $acrName

if ($deployAks -And $stepDeployCertManager) {
    # Deploy Cert Manager
    & ./DeployCertManager.ps1
}

if ($deployAks -And $stepDeployTls) {
    # Deploy TLS
    & ./DeployTlsSupport.ps1 -sslSupport prod -resourceGroup $resourceGroup -aksName $aksName
}

if ($stepBuildPush) {
    # Build an Push
    & ./BuildPush.ps1 -resourceGroup $resourceGroup -acrName $acrName
}

if ($stepUploadSystemPrompts) {
    # Upload System Prompts
    & ./UploadSystemPrompts.ps1 -resourceGroup $resourceGroup -location $location
}

if ($stepDeployImages) {
    # Deploy images in AKS
    $gValuesLocation=$(./Join-Path-Recursively.ps1 -pathParts ..,__values,$gValuesFile)
    $chartsToDeploy = "*"

    if ($deployAks) {
        & ./Deploy-Images-Aks.ps1 -aksName $aksName -resourceGroup $resourceGroup -charts $chartsToDeploy -acrName $acrName -valuesFile $gValuesLocation
    }
    else
    {
        & ./Deploy-Images-Aca.ps1 -resourceGroup $resourceGroup -acrName $acrName
    }
}

if ($stepImportData) {
    # Import Data
    & ./Import-Data.ps1 -resourceGroup $resourceGroup -cosmosDbAccountName $cosmosDbAccountName
}

if ($deployAks)
{
    $webappHostname=$(az aks show -n $aksName -g $resourceGroup -o json --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName | ConvertFrom-Json)
}
else
{
    $webappHostname=$(az deployment group show -g $resourceGroup -n cosmosdb-openai-azuredeploy -o json --query properties.outputs.webFqdn.value | ConvertFrom-Json)
}

Write-Host "===========================================================" -ForegroundColor Yellow
Write-Host "The frontend is hosted at https://$webappHostname" -ForegroundColor Yellow
Write-Host "===========================================================" -ForegroundColor Yellow

Pop-Location
