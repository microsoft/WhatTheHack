<#PSScriptInfo
.VERSION 1.0.0
.GUID 331c7f40-112d-468c-9bd0-8f1b073bee44
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
        This configuration will create a computer account disabled, configure
        a cluster using the disabled computer account, and enforcing the
        computer account to be enabled.
#>
Configuration ADComputer_CreateClusterComputerAccount_Config
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
        ADComputer 'ClusterAccount'
        {
            ComputerName      = 'CLU_CNO01'
            EnabledOnCreation = $false
        }

        xCluster 'CreateCluster'
        {
            Name                          = 'CLU_CNO01'
            StaticIPAddress               = '192.168.100.20/24'
            DomainAdministratorCredential = $Credential

            DependsOn                     = '[ADComputer]ClusterAccount'
        }

        ADObjectEnabledState 'EnforceEnabledPropertyToEnabled'
        {
            Identity    = 'CLU_CNO01'
            ObjectClass = 'Computer'
            Enabled     = $true

            DependsOn   = '[xCluster]CreateCluster'
        }
    }
}
