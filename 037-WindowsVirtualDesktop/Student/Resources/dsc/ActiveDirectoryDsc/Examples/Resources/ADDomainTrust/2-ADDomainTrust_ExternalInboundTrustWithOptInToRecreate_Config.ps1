<#PSScriptInfo
.VERSION 1.0
.GUID ab9a3c8a-b63a-4a54-94d7-807da3e799e4
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
        This configuration will create a new one way inbound trust between two
        domains, and allows the trust to recreated if it should have the wrong
        trust type.
#>
Configuration ADDomainTrust_ExternalInboundTrustWithOptInToRecreate_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SourceDomain,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TargetDomain,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $TargetDomainAdminCred
    )

    Import-DscResource -module ActiveDirectoryDsc

    node localhost
    {
        ADDomainTrust 'Trust'
        {
            Ensure               = 'Present'
            SourceDomainName     = $SourceDomain
            TargetDomainName     = $TargetDomain
            TargetCredential     = $TargetDomainAdminCred
            TrustDirection       = 'Inbound'
            TrustType            = 'External'
            AllowTrustRecreation = $true
        }
    }
}
