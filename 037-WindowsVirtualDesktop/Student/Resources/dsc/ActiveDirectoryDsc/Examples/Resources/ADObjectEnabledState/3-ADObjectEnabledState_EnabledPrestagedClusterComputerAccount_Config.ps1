<#PSScriptInfo
.VERSION 1.0.0
.GUID 1da557bb-07a1-4461-8f64-df0d62b30305
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
#Requires -module xFailoverCluster

<#
    .DESCRIPTION
        This configuration will configure a cluster using a pre-staged computer
        account, and enforcing the pre-staged computer account to be enabled.
#>
Configuration ADObjectEnabledState_EnabledPrestagedClusterComputerAccount_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName ActiveDirectoryDsc
    Import-DscResource -ModuleName xFailoverCluster

    node localhost
    {
        xCluster 'CreateCluster'
        {
            Name                          = 'CLU_CNO01'
            StaticIPAddress               = '192.168.100.20/24'
            DomainAdministratorCredential = $Credential
        }

        ADObjectEnabledState 'EnforceEnabledPropertyToEnabled'
        {
            Identity    = 'CLU_CNO01'
            ObjectClass = 'Computer'
            Enabled     = $true

            DependsOn   = @(
                '[xCluster]CreateCluster'
            )
        }
    }
}
