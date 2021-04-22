<#PSScriptInfo
.VERSION 1.0
.GUID 5f105122-a318-46f4-a7e9-7dc745c57878
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
        This configuration will wait for an Active Directory domain controller
        to respond within 300 seconds (default) in the domain 'contoso.com'
        before returning and allowing the configuration to continue to run.
        If the timeout is reached an error will be thrown.
        This will use the current user when determining if the domain is available,
        if run though LCM this will use SYSTEM (which might not have access).
#>
Configuration WaitForADDomain_WaitForDomainController_Config
{
    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        WaitForADDomain 'contoso.com'
        {
            DomainName = 'contoso.com'
        }
    }
}
