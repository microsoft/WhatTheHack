<#PSScriptInfo
.VERSION 1.0
.GUID 2caf2b93-d87e-426d-8c44-9f1d0452be10
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
        domains.
#>
Configuration ADDomainTrust_ExternalInboundTrust_Config
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
            Ensure           = 'Present'
            SourceDomainName = $SourceDomain
            TargetDomainName = $TargetDomain
            TargetCredential = $TargetDomainAdminCred
            TrustDirection   = 'Inbound'
            TrustType        = 'External'
        }
    }
}
