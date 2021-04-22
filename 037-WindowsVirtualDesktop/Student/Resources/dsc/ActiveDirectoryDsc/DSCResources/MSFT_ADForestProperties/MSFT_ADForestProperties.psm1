$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADForestProperties'

<#
    .SYNOPSIS
        Gets the current state of user principal name and service principal name suffixes in the forest.

    .PARAMETER Credential
        The user account credentials to use to perform this task.

    .PARAMETER ForestName
        The target Active Directory forest for the change.

    .PARAMETER ServicePrincipalNameSuffix
        The Service Principal Name Suffix(es) to be explicitly defined in the forest and replace existing
        members. Cannot be used with ServicePrincipalNameSuffixToAdd or ServicePrincipalNameSuffixToRemove.

    .PARAMETER ServicePrincipalNameSuffixToAdd
        The Service Principal Name Suffix(es) to add in the forest. Cannot be used with ServicePrincipalNameSuffix.

    .PARAMETER ServicePrincipalNameSuffixToRemove
        The Service Principal Name Suffix(es) to remove in the forest. Cannot be used with ServicePrincipalNameSuffix.

    .PARAMETER UserPrincipalNameSuffix
        The User Principal Name Suffix(es) to be explicitly defined in the forest and replace existing
        members. Cannot be used with UserPrincipalNameSuffixToAdd or UserPrincipalNameSuffixToRemove.

    .PARAMETER UserPrincipalNameSuffixToAdd
        The User Principal Name Suffix(es) to add in the forest. Cannot be used with UserPrincipalNameSuffix.

    .PARAMETER UserPrincipalNameSuffixToRemove
        The User Principal Name Suffix(es) to remove in the forest. Cannot be used with UserPrincipalNameSuffix.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNameSuffix,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNameSuffixToAdd,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNameSuffixToRemove,

        [Parameter()]
        [System.String[]]
        $UserPrincipalNameSuffix,

        [Parameter()]
        [System.String[]]
        $UserPrincipalNameSuffixToAdd,

        [Parameter()]
        [System.String[]]
        $UserPrincipalNameSuffixToRemove
    )

    Assert-Module -ModuleName 'ActiveDirectory'
    Import-Module -Name 'ActiveDirectory' -Verbose:$false

    $getADForestParameters = @{
        Identity = $ForestName
    }

    if ($Credential)
    {
        $getADForestParameters['Credential'] = $Credential
    }

    Write-Verbose -Message ($script:localizedData.GetForest -f $ForestName)
    $forest = Get-ADForest -Identity $ForestName

    return @{
        Credential                         = ''
        ForestName                         = $forest.Name
        ServicePrincipalNameSuffix         = [System.Array] $forest.SpnSuffixes
        ServicePrincipalNameSuffixToAdd    = [System.Array] $ServicePrincipalNameSuffixToAdd
        ServicePrincipalNameSuffixToRemove = [System.Array] $ServicePrincipalNameSuffixToRemove
        UserPrincipalNameSuffix            = [System.Array] $forest.UpnSuffixes
        UserPrincipalNameSuffixToAdd       = [System.Array] $UserPrincipalNameSuffixToAdd
        UserPrincipalNameSuffixToRemove    = [System.Array] $UserPrincipalNameSuffixToRemove
    }
}

