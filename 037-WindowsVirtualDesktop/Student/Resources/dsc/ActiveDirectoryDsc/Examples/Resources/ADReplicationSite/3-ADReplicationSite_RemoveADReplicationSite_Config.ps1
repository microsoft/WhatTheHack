<#PSScriptInfo
.VERSION 1.0
.GUID 8fced2a6-bb34-400c-a44e-2c484e3bc9e3
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
.RELEASENOTES
.PRIVATEDATA
#>

#Requires -module ActiveDirectoryDsc

<#
    .DESCRIPTION
        This configuration will remove the Active Directory replication site
        called 'Cupertino'.
#>
Configuration ADReplicationSite_RemoveADReplicationSite_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADReplicationSite 'CupertinoSite'
        {
            Ensure = 'Absent'
            Name   = 'Cupertino'
        }
    }
}
