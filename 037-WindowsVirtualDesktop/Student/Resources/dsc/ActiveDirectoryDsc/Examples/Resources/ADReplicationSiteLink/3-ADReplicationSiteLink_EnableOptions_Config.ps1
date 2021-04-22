<#PSScriptInfo
.VERSION 1.0
.GUID c44c6907-d900-4cd8-b48a-2d39013a8bb9
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
        This configuration will modify an existing AD Replication Site Link by enabling Replication Options.
#>
Configuration ADReplicationSiteLink_EnableOptions_Config
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
            OptionChangeNotification      = $true
            OptionTwoWaySync              = $true
            OptionDisableCompression      = $true
            Ensure                        = 'Present'
        }
    }
}
