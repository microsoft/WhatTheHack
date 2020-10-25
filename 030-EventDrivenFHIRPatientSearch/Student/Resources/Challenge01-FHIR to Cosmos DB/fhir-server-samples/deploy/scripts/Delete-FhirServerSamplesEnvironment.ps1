<#
.SYNOPSIS
Removes a FHIR Server Samples environment
.DESCRIPTION
#>
param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$EnvironmentName
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

# Set up Auth Configuration and Resource Group
./Delete-FhirServerSamplesAuthConfig.ps1 -EnvironmentName $EnvironmentName 

# Wipe out the environment
Get-AzureRmResourceGroup -Name $EnvironmentName | Remove-AzureRmResourceGroup -Verbose -Force
