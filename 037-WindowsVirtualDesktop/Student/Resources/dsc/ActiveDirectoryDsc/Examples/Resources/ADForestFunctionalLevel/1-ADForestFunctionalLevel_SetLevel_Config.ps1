<#PSScriptInfo
.VERSION 1.0.0
.GUID 09a75817-166a-4c9e-8d94-46b64526e01b
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
        This configuration will change the forest functional level to
        a Windows Server 2012 R2 Forest.
#>
Configuration ADForestFunctionalLevel_SetLevel_Config
{
    Import-DscResource -ModuleName ActiveDirectoryDsc

    node localhost
    {
        ADForestFunctionalLevel 'ChangeForestFunctionalLevel'
        {
            ForestIdentity          = 'contoso.com'
            ForestMode              = 'Windows2012R2Forest'
        }
    }
}
