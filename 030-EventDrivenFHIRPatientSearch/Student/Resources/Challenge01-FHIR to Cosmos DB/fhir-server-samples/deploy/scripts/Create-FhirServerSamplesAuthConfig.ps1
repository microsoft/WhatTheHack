<#
.SYNOPSIS
Adds the required application registrations and user profiles to an AAD tenant
.DESCRIPTION
#>
param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$EnvironmentName,

    [Parameter(Mandatory = $false)]
    [string]$EnvironmentLocation = "West US",

    [Parameter(Mandatory = $false )]
    [String]$WebAppSuffix = "azurewebsites.net",

    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName = $EnvironmentName,

    [parameter(Mandatory = $false)]
    [string]$KeyVaultName = "$EnvironmentName-ts",

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

# Ensure that we have the FhirServer PS Module loaded
if (Get-Module -Name FhirServer) {
    Write-Host "FhirServer PS module is loaded"
} else {
    Write-Host "Cloning FHIR Server repo to get access to FhirServer PS module."
    if (!(Test-Path -Path ".\fhir-server")) {
        git clone --quiet https://github.com/Microsoft/fhir-server | Out-Null
    }
    Import-Module .\fhir-server\samples\scripts\PowerShell\FhirServer\FhirServer.psd1
}

$keyVault = Get-AzureRmKeyVault -VaultName $KeyVaultName

