<#PSScriptInfo
.VERSION 1.0
.GUID 634194bb-189a-4b26-bd80-7c01270026ea
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
        This configuration will add a Service Principal Name to a computer account.
#>
Configuration ADServicePrincipalName_AddComputerServicePrincipalName_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADServicePrincipalName 'web.contoso.com'
        {
            ServicePrincipalName = 'HTTP/web.contoso.com'
            Account              = 'IIS01$'
        }
    }
}
