#! /usr/bin/pwsh

Param (
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$false)][string]$openAiName,
    [parameter(Mandatory=$false)][string]$openAiRg,
    [parameter(Mandatory=$false)][string]$openAiDeployment,
    [parameter(Mandatory=$false)][string[]]$outputFile=$null,
    [parameter(Mandatory=$false)][string[]]$gvaluesTemplate="..,gvalues.template.yml",
    [parameter(Mandatory=$false)][string[]]$migrationSettingsTemplate="..,migrationsettings.template.json",
    [parameter(Mandatory=$false)][string]$ingressClass="addon-http-application-routing",
    [parameter(Mandatory=$false)][string]$domain
)

function EnsureAndReturnFirstItem($arr, $restype) {
    if (-not $arr -or $arr.Length -ne 1) {
        Write-Host "Fatal: No $restype found (or found more than one)" -ForegroundColor Red
        exit 1
    }

    return $arr[0]
}

# Check the rg
$rg=$(az group show -n $resourceGroup -o json | ConvertFrom-Json)

if (-not $rg) {
    Write-Host "Fatal: Resource group not found" -ForegroundColor Red
    exit 1
}

### Getting Resources
$tokens=@{}

## Getting storage info
# $storage=$(az storage account list -g $resourceGroup --query "[].{name: name, blob: primaryEndpoints.blob}" -o json | ConvertFrom-Json)
# $storage=EnsureAndReturnFirstItem $storage "Storage Account"
# Write-Host "Storage Account: $($storage.name)" -ForegroundColor Yellow

## Getting API URL domain
if ([String]::IsNullOrEmpty($domain)) {
    $domain = $(az aks show -n $aksName -g $resourceGroup -o json --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName | ConvertFrom-Json)
    if (-not $domain) {
        $domain = $(az aks show -n $aksName -g $resourceGroup -o json --query addonProfiles.httpapplicationrouting.config.HTTPApplicationRoutingZoneName | ConvertFrom-Json)
    }
}

$apiUrl = "https://$domain"

## Getting CosmosDb info
$docdb=$(az cosmosdb list -g $resourceGroup --query "[?kind=='GlobalDocumentDB'].{name: name, kind:kind, documentEndpoint:documentEndpoint}" -o json | ConvertFrom-Json)
$docdb=EnsureAndReturnFirstItem $docdb "CosmosDB (Document Db)"
$docdbKey=$(az cosmosdb keys list -g $resourceGroup -n $docdb.name -o json --query primaryMasterKey | ConvertFrom-Json)
Write-Host "Document Db Account: $($docdb.name)" -ForegroundColor Yellow

## Getting Storage info
$blobAccount=$(az storage account list -g $resourceGroup -o json | ConvertFrom-Json).name
$blobKey=$(az storage account keys list -g $resourceGroup -n $blobAccount -o json | ConvertFrom-Json)[0].value

## Getting OpenAI info
if ($openAiName) {
    $openAi=$(az cognitiveservices account show -n $openAiName -g $openAiRg -o json | ConvertFrom-Json)
} else {
    $openAi=$(az cognitiveservices account list -g $resourceGroup -o json | ConvertFrom-Json)
    $openAiRg=$resourceGroup
}

$openAiKey=$(az cognitiveservices account keys list -g $openAiRg -n $openAi.name -o json --query key1 | ConvertFrom-Json)

## Getting App Insights instrumentation key, if required
$appinsightsId=@()
$appInsightsName=$(az resource list -g $resourceGroup --resource-type Microsoft.Insights/components --query [].name | ConvertFrom-Json)
if ($appInsightsName -and $appInsightsName.Length -eq 1) {
    $appinsightsConfig=$(az monitor app-insights component show --app $appInsightsName -g $resourceGroup -o json | ConvertFrom-Json)

    if ($appinsightsConfig) {
        $appinsightsId = $appinsightsConfig.instrumentationKey
        $appinsightsConnectionString = $appinsightsConfig.connectionString 
    }
}
Write-Host "App Insights Instrumentation Key: $appinsightsId" -ForegroundColor Yellow

## Showing Values that will be used

Write-Host "===========================================================" -ForegroundColor Yellow
Write-Host "gvalues file will be generated with values:"

$tokens.apiUrl=$apiUrl
$tokens.blobStorageConnectionString="DefaultEndpointsProtocol=https;AccountName=$($blobAccount);AccountKey=$blobKey;EndpointSuffix=core.windows.net"
$tokens.cosmosConnectionString="AccountEndpoint=$($docdb.documentEndpoint);AccountKey=$docdbKey"
$tokens.cosmosEndpoint=$docdb.documentEndpoint
$tokens.cosmosKey=$docdbKey
$tokens.openAiEndpoint=$openAi.properties.endpoint
$tokens.openAiKey=$openAiKey
$tokens.searchEndpoint="https://$($search.name).search.windows.net/"
$tokens.aiConnectionString=$appinsightsConnectionString

# Standard fixed tokens
$tokens.ingressclass=$ingressClass
$tokens.ingressrewritepath="(/|$)(.*)"
$tokens.ingressrewritetarget="`$2"

if($ingressClass -eq "nginx") {
    $tokens.ingressrewritepath="(/|$)(.*)" 
    $tokens.ingressrewritetarget="`$2"
}

Write-Host ($tokens | ConvertTo-Json) -ForegroundColor Yellow
Write-Host "===========================================================" -ForegroundColor Yellow

Push-Location $($MyInvocation.InvocationName | Split-Path)
$gvaluesTemplatePath=$(./Join-Path-Recursively -pathParts $gvaluesTemplate.Split(","))
$outputFilePath=$(./Join-Path-Recursively -pathParts $outputFile.Split(","))
& ./Token-Replace.ps1 -inputFile $gvaluesTemplatePath -outputFile $outputFilePath -tokens $tokens
Pop-Location

Push-Location $($MyInvocation.InvocationName | Split-Path)
$migrationSettingsTemplatePath=$(./Join-Path-Recursively -pathParts $migrationSettingsTemplate.Split(","))
$outputFilePath=$(./Join-Path-Recursively -pathParts ..,migrationsettings.json)
& ./Token-Replace.ps1 -inputFile $migrationSettingsTemplatePath -outputFile $outputFilePath -tokens $tokens
Pop-Location