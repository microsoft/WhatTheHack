$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

# Import ResourceSetHelper for New-ResourceSetConfigurationScriptBlock
$script:dscResourcesFolderFilePath = Split-Path -Path $PSScriptRoot -Parent
$script:resourceSetHelperFilePath = Join-Path -Path $script:dscResourcesFolderFilePath -ChildPath 'ResourceSetHelper.psm1'
Import-Module -Name $script:resourceSetHelperFilePath

<#
    .SYNOPSIS
        A composite DSC resource to configure a set of similar Group resources.

    .DESCRIPTION
    Provides a mechanism to manage local groups on the target node. Use this resource when you want to add and/or remove the same list of members to more than one group, remove more than one group, or add more than one group with the same list of members.


    .PARAMETER GroupName
        An array of the names of the groups to configure.

    .PARAMETER Ensure
        Specifies whether or not the set of groups should exist.

        Set this property to Present to create or modify a set of groups.
        Set this property to Absent to remove a set of groups.

    .PARAMETER MembersToInclude
        The members that should be included in each group in the set.

    .PARAMETER MembersToExclude
        The members that should be excluded from each group in the set.

    .PARAMETER Credential
        The credential to resolve all groups and user accounts.
#>
Configuration GroupSet
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $GroupName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

        [Parameter()]
        [System.String[]]
        $MembersToInclude,

        [Parameter()]
        [System.String[]]
        $MembersToExclude,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    $newResourceSetConfigurationParams = @{
        ResourceName = 'Group'
        ModuleName = 'PSDscResources'
        KeyParameterName = 'GroupName'
        Parameters = $PSBoundParameters
    }

    $configurationScriptBlock = New-ResourceSetConfigurationScriptBlock @newResourceSetConfigurationParams

    # This script block must be run directly in this configuration in order to resolve variables
    . $configurationScriptBlock
}
