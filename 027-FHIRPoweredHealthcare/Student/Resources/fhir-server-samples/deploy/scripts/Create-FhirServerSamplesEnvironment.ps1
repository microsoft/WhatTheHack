<#
.SYNOPSIS
Creates a new FHIR Server Samples environment.
.DESCRIPTION
#>
param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(5,12)]
    [ValidateScript({
        if ("$_" -Like "* *") {
            throw "Environment name cannot contain whitespace"
            return $false
        }
        else {
            return $true
        }
    })]
    [string]$EnvironmentName,

    [Parameter(Mandatory = $false)]
    [string]$EnvironmentLocation = "westus",

    [Parameter(Mandatory = $false)]
    [string]$FhirApiLocation = "westus2",

    [Parameter(Mandatory = $false)]
    [string]$SourceRepository = "https://github.com/Microsoft/fhir-server-samples",

    [Parameter(Mandatory = $false)]
    [string]$SourceRevision = "master",

    [Parameter(Mandatory = $false)]
    [bool]$DeploySource = $true,

    [Parameter(Mandatory = $false)]
    [bool]$UsePaaS = $true,

    [Parameter(Mandatory = $false)]
    [ValidateSet('cosmos','sql')]
    [string]$PersistenceProvider = "cosmos",

    [Parameter(Mandatory = $false)]
    [ValidateSet('Stu3','R4')]
    [string]$FhirVersion = "R4",

    [Parameter(Mandatory = $false)]
    [SecureString]$SqlAdminPassword,

    [Parameter(Mandatory = $false)]
    [bool]$EnableExport = $false,

    [parameter(Mandatory = $false)]
    [SecureString]$AdminPassword

)

Set-StrictMode -Version Latest

# Some additional parameter validation
if (($PersistenceProvider -eq "sql") -and ([string]::IsNullOrEmpty($SqlAdminPassword)))
{
    throw 'For SQL persistence provider you must provide -SqlAdminPassword parameter'
}

if ($UsePaaS -and ($PersistenceProvider -ne "cosmos"))
{
    throw 'SQL Server is only supported in OSS. Set -UsePaaS $false when using SQL'
}


# Get current AzureAd context
try {
    $tenantInfo = Get-AzureADCurrentSessionInfo -ErrorAction Stop
} 
catch {
    throw "Please log in to Azure AD with Connect-AzureAD cmdlet before proceeding"
}

# Get current Az context
try {
    $azContext = Get-AzContext
} 
catch {
    throw "Please log in to Azure RM with Login-AzAccount cmdlet before proceeding"
}

if ($azContext.Account.Type -eq "User") {
    Write-Host "Current context is user: $($azContext.Account.Id)"
    $currentUser = Get-AzADUser -UserPrincipalName $azContext.Account.Id

    if (!$currentUser) {
        # For some reason $azContext.Account.Id will sometimes be the email of the user instead of the UPN, we need the UPN
        # Selecting the same subscription with the same tenant (twice), brings us back to the UPN
        Select-AzSubscription -SubscriptionId $azContext.Subscription.Id -TenantId $azContext.Tenant.Id | Out-Null
        Select-AzSubscription -SubscriptionId $azContext.Subscription.Id -TenantId $azContext.Tenant.Id | Out-Null
        $azContext = Get-AzContext
        Write-Host "Current context is user: $($azContext.Account.Id)"
        $currentUser = Get-AzADUser -UserPrincipalName $azContext.Account.Id    
    }

    #If this is guest account, we will try a search instead
    if (!$currentUser) {
        # External user accounts have UserPrincipalNames of the form:
        # myuser_outlook.com#EXT#@mytenant.onmicrosoft.com for a user with username myuser@outlook.com
        $tmpUserName = $azContext.Account.Id.Replace("@", "_")
        $currentUser = Get-AzureADUser -Filter "startswith(UserPrincipalName, '${tmpUserName}')"
        $currentObjectId = $currentUser.ObjectId
    } else {
        $currentObjectId = $currentUser.Id
    }

    if (!$currentObjectId) {
        throw "Failed to find objectId for signed in user"
    }
}
elseif ($azContext.Account.Type -eq "ServicePrincipal") {
    Write-Host "Current context is service principal: $($azContext.Account.Id)"
    $currentObjectId = (Get-AzADServicePrincipal -ServicePrincipalName $azContext.Account.Id).Id
}
else {
    Write-Host "Current context is account of type '$($azContext.Account.Type)' with id of '$($azContext.Account.Id)"
    throw "Running as an unsupported account type. Please use either a 'User' or 'Service Principal' to run this command"
}


# Set up Auth Configuration and Resource Group
./Create-FhirServerSamplesAuthConfig.ps1 -EnvironmentName $EnvironmentName -EnvironmentLocation $EnvironmentLocation -AdminPassword $AdminPassword -UsePaaS $UsePaaS

