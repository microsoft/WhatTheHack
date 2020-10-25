<#
.SYNOPSIS
Creates a new FHIR Server Samples environment.
.DESCRIPTION
#>
param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$EnvironmentName,

    [Parameter(Mandatory = $false)]
    [string]$EnvironmentLocation = "westus2",

    [Parameter(Mandatory = $false)]
    [string]$SourceRepository = "https://github.com/Microsoft/fhir-server-samples",

    [Parameter(Mandatory = $false)]
    [string]$SourceRevision = "master",

    [Parameter(Mandatory = $false)]
    [bool]$DeploySource = $true,

    [Parameter(Mandatory = $false)]
    [bool]$UsePaaS = $false,

    [parameter(Mandatory = $false)]
    [SecureString]$AdminPassword

)

Set-StrictMode -Version Latest

# Get current AzureAd context
try {
    $tenantInfo = Get-AzureADCurrentSessionInfo -ErrorAction Stop
} 
catch {
    throw "Please log in to Azure AD with Connect-AzureAD cmdlet before proceeding"
}

# Get current AzureRm context
try {
    $azureRmContext = Get-AzureRmContext
} 
catch {
    throw "Please log in to Azure RM with Login-AzureRmAccount cmdlet before proceeding"
}

if ($azureRmContext.Account.Type -eq "User") {
    Write-Host "Current context is user: $($azureRmContext.Account.Id)"
    
    $currentUser = Get-AzureRmADUser -UserPrincipalName $azureRmContext.Account.Id

    #If this is guest account, we will try a search instead
    if (!$currentUser) {
        $currentUser = Get-AzureRmADUser -SearchString $azureRmContext.Account.Id
    }

    $currentObjectId = $currentUser.Id

    if (!$currentObjectId) {
        throw "Failed to find objectId for signed in user"
    }
}
elseif ($azureRmContext.Account.Type -eq "ServicePrincipal") {
    Write-Host "Current context is service principal: $($azureRmContext.Account.Id)"
    $currentObjectId = (Get-AzureRmADServicePrincipal -ServicePrincipalName $azureRmContext.Account.Id).Id
}
else {
    Write-Host "Current context is account of type '$($azureRmContext.Account.Type)' with id of '$($azureRmContext.Account.Id)"
    throw "Running as an unsupported account type. Please use either a 'User' or 'Service Principal' to run this command"
}


# Set up Auth Configuration and Resource Group
./Create-FhirServerSamplesAuthConfig.ps1 -EnvironmentName $EnvironmentName -EnvironmentLocation $EnvironmentLocation -AdminPassword $AdminPassword -UsePaaS $UsePaaS

#Template URLs
$githubRawBaseUrl = $SourceRepository.Replace("github.com","raw.githubusercontent.com").TrimEnd('/')
$sandboxTemplate = "${githubRawBaseUrl}/${SourceRevision}/deploy/templates/azuredeploy-sandbox.json"
$dashboardTemplate = "${githubRawBaseUrl}/${SourceRevision}/deploy/templates/azuredeploy-fhirdashboard.json"
$importerTemplate = "${githubRawBaseUrl}/${SourceRevision}/deploy/templates/azuredeploy-importer.json"

$tenantDomain = $tenantInfo.TenantDomain
$aadAuthority = "https://login.microsoftonline.com/${tenantDomain}"

$dashboardUrl = "https://${EnvironmentName}dash.azurewebsites.net"

if ($UsePaaS) {
    $fhirServerUrl = "https://${EnvironmentName}.azurehealthcareapis.com"
} else {
    $fhirServerUrl = "https://${EnvironmentName}srvr.azurewebsites.net"
}

$confidentialClientId = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-confidential-client-id").SecretValueText
$confidentialClientSecret = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-confidential-client-secret").SecretValueText
$serviceClientId = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-service-client-id").SecretValueText
$serviceClientSecret = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-service-client-secret").SecretValueText
$serviceClientObjectId = (Get-AzureADServicePrincipal -Filter "AppId eq '$serviceClientId'").ObjectId
$dashboardUserUpn  = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-admin-upn").SecretValueText
$dashboardUserOid = (Get-AzureADUser -Filter "UserPrincipalName eq '$dashboardUserUpn'").ObjectId
$dashboardUserPassword  = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-admin-password").SecretValueText
$publicClientId = (Get-AzureKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-public-client-id").SecretValueText

$accessPolicies = @()
$accessPolicies += @{ "objectId" = $currentObjectId.ToString() }
$accessPolicies += @{ "objectId" = $serviceClientObjectId.ToString() }
$accessPolicies += @{ "objectId" = $dashboardUserOid.ToString() }

# Deploy the template
if ($UsePaaS) {
    New-AzureRmResourceGroupDeployment -TemplateFile ..\templates\azuredeploy-paas-sandbox.json -environmentName $EnvironmentName -ResourceGroupName $EnvironmentName -aadAuthority $aadAuthority -aadDashboardClientId $confidentialClientId -aadDashboardClientSecret $confidentialClientSecret -aadServiceClientId $serviceClientId -aadServiceClientSecret $serviceClientSecret -fhirDashboardTemplateUrl $dashboardTemplate -fhirImporterTemplateUrl $importerTemplate -fhirDashboardRepositoryUrl $SourceRepository -fhirDashboardRepositoryBranch $SourceRevision -deployDashboardSourceCode $DeploySource -accessPolicies $accessPolicies
} else {
    New-AzureRmResourceGroupDeployment -TemplateUri $sandboxTemplate -environmentName $EnvironmentName -ResourceGroupName $EnvironmentName -aadAuthority $aadAuthority -aadDashboardClientId $confidentialClientId -aadDashboardClientSecret $confidentialClientSecret -aadServiceClientId $serviceClientId -aadServiceClientSecret $serviceClientSecret -smartAppClientId $publicClientId -fhirDashboardTemplateUrl $dashboardTemplate -fhirImporterTemplateUrl $importerTemplate -fhirDashboardRepositoryUrl $SourceRepository -fhirDashboardRepositoryBranch $SourceRevision -deployDashboardSourceCode $DeploySource
}

Write-Host "Warming up site..."
Invoke-WebRequest -Uri "${fhirServerUrl}/metadata" | Out-Null
$functionAppUrl = "https://${EnvironmentName}imp.azurewebsites.net"
Invoke-WebRequest -Uri $functionAppUrl | Out-Null 

@{
    dashboardUrl              = $dashboardUrl
    fhirServerUrl             = $fhirServerUrl
    dashboardUserUpn          = $dashboardUserUpn
    dashboardUserPassword     = $dashboardUserPassword
}
