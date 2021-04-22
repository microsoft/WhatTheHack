<#PSScriptInfo
.VERSION 1.0
.GUID db6e6810-76eb-464f-9514-92bc91ec28de
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
        This configuration will create an Active Directory replication site
        called 'Seattle'.
#>
Configuration ADReplicationSite_CreateADReplicationSite_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADReplicationSite 'SeattleSite'
        {
            Ensure = 'Present'
            Name   = 'Seattle'
        }
    }
}
