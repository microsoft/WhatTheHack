<#PSScriptInfo
.VERSION 1.0
.GUID 24e89cf1-5696-499e-9e3c-e44df3a9948f
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
        This configuration will create a new domain-local group in contoso with
        three members in different domains.
#>
Configuration ADGroup_NewGroupMultiDomainMembers_Config
{
    Import-DscResource -ModuleName ActiveDirectoryDsc

    node localhost
    {
        ADGroup 'dl1'
        {
            GroupName           = 'DL_APP_1'
            GroupScope          = 'DomainLocal'
            MembershipAttribute = 'DistinguishedName'
            Members             = @(
                'CN=john,OU=Accounts,DC=contoso,DC=com'
                'CN=jim,OU=Accounts,DC=subdomain,DC=contoso,DC=com'
                'CN=sally,OU=Accounts,DC=anothersub,DC=contoso,DC=com'
            )
        }
    }
}
