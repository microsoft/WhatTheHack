<#
.SYNOPSIS
Sets environment variables for E2E integration tests
.DESCRIPTION
#>
param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$EnvironmentName,

    [Parameter(Mandatory = $false)]
    [bool]$SetUserSecrets = $false
)

Set-StrictMode -Version Latest

# Get current AzureRm context
try {
    $azureRmContext = Get-AzureRmContext
} 
catch {
    throw "Please log in to Azure RM with Login-AzureRmAccount cmdlet before proceeding"
}

$dashboardUrl = "https://${EnvironmentName}dash.azurewebsites.net"
$growthChartAppLaunchUrl = "https://${EnvironmentName}growth.azurewebsites.net/launch.html"
$medicationsAppLaunchUrl = "https://${EnvironmentName}meds.azurewebsites.net/launch.html"
$fhirServerUrl = "https://${EnvironmentName}srvr.azurewebsites.net"
$dashboardUserUpn  = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-admin-upn").SecretValueText
$dashboardUserPassword  = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-admin-password").SecretValueText
$confidentialClientId  = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-confidential-client-id").SecretValueText
$confidentialClientSecret  = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-confidential-client-secret").SecretValueText
$serviceClientId  = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-service-client-id").SecretValueText
$serviceClientSecret  = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-service-client-secret").SecretValueText

$storageAccountName = ("${EnvironmentName}dashsa").Replace('-','');
$storageAccountKey = (Get-AzureRmStorageAccountKey -Name $storageAccountName -ResourceGroupName $EnvironmentName)[0].Value
$storageAccountConnectionString = "DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccountKey}"

$env:StorageAccountConnectionString = $storageAccountConnectionString
$env:FhirServerUrl = $fhirServerUrl
$env:DashboardUrl = $dashboardUrl
$env:DashboardUserUpn = $dashboardUserUpn
$env:DashboardUserPassword = $dashboardUserPassword
$env:ConfidentialClientId = $confidentialClientId
$env:ConfidentialClientSecret = $confidentialClientSecret
$env:ServiceClientId = $serviceClientId
$env:ServiceClientSecret = $serviceClientSecret

if ($SetUserSecrets)
{
    dotnet user-secrets set "FhirImportService:StorageConnectionString" $storageAccountConnectionString
    dotnet user-secrets set "FhirServerUrl" $fhirServerUrl
    dotnet user-secrets set "FhirImportService:FhirServerUrl" $fhirServerUrl
    dotnet user-secrets set "FhirImportService:ClientSecret" $serviceClientSecret
    dotnet user-secrets set "FhirImportService:ClientId" $serviceClientId
    dotnet user-secrets set "FhirServerAudience" $fhirServerUrl
    dotnet user-secrets set "AzureAd:ClientSecret" $confidentialClientSecret
    dotnet user-secrets set "AzureAd:ClientId" $confidentialClientId
    dotnet user-secrets set "SmartOnFhirApps:0:DisplayName" "Growth Chart"
    dotnet user-secrets set "SmartOnFhirApps:0:LaunchUrl" $growthChartAppLaunchUrl
    dotnet user-secrets set "SmartOnFhirApps:1:DisplayName" "Medications"
    dotnet user-secrets set "SmartOnFhirApps:1:LaunchUrl" $medicationsAppLaunchUrl
}

@{
    dashboardUrl                   = $dashboardUrl
    fhirServerUrl                  = $fhirServerUrl
    dashboardUserUpn               = $dashboardUserUpn
    dashboardUserPassword          = $dashboardUserPassword
    confidentialClientId           = $confidentialClientId
    confidentialClientSecret       = $confidentialClientSecret
    serviceClientId                = $serviceClientId
    serviceClientSecret            = $serviceClientSecret
    storageAccountConnectionString = $storageAccountConnectionString
}


