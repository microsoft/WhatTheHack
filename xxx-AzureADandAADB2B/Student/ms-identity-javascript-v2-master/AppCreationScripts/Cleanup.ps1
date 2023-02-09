[CmdletBinding()]
param(    
    [Parameter(Mandatory = $True, HelpMessage = 'Tenant ID (This is a GUID which represents the "Directory ID" of the AzureAD tenant into which you want to create the apps')]
    [string] $tenantId
)

#Requires -Modules Microsoft.Graph.Applications

# Pre-requisites
if ($null -eq (Get-Module -ListAvailable -Name "Microsoft.Graph.Applications")) {
    Install-Module "Microsoft.Graph.Applications" -Scope CurrentUser 
}

Import-Module Microsoft.Graph.Applications

$ErrorActionPreference = "Stop"

Function Cleanup {
    <#.Description
        This function removes the Azure AD applications for the sample. These applications were created by the Configure.ps1 script
    #>
    
    # Connect to the Microsoft Graph API
    Write-Host "Connecting Microsoft Graph"
    Connect-MgGraph -TenantId $TenantId -Scopes "Application.ReadWrite.All"
        
    # Removes the applications
    Write-Host "Removing 'spa' (ms-identity-javascript-v2) if needed"
    Get-MgApplication -Filter "DisplayName eq 'ms-identity-javascript-v2'"  | ForEach-Object { Remove-MgApplication -ApplicationId $_.Id }
    $apps = Get-MgApplication -Filter "DisplayName eq 'ms-identity-javascript-v2'"

    if ($apps) {
        Remove-MgApplication -ApplicationId $apps.Id
    }

    foreach ($app in $apps) {
        Remove-MgApplication -ApplicationId $apps.Id
        Write-Host "Removed ms-identity-javascript-v2"
    }

    # also remove service principals of this app
    Get-MgServicePrincipal -filter "DisplayName eq 'ms-identity-javascript-v2'" | ForEach-Object { Remove-MgServicePrincipal -ApplicationId $_.Id -Confirm:$false }
    
}

Cleanup -tenantId $TenantId