<#PSScriptInfo
.VERSION 1.0
.GUID ef167bdf-7f25-4d28-8ef3-68918eb2702c
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
        This will use the user credential passed in the built-in PsDscRunAsCredential
        parameter when determining if the domain is available.
#>
Configuration WaitForADDomain_WaitForDomainControllerUsingBuiltInCredential_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        WaitForADDomain 'contoso.com'
        {
            DomainName = 'contoso.com'

            PsDscRunAsCredential = $Credential
        }
    }
}
