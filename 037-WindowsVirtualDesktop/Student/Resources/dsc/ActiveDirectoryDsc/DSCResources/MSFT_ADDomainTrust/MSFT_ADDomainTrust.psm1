$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADDomainTrust'

<#
    .SYNOPSIS
        Returns the current state of the Active Directory trust.

    .PARAMETER SourceDomainName
        Specifies the name of the Active Directory domain that is requesting the
        trust.

    .PARAMETER TargetDomainName
        Specifies the name of the Active Directory domain that is being trusted.

    .PARAMETER TargetCredential
        Specifies the credentials to authenticate to the target domain.

    .PARAMETER TrustType
        Specifies the type of trust. The value 'External' means the context Domain,
        while the value 'Forest' means the context 'Forest'.

    .PARAMETER TrustDirection
        Specifies the direction of the trust.

    .PARAMETER AllowTrustRecreation
        Specifies if the is allowed to be recreated if required. Default value is
        $false.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SourceDomainName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TargetDomainName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $TargetCredential,

        [Parameter(Mandatory = $true)]
        [ValidateSet('External', 'Forest')]
        [System.String]
        $TrustType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Bidirectional', 'Inbound', 'Outbound')]
        [System.String]
        $TrustDirection,

        [Parameter()]
        [System.Boolean]
        $AllowTrustRecreation = $false
    )

    # Return a credential object without the password.
    $cimCredentialInstance = New-CimCredentialInstance -Credential $TargetCredential

    $returnValue = @{
        SourceDomainName     = $SourceDomainName
        TargetDomainName     = $TargetDomainName
        TargetCredential     = $cimCredentialInstance
        AllowTrustRecreation = $AllowTrustRecreation
    }

    $getTrustTargetAndSourceObject = @{
        SourceDomainName = $SourceDomainName
        TargetDomainName = $TargetDomainName
        TargetCredential = $TargetCredential
        TrustType        = $TrustType
    }

    $trustSource, $trustTarget = Get-TrustSourceAndTargetObject @getTrustTargetAndSourceObject

    try
    {
        # Find trust between source & destination.
        Write-Verbose -Message (
            $script:localizedData.CheckingTrustMessage -f $SourceDomainName, $TargetDomainName, $directoryContextTyp
        )

        $trust = $trustSource.GetTrustRelationship($trustTarget)

        $returnValue['TrustDirection'] = $trust.TrustDirection
        $returnValue['TrustType'] = ConvertFrom-DirectoryContextType -DirectoryContextType $trust.TrustType

        Write-Verbose -Message ($script:localizedData.TrustPresentMessage -f $SourceDomainName, $TargetDomainName, $directoryContextType)

        $returnValue['Ensure'] = 'Present'
    }
    catch
    {
        Write-Verbose -Message ($script:localizedData.TrustAbsentMessage -f $SourceDomainName, $TargetDomainName, $directoryContextType)

        $returnValue['Ensure'] = 'Absent'
        $returnValue['TrustDirection'] = $null
        $returnValue['TrustType'] = $null
    }

    return $returnValue
}

