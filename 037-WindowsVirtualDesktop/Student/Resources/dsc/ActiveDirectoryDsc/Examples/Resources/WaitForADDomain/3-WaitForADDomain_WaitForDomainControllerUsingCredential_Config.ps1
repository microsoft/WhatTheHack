<#PSScriptInfo
.VERSION 1.0
.GUID d0713e4e-274b-4510-949e-39bce2ef2158
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
        This will use the user credential passed in the parameter Credential
        when determining if the domain is available.
#>
Configuration WaitForADDomain_WaitForDomainControllerUsingCredential_Config
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
            Credential = $Credential
        }
    }
}
