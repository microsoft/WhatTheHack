<#PSScriptInfo
.VERSION 1.0.0
.GUID 1629d7ce-e8a8-4cba-ae0f-efe795470dd8
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
        This configuration will change the domain functional level to
        a Windows Server 2012 R2 Domain.
#>
Configuration ADDomainFunctionalLevel_SetLevel_Config
{
    Import-DscResource -ModuleName ActiveDirectoryDsc

    node localhost
    {
        ADDomainFunctionalLevel 'ChangeDomainFunctionalLevel'
        {
            DomainIdentity          = 'contoso.com'
            DomainMode              = 'Windows2012R2Domain'
        }
    }
}
