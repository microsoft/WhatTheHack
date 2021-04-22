<#PSScriptInfo
.VERSION 1.0
.GUID 0d6564cf-5492-4922-b4ef-4c20da0b7b3f
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
        This configuration will create a new domain-local group with three members.
#>
Configuration ADGroup_NewGroupWithMembers_Config
{
    Import-DscResource -ModuleName ActiveDirectoryDsc

    node localhost
    {
        ADGroup 'dl1'
        {
            GroupName  = 'DL_APP_1'
            GroupScope = 'DomainLocal'
            Members    = 'john', 'jim', 'sally'
        }
    }
}
