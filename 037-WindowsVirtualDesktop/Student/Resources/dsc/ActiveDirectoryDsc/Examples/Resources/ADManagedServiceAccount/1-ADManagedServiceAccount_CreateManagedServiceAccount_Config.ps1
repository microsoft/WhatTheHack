<#PSScriptInfo
.VERSION 1.0
.GUID 4ab7581b-8729-4262-ae01-b04d1af51ab2
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
        This configuration will create a managed service account.
#>
Configuration ADManagedServiceAccount_CreateManagedServiceAccount_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADManagedServiceAccount 'ExampleSingleMSA'
        {
            Ensure             = 'Present'
            ServiceAccountName = 'Service01'
        }
    }
}