<#
    .SYNOPSIS
        Creates, removes, or updates the Active Directory trust so it is in the
        desired state.

    .PARAMETER SourceDomainName
        Specifies the name of the Active Directory domain that is requesting the
        trust.

    .PARAMETER TargetDomainName
        Specifies the name of the Active Directory domain that is being trusted.

    .PARAMETER TargetCredential
        Specifies the credentials to authenticate to the target domain.

    .PARAMETER TrustType
        Specifies the type of trust. The value 'External' means the context Domain,
        while the value 'Forest' means the context 'Forest'.

    .PARAMETER TrustDirection
        Specifies the direction of the trust.

    .PARAMETER Ensure
        Specifies whether the computer account is present or absent. Default
        value is 'Present'.

    .PARAMETER AllowTrustRecreation
        Specifies if the is allowed to be recreated if required. Default value is
        $false.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SourceDomainName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TargetDomainName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $TargetCredential,

        [Parameter(Mandatory = $true)]
        [ValidateSet('External', 'Forest')]
        [System.String]
        $TrustType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Bidirectional', 'Inbound', 'Outbound')]
        [System.String]
        $TrustDirection,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Boolean]
        $AllowTrustRecreation = $false
    )

    $getTrustTargetAndSourceObject = @{
        SourceDomainName = $SourceDomainName
        TargetDomainName = $TargetDomainName
        TargetCredential = $TargetCredential
        TrustType        = $TrustType
    }

    $trustSource, $trustTarget = Get-TrustSourceAndTargetObject @getTrustTargetAndSourceObject

    # Only pass those properties that should be evaluated.
    $compareTargetResourceStateParameters = @{} + $PSBoundParameters
    $compareTargetResourceStateParameters.Remove('AllowTrustRecreation')

    $compareTargetResourceStateResult = Compare-TargetResourceState @compareTargetResourceStateParameters

    # Get all properties that are not in desired state.
    $propertiesNotInDesiredState = $compareTargetResourceStateResult |
    Where-Object -FilterScript {
        -not $_.InDesiredState
    }

    if ($propertiesNotInDesiredState.Where( { $_.ParameterName -eq 'Ensure' }))
    {
        if ($Ensure -eq 'Present')
        {
            # Create trust.
            $trustSource.CreateTrustRelationship($trustTarget, $TrustDirection)

            Write-Verbose -Message (
                $script:localizedData.AddedTrust -f @(
                    $SourceDomainName,
                    $TargetDomainName,
                    $TrustType,
                    $TrustDirection
                )
            )
        }
        else
        {
            # Remove trust.
            $trustSource.DeleteTrustRelationship($trustTarget)

            Write-Verbose -Message (
                $script:localizedData.RemovedTrust -f @(
                    $SourceDomainName,
                    $TargetDomainName,
                    $TrustType,
                    $TrustDirection
                )
            )
        }
    }
    else
    {
        if ($Ensure -eq 'Present')
        {
            $trustRecreated = $false

            # Check properties.
            $trustTypeProperty = $propertiesNotInDesiredState.Where( { $_.ParameterName -eq 'TrustType' })

            if ($trustTypeProperty)
            {
                Write-Verbose -Message (
                    $script:localizedData.NeedToRecreateTrust -f @(
                        $SourceDomainName,
                        $TargetDomainName,
                        (ConvertFrom-DirectoryContextType -DirectoryContextType $trustTypeProperty.Actual),
                        $TrustType
                    )
                )

                if ($AllowTrustRecreation)
                {
                    $trustSource.DeleteTrustRelationship($trustTarget)
                    $trustSource.CreateTrustRelationship($trustTarget, $TrustDirection)

                    Write-Verbose -Message (
                        $script:localizedData.RecreatedTrustType -f @(
                            $SourceDomainName,
                            $TargetDomainName,
                            $TrustType,
                            $TrustDirection
                        )
                    )

                    $trustRecreated = $true
                }
                else
                {
                    throw $script:localizedData.NotOptInToRecreateTrust
                }
            }

            <#
                In case the trust direction property should be wrong, there
                is no need to update that property twice since it was set
                to the correct value when the trust was recreated.
            #>
            if (-not $trustRecreated)
            {
                if ($propertiesNotInDesiredState.Where( { $_.ParameterName -eq 'TrustDirection' }))
                {
                    $trustSource.UpdateTrustRelationship($trustTarget, $TrustDirection)

                    Write-Verbose -Message (
                        $script:localizedData.SetTrustDirection -f $TrustDirection
                    )
                }
            }

            Write-Verbose -Message $script:localizedData.InDesiredState
        }
        else
        {
            # The trust is already absent, so in desired state.
            Write-Verbose -Message $script:localizedData.InDesiredState
        }
    }
}