if (!$keyVault) {
    Write-Host "Creating keyvault with the name $KeyVaultName"
    $resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
    if (!$resourceGroup) {
        New-AzureRmResourceGroup -Name $ResourceGroupName -Location $EnvironmentLocation | Out-Null
    }
    New-AzureRmKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName -Location $EnvironmentLocation | Out-Null
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

if ($currentObjectId) {
    Write-Host "Adding permission to keyvault for $currentObjectId"
    Set-AzureRmKeyVaultAccessPolicy -VaultName $KeyVaultName -ObjectId $currentObjectId -PermissionsToSecrets Get, Set, List
}

Write-Host "Ensuring API application exists"

$fhirServiceName = "${EnvironmentName}srvr"
if ($UsePaas) {
    $fhirServiceUrl = "https://${EnvironmentName}.azurehealthcareapis.com"
} else {
    $fhirServiceUrl = "https://${fhirServiceName}.${WebAppSuffix}"    
}

$application = Get-AzureAdApplication -Filter "identifierUris/any(uri:uri eq '$fhirServiceUrl')"

if (!$application) {
    $newApplication = New-FhirServerApiApplicationRegistration -FhirServiceAudience $fhirServiceUrl -AppRoles "admin"
    
    # Change to use applicationId returned
    $application = Get-AzureAdApplication -Filter "identifierUris/any(uri:uri eq '$fhirServiceUrl')"
}

$UserNamePrefix = "${EnvironmentName}-"
$userId = "${UserNamePrefix}admin"
$domain = $tenantInfo.TenantDomain
$userUpn = "${userId}@${domain}"

# See if the user exists
$aadUser = Get-AzureADUser -searchstring $userId


if ($AdminPassword)
{
    $passwordSecureString = $AdminPassword
    $password = (New-Object PSCredential "user",$passwordSecureString).GetNetworkCredential().Password
}
else
{
    Add-Type -AssemblyName System.Web
    $password = [System.Web.Security.Membership]::GeneratePassword(16, 5)
    $passwordSecureString = ConvertTo-SecureString $password -AsPlainText -Force
}

if ($aadUser) {
    Set-AzureADUserPassword -ObjectId $aadUser.ObjectId -Password $passwordSecureString -EnforceChangePasswordPolicy $false -ForceChangePasswordNextLogin $false
}
else {
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $password
    $PasswordProfile.EnforceChangePasswordPolicy = $false
    $PasswordProfile.ForceChangePasswordNextLogin = $false

    $aadUser = New-AzureADUser -DisplayName $userId -PasswordProfile $PasswordProfile -UserPrincipalName $userUpn -AccountEnabled $true -MailNickName $userId
}

$upnSecureString = ConvertTo-SecureString $userUpn -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "$userId-upn" -SecretValue $upnSecureString | Out-Null   
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "$userId-password" -SecretValue $passwordSecureString | Out-Null   
Set-FhirServerUserAppRoleAssignments -ApiAppId $application.AppId -UserPrincipalName $userUpn -AppRoles "admin"

$dashboardName = "${EnvironmentName}dash"
$dashboardUrl = "https://${dashboardName}.${WebAppSuffix}"
$dashboardReplyUrl = "${dashboardUrl}/signin-oidc"
$growthChartName = "${EnvironmentName}growth"
$growthChartUrl = "https://${growthChartName}.${WebAppSuffix}"
$medicationsName = "${EnvironmentName}meds"
$medicationsUrl = "https://${medicationsName}.${WebAppSuffix}"

$confidentialClientAppName = "${EnvironmentName}-confidential-client"
$confidentialClient = Get-AzureAdApplication -Filter "DisplayName eq '$confidentialClientAppName'"
if (!$confidentialClient) {
    if ($UsePaaS) {
        Write-Host "Creating client for PaaS"
        $confidentialClient = .\Create-AzureApiForFhirClientRegistration.ps1 -DisplayName $confidentialClientAppName -ReplyUrl $dashboardReplyUrl
    } else {
        $confidentialClient = New-FhirServerClientApplicationRegistration -ApiAppId $application.AppId -DisplayName $confidentialClientAppName -ReplyUrl $dashboardReplyUrl
    }
    $secretSecureString = ConvertTo-SecureString $confidentialClient.AppSecret -AsPlainText -Force
} else {
    $existingPassword = Get-AzureADApplicationPasswordCredential -ObjectId $confidentialClient.ObjectId | Remove-AzureADApplicationPasswordCredential -ObjectId $confidentialClient.ObjectId
    $newPassword = New-AzureADApplicationPasswordCredential -ObjectId $confidentialClient.ObjectId
    $secretSecureString = ConvertTo-SecureString $newPassword.Value -AsPlainText -Force
}
$secretConfidentialClientId = ConvertTo-SecureString $confidentialClient.AppId -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "$confidentialClientAppName-id" -SecretValue $secretConfidentialClientId| Out-Null
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "$confidentialClientAppName-secret" -SecretValue $secretSecureString | Out-Null

# Create service client
$serviceClientAppName = "${EnvironmentName}-service-client"
$serviceClient = Get-AzureAdApplication -Filter "DisplayName eq '$serviceClientAppName'"
if (!$serviceClient) {
    if ($UsePaaS) {
        $serviceClient = .\Create-AzureApiForFhirClientRegistration.ps1 -DisplayName $serviceClientAppName
    } else {
        $serviceClient = New-FhirServerClientApplicationRegistration -ApiAppId $application.AppId -DisplayName $serviceClientAppName
    }
    $secretSecureString = ConvertTo-SecureString $serviceClient.AppSecret -AsPlainText -Force
} else {
    $existingPassword = Get-AzureADApplicationPasswordCredential -ObjectId $serviceClient.ObjectId | Remove-AzureADApplicationPasswordCredential -ObjectId $serviceClient.ObjectId
    $newPassword = New-AzureADApplicationPasswordCredential -ObjectId $serviceClient.ObjectId
    $secretSecureString = ConvertTo-SecureString $newPassword.Value -AsPlainText -Force
}

Set-FhirServerClientAppRoleAssignments -AppId $serviceClient.AppId -ApiAppId $application.AppId -AppRoles admin

$secretServiceClientId = ConvertTo-SecureString $serviceClient.AppId -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "$serviceClientAppName-id" -SecretValue $secretServiceClientId| Out-Null
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "$serviceClientAppName-secret" -SecretValue $secretSecureString | Out-Null


# Create public (SMART on FHIR) client
$publicClientAppName = "${EnvironmentName}-public-client"
$publicClient = Get-AzureAdApplication -Filter "DisplayName eq '$publicClientAppName'"
if (!$publicClient) {
    $publicClient = New-FhirServerClientApplicationRegistration -ApiAppId $application.AppId -DisplayName $publicClientAppName -PublicClient:$true
    $secretPublicClientId = ConvertTo-SecureString $publicClient.AppId -AsPlainText -Force
    Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name "$publicClientAppName-id" -SecretValue $secretPublicClientId| Out-Null
} 

Set-FhirServerClientAppRoleAssignments -AppId $publicClient.AppId -ApiAppId $application.AppId -AppRoles admin
New-FhirServerSmartClientReplyUrl -AppId $publicClient.AppId -FhirServerUrl $fhirServiceUrl -ReplyUrl $growthChartUrl
New-FhirServerSmartClientReplyUrl -AppId $publicClient.AppId -FhirServerUrl $fhirServiceUrl -ReplyUrl "${growthChartUrl}/"
New-FhirServerSmartClientReplyUrl -AppId $publicClient.AppId -FhirServerUrl $fhirServiceUrl -ReplyUrl "${growthChartUrl}/index.html"
New-FhirServerSmartClientReplyUrl -AppId $publicClient.AppId -FhirServerUrl $fhirServiceUrl -ReplyUrl $medicationsUrl
New-FhirServerSmartClientReplyUrl -AppId $publicClient.AppId -FhirServerUrl $fhirServiceUrl -ReplyUrl "${medicationsUrl}/"
New-FhirServerSmartClientReplyUrl -AppId $publicClient.AppId -FhirServerUrl $fhirServiceUrl -ReplyUrl "${medicationsUrl}/index.html"

