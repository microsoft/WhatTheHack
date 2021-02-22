function New-FhirServerClientApplicationRegistration {
    <#
    .SYNOPSIS
    Create an AAD Application registration for a client application.
    .DESCRIPTION
    Create a new AAD Application registration for a client application that consumes an API.
    .EXAMPLE
    New-FhirServerClientApplicationRegistration -DisplayName "clientapplication" -ApiAppId 9125e524-1509-XXXX-XXXX-74137cc75422
    .PARAMETER ApiAppId
    API AAD Application registration Id
    .PARAMETER DisplayName
    Display name for the client AAD Application registration
    .PARAMETER ReplyUrl
    Reply URL for the client AAD Application registration
    .PARAMETER IdentifierUri
    Identifier URI for the client AAD Application registration
    .PARAMETER PublicClient
    Switch to indicate if the client application should be a public client (desktop/mobile applications)
    #>
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiAppId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DisplayName,

        [Parameter(Mandatory = $false)]
        [string]$ReplyUrl = "https://www.getpostman.com/oauth2/callback",

        [Parameter(Mandatory = $false)]
        [string]$IdentifierUri = "https://$DisplayName",

        [Parameter(Mandatory = $false)]
        [switch]$PublicClient
    )

    Set-StrictMode -Version Latest
    
    # Get current AzureAd context
    try {
        Get-AzureADCurrentSessionInfo -ErrorAction Stop | Out-Null
    } 
    catch {
        throw "Please log in to Azure AD with Connect-AzureAD cmdlet before proceeding"
    }

    $apiAppReg = Get-AzureADApplication -Filter "AppId eq '$ApiAppId'"

    # Some GUID values for Azure Active Directory
    # https://blogs.msdn.microsoft.com/aaddevsup/2018/06/06/guid-table-for-windows-azure-active-directory-permissions/
    # Windows AAD Resource ID:
    $windowsAadResourceId = "00000002-0000-0000-c000-000000000000"
    # 'Sign in and read user profile' permission (scope)
    $signInScope = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"

    # Required App permission for Azure AD sign-in
    $reqAad = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
    $reqAad.ResourceAppId = $windowsAadResourceId
    $reqAad.ResourceAccess = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" -ArgumentList $signInScope, "Scope"

    # Required App Permission for the API application registration. 
    $reqApi = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
    $reqApi.ResourceAppId = $apiAppReg.AppId #From API App registration above

    # Just add the first scope (user impersonation)
    $reqApi.ResourceAccess = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" -ArgumentList $apiAppReg.Oauth2Permissions[0].id, "Scope"

    if($PublicClient)
    {
        $clientAppReg = New-AzureADApplication -DisplayName $DisplayName -RequiredResourceAccess $reqAad, $reqApi -ReplyUrls $ReplyUrl -PublicClient $true
    }
    else
    {
        $clientAppReg = New-AzureADApplication -DisplayName $DisplayName -IdentifierUris $IdentifierUri -RequiredResourceAccess $reqAad, $reqApi -ReplyUrls $ReplyUrl
    }

    # Create a client secret
    $clientAppPassword = New-AzureADApplicationPasswordCredential -ObjectId $clientAppReg.ObjectId

    # Create Service Principal
    New-AzureAdServicePrincipal -AppId $clientAppReg.AppId | Out-Null

    $securityAuthenticationAudience = $apiAppReg.IdentifierUris[0]
    $aadEndpoint = (Get-AzureADCurrentSessionInfo).Environment.Endpoints["ActiveDirectory"]
    $aadTenantId = (Get-AzureADCurrentSessionInfo).Tenant.Id.ToString()
    $securityAuthenticationAuthority = "$aadEndpoint$aadTenantId"

    @{
        AppId     = $clientAppReg.AppId;
        AppSecret = $clientAppPassword.Value;
        ReplyUrl  = $clientAppReg.ReplyUrls[0]
        AuthUrl   = "$securityAuthenticationAuthority/oauth2/authorize?resource=$securityAuthenticationAudience"
        TokenUrl  = "$securityAuthenticationAuthority/oauth2/token"
    }
}