#Template URLs
$fhirServerTemplateUrl = "https://raw.githubusercontent.com/microsoft/fhir-server/master/samples/templates/default-azuredeploy.json"
if ($PersistenceProvider -eq 'sql')
{
    $fhirServerTemplateUrl = "https://raw.githubusercontent.com/microsoft/fhir-server/master/samples/templates/default-azuredeploy-sql.json"
}

$githubRawBaseUrl = $SourceRepository.Replace("github.com","raw.githubusercontent.com").TrimEnd('/')
$sandboxTemplate = "${githubRawBaseUrl}/${SourceRevision}/deploy/templates/azuredeploy-sandbox.json"
$dashboardJSTemplate = "${githubRawBaseUrl}/${SourceRevision}/deploy/templates/azuredeploy-fhirdashboard-js.json"
$importerTemplate = "${githubRawBaseUrl}/${SourceRevision}/deploy/templates/azuredeploy-importer.json"

$tenantDomain = $tenantInfo.TenantDomain
$aadAuthority = "https://login.microsoftonline.com/${tenantDomain}"

$dashboardJSUrl = "https://${EnvironmentName}dash.azurewebsites.net"

if ($UsePaaS) {
    $fhirServerUrl = "https://${EnvironmentName}.azurehealthcareapis.com"
} else {
    $fhirServerUrl = "https://${EnvironmentName}srvr.azurewebsites.net"
}

$confidentialClientId = (Get-AzKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-confidential-client-id").SecretValueText
$confidentialClientSecret = (Get-AzKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-confidential-client-secret").SecretValueText
$serviceClientId = (Get-AzKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-service-client-id").SecretValueText
$serviceClientSecret = (Get-AzKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-service-client-secret").SecretValueText
$serviceClientObjectId = (Get-AzureADServicePrincipal -Filter "AppId eq '$serviceClientId'").ObjectId
$dashboardUserUpn  = (Get-AzKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-admin-upn").SecretValueText
$dashboardUserOid = (Get-AzureADUser -Filter "UserPrincipalName eq '$dashboardUserUpn'").ObjectId
$dashboardUserPassword  = (Get-AzKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-admin-password").SecretValueText
$publicClientId = (Get-AzKeyVaultSecret -VaultName "${EnvironmentName}-ts" -Name "${EnvironmentName}-public-client-id").SecretValueText

$accessPolicies = @()
$accessPolicies += @{ "objectId" = $currentObjectId.ToString() }
$accessPolicies += @{ "objectId" = $serviceClientObjectId.ToString() }
$accessPolicies += @{ "objectId" = $dashboardUserOid.ToString() }

#We need to pass "something" as SQL server password even when it is not used:
if ([string]::IsNullOrEmpty($SqlAdminPassword))
{
    $SqlAdminPassword = ConvertTo-SecureString -AsPlainText -Force "DummySQLServerPasswordNotUsed"
}

$resourceGroup = Get-AzResourceGroup -Name $EnvironmentName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzResourceGroup -Name $EnvironmentName -Location $EnvironmentLocation | Out-Null
}

# Making a separate resource group for SMART on FHIR apps, since Linux Container apps cannot live in a resource group with windows apps
$sofResourceGroup = Get-AzResourceGroup -Name "${EnvironmentName}-sof" -ErrorAction SilentlyContinue
if (!$sofResourceGroup) {
    New-AzResourceGroup -Name "${EnvironmentName}-sof" -Location $EnvironmentLocation | Out-Null
}

# Deploy the template
New-AzResourceGroupDeployment -TemplateUri $sandboxTemplate -environmentName $EnvironmentName -fhirApiLocation $FhirApiLocation -ResourceGroupName $EnvironmentName -fhirServerTemplateUrl $fhirServerTemplateUrl -fhirVersion $FhirVersion -sqlAdminPassword $SqlAdminPassword -aadAuthority $aadAuthority -aadDashboardClientId $confidentialClientId -aadDashboardClientSecret $confidentialClientSecret -aadServiceClientId $serviceClientId -aadServiceClientSecret $serviceClientSecret -smartAppClientId $publicClientId -fhirDashboardJSTemplateUrl $dashboardJSTemplate -fhirImporterTemplateUrl $importerTemplate -fhirDashboardRepositoryUrl $SourceRepository -fhirDashboardRepositoryBranch $SourceRevision -deployDashboardSourceCode $DeploySource -usePaaS $UsePaaS -accessPolicies $accessPolicies -enableExport $EnableExport

Write-Host "Warming up site..."
Invoke-WebRequest -Uri "${fhirServerUrl}/metadata" | Out-Null
$functionAppUrl = "https://${EnvironmentName}imp.azurewebsites.net"
Invoke-WebRequest -Uri $functionAppUrl | Out-Null 

@{
    dashboardUrl              = $dashboardJSUrl
    fhirServerUrl             = $fhirServerUrl
    dashboardUserUpn          = $dashboardUserUpn
    dashboardUserPassword     = $dashboardUserPassword
}
