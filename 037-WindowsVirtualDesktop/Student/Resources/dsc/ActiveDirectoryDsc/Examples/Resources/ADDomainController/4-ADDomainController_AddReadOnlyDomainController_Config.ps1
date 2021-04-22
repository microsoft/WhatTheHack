<#PSScriptInfo
.VERSION 1.0.0
.GUID ba30df50-0873-4c2c-872b-96f5c825910d
.AUTHOR Microsoft Corporation
.COMPANYNAME Microsoft Corporation
.COPYRIGHT (c) Microsoft Corporation. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/PowerShell/ActiveDirectoryDsc/blob/master/LICENSE
.PROJECTURI https://github.com/PowerShell/ActiveDirectoryDsc
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES First version.
.PRIVATEDATA 2016-Datacenter,2016-Datacenter-Server-Core
#>

#Requires -module ActiveDirectoryDsc

<#
    .DESCRIPTION
    This configuration will add a read-only domain controller to the domain contoso.com
    and specify a list of account, whose passwords are allowed/denied for synchronisation.
#>
Configuration ADDomainController_AddReadOnlyDomainController_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $SafeModePassword
    )

    Import-DscResource -ModuleName PSDscResources
    Import-DscResource -ModuleName ActiveDirectoryDsc

    node localhost
    {
        WindowsFeature 'InstallADDomainServicesFeature'
        {
            Ensure = 'Present'
            Name   = 'AD-Domain-Services'
        }

        WindowsFeature 'RSATADPowerShell'
        {
            Ensure    = 'Present'
            Name      = 'RSAT-AD-PowerShell'

            DependsOn = '[WindowsFeature]InstallADDomainServicesFeature'
        }

        WaitForADDomain 'WaitForestAvailability'
        {
            DomainName = 'contoso.com'
            Credential = $Credential

            DependsOn  = '[WindowsFeature]RSATADPowerShell'
        }

        ADDomainController 'Read-OnlyDomainController(RODC)'
        {
            DomainName                          = 'contoso.com'
            Credential                          = $Credential
            SafeModeAdministratorPassword       = $SafeModePassword
            ReadOnlyReplica                     = $true
            SiteName                            = 'Default-First-Site-Name'
            AllowPasswordReplicationAccountName = @('pvdi.test1', 'pvdi.test')
            DenyPasswordReplicationAccountName  = @('SVC_PVS', 'TA2SCVMM')

            DependsOn                           = '[WaitForADDomain]WaitForestAvailability'
        }
    }
}
