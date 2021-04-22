<#PSScriptInfo
.VERSION 1.0
.GUID 0c29d71c-5787-49e6-97e9-c74583028f63
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
        This configuration will add a Service Principal Name to a user account.
#>
Configuration ADServicePrincipalName_AddUserServicePrincipalName_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        ADServicePrincipalName 'SQL01Svc'
        {
            ServicePrincipalName = 'MSSQLSvc/sql01.contoso.com:1433'
            Account              = 'SQL01Svc'
        }
    }
}