<#
    .SYNOPSIS
        Determines if the properties of the Active Directory trust is in
        the desired state.

    .PARAMETER SourceDomainName
        Specifies the name of the Active Directory domain that is requesting the
        trust.

    .PARAMETER TargetDomainName
        Specifies the name of the Active Directory domain that is being trusted.

    .PARAMETER TargetCredential
        Specifies the credentials to authenticate to the target domain.

    .PARAMETER TrustType
        Specifies the type of trust. The value 'External' means the context Domain,
        while the value 'Forest' means the context 'Forest'.

    .PARAMETER TrustDirection
        Specifies the direction of the trust.

    .PARAMETER Ensure
        Specifies whether the computer account is present or absent. Default
        value is 'Present'.

    .PARAMETER AllowTrustRecreation
        Specifies if the is allowed to be recreated if required. Default value is
        $false.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SourceDomainName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TargetDomainName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $TargetCredential,

        [Parameter(Mandatory = $true)]
        [ValidateSet('External', 'Forest')]
        [System.String]
        $TrustType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Bidirectional', 'Inbound', 'Outbound')]
        [System.String]
        $TrustDirection,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Boolean]
        $AllowTrustRecreation = $false
    )

    Write-Verbose -Message (
        $script:localizedData.TestConfiguration -f $SourceDomainName, $TargetDomainName, $TrustType
    )

    # Only pass those properties that should be evaluated.
    $compareTargetResourceStateParameters = @{} + $PSBoundParameters
    $compareTargetResourceStateParameters.Remove('AllowTrustRecreation')

    <#
        This returns array of hashtables which contain the properties ParameterName,
        Expected, Actual, and InDesiredState.
    #>
    $compareTargetResourceStateResult = Compare-TargetResourceState @compareTargetResourceStateParameters

    if ($false -in $compareTargetResourceStateResult.InDesiredState)
    {
        $testTargetResourceReturnValue = $false

        Write-Verbose -Message $script:localizedData.NotInDesiredState
    }
    else
    {
        $testTargetResourceReturnValue = $true

        Write-Verbose -Message $script:localizedData.InDesiredState
    }

    return $testTargetResourceReturnValue
}

<#
    .SYNOPSIS
        Compares the properties in the current state with the properties of the
        desired state and returns a hashtable with the comparison result.

    .PARAMETER SourceDomainName
        Specifies the name of the Active Directory domain that is requesting the
        trust.

    .PARAMETER TargetDomainName
        Specifies the name of the Active Directory domain that is being trusted.

    .PARAMETER TargetCredential
        Specifies the credentials to authenticate to the target domain.

    .PARAMETER TrustType
        Specifies the type of trust. The value 'External' means the context Domain,
        while the value 'Forest' means the context 'Forest'.

    .PARAMETER TrustDirection
        Specifies the direction of the trust.

    .PARAMETER Ensure
        Specifies whether the computer account is present or absent. Default
        value is 'Present'.
#>
function Compare-TargetResourceState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SourceDomainName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TargetDomainName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $TargetCredential,

        [Parameter(Mandatory = $true)]
        [ValidateSet('External', 'Forest')]
        [System.String]
        $TrustType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Bidirectional', 'Inbound', 'Outbound')]
        [System.String]
        $TrustDirection,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present'
    )

    $getTargetResourceParameters = @{
        SourceDomainName = $SourceDomainName
        TargetDomainName = $TargetDomainName
        TargetCredential = $TargetCredential
        TrustType        = $TrustType
        TrustDirection   = $TrustDirection
    }

    $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

    <#
        If the desired state should be Absent, then there is no need to
        compare properties other than 'Ensure'. If the other properties
        would be compared, they would return a false negative during test.
    #>
    if ($Ensure -eq 'Present')
    {
        $propertiesToEvaluate = @(
            'Ensure'
            'TrustType'
            'TrustDirection'
        )
    }
    else
    {
        $propertiesToEvaluate = @(
            'Ensure'
        )
    }

    <#
        If the user did not specify Ensure property, then it is not part of
        the $PSBoundParameters, but it still needs to be compared.
        Copy the hashtable $PSBoundParameters and add 'Ensure' property to make
        sure it is part of the DesiredValues.
    #>
    $desiredValues = @{} + $PSBoundParameters
    $desiredValues['Ensure'] = $Ensure

    $compareResourcePropertyStateParameters = @{
        CurrentValues = $getTargetResourceResult
        DesiredValues = $desiredValues
        Properties    = $propertiesToEvaluate
    }

    return Compare-ResourcePropertyState @compareResourcePropertyStateParameters
}

<#
    .SYNOPSIS
        This returns a new object of the type System.DirectoryServices.ActiveDirectory.Domain
        which is a class that represents an Active Directory Domain Services domain.

    .PARAMETER DirectoryContext
        The Active Directory context from which the domain object is returned.
        Calling the Get-ADDirectoryContext gets a value that can be provided in
        this parameter.

    .NOTES
        This is a wrapper to enable unit testing of this resource.
        see issue https://github.com/PowerShell/ActiveDirectoryDsc/issues/324
        for more information.
