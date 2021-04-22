<#PSScriptInfo
.VERSION 1.0
.GUID 63447da7-3fe9-4d03-b680-2129a2e0318f
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
        This configuration will enable the Active Directory Recycle Bin for a
        specified Domain
#>
Configuration ADOptionalFeature_EnableADRecycleBin_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ForestFQDN,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $EnterpriseAdministratorCredential
    )

    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADOptionalFeature RecycleBin
        {
            FeatureName                       = "Recycle Bin Feature"
            EnterpriseAdministratorCredential = $EnterpriseAdministratorCredential
            ForestFQDN                        = $ForestFQDN
        }
    }
}
