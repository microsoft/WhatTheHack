<#PSScriptInfo
.VERSION 1.0
.GUID c3e0fb1e-d583-45ed-b95d-e7df1afa88b7
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
        This configuration will create a KDS root key in the past. This will allow
        the key to be used right away, but if all the domain controllers haven't
        replicated yet, there may be issues when retrieving the gMSA password.
        Use with caution
#>
Configuration ADKDSKey_CreateKDSRootKeyInPast_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADKDSKey 'ExampleKDSRootKeyInPast'
        {
            Ensure                   = 'Present'
            EffectiveTime            = '1/1/1999 13:00'
            AllowUnsafeEffectiveTime = $true # Use with caution
        }
    }
}
