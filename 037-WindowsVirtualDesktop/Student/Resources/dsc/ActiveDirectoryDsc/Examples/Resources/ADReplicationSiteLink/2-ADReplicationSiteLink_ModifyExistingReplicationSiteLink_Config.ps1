<#PSScriptInfo
.VERSION 1.0
.GUID cd618e81-b903-4ae9-9dd0-ab794931505c
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
        This configuration will modify an existing AD Replication Site Link.
#>
Configuration ADReplicationSiteLink_ModifyExistingReplicationSiteLink_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADReplicationSiteLink 'HQSiteLink'
        {
            Name                          = 'HQSiteLInk'
            SitesIncluded                 = 'site1'
            SitesExcluded                 = 'site2'
            Cost                          = 100
            ReplicationFrequencyInMinutes = 20
            Ensure                        = 'Present'
        }
    }
}
