function Remove-FhirServerApplicationRegistration {
    <#
    .SYNOPSIS
    Remove (delete) an AAD Application registration
    .DESCRIPTION
    Deletes an AAD Application registration with a specific AppId
    .EXAMPLE
    Remove-FhirServerApplicationRegistration -AppId 9125e524-1509-XXXX-XXXX-74137cc75422
    #>
    [CmdletBinding(DefaultParameterSetName='ByIdentifierUri')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'ByAppId' )]
        [ValidateNotNullOrEmpty()]
        [string]$AppId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByIdentifierUri' )]
        [ValidateNotNullOrEmpty()]
        [string]$IdentifierUri
    )

    Set-StrictMode -Version Latest
    
    # Get current AzureAd context
    try {
        $session = Get-AzureADCurrentSessionInfo -ErrorAction Stop
    } 
    catch {
        throw "Please log in to Azure AD with Connect-AzureAD cmdlet before proceeding"
    }

    $appReg = $null

    if ($AppId) {
        $appReg = Get-AzureADApplication -Filter "AppId eq '$AppId'"
        if (!$appReg) {
            Write-Host "Application with AppId = $AppId was not found."
            return
        }
    }
    else {
        $appReg = Get-AzureADApplication -Filter "identifierUris/any(uri:uri eq '$IdentifierUri')"
        if (!$appReg) {
            Write-Host "Application with IdentifierUri = $IdentifierUri was not found."
            return
        }
    }

    Remove-AzureADApplication -ObjectId $appReg.ObjectId
}
