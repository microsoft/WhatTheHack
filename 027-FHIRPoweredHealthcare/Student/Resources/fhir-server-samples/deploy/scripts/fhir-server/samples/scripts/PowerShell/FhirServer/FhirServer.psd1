#
# Module manifest for module 'FhirServer'
#
@{
    RootModule = 'FhirServer.psm1'
    ModuleVersion = '0.0.1'
    GUID = '8d82e68c-0121-478c-9e81-62bced8d2a68'
    Author = 'Microsoft Healthcare NExT'
    CompanyName = 'https://microsoft.com'
    Description = 'PowerShell Module for managing Azure Active Directory registrations and users for Microsoft FHIR Server.'
    PowerShellVersion = '3.0'
    FunctionsToExport = 'Remove-FhirServerApplicationRegistration', 'New-FhirServerClientApplicationRegistration', 'New-FhirServerApiApplicationRegistration', 'Get-FhirServerAzureAdAccessToken', 'Set-FhirServerApiApplicationRoles','Set-FhirServerClientAppRoleAssignments','Set-FhirServerUserAppRoleAssignments','New-FhirServerSmartClientReplyUrl'
    CmdletsToExport = @()
    AliasesToExport = @()    
}
    