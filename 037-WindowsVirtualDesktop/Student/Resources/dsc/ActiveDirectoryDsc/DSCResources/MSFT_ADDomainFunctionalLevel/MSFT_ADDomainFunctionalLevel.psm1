$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADDomainFunctionalLevel'

<#
    .SYNOPSIS
        Returns the current functional level of the domain.

    .PARAMETER DomainIdentity
        Specifies the Active Directory domain to modify. You can identify a
        domain by its distinguished name, GUID, security identifier, DNS domain
        name, or NetBIOS domain name.

    .PARAMETER DomainMode
        Specifies the functional level for the Active Directory domain.

        Not used in Get-TargetResource.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainIdentity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows2008R2Domain', 'Windows2012Domain', 'Windows2012R2Domain', 'Windows2016Domain')]
        [System.String]
        $DomainMode
    )

    Write-Verbose -Message (
        $script:localizedData.RetrievingDomainMode -f $DomainIdentity
    )

    $getTargetResourceReturnValue = @{
        DomainIdentity = $DomainIdentity
        DomainMode = $null
    }

    $domainObject = Get-ADDomain -Identity $DomainIdentity -ErrorAction 'Stop'

    $getTargetResourceReturnValue['DomainMode'] = $domainObject.DomainMode

    return $getTargetResourceReturnValue
}

<#
    .SYNOPSIS
        Determines if the functional level is in the desired state.

    .PARAMETER DomainIdentity
        Specifies the Active Directory domain to modify. You can identify a
        domain by its distinguished name, GUID, security identifier, DNS domain
        name, or NetBIOS domain name.

    .PARAMETER DomainMode
        Specifies the functional level for the Active Directory domain.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainIdentity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows2008R2Domain', 'Windows2012Domain', 'Windows2012R2Domain', 'Windows2016Domain')]
        [System.String]
        $DomainMode
    )

    Write-Verbose -Message (
        $script:localizedData.TestConfiguration -f $DomainIdentity
    )

    $compareTargetResourceStateResult = Compare-TargetResourceState @PSBoundParameters

    if ($false -in $compareTargetResourceStateResult.InDesiredState)
    {
        Write-Verbose -Message $script:localizedData.LevelNotInDesiredState

        $testTargetResourceReturnValue = $false
    }
    else
    {
        Write-Verbose -Message $script:localizedData.LevelInDesiredState

        $testTargetResourceReturnValue = $true
    }

    return $testTargetResourceReturnValue
}

<#
    .SYNOPSIS
        Sets the functional level on the Active Directory domain.

    .PARAMETER DomainIdentity
        Specifies the Active Directory domain to modify. You can identify a
        domain by its distinguished name, GUID, security identifier, DNS domain
        name, or NetBIOS domain name.

    .PARAMETER DomainMode
        Specifies the functional level for the Active Directory domain.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainIdentity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows2008R2Domain', 'Windows2012Domain', 'Windows2012R2Domain', 'Windows2016Domain')]
        [System.String]
        $DomainMode
    )

    $compareTargetResourceStateResult = Compare-TargetResourceState @PSBoundParameters

    # Get all properties that are not in desired state.
    $propertiesNotInDesiredState = $compareTargetResourceStateResult | Where-Object -FilterScript {
        -not $_.InDesiredState
    }

    $domainModeProperty = $propertiesNotInDesiredState.Where({ $_.ParameterName -eq 'DomainMode' })

    if ($domainModeProperty)
    {
        Write-Verbose -Message (
            $script:localizedData.DomainModeUpdating -f $domainModeProperty.Actual, $DomainMode
        )

        $setADDomainModeParameters = @{
            Identity = $DomainIdentity
            DomainMode = [Microsoft.ActiveDirectory.Management.ADDomainMode]::$DomainMode
            Confirm = $false
        }

        Set-ADDomainMode @setADDomainModeParameters
    }
}

<#
    .SYNOPSIS
        Compares the properties in the current state with the properties of the
        desired state and returns a hashtable with the comparison result.

    .PARAMETER DomainIdentity
        Specifies the Active Directory domain to modify. You can identify a
        domain by its distinguished name, GUID, security identifier, DNS domain
        name, or NetBIOS domain name.

    .PARAMETER DomainMode
       Specifies the functional level for the Active Directory domain.
#>
function Compare-TargetResourceState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainIdentity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows2008R2Domain', 'Windows2012Domain', 'Windows2012R2Domain', 'Windows2016Domain')]
        [System.String]
        $DomainMode
    )

    $getTargetResourceResult = Get-TargetResource @PSBoundParameters

    $compareTargetResourceStateParameters = @{
        CurrentValues = $getTargetResourceResult
        DesiredValues = $PSBoundParameters
        Properties    = @('DomainMode')
    }

    return Compare-ResourcePropertyState @compareTargetResourceStateParameters
}
