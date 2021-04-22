<#PSScriptInfo
.VERSION 1.0.0
.GUID c5ba4d3d-72ec-4dfc-b1f9-ff1f4c45f845
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
.RELEASENOTES First version.
.PRIVATEDATA 2016-Datacenter,2016-Datacenter-Server-Core
#>

#Requires -module ActiveDirectoryDsc

<#
    .DESCRIPTION
        This configuration will create an Active Directory computer account
        on the specified domain controller and in the specific organizational
        unit. After the account is create an Offline Domain Join Request file
        is created to the specified path.
#>
Configuration ADComputer_AddComputerAccountAndCreateODJRequest_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName ActiveDirectoryDsc

    node localhost
    {
        ADComputer 'CreateComputerAccount'
        {
            DomainController = 'DC01'
            ComputerName     = 'NANO-200'
            Path             = 'OU=Servers,DC=contoso,DC=com'
            RequestFile      = 'D:\ODJFiles\NANO-200.txt'
            Credential       = $Credential
        }
    }
}
