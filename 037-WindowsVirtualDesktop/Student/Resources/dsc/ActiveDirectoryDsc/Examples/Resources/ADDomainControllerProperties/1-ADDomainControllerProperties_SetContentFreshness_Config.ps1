<#PSScriptInfo
.VERSION 1.0.0
.GUID 924568d9-9764-4277-ab85-5a03b818bf6d
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
        This configuration will set the content freshness to 100 days.
#>
Configuration ADDomainControllerProperties_SetContentFreshness_Config
{
    Import-DscResource -ModuleName ActiveDirectoryDsc

    node localhost
    {
        ADDomainControllerProperties 'ContentFreshness'
        {
            IsSingleInstance = 'Yes'
            ContentFreshness = 100
        }
    }
}
