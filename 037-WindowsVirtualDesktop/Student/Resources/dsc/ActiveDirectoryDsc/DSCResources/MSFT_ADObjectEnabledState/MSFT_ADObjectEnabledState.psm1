$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADObjectEnabledState'

<#
    .SYNOPSIS
        Returns the current state of the property Enabled of an Active Directory
        object.

    .PARAMETER Identity
        Specifies the identity of an object that has the object class specified
        in the parameter ObjectClass. When ObjectClass is set to 'Computer' then
        this property can be set to either distinguished name, GUID (objectGUID),
        security identifier (objectSid), or security Accounts Manager account
        name (sAMAccountName).

    .PARAMETER ObjectClass
        Specifies the object class.

    .PARAMETER Enabled
        Specifies the value of the Enabled property.

        Not used in Get-TargetResource.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Services instance to connect to perform the task.

        Used by Get-ADCommonParameters and is returned as a common parameter.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform the task.

        Used by Get-ADCommonParameters and is returned as a common parameter.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Computer')]
        [System.String]
        $ObjectClass,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DomainController,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )

    Assert-Module -ModuleName 'ActiveDirectory' -ImportModule

    <#
        These are properties that have no corresponding property in a
        Computer account object.
    #>
    $getTargetResourceReturnValue = @{
        Identity         = $Identity
        ObjectClass      = $ObjectClass
        Enabled          = $false
        DomainController = $DomainController
        Credential       = $Credential
    }

    switch ($ObjectClass)
    {
        'Computer'
        {
            $getADComputerResult = $null

            try
            {
                Write-Verbose -Message ($script:localizedData.RetrievingComputerAccount -f $Identity)

                $getADComputerParameters = Get-ADCommonParameters @PSBoundParameters
                $getADComputerParameters['Properties'] = 'Enabled'

                # If the computer account is not found Get-ADComputer will throw an error.
                $getADComputerResult = Get-ADComputer @getADComputerParameters

                $getTargetResourceReturnValue['Enabled'] = $getADComputerResult.Enabled

                if ($getADComputerResult.Enabled)
                {
                    Write-Verbose -Message $script:localizedData.ComputerAccountEnabled
                }
                else
                {
                    Write-Verbose -Message $script:localizedData.ComputerAccountDisabled
                }
            }
            catch
            {
                $errorMessage = $script:localizedData.FailedToRetrieveComputerAccount -f $Identity
                New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
            }
        }
    }

    return $getTargetResourceReturnValue
}

<#
    .SYNOPSIS
        Determines if the property Enabled of the Active Directory object is in
        the desired state.

    .PARAMETER Identity
        Specifies the identity of an object that has the object class specified
        in the parameter ObjectClass. When ObjectClass is set to 'Computer' then
        this property can be set to either distinguished name, GUID (objectGUID),
        security identifier (objectSid), or security Accounts Manager account
        name (sAMAccountName).

    .PARAMETER ObjectClass
        Specifies the object class.

    .PARAMETER Enabled
        Specifies the value of the Enabled property.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Services instance to connect to
        perform the task.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform the task.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Computer')]
        [System.String]
        $ObjectClass,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DomainController,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )

    Write-Verbose -Message (
        $script:localizedData.TestConfiguration -f $Identity, $ObjectClass
    )

    $compareTargetResourceStateResult = Compare-TargetResourceState @PSBoundParameters

    if ($false -in $compareTargetResourceStateResult.InDesiredState)
    {
        $testTargetResourceReturnValue = $false
    }
    else
    {
        $testTargetResourceReturnValue = $true
    }

    switch ($ObjectClass)
    {
        'Computer'
        {
            if ($testTargetResourceReturnValue)
            {
                Write-Verbose -Message ($script:localizedData.ComputerAccountInDesiredState -f $Identity)
            }
            else
            {
                Write-Verbose -Message ($script:localizedData.ComputerAccountNotInDesiredState -f $Identity)
            }
        }
    }

    return $testTargetResourceReturnValue
}

<#
    .SYNOPSIS
        Sets the property Enabled of the Active Directory object.

    .PARAMETER Identity
        Specifies the identity of an object that has the object class specified
        in the parameter ObjectClass. When ObjectClass is set to 'Computer' then
        this property can be set to either distinguished name, GUID (objectGUID),
        security identifier (objectSid), or security Accounts Manager account
        name (sAMAccountName).

    .PARAMETER ObjectClass
        Specifies the object class.

    .PARAMETER Enabled
        Specifies the value of the Enabled property.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Services instance to connect to
        perform the task.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform the task.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Computer')]
        [System.String]
        $ObjectClass,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DomainController,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )

    $compareTargetResourceStateResult = Compare-TargetResourceState @PSBoundParameters

    # Get all properties that are not in desired state.
    $propertiesNotInDesiredState = $compareTargetResourceStateResult | Where-Object -FilterScript {
        -not $_.InDesiredState
    }

    if ($propertiesNotInDesiredState.Where( { $_.ParameterName -eq 'Enabled' }))
    {
        $commonParameters = Get-ADCommonParameters @PSBoundParameters

        switch ($ObjectClass)
        {
            'Computer'
            {
                $setADComputerParameters = $commonParameters.Clone()
                $setADComputerParameters['Enabled'] = $Enabled

                Set-DscADComputer -Parameters $setADComputerParameters

                if ($Enabled)
                {
                    Write-Verbose -Message (
                        $script:localizedData.ComputerAccountHasBeenEnabled -f $Identity
                    )
                }
                else
                {
                    Write-Verbose -Message (
                        $script:localizedData.ComputerAccountHasBeenDisabled -f $Identity
                    )
                }
            }
        }
    }
}

<#
    .SYNOPSIS
        Compares the properties in the current state with the properties of the
        desired state and returns a hashtable with the comaprison result.

    .PARAMETER Identity
        Specifies the identity of an object that has the object class specified
        in the parameter ObjectClass. When ObjectClass is set to 'Computer' then
        this property can be set to either distinguished name, GUID (objectGUID),
        security identifier (objectSid), or security Accounts Manager account
        name (sAMAccountName).

    .PARAMETER ObjectClass
        Specifies the object class.

    .PARAMETER Enabled
        Specifies the value of the Enabled property.

    .PARAMETER DomainController
        Specifies the Active Directory Domain Services instance to connect to
        perform the task.

    .PARAMETER Credential
        Specifies the user account credentials to use to perform the task.
#>
function Compare-TargetResourceState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Computer')]
        [System.String]
        $ObjectClass,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [ValidateNotNull()]
        [System.String]
        $DomainController,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )

    $getTargetResourceParameters = @{
        Identity         = $Identity
        ObjectClass      = $ObjectClass
        Enabled          = $Enabled
        DomainController = $DomainController
        Credential       = $Credential
    }

    # Need the @() around this to get a new array to enumerate.
    @($getTargetResourceParameters.Keys) | ForEach-Object {
        if (-not $PSBoundParameters.ContainsKey($_))
        {
            $getTargetResourceParameters.Remove($_)
        }
    }

    $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

    $compareTargetResourceStateParameters = @{
        CurrentValues = $getTargetResourceResult
        DesiredValues = $PSBoundParameters
        Properties    = @('Enabled')
    }

    return Compare-ResourcePropertyState @compareTargetResourceStateParameters
}