<#
    .SYNOPSIS
        Tests the current state of user principal name and service principal name suffixes in the forest.

    .PARAMETER Credential
        The user account credentials to use to perform this task.

    .PARAMETER ForestName
        The target Active Directory forest for the change.

    .PARAMETER ServicePrincipalNameSuffix
        The Service Principal Name Suffix(es) to be explicitly defined in the forest and replace existing
        members. Cannot be used with ServicePrincipalNameSuffixToAdd or ServicePrincipalNameSuffixToRemove.

    .PARAMETER ServicePrincipalNameSuffixToAdd
        The Service Principal Name Suffix(es) to add in the forest. Cannot be used with ServicePrincipalNameSuffix.

    .PARAMETER ServicePrincipalNameSuffixToRemove
        The Service Principal Name Suffix(es) to remove in the forest. Cannot be used with ServicePrincipalNameSuffix.

    .PARAMETER UserPrincipalNameSuffix
        The User Principal Name Suffix(es) to be explicitly defined in the forest and replace existing
        members. Cannot be used with UserPrincipalNameSuffixToAdd or UserPrincipalNameSuffixToRemove.

    .PARAMETER UserPrincipalNameSuffixToAdd
        The User Principal Name Suffix(es) to add in the forest. Cannot be used with UserPrincipalNameSuffix.

    .PARAMETER UserPrincipalNameSuffixToRemove
        The User Principal Name Suffix(es) to remove in the forest. Cannot be used with UserPrincipalNameSuffix.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNameSuffix,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNameSuffixToAdd,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNameSuffixToRemove,

        [Parameter()]
        [System.String[]]
        $UserPrincipalNameSuffix,

        [Parameter()]
        [System.String[]]
        $UserPrincipalNameSuffixToAdd,

        [Parameter()]
        [System.String[]]
        $UserPrincipalNameSuffixToRemove
    )

    Assert-Module -ModuleName 'ActiveDirectory'
    Import-Module -Name 'ActiveDirectory' -Verbose:$false

    $inDesiredState = $true

    $forest = Get-ADForest -Identity $ForestName

    # Validate parameters before we even attempt to retrieve anything
    $assertMemberParameters = @{}

    if ($PSBoundParameters.ContainsKey('ServicePrincipalNameSuffix') -and -not [system.string]::IsNullOrEmpty($ServicePrincipalNameSuffix))
    {
        $assertMemberParameters['Members'] = $ServicePrincipalNameSuffix
    }

    if ($PSBoundParameters.ContainsKey('ServicePrincipalNameSuffixToAdd') -and -not [system.string]::IsNullOrEmpty($ServicePrincipalNameSuffixToAdd))
    {
        $assertMemberParameters['MembersToInclude'] = $ServicePrincipalNameSuffixToAdd
    }

    if ($PSBoundParameters.ContainsKey('ServicePrincipalNameSuffixToRemove') -and -not [system.string]::IsNullOrEmpty($ServicePrincipalNameSuffixToRemove))
    {
        $assertMemberParameters['MembersToExclude'] = $ServicePrincipalNameSuffixToRemove
    }

    Assert-MemberParameters @assertMemberParameters -ErrorAction Stop

    if (-not ( Test-Members @assertMemberParameters -ExistingMembers ($forest.SpnSuffixes -split ',') ))
    {
        Write-Verbose -Message $script:localizedData.ForestSpnSuffixNotInDesiredState
        $inDesiredState = $false
    }

    $assertMemberParameters = @{}

    if ($PSBoundParameters.ContainsKey('UserPrincipalNameSuffix') -and -not [system.string]::IsNullOrEmpty($UserPrincipalNameSuffix))
    {
        $assertMemberParameters['Members'] = $UserPrincipalNameSuffix
    }

    if ($PSBoundParameters.ContainsKey('UserPrincipalNameSuffixToAdd') -and -not [system.string]::IsNullOrEmpty($UserPrincipalNameSuffixToAdd))
    {
        $assertMemberParameters['MembersToInclude'] = $UserPrincipalNameSuffixToAdd
    }

    if ($PSBoundParameters.ContainsKey('UserPrincipalNameSuffixToRemove') -and -not [system.string]::IsNullOrEmpty($UserPrincipalNameSuffixToRemove))
    {
        $assertMemberParameters['MembersToExclude'] = $UserPrincipalNameSuffixToRemove
    }

    Assert-MemberParameters @assertMemberParameters -ErrorAction Stop

    if (-not ( Test-Members @assertMemberParameters -ExistingMembers ($forest.UpnSuffixes -split ',') ))
    {
        Write-Verbose -Message $script:localizedData.ForestUpnSuffixNotInDesiredState
        $inDesiredState = $false
    }

    return $inDesiredState
}

