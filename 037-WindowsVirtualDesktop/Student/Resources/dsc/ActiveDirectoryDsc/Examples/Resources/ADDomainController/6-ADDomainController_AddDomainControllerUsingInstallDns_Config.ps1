<#PSScriptInfo
.VERSION 1.0.0
.GUID d817a83d-6450-4dff-9b39-9b184572c100
.AUTHOR Microsoft Corporation
.COMPANYNAME Microsoft Corporation
.COPYRIGHT (c) Microsoft Corporation. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/PowerShell/xActiveDirectory/blob/master/LICENSE
.PROJECTURI https://github.com/PowerShell/xActiveDirectory
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
    This configuration will add a domain controller to the domain contoso.com
    without installing the local DNS server service and using the one in the existing domain.
#>
Configuration ADDomainController_AddDomainControllerUsingInstallDns_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
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
            DomainName       = 'contoso.com'
            Credential       = $Credential

            DependsOn        = '[WindowsFeature]RSATADPowerShell'
        }

        ADDomainController 'DomainControllerUsingExistingDNSServer'
        {
            DomainName                    = 'contoso.com'
            Credential                    = $Credential
            SafeModeAdministratorPassword = $Credential
            InstallDns                    = $false

            DependsOn                     = '[WaitForADDomain]WaitForestAvailability'
        }
    }
}
