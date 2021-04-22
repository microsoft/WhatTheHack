<#PSScriptInfo
.VERSION 1.0
.GUID f24bbdb8-4f0d-47a4-9281-d40092322cd5
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
        This configuration will create a new domain-local group
#>
Configuration ADGroup_NewGroup_Config
{
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $GroupName,

        [ValidateSet('DomainLocal', 'Global', 'Universal')]
        [System.String]
        $Scope = 'Global',

        [ValidateSet('Security', 'Distribution')]
        [System.String]
        $Category = 'Security',

        [ValidateNotNullOrEmpty()]
        [System.String]
        $Description
    )

    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADGroup 'ExampleGroup'
        {
            GroupName   = $GroupName
            GroupScope  = $Scope
            Category    = $Category
            Description = $Description
            Ensure      = 'Present'
        }
    }
}