<#
    .SYNOPSIS
        Sets the user principal name and service principal name suffixes in the forest.

    .PARAMETER Credential
        The user account credentials to use to perform this task.

    .PARAMETER ForestName
        The target Active Directory forest for the change.

    .PARAMETER ServicePrincipalNameSuffix
        The Service Principal Name Suffix(es) to be explicitly defined in the forest and replace existing
        members. Cannot be used with ServicePrincipalNameSuffixToAdd or ServicePrincipalNameSuffixToRemove.

    .PARAMETER ServicePrincipalNameSuffixToAdd
        The Service Principal Name Suffix(es) to add in the forest. Cannot be used with ServicePrincipalNameSuffix.

    .PARAMETER ServicePrincipalNameSuffixToRemove
        The Service Principal Name Suffix(es) to remove in the forest. Cannot be used with ServicePrincipalNameSuffix.

    .PARAMETER UserPrincipalNameSuffix
        The User Principal Name Suffix(es) to be explicitly defined in the forest and replace existing
        members. Cannot be used with UserPrincipalNameSuffixToAdd or UserPrincipalNameSuffixToRemove.

    .PARAMETER UserPrincipalNameSuffixToAdd
        The User Principal Name Suffix(es) to add in the forest. Cannot be used with UserPrincipalNameSuffix.

    .PARAMETER UserPrincipalNameSuffixToRemove
        The User Principal Name Suffix(es) to remove in the forest. Cannot be used with UserPrincipalNameSuffix.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNameSuffix,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNameSuffixToAdd,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNameSuffixToRemove,

        [Parameter()]
        [System.String[]]
        $UserPrincipalNameSuffix,

        [Parameter()]
        [System.String[]]
        $UserPrincipalNameSuffixToAdd,

        [Parameter()]
        [System.String[]]
        $UserPrincipalNameSuffixToRemove
    )

    Assert-Module -ModuleName 'ActiveDirectory'
    Import-Module -Name 'ActiveDirectory' -Verbose:$false

    $setADForestParameters = @{
        Identity = $ForestName
    }

    if ($Credential)
    {
        $setADForestParameters['Credential'] = $Credential
    }

    # add ServicePrincipalName parameter
    if ($PSBoundParameters.ContainsKey('ServicePrincipalNameSuffix') -and -not [system.string]::IsNullOrEmpty($ServicePrincipalNameSuffix))
    {
        $replaceServicePrincipalNameSuffix = $ServicePrincipalNameSuffix -join ','
        $setADForestParameters['SpnSuffixes'] = @{
            replace = $($ServicePrincipalNameSuffix)
        }

        Write-Verbose -Message ($script:localizedData.ReplaceSpnSuffix -f $replaceServicePrincipalNameSuffix)
    }

    if ($PSBoundParameters.ContainsKey('ServicePrincipalNameSuffixToAdd') -and -not [system.string]::IsNullOrEmpty($ServicePrincipalNameSuffixToAdd))
    {
        $addServicePrincipalNameSuffix = $ServicePrincipalNameSuffixToAdd -join ','
        $setADForestParameters['SpnSuffixes'] = @{
            add = $($ServicePrincipalNameSuffixToAdd)
        }

        Write-Verbose -Message ($script:localizedData.AddSpnSuffix -f $addServicePrincipalNameSuffix)
    }

    if ($PSBoundParameters.ContainsKey('ServicePrincipalNameSuffixToRemove') -and -not [system.string]::IsNullOrEmpty($ServicePrincipalNameSuffixToRemove))
    {
        $removeServicePrincipalNameSuffix = $ServicePrincipalNameSuffixToRemove -join ','

        if ($setADForestParameters['SpnSuffixes'])
        {
            $setADForestParameters['SpnSuffixes']['remove'] = $($ServicePrincipalNameSuffixToRemove)
        }
        else
        {
            $setADForestParameters['SpnSuffixes'] = @{
                remove = $($ServicePrincipalNameSuffixToRemove)
            }
        }

        Write-Verbose -Message ($script:localizedData.RemoveSpnSuffix -f $removeServicePrincipalNameSuffix)
    }

    # add UserPrincipalName parameter
    if ($PSBoundParameters.ContainsKey('UserPrincipalNameSuffix') -and -not [system.string]::IsNullOrEmpty($UserPrincipalNameSuffix))
    {
        $replaceUserPrincipalNameSuffix = $UserPrincipalNameSuffix -join ','

        $setADForestParameters['UpnSuffixes'] = @{
            replace = $($UserPrincipalNameSuffix)
        }

        Write-Verbose -Message ($script:localizedData.ReplaceUpnSuffix -f $replaceUserPrincipalNameSuffix)
    }

    if ($PSBoundParameters.ContainsKey('UserPrincipalNameSuffixToAdd') -and -not [system.string]::IsNullOrEmpty($UserPrincipalNameSuffixToAdd))
    {
        $addUserPrincipalNameSuffix = $UserPrincipalNameSuffixToAdd -join ','

        $setADForestParameters['UpnSuffixes'] = @{
            add = $($UserPrincipalNameSuffixToAdd)
        }

        Write-Verbose -Message ($script:localizedData.AddUpnSuffix -f $addUserPrincipalNameSuffix)
    }

    if ($PSBoundParameters.ContainsKey('UserPrincipalNameSuffixToRemove') -and -not [system.string]::IsNullOrEmpty($UserPrincipalNameSuffixToRemove))
    {
        $removeUserPrincipalNameSuffix = $UserPrincipalNameSuffixToRemove -join ','

        if ($setADForestParameters['UpnSuffixes'])
        {
            $setADForestParameters['UpnSuffixes']['remove'] = $($UserPrincipalNameSuffixToRemove)
        }
        else
        {
            $setADForestParameters['UpnSuffixes'] = @{
                remove = $($UserPrincipalNameSuffixToRemove)
            }
        }

        Write-Verbose -Message ($script:localizedData.RemoveUpnSuffix -f $removeUserPrincipalNameSuffix)
    }

    Set-ADForest @setADForestParameters
}
