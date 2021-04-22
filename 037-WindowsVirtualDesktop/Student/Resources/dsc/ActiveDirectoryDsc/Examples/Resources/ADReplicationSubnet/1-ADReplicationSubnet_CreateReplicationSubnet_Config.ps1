<#PSScriptInfo
.VERSION 1.0
.GUID 3d2af0ab-3470-4da7-a38b-1c05ef384e05
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
        This configuration will create an AD Replication Subnet.
#>
Configuration ADReplicationSubnet_CreateReplicationSubnet_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADReplicationSubnet 'LondonSubnet'
        {
            Name        = '10.0.0.0/24'
            Site        = 'London'
            Location    = 'Datacenter 3'
            Description = 'Datacenter Management Subnet'
        }
    }
}