#>
function Get-ActiveDirectoryDomain
{
    [CmdletBinding()]
    [OutputType([System.DirectoryServices.ActiveDirectory.Domain])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.DirectoryServices.ActiveDirectory.DirectoryContext]
        $DirectoryContext
    )

    return [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain($DirectoryContext)
}

<#
    .SYNOPSIS
        This returns a new object of the type System.DirectoryServices.ActiveDirectory.Forest
        which is a class that represents an Active Directory Domain Services forest.

    .PARAMETER DirectoryContext
        The Active Directory context from which the forest object is returned.
        Calling the Get-ADDirectoryContext gets a value that can be provided in
        this parameter.

    .NOTES
        This is a wrapper to enable unit testing of this resource.
        see issue https://github.com/PowerShell/ActiveDirectoryDsc/issues/324
        for more information.
#>
function Get-ActiveDirectoryForest
{
    [CmdletBinding()]
    [OutputType([System.DirectoryServices.ActiveDirectory.Forest])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.DirectoryServices.ActiveDirectory.DirectoryContext]
        $DirectoryContext
    )

    return [System.DirectoryServices.ActiveDirectory.Forest]::GetForest($DirectoryContext)
}

<#
    .SYNOPSIS
        This returns the converted value from a Trust Type value to the correct
        Directory Context Type value.

    .PARAMETER TrustType
        The trust type value to convert.
#>
function ConvertTo-DirectoryContextType
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $TrustType
    )

    switch ($TrustType)
    {
        'External'
        {
            $directoryContextType = 'Domain'
        }

        'Forest'
        {
            $directoryContextType = 'Forest'
        }
    }

    return $directoryContextType
}

<#
    .SYNOPSIS
        This returns the converted value from a Directory Context Type value to
        the correct Trust Type value.

    .PARAMETER DirectoryContextType
        The Directory Context Type value to convert.
#>
function ConvertFrom-DirectoryContextType
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DirectoryContextType
    )

    switch ($DirectoryContextType)
    {
        'Domain'
        {
            $trustType = 'External'
        }

        'Forest'
        {
            $trustType = 'Forest'
        }
    }

    return $trustType
}

<#
    .SYNOPSIS
        Returns two objects where the first object is for the source domain and
        the second object is for the target domain.

    .PARAMETER SourceDomainName
        Specifies the name of the Active Directory domain that is requesting the
        trust.

    .PARAMETER TargetDomainName
        Specifies the name of the Active Directory domain that is being trusted.

    .PARAMETER TargetCredential
        Specifies the credentials to authenticate to the target domain.

    .PARAMETER TrustType
        Specifies the type of trust. The value 'External' means the context Domain,
        while the value 'Forest' means the context 'Forest'.

    .OUTPUTS
        For both objects the type returned is either of the type
        System.DirectoryServices.ActiveDirectory.Domain or of the type
        System.DirectoryServices.ActiveDirectory.Forest.
#>
function Get-TrustSourceAndTargetObject
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SourceDomainName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TargetDomainName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $TargetCredential,

        [Parameter(Mandatory = $true)]
        [ValidateSet('External', 'Forest')]
        [System.String]
        $TrustType
    )

    $directoryContextType = ConvertTo-DirectoryContextType -TrustType $TrustType

    # Create the target object.
    $getADDirectoryContextParameters = @{
        DirectoryContextType = $directoryContextType
        Name                 = $TargetDomainName
        Credential           = $TargetCredential
    }

    $targetDirectoryContext = Get-ADDirectoryContext @getADDirectoryContextParameters

    # Create the source object.
    $getADDirectoryContextParameters = @{
        DirectoryContextType = $directoryContextType
        Name                 = $SourceDomainName
    }

    $sourceDirectoryContext = Get-ADDirectoryContext @getADDirectoryContextParameters

    if ($directoryContextType -eq 'Domain')
    {
        $trustSource = Get-ActiveDirectoryDomain -DirectoryContext $sourceDirectoryContext
        $trustTarget = Get-ActiveDirectoryDomain -DirectoryContext $targetDirectoryContext
    }
    else
    {
        $trustSource = Get-ActiveDirectoryForest -DirectoryContext $sourceDirectoryContext
        $trustTarget = Get-ActiveDirectoryForest -DirectoryContext $targetDirectoryContext
    }

    return $trustSource, $trustTarget
}

Export-ModuleMember -Function *-TargetResource
