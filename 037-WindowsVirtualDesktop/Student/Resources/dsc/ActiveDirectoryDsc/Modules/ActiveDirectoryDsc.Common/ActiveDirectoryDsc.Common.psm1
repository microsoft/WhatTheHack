<#
    .SYNOPSIS
        Retrieves the localized string data based on the machine's culture.
        Falls back to en-US strings if the machine's culture is not supported.

    .PARAMETER ResourceName
        The name of the resource as it appears before '.strings.psd1' of the localized string file.
        For example:
            For WindowsOptionalFeature: MSFT_WindowsOptionalFeature
            For Service: MSFT_ServiceResource
            For Registry: MSFT_RegistryResource
            For Helper: SqlServerDscHelper

    .PARAMETER ScriptRoot
        Optional. The root path where to expect to find the culture folder. This is only needed
        for localization in helper modules. This should not normally be used for resources.

    .NOTES
        To be able to use localization in the helper function, this function must
        be first in the file, before Get-LocalizedData is used by itself to load
        localized data for this helper module (see directly after this function).
#>
function Get-LocalizedData
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ResourceName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ScriptRoot
    )

    if (-not $ScriptRoot)
    {
        $dscResourcesFolder = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'DSCResources'
        $resourceDirectory = Join-Path -Path $dscResourcesFolder -ChildPath $ResourceName
    }
    else
    {
        $resourceDirectory = $ScriptRoot
    }

    $localizedStringFileLocation = Join-Path -Path $resourceDirectory -ChildPath $PSUICulture

    if (-not (Test-Path -Path $localizedStringFileLocation))
    {
        # Fallback to en-US
        $localizedStringFileLocation = Join-Path -Path $resourceDirectory -ChildPath 'en-US'
    }

    Import-LocalizedData `
        -BindingVariable 'localizedData' `
        -FileName "$ResourceName.strings.psd1" `
        -BaseDirectory $localizedStringFileLocation

    return $localizedData
}

<#
    .SYNOPSIS
        Creates and throws an invalid argument exception.

    .PARAMETER Message
        The message explaining why this error is being thrown.

    .PARAMETER ArgumentName
        The name of the invalid argument that is causing this error to be thrown.
#>
function New-InvalidArgumentException
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Message,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ArgumentName
    )

    $argumentException = New-Object -TypeName 'ArgumentException' `
        -ArgumentList @($Message, $ArgumentName)

    $newObjectParameters = @{
        TypeName     = 'System.Management.Automation.ErrorRecord'
        ArgumentList = @($argumentException, $ArgumentName, 'InvalidArgument', $null)
    }

    $errorRecord = New-Object @newObjectParameters

    throw $errorRecord
}

<#
    .SYNOPSIS
        Creates and throws an invalid operation exception.

    .PARAMETER Message
        The message explaining why this error is being thrown.

    .PARAMETER ErrorRecord
        The error record containing the exception that is causing this terminating error.
#>
function New-InvalidOperationException
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Message,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord
    )

    if ($null -eq $ErrorRecord)
    {
        $invalidOperationException = New-Object -TypeName 'InvalidOperationException' `
            -ArgumentList @($Message)
    }
    else
    {
        $invalidOperationException = New-Object -TypeName 'InvalidOperationException' `
            -ArgumentList @($Message, $ErrorRecord.Exception)
    }

    $newObjectParameters = @{
        TypeName     = 'System.Management.Automation.ErrorRecord'
        ArgumentList = @(
            $invalidOperationException.ToString(),
            'MachineStateIncorrect',
            'InvalidOperation',
            $null
        )
    }

    $errorRecordToThrow = New-Object @newObjectParameters

    throw $errorRecordToThrow
}

<#
    .SYNOPSIS
        Creates and throws an object not found exception.

    .PARAMETER Message
        The message explaining why this error is being thrown.

    .PARAMETER ErrorRecord
        The error record containing the exception that is causing this terminating error.
#>
function New-ObjectNotFoundException
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Message,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord
    )

    if ($null -eq $ErrorRecord)
    {
        $exception = New-Object -TypeName 'System.Exception' `
            -ArgumentList @($Message)
    }
    else
    {
        $exception = New-Object -TypeName 'System.Exception' `
            -ArgumentList @($Message, $ErrorRecord.Exception)
    }

    $newObjectParameters = @{
        TypeName     = 'System.Management.Automation.ErrorRecord'
        ArgumentList = @(
            $exception.ToString(),
            'MachineStateIncorrect',
            'ObjectNotFound',
            $null
        )
    }

    $errorRecordToThrow = New-Object @newObjectParameters

    throw $errorRecordToThrow
}

<#
    .SYNOPSIS
        Creates and throws an invalid result exception.

    .PARAMETER Message
        The message explaining why this error is being thrown.

    .PARAMETER ErrorRecord
        The error record containing the exception that is causing this terminating error.
#>
function New-InvalidResultException
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Message,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord
    )

    if ($null -eq $ErrorRecord)
    {
        $exception = New-Object -TypeName 'System.Exception' `
            -ArgumentList @($Message)
    }
    else
    {
        $exception = New-Object -TypeName 'System.Exception' `
            -ArgumentList @($Message, $ErrorRecord.Exception)
    }

    $newObjectParameters = @{
        TypeName     = 'System.Management.Automation.ErrorRecord'
        ArgumentList = @(
            $exception.ToString(),
            'MachineStateIncorrect',
            'InvalidResult',
            $null
        )
    }

    $errorRecordToThrow = New-Object @newObjectParameters

    throw $errorRecordToThrow
}

<#
    .SYNOPSIS
        Tests the status of DSC resource parameters.

    .DESCRIPTION
        This function tests the parameter status of DSC resource parameters against the current values present on the system.

    .PARAMETER CurrentValues
        A hashtable with the current values on the system, obtained by e.g. Get-TargetResource.

    .PARAMETER DesiredValues
        The hashtable of desired values.

    .PARAMETER ValuesToCheck
        The values to check if not all values should be checked.
#>
function Test-DscParameterState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $CurrentValues,

        [Parameter(Mandatory = $true)]
        [System.Object]
        $DesiredValues,

        [Parameter()]
        [System.Array]
        $ValuesToCheck
    )
    $returnValue = $true

    if (($DesiredValues.GetType().Name -ne 'HashTable') `
            -and ($DesiredValues.GetType().Name -ne 'CimInstance') `
            -and ($DesiredValues.GetType().Name -ne 'PSBoundParametersDictionary'))
    {
        $errorMessage = $script:localizedData.PropertyTypeInvalidForDesiredValues -f $($DesiredValues.GetType().Name)
        New-InvalidArgumentException -ArgumentName 'DesiredValues' -Message $errorMessage
    }

    if (($DesiredValues.GetType().Name -eq 'CimInstance') -and ($null -eq $ValuesToCheck))
    {
        $errorMessage = $script:localizedData.PropertyTypeInvalidForValuesToCheck
        New-InvalidArgumentException -ArgumentName 'ValuesToCheck' -Message $errorMessage
    }

    if (($null -eq $ValuesToCheck) -or ($ValuesToCheck.Count -lt 1))
    {
        $keyList = $DesiredValues.Keys
    }
    else
    {
        $keyList = $ValuesToCheck
    }

    $keyList |
        ForEach-Object -Process {
            if (($_ -ne 'Verbose'))
            {
                if (($CurrentValues.ContainsKey($_) -eq $false) `
                        -or ($CurrentValues.$_ -ne $DesiredValues.$_) `
                        -or (($DesiredValues.GetType().Name -ne 'CimInstance' -and $DesiredValues.ContainsKey($_) -eq $true) -and ($null -ne $DesiredValues.$_ -and $DesiredValues.$_.GetType().IsArray)))
                {
                    if ($DesiredValues.GetType().Name -eq 'HashTable' -or `
                            $DesiredValues.GetType().Name -eq 'PSBoundParametersDictionary')
                    {
                        $checkDesiredValue = $DesiredValues.ContainsKey($_)
                    }
                    else
                    {
                        # If DesiredValue is a CimInstance.
                        $checkDesiredValue = $false
                        if (([System.Boolean]($DesiredValues.PSObject.Properties.Name -contains $_)) -eq $true)
                        {
                            if ($null -ne $DesiredValues.$_)
                            {
                                $checkDesiredValue = $true
                            }
                        }
                    }

                    if ($checkDesiredValue)
                    {
                        $desiredType = $DesiredValues.$_.GetType()
                        $fieldName = $_
                        if ($desiredType.IsArray -eq $true)
                        {
                            if (($CurrentValues.ContainsKey($fieldName) -eq $false) `
                                    -or ($null -eq $CurrentValues.$fieldName))
                            {
                                Write-Verbose -Message ($script:localizedData.PropertyValidationError -f $fieldName) -Verbose

                                $returnValue = $false
                            }
                            else
                            {
                                $arrayCompare = Compare-Object -ReferenceObject $CurrentValues.$fieldName `
                                    -DifferenceObject $DesiredValues.$fieldName
                                if ($null -ne $arrayCompare)
                                {
                                    Write-Verbose -Message ($script:localizedData.PropertiesDoesNotMatch -f $fieldName) -Verbose

                                    $arrayCompare |
                                        ForEach-Object -Process {
                                            Write-Verbose -Message ($script:localizedData.PropertyThatDoesNotMatch -f $_.InputObject, $_.SideIndicator) -Verbose
                                        }

                                    $returnValue = $false
                                }
                            }
                        }
                        else
                        {
                            switch ($desiredType.Name)
                            {
                                'String'
                                {
                                    if (-not [System.String]::IsNullOrEmpty($CurrentValues.$fieldName) -or `
                                            -not [System.String]::IsNullOrEmpty($DesiredValues.$fieldName))
                                    {
                                        Write-Verbose -Message ($script:localizedData.ValueOfTypeDoesNotMatch `
                                                -f $desiredType.Name, $fieldName, $($CurrentValues.$fieldName), $($DesiredValues.$fieldName)) -Verbose

                                        $returnValue = $false
                                    }
                                }

                                'Int32'
                                {
                                    if (-not ($DesiredValues.$fieldName -eq 0) -or `
                                            -not ($null -eq $CurrentValues.$fieldName))
                                    {
                                        Write-Verbose -Message ($script:localizedData.ValueOfTypeDoesNotMatch `
                                                -f $desiredType.Name, $fieldName, $($CurrentValues.$fieldName), $($DesiredValues.$fieldName)) -Verbose

                                        $returnValue = $false
                                    }
                                }

                                { $_ -eq 'Int16' -or $_ -eq 'UInt16' -or $_ -eq 'Single' }
                                {
                                    if (-not ($DesiredValues.$fieldName -eq 0) -or `
                                            -not ($null -eq $CurrentValues.$fieldName))
                                    {
                                        Write-Verbose -Message ($script:localizedData.ValueOfTypeDoesNotMatch `
                                                -f $desiredType.Name, $fieldName, $($CurrentValues.$fieldName), $($DesiredValues.$fieldName)) -Verbose

                                        $returnValue = $false
                                    }
                                }

                                'Boolean'
                                {
                                    if ($CurrentValues.$fieldName -ne $DesiredValues.$fieldName)
                                    {
                                        Write-Verbose -Message ($script:localizedData.ValueOfTypeDoesNotMatch `
                                                -f $desiredType.Name, $fieldName, $($CurrentValues.$fieldName), $($DesiredValues.$fieldName)) -Verbose

                                        $returnValue = $false
                                    }
                                }

                                default
                                {
                                    Write-Warning -Message ($script:localizedData.UnableToCompareProperty `
                                            -f $fieldName, $desiredType.Name)

                                    $returnValue = $false
                                }
                            }
                        }
                    }
                }
            }
        }

    return $returnValue
}

<#
    .SYNOPSIS
        Starts a process with a timeout.

    .PARAMETER FilePath
        String containing the path to the executable to start.

    .PARAMETER ArgumentList
        The arguments that should be passed to the executable.

    .PARAMETER Timeout
        The timeout in seconds to wait for the process to finish.

#>
function Start-ProcessWithTimeout
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FilePath,

        [Parameter()]
        [System.String[]]
        $ArgumentList,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $Timeout
    )

    $startProcessParameters = @{
        FilePath     = $FilePath
        ArgumentList = $ArgumentList
        PassThru     = $true
        NoNewWindow  = $true
        ErrorAction  = 'Stop'
    }

    $sqlSetupProcess = Start-Process @startProcessParameters

    Write-Verbose -Message ($script:localizedData.StartProcess -f $sqlSetupProcess.Id, $startProcessParameters.FilePath, $Timeout) -Verbose

    Wait-Process -InputObject $sqlSetupProcess -Timeout $Timeout -ErrorAction 'Stop'

    return $sqlSetupProcess.ExitCode
}

<#
    .SYNOPSIS
        Assert if the role specific module is installed or not and optionally
        import it.

    .PARAMETER ModuleName
        The name of the module to assert is installed.

    .PARAMETER ImportModule
        This switch causes the module to be imported if it is installed.
#>
function Assert-Module
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ModuleName = 'ActiveDirectory',

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $ImportModule
    )

    if (-not (Get-Module -Name $ModuleName -ListAvailable))
    {
        $errorMessage = $script:localizedData.ModuleNotFoundError -f $moduleName
        New-ObjectNotFoundException -Message $errorMessage
    }

    if ($ImportModule)
    {
        Import-Module -Name $ModuleName
    }
} #end function Assert-Module

<#
    .SYNOPSIS
        Tests whether this computer is a member of a domain.
#>
function Test-DomainMember
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
    )

    $isDomainMember = [System.Boolean] (Get-CimInstance -ClassName Win32_ComputerSystem -Verbose:$false).PartOfDomain

    return $isDomainMember
}


<#
    .SYNOPSIS
        Get the domain name of this computer.
#>
function Get-DomainName
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
    )

    $domainName = [System.String] (Get-CimInstance -ClassName Win32_ComputerSystem -Verbose:$false).Domain

    return $domainName
} # function Get-DomainName

<#
    .SYNOPSIS
        Assemble a fully qualifies domain name by appending the domain name
        to the parent domain name.

    .PARAMETER DomainName
        The domain name to append to the ParentDomainName.

    .PARAMETER ParentDomainName
        The parent domain name.
#>
function Resolve-DomainFQDN
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter()]
        [AllowNull()]
        [System.String]
        $ParentDomainName
    )

    $domainFQDN = $DomainName

    if ($ParentDomainName)
    {
        $domainFQDN = '{0}.{1}' -f $DomainName, $ParentDomainName
    }

    return $domainFQDN
}

<#
    .SYNOPSIS
        Get an Active Directory object's parent distinguished name.

    .PARAMETER DN
        The distinguished name of the object to return the parent from.

    .NOTES
        Copyright (c) 2016 The University Of Vermont
        All rights reserved.

        Redistribution and use in source and binary forms, with or without modification, are permitted provided that
        the following conditions are met:

        1. Redistributions of source code must retain the above copyright notice, this list of conditions and the
           following disclaimer.
        2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
           following disclaimer in the documentation and/or other materials provided with the distribution.
        3. Neither the name of the University nor the names of its contributors may be used to endorse or promote
           products derived from this software without specific prior written permission.

        THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
        LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
        IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
        CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
        OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
        CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
        THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

        http://www.uvm.edu/~gcd/code-license/
#>
function Get-ADObjectParentDN
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DN
    )

    # https://www.uvm.edu/~gcd/2012/07/listing-parent-of-ad-object-in-powershell/
    $distinguishedNameParts = $DN -split '(?<![\\]),'
    return $distinguishedNameParts[1..$($distinguishedNameParts.Count - 1)] -join ','
} #end function GetADObjectParentDN

<#
    .SYNOPSIS
        Validates the Members, MembersToInclude and MembersToExclude combination
        is valid. If the combination is invalid, an InvalidArgumentError is raised.

    .PARAMETER Members
        The Members to validate.

    .PARAMETER MembersToInclude
        The MembersToInclude to validate.

    .PARAMETER MembersToExclude
        The MembersToExclude to validate.
#>
function Assert-MemberParameters
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateNotNull()]
        [System.String[]]
        $MembersToInclude,

        [Parameter()]
        [ValidateNotNull()]
        [System.String[]]
        $MembersToExclude
    )

    if ($PSBoundParameters.ContainsKey('Members'))
    {
        if ($PSBoundParameters.ContainsKey('MembersToInclude') -or $PSBoundParameters.ContainsKey('MembersToExclude'))
        {
            # If Members are provided, Include and Exclude are not allowed.
            $errorMessage = $script:localizedData.MembersAndIncludeExcludeError -f 'Members', 'MembersToInclude', 'MembersToExclude'
            New-InvalidArgumentException -ArgumentName 'Members' -Message $errorMessage
        }
    }

    if ($PSBoundParameters.ContainsKey('MembersToInclude'))
    {
        $MembersToInclude = Remove-DuplicateMembers -Members $MembersToInclude
    }

    if ($PSBoundParameters.ContainsKey('MembersToExclude'))
    {
        $MembersToExclude = Remove-DuplicateMembers -Members $MembersToExclude
    }

    if (($PSBoundParameters.ContainsKey('MembersToInclude')) -and ($PSBoundParameters.ContainsKey('MembersToExclude')))
    {
        if (($MembersToInclude.Length -eq 0) -and ($MembersToExclude.Length -eq 0))
        {
            $errorMessage = $script:localizedData.IncludeAndExcludeAreEmptyError -f 'MembersToInclude', 'MembersToExclude'
            New-InvalidArgumentException -ArgumentName 'MembersToInclude, MembersToExclude' -Message $errorMessage
        }

        # Both MembersToInclude and MembersToExclude were provided. Check if they have common principals.
        foreach ($member in $MembersToInclude)
        {
            if ($member -in $MembersToExclude)
            {
                $errorMessage = $script:localizedData.IncludeAndExcludeConflictError -f $member, 'MembersToInclude', 'MembersToExclude'
                New-InvalidArgumentException -ArgumentName 'MembersToInclude, MembersToExclude' -Message $errorMessage
            }
        }
    }

} #end function Assert-MemberParameters

<#
    .SYNOPSIS
        Remove duplicate members from a string array. The comparison is
        case insensitive.

    .PARAMETER Members
        The array of members to remove duplicates from.

    .OUTPUTS
        A string array with the unique members-
#>
function Remove-DuplicateMembers
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param
    (
        [Parameter()]
        [System.String[]]
        $Members
    )

    if ($null -eq $Members -or $Members.Count -eq 0)
    {
        $uniqueMembers = [System.String[]] @()
    }
    else
    {
        $uniqueMembers = [System.String[]] ($members | Sort-Object -Unique)
    }

    <#
        Comma make sure we return the string array as the correct type,
        and also make sure one entry is returned as a string array.
    #>
    return ,$uniqueMembers
} #end function RemoveDuplicateMembers

<#
    .SYNOPSIS
        Test whether the existing array members match the defined explicit array
        and include/exclude the specified members.

    .PARAMETER ExistingMembers
        Existing array members.

    .PARAMETER Members
        Explicit array members.

    .PARAMETER MembersToInclude
       Compulsory array members.

    .PARAMETER MembersToExclude
       Excluded array members.
#>
function Test-Members
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [AllowNull()]
        [System.String[]]
        $ExistingMembers,

        [Parameter()]
        [AllowNull()]
        [System.String[]]
        $Members,

        [Parameter()]
        [AllowNull()]
        [System.String[]]
        $MembersToInclude,

        [Parameter()]
        [AllowNull()]
        [System.String[]]
        $MembersToExclude
    )

    if ($PSBoundParameters.ContainsKey('Members'))
    {
        if ($null -eq $Members -or (($Members.Count -eq 1) -and ($Members[0].Length -eq 0)))
        {
            $Members = @()
        }

        Write-Verbose ($script:localizedData.CheckingMembers -f 'Explicit')

        $Members = Remove-DuplicateMembers -Members $Members

        if ($ExistingMembers.Count -ne $Members.Count)
        {
            Write-Verbose -Message ($script:localizedData.MembershipCountMismatch -f $Members.Count, $ExistingMembers.Count)
            return $false
        }

        $isInDesiredState = $true

        foreach ($member in $Members)
        {
            if ($member -notin $ExistingMembers)
            {
                Write-Verbose -Message ($script:localizedData.MemberNotInDesiredState -f $member)
                $isInDesiredState = $false
            }
        }

        if (-not $isInDesiredState)
        {
            Write-Verbose -Message ($script:localizedData.MembershipNotDesiredState -f $member)
            return $false
        }
    } #end if $Members

    if ($PSBoundParameters.ContainsKey('MembersToInclude'))
    {
        if ($null -eq $MembersToInclude -or (($MembersToInclude.Count -eq 1) -and ($MembersToInclude[0].Length -eq 0)))
        {
            $MembersToInclude = @()
        }

        Write-Verbose -Message ($script:localizedData.CheckingMembers -f 'Included')

        $MembersToInclude = Remove-DuplicateMembers -Members $MembersToInclude

        $isInDesiredState = $true

        foreach ($member in $MembersToInclude)
        {
            if ($member -notin $ExistingMembers)
            {
                Write-Verbose -Message ($script:localizedData.MemberNotInDesiredState -f $member)
                $isInDesiredState = $false
            }
        }

        if (-not $isInDesiredState)
        {
            Write-Verbose -Message ($script:localizedData.MembershipNotDesiredState -f $member)
            return $false
        }
    } #end if $MembersToInclude

    if ($PSBoundParameters.ContainsKey('MembersToExclude'))
    {
        if ($null -eq $MembersToExclude -or (($MembersToExclude.Count -eq 1) -and ($MembersToExclude[0].Length -eq 0)))
        {
            $MembersToExclude = @()
        }

        Write-Verbose -Message ($script:localizedData.CheckingMembers -f 'Excluded')

        $MembersToExclude = Remove-DuplicateMembers -Members $MembersToExclude

        $isInDesiredState = $true

        foreach ($member in $MembersToExclude)
        {
            if ($member -in $ExistingMembers)
            {
                Write-Verbose -Message ($script:localizedData.MemberNotInDesiredState -f $member)
                $isInDesiredState = $false
            }
        }

        if (-not $isInDesiredState)
        {
            Write-Verbose -Message ($script:localizedData.MembershipNotDesiredState -f $member)
            return $false
        }
    } #end if $MembersToExclude

    Write-Verbose -Message $script:localizedData.MembershipInDesiredState
    return $true
} #end function Test-Membership

<#
    .SYNOPSIS
        Convert a specified time period in seconds, minutes, hours or days into
        a time span object.

    .PARAMETER TimeSpan
        The length of time to use for the time span.

    .PARAMETER TimeSpanType
        The units of measure in the TimeSpan parameter.
#>
function ConvertTo-TimeSpan
{
    [CmdletBinding()]
    [OutputType([System.TimeSpan])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.UInt32]
        $TimeSpan,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Seconds', 'Minutes', 'Hours', 'Days')]
        [System.String]
        $TimeSpanType
    )

    $newTimeSpanParams = @{}

    switch ($TimeSpanType)
    {
        'Seconds'
        {
            $newTimeSpanParams['Seconds'] = $TimeSpan
        }

        'Minutes'
        {
            $newTimeSpanParams['Minutes'] = $TimeSpan
        }

        'Hours'
        {
            $newTimeSpanParams['Hours'] = $TimeSpan
        }

        'Days'
        {
            $newTimeSpanParams['Days'] = $TimeSpan
        }
    }
    return (New-TimeSpan @newTimeSpanParams)
} #end function ConvertTo-TimeSpan

<#
    .SYNOPSIS
        Converts a System.TimeSpan into the number of seconds, minutes, hours or days.

    .PARAMETER TimeSpan
        TimeSpan to convert into an integer

    .PARAMETER TimeSpanType
        Convert timespan into the total number of seconds, minutes, hours or days.

    .EXAMPLE
        ConvertFrom-TimeSpan -TimeSpan (New-TimeSpan -Days 15) -TimeSpanType Seconds

        Returns the number of seconds in 15 days.
#>
function ConvertFrom-TimeSpan
{
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.TimeSpan]
        $TimeSpan,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Seconds', 'Minutes', 'Hours', 'Days')]
        [System.String]
        $TimeSpanType
    )

    switch ($TimeSpanType)
    {
        'Seconds'
        {
            return $TimeSpan.TotalSeconds -as [System.UInt32]
        }
        'Minutes'
        {
            return $TimeSpan.TotalMinutes -as [System.UInt32]
        }
        'Hours'
        {
            return $TimeSpan.TotalHours -as [System.UInt32]
        }
        'Days'
        {
            return $TimeSpan.TotalDays -as [System.UInt32]
        }
    }
} #end function ConvertFrom-TimeSpan

<#
    .SYNOPSIS
        Returns common AD cmdlet connection parameter for splatting.

    .PARAMETER CommonName
        When specified, a CommonName overrides theUsed by the ADUser
        cmdletReturns the Identity as the Name key. For example, the
        Get-ADUser, Set-ADUser and Remove-ADUser cmdlets take an Identity
        parameter, but the New-ADUser cmdlet uses the Name parameter.

    .PARAMETER UseNameParameter
        Returns the Identity as the Name key. For example, the Get-ADUser,
        Set-ADUser and Remove-ADUser cmdlets take an Identity parameter,
        but the New-ADUser cmdlet uses the Name parameter.

    .EXAMPLE
        $getADUserParams = Get-CommonADParameters @PSBoundParameters

        Returns connection parameters suitable for Get-ADUser using the
        splatted cmdlet parameters.

    .EXAMPLE
        $newADUserParams = Get-CommonADParameters @PSBoundParameters -UseNameParameter

        Returns connection parameters suitable for New-ADUser using
        the splatted cmdlet parameters.
#>
function Get-ADCommonParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('UserName', 'GroupName', 'ComputerName', 'ServiceAccountName')]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $CommonName,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Alias('DomainController')]
        [System.String]
        $Server,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UseNameParameter,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $PreferCommonName,

        # Catch all to enable splatted $PSBoundParameters
        [Parameter(ValueFromRemainingArguments)]
        $RemainingArguments
    )

    if ($UseNameParameter)
    {
        if ($PreferCommonName -and ($PSBoundParameters.ContainsKey('CommonName')))
        {
            $adConnectionParameters = @{
                Name = $CommonName
            }
        }
        else
        {
            $adConnectionParameters = @{
                Name = $Identity
            }
        }
    }
    else
    {
        if ($PreferCommonName -and ($PSBoundParameters.ContainsKey('CommonName')))
        {
            $adConnectionParameters = @{
                Identity = $CommonName
            }
        }
        else
        {
            $adConnectionParameters = @{
                Identity = $Identity
            }
        }
    }

    if ($Credential)
    {
        $adConnectionParameters['Credential'] = $Credential
    }

    if ($Server)
    {
        $adConnectionParameters['Server'] = $Server
    }

    return $adConnectionParameters
} #end function Get-ADCommonParameters

<#
    .SYNOPSIS
        Test Active Directory replication site availablity.

    .PARAMETER SiteName
        The replication site name to test the availability of.

    .PARAMETER DomainName
        The domain name containing the replication site.

    .PARAMETER Credential
        The credential to use to access the replication site.
#>
function Test-ADReplicationSite
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message ($script:localizedData.CheckingSite -f $SiteName)

    $existingDC = "$((Get-ADDomainController -Discover -DomainName $DomainName -ForceDiscover).HostName)"

    try
    {
        $site = Get-ADReplicationSite -Identity $SiteName -Server $existingDC -Credential $Credential
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {
        return $false
    }

    return ($null -ne $site)
}

<#
    .SYNOPSIS
        Convert a ModeId or Microsoft.ActiveDirectory.Management.ADForestMode to
        a Microsoft.DirectoryServices.Deployment.Types.ForestMode type.

    .PARAMETER ModeId
        The ModeId value to convert to a
        Microsoft.DirectoryServices.Deployment.Types.ForestMode type.

    .PARAMETER Mode
        The Microsoft.ActiveDirectory.Management.ADForestMode value to convert
        to a Microsoft.DirectoryServices.Deployment.Types.ForestMode type
#>
function ConvertTo-DeploymentForestMode
{
    [CmdletBinding()]
    [OutputType([Microsoft.DirectoryServices.Deployment.Types.ForestMode])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'ById')]
        [System.UInt16]
        $ModeId,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'ByName')]
        [AllowNull()]
        [System.Nullable``1[Microsoft.ActiveDirectory.Management.ADForestMode]]
        $Mode
    )

    $convertedMode = $null

    if ($PSCmdlet.ParameterSetName -eq 'ByName' -and $Mode)
    {
        $convertedMode = $Mode -as [Microsoft.DirectoryServices.Deployment.Types.ForestMode]
    }

    if ($PSCmdlet.ParameterSetName -eq 'ById')
    {
        $convertedMode = $ModeId -as [Microsoft.DirectoryServices.Deployment.Types.ForestMode]
    }

    if ([enum]::GetValues([Microsoft.DirectoryServices.Deployment.Types.ForestMode]) -notcontains $convertedMode)
    {
        return $null
    }

    return $convertedMode
}

<#
    .SYNOPSIS
        Convert a ModeId or Microsoft.ActiveDirectory.Management.ADDomainMode to
        a Microsoft.DirectoryServices.Deployment.Types.DomainMode type.

    .PARAMETER ModeId
        The ModeId value to convert to a
        Microsoft.DirectoryServices.Deployment.Types.DomainMode type.

    .PARAMETER Mode
        The Microsoft.ActiveDirectory.Management.ADDomainMode value to convert
        to a Microsoft.DirectoryServices.Deployment.Types.DomainMode type
#>
function ConvertTo-DeploymentDomainMode
{
    [CmdletBinding()]
    [OutputType([Microsoft.DirectoryServices.Deployment.Types.DomainMode])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'ById')]
        [System.UInt16]
        $ModeId,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'ByName')]
        [AllowNull()]
        [System.Nullable``1[Microsoft.ActiveDirectory.Management.ADDomainMode]]
        $Mode
    )

    $convertedMode = $null

    if ($PSCmdlet.ParameterSetName -eq 'ByName' -and $Mode)
    {
        $convertedMode = $Mode -as [Microsoft.DirectoryServices.Deployment.Types.DomainMode]
    }

    if ($PSCmdlet.ParameterSetName -eq 'ById')
    {
        $convertedMode = $ModeId -as [Microsoft.DirectoryServices.Deployment.Types.DomainMode]
    }

    if ([enum]::GetValues([Microsoft.DirectoryServices.Deployment.Types.DomainMode]) -notcontains $convertedMode)
    {
        return $null
    }

    return $convertedMode
}

<#
    .SYNOPSIS
        Restore and AD object from the AD recyle bin.

    .PARAMETER Identity
        The identity of the object to restore.

    .PARAMETER ObjectClass
        The type of the AD object to restore.

    .PARAMETER Credential
        The credential to use to restore the object in the Active
        Directory.

    .PARAMETER Server
        The name of the domain controller use to restore the object.
#>
function Restore-ADCommonObject
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('UserName', 'GroupName', 'ComputerName', 'ServiceAccountName')]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Computer', 'OrganizationalUnit', 'User', 'Group')]
        [System.String]
        $ObjectClass,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Alias('DomainController')]
        [System.String]
        $Server
    )

    $restoreFilter = 'msDS-LastKnownRDN -eq "{0}" -and objectClass -eq "{1}" -and isDeleted -eq $true' -f $Identity, $ObjectClass
    Write-Verbose -Message ($script:localizedData.FindInRecycleBin -f $restoreFilter) -Verbose

    <#
        Using IsDeleted and IncludeDeletedObjects will mean that the cmdlet does not throw
        any more, and simply returns $null instead
    #>
    $commonParams = Get-ADCommonParameters @PSBoundParameters
    $getAdObjectParams = $commonParams.Clone()
    $getAdObjectParams.Remove('Identity')
    $getAdObjectParams['Filter'] = $restoreFilter
    $getAdObjectParams['IncludeDeletedObjects'] = $true
    $getAdObjectParams['Properties'] = @('whenChanged')

    # If more than one object is returned, we pick the one that was changed last.
    $restorableObject = Get-ADObject @getAdObjectParams |
        Sort-Object -Descending -Property 'whenChanged' |
            Select-Object -First 1

    $restoredObject = $null

    if ($restorableObject)
    {
        Write-Verbose -Message ($script:localizedData.FoundRestoreTargetInRecycleBin -f $Identity, $ObjectClass, $restorableObject.DistinguishedName) -Verbose

        try
        {
            $restoreParams = $commonParams.Clone()
            $restoreParams['PassThru'] = $true
            $restoreParams['ErrorAction'] = 'Stop'
            $restoreParams['Identity'] = $restorableObject.DistinguishedName
            $restoredObject = Restore-ADObject @restoreParams

            Write-Verbose -Message ($script:localizedData.RecycleBinRestoreSuccessful -f $Identity, $ObjectClass) -Verbose
        }
        catch [Microsoft.ActiveDirectory.Management.ADException]
        {
            # After Get-TargetResource is through, only one error can occur here: Object parent does not exist
            $errorMessage = $script:localizedData.RecycleBinRestoreFailed -f $Identity, $ObjectClass
            New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
        }
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.NoObjectFoundInRecycleBin) -Verbose
    }

    return $restoredObject
}

<#
    .SYNOPSIS
        Converts an Active Directory distinguished name into a fully
        qualified domain name.

    .DESCRIPTION
        Takes an Active Directory distinguished name as input, returns
        the domain FQDN.

    .PARAMETER DistinguishedName
        The distinguished name to convert into the FQDN.

    .EXAMPLE
        Get-ADDomainNameFromDistinguishedName -DistinguishedName 'CN=ExampleObject,OU=ExampleOU,DC=example,DC=com'

    .NOTES
        Author: Robert D. Biddle (https://github.com/RobBiddle)
        Created: December.20.2017
#>
function Get-ADDomainNameFromDistinguishedName
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $DistinguishedName
    )

    if ($DistinguishedName -notlike '*DC=*')
    {
        return
    }

    $splitDistinguishedName = ($DistinguishedName -split 'DC=')
    $splitDistinguishedNameParts = $splitDistinguishedName[1..$splitDistinguishedName.Length]
    $domainFqdn = ''

    foreach ($part in $splitDistinguishedNameParts)
    {
        $domainFqdn += "DC=$part"
    }

    $domainName = $domainFqdn -replace 'DC=', '' -replace ',', '.'

    return $domainName

} #end function Get-ADDomainNameFromDistinguishedName

<#
    .SYNOPSIS
        Add group member from current or different domain.

    .PARAMETER Members
        The members to add to the group. These may be in the same
        domain as the group or in alternate domains.

    .PARAMETER Parameters
        The parameters to pass to the Add-ADGroupMember cmdlet when
        adding the members to the group. This should include the group
        identity.

    .PARAMETER MembersInMultipleDomains
        Setting this switch indicates that there are members from
        alternate domains. This triggers the identities of the members
        to be looked up in the alternate domain.

    .NOTES
        Author original code: Robert D. Biddle (https://github.com/RobBiddle)
        Author refactored code: Jan-Hendrik Peters (https://github.com/nyanhp)
#>
function Add-ADCommonGroupMember
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [hashtable]
        $Parameters,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $MembersInMultipleDomains
    )

    Assert-Module -ModuleName ActiveDirectory

    if ($Members)
    {
        if ($MembersInMultipleDomains.IsPresent)
        {
            foreach ($member in $Members)
            {
                $memberDomain = Get-ADDomainNameFromDistinguishedName -DistinguishedName $member

                if (-not $memberDomain)
                {
                    $errorMessage = $script:localizedData.EmptyDomainError -f $member, $Parameters.Identity
                    New-InvalidOperationException -Message $errorMessage
                }

                Write-Verbose -Message ($script:localizedData.AddingGroupMember -f $member, $memberDomain, $Parameters.Identity)

                $commonParameters = @{
                    Identity = $member
                    Server = $memberDomain
                    ErrorAction = 'Stop'
                }

                $activeDirectoryObject = Get-ADObject @commonParameters -Properties @('ObjectClass')

                $memberObjectClass = $activeDirectoryObject.ObjectClass

                if ($memberObjectClass -eq 'computer')
                {
                    $memberObject = Get-ADComputer @commonParameters
                }
                elseif ($memberObjectClass -eq 'group')
                {
                    $memberObject = Get-ADGroup @commonParameters
                }
                elseif ($memberObjectClass -eq 'user')
                {
                    $memberObject = Get-ADUser @commonParameters
                }

                Add-ADGroupMember @Parameters -Members $memberObject -ErrorAction 'Stop'
            }
        }
        else
        {
            Add-ADGroupMember @Parameters -Members $Members -ErrorAction 'Stop'
        }
    }
}

<#
    .SYNOPSIS
        Returns the domain controller object if the node is a domain controller,
        otherwise it return $null.

    .PARAMETER DomainName
        The name of the domain that should contain the domain controller.

    .PARAMETER ComputerName
        The name of the node to return the domain controller object for.
        Defaults to $env:COMPUTERNAME.

    .OUTPUTS
        If the domain controller is not found, an empty object ($null) is returned.

    .NOTES
        Throws an exception of Microsoft.ActiveDirectory.Management.ADServerDownException
        if the domain cannot be contacted.
#>
function Get-DomainControllerObject
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter()]
        [System.String]
        $ComputerName = $env:COMPUTERNAME,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    <#
        It is not possible to use `-ErrorAction 'SilentlyContinue` on the
        cmdlet Get-ADDomainController, it will throw an error regardless.
    #>
    try
    {
        $getADDomainControllerParameters = @{
            Filter = 'Name -eq "{0}"' -f $ComputerName
            Server = $DomainName
        }

        if ($PSBoundParameters.ContainsKey('Credential'))
        {
            $getADDomainControllerParameters['Credential'] = $Credential
        }

        $domainControllerObject = Get-ADDomainController @getADDomainControllerParameters

        if (-not $domainControllerObject -and (Test-IsDomainController) -eq $true)
        {
            $errorMessage = $script:localizedData.WasExpectingDomainController
            New-InvalidResultException -Message $errorMessage
        }
    }
    catch
    {
        $errorMessage = $script:localizedData.FailedEvaluatingDomainController
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }

    return $domainControllerObject
}

<#
    .SYNOPSIS
        Returns $true if the node is a domain controller, otherwise it returns
        $false
#>
function Test-IsDomainController
{
    [CmdletBinding()]
    param
    (
    )

    $operatingSystemInformation = Get-CimInstance -ClassName 'Win32_OperatingSystem'

    return $operatingSystemInformation.ProductType -eq 2
}

<#
    .SYNOPSIS
        Converts a hashtable containing the parameter to property mappings to
        an array of properties that can be used to call cmdlets that supports the
        parameter Properties.

    .PARAMETER PropertyMap
        The property map, as an array of hashtables, to convert to a properties array.

    .EXAMPLE
        $computerObjectPropertyMap = @(
            @{
                ParameterName = 'ComputerName'
                PropertyName  = 'cn'
            },
            @{
                ParameterName = 'Location'
            }
        )

        $computerObjectProperties = Convert-PropertyMapToObjectProperties $computerObjectPropertyMap
        $getADComputerResult = Get-ADComputer -Identity 'APP01' -Properties $computerObjectProperties
#>
function Convert-PropertyMapToObjectProperties
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Array]
        $PropertyMap
    )

    $objectProperties = @()

    # Create an array of the AD property names to retrieve from the property map
    foreach ($property in $PropertyMap)
    {
        if ($property -isnot [System.Collections.Hashtable])
        {
            $errorMessage = $script:localizedData.PropertyMapArrayIsWrongType
            New-InvalidOperationException -Message $errorMessage
        }

        if ($property.ContainsKey('PropertyName'))
        {
            $objectProperties += @($property.PropertyName)
        }
        else
        {
            $objectProperties += $property.ParameterName
        }
    }

    return $objectProperties
}

<#
    .SYNOPSIS
        This function is used to compare current and desired values for any DSC
        resource, and return a hashtable with the result from the comparison.

    .PARAMETER CurrentValues
        The current values that should be compared to to desired values. Normally
        the values returned from Get-TargetResource.

    .PARAMETER DesiredValues
        The values set in the configuration and is provided in the call to the
        functions *-TargetResource, and that will be compared against current
        values. Normally set to $PSBoundParameters.

    .PARAMETER Properties
        An array of property names, from the keys provided in DesiredValues, that
        will be compared. If this parameter is left out, all the keys in the
        DesiredValues will be compared.
#>
function Compare-ResourcePropertyState
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $CurrentValues,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $DesiredValues,

        [Parameter()]
        [System.String[]]
        $Properties,

        [Parameter()]
        [System.String[]]
        $IgnoreProperties
    )

    if ($PSBoundParameters.ContainsKey('Properties'))
    {
        # Filter out the parameters (keys) not specified in Properties
        $desiredValuesToRemove = $DesiredValues.Keys |
            Where-Object -FilterScript {
                $_ -notin $Properties
            }

        $desiredValuesToRemove |
            ForEach-Object -Process {
                $DesiredValues.Remove($_)
            }
    }
    else
    {
        <#
            Remove any common parameters that might be part of DesiredValues,
            if it $PSBoundParameters was used to pass the desired values.
        #>
        $commonParametersToRemove = $DesiredValues.Keys |
            Where-Object -FilterScript {
                $_ -in [System.Management.Automation.PSCmdlet]::CommonParameters `
                    -or $_ -in [System.Management.Automation.PSCmdlet]::OptionalCommonParameters
            }

        $commonParametersToRemove |
            ForEach-Object -Process {
                $DesiredValues.Remove($_)
            }
    }

    # Remove any properties that should be ignored.
    if ($PSBoundParameters.ContainsKey('IgnoreProperties'))
    {
        $IgnoreProperties |
            ForEach-Object -Process {
                if ($DesiredValues.ContainsKey($_))
                {
                    $DesiredValues.Remove($_)
                }
            }
    }

    $compareTargetResourceStateReturnValue = @()

    foreach ($parameterName in $DesiredValues.Keys)
    {
        Write-Verbose -Message ($script:localizedData.EvaluatePropertyState -f $parameterName) -Verbose

        $parameterState = @{
            ParameterName = $parameterName
            Expected      = $DesiredValues.$parameterName
            Actual        = $CurrentValues.$parameterName
        }

        # Check if the parameter is in compliance.
        $isPropertyInDesiredState = Test-DscPropertyState -Values @{
            CurrentValue = $CurrentValues.$parameterName
            DesiredValue = $DesiredValues.$parameterName
        }

        if ($isPropertyInDesiredState)
        {
            Write-Verbose -Message ($script:localizedData.PropertyInDesiredState -f $parameterName) -Verbose

            $parameterState['InDesiredState'] = $true
        }
        else
        {
            Write-Verbose -Message ($script:localizedData.PropertyNotInDesiredState -f $parameterName) -Verbose

            $parameterState['InDesiredState'] = $false
        }

        $compareTargetResourceStateReturnValue += $parameterState
    }

    return $compareTargetResourceStateReturnValue
}

<#
    .SYNOPSIS
        This function is used to compare the current and the desired value of a
        property.

    .PARAMETER Values
        This is set to a hash table with the current value (the CurrentValue key)
        and desired value (the DesiredValue key).

    .EXAMPLE
        Test-DscPropertyState -Values @{
            CurrentValue = 'John'
            DesiredValue = 'Alice'
        }
    .EXAMPLE
        Test-DscPropertyState -Values @{
            CurrentValue = 1
            DesiredValue = 2
        }
#>
function Test-DscPropertyState
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Values
    )

    if ($null -eq $Values.CurrentValue -and $null -eq $Values.DesiredValue)
    {
        # Both values are $null so return $true
        $returnValue = $true
    }
    elseif ($null -eq $Values.CurrentValue -or $null -eq $Values.DesiredValue)
    {
        # Either CurrentValue or DesiredValue are $null so return $false
        $returnValue = $false
    }
    elseif ($Values.DesiredValue.GetType().IsArray -or $Values.CurrentValue.GetType().IsArray)
    {
        $compareObjectParameters = @{
            ReferenceObject  = $Values.CurrentValue
            DifferenceObject = $Values.DesiredValue
        }

        $arrayCompare = Compare-Object @compareObjectParameters

        if ($null -ne $arrayCompare)
        {
            Write-Verbose -Message $script:localizedData.ArrayDoesNotMatch -Verbose

            $arrayCompare |
                ForEach-Object -Process {
                    Write-Verbose -Message ($script:localizedData.ArrayValueThatDoesNotMatch -f `
                            $_.InputObject, $_.SideIndicator) -Verbose
                }

            $returnValue = $false
        }
        else
        {
            $returnValue = $true
        }
    }
    elseif ($Values.CurrentValue -ne $Values.DesiredValue)
    {
        $desiredType = $Values.DesiredValue.GetType()

        $returnValue = $false

        $supportedTypes = @(
            'String'
            'Int32'
            'UInt32'
            'Int16'
            'UInt16'
            'Single'
            'Boolean'
        )

        if ($desiredType.Name -notin $supportedTypes)
        {
            Write-Warning -Message ($script:localizedData.UnableToCompareType `
                    -f $fieldName, $desiredType.Name)
        }
        else
        {
            Write-Verbose -Message (
                $script:localizedData.PropertyValueOfTypeDoesNotMatch `
                    -f $desiredType.Name, $Values.CurrentValue, $Values.DesiredValue
            ) -Verbose
        }
    }
    else
    {
        $returnValue = $true
    }

    return $returnValue
}

<#
    .SYNOPSIS
        Asserts if the AD PS Drive has been created, and creates one if not.

    .PARAMETER Root
        Specifies the AD path to which the drive is mapped.

    .NOTES
        Throws an exception if the PS Drive cannot be created.
#>
function Assert-ADPSDrive
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $Root = '//RootDSE/'
    )

    Assert-Module -ModuleName 'ActiveDirectory' -ImportModule

    $activeDirectoryPSDrive = Get-PSDrive -Name AD -ErrorAction SilentlyContinue

    if ($null -eq $activeDirectoryPSDrive)
    {
        Write-Verbose -Message $script:localizedData.CreatingNewADPSDrive -Verbose

        try
        {
            New-PSDrive -Name AD -PSProvider 'ActiveDirectory' -Root $Root -Scope Script -ErrorAction 'Stop' |
                Out-Null
        }
        catch
        {
            $errorMessage = $script:localizedData.CreatingNewADPSDriveError
            New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
        }
    }
}

<#
    .SYNOPSIS
        This is a wrapper for Set-ADComputer.

    .PARAMETER Parameters
        A hash table containing all parameters that will be passed trough to
        Set-ADComputer.

    .NOTES
        This is needed because of how Pester is unable to handle mocking the
        cmdlet Set-ADComputer. Therefor there are no unit test for this function.
#>
function Set-DscADComputer
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters
    )

    Set-ADComputer @Parameters | Out-Null
}

<#
    .SYNOPSIS
        This returns a new MSFT_Credential CIM instance credential object to be
        used when returning credential objects from Get-TargetResource.
        This returns a credential object without the password.

    .PARAMETER Credential
        The PSCredential object to return as a MSFT_Credential CIM instance
        credential object.

    .NOTES
        When returning a PSCredential object from Get-TargetResource, the
        credential object does not contain the username. The object is empty.

        Password UserName PSComputerName
        -------- -------- --------------
                          localhost

        When the MSFT_Credential CIM instance credential object is returned by
        the Get-TargetResource then the credential object contains the values
        provided in the object.

        Password UserName             PSComputerName
        -------- --------             --------------
                 COMPANY\TestAccount  localhost
#>
function New-CimCredentialInstance
{
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    $newCimInstanceParameters = @{
        ClassName = 'MSFT_Credential'
        ClientOnly = $true
        Namespace = 'root/microsoft/windows/desiredstateconfiguration'
        Property = @{
            UserName = [System.String] $Credential.UserName
            Password = [System.String] $null
        }
    }

    return New-CimInstance @newCimInstanceParameters
}

<#
    .SYNOPSIS
        This loads the assembly type, optionally after a check
        if the type is missing in the PowerShell session.

    .PARAMETER AssemblyName
        The assembly to load into the PowerShell session.

    .PARAMETER TypeName
        An optional parameter to check if the type exist, if it exist then the
        assembly is not loaded again.
#>
function Add-TypeAssembly
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AssemblyName,

        [Parameter()]
        [System.String]
        $TypeName
    )

    if ($PSBoundParameters.ContainsKey('TypeName'))
    {
        if ($TypeName -as [Type])
        {
            Write-Verbose -Message ($script:localizedData.TypeAlreadyExistInSession -f $TypeName) -Verbose

            # The type already exists so no need to load the type again.
            return
        }
        else
        {
            Write-Verbose -Message ($script:localizedData.TypeDoesNotExistInSession -f $TypeName) -Verbose
        }
    }

    try
    {
        Write-Verbose -Message ($script:localizedData.AddingAssemblyToSession -f $AssemblyName) -Verbose

        Add-Type -AssemblyName $AssemblyName
    }
    catch
    {
        $missingRoleMessage = $script:localizedData.CouldNotLoadAssembly -f $AssemblyName
        New-ObjectNotFoundException -Message $missingRoleMessage -ErrorRecord $_
    }
}

<#
    .SYNOPSIS
        This returns a new object of the type System.DirectoryServices.ActiveDirectory.DirectoryContext.

    .PARAMETER DirectoryContextType
        The context type of the object to return. Valid values are 'Domain', 'Forest',
        'ApplicationPartition', 'ConfigurationSet' or 'DirectoryServer'.

    .PARAMETER Name
        An optional parameter for the target of the directory context.
        For the correct format for this parameter depending on context type, see
        the article https://docs.microsoft.com/en-us/dotnet/api/system.directoryservices.activedirectory.directorycontext?view=netframework-4.8
#>
function Get-ADDirectoryContext
{
    [CmdletBinding()]
    [OutputType([System.DirectoryServices.ActiveDirectory.DirectoryContext])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Domain', 'Forest', 'ApplicationPartition', 'ConfigurationSet', 'DirectoryServer')]
        [System.String]
        $DirectoryContextType,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    $typeName = 'System.DirectoryServices.ActiveDirectory.DirectoryContext'

    Add-TypeAssembly -AssemblyName 'System.DirectoryServices' -TypeName $typeName

    Write-Verbose -Message ($script:localizedData.NewDirectoryContext -f $DirectoryContextType) -Verbose

    $newObjectArgumentList = @(
        $DirectoryContextType
    )

    if ($PSBoundParameters.ContainsKey('Name'))
    {
        Write-Verbose -Message ($script:localizedData.NewDirectoryContextTarget -f $Name) -Verbose

        $newObjectArgumentList += @(
            $Name
        )
    }

    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        Write-Verbose -Message ($script:localizedData.NewDirectoryContextCredential -f $Credential.UserName) -Verbose

        $newObjectArgumentList += @(
            $Credential.UserName
            $Credential.GetNetworkCredential().Password
        )
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.NewDirectoryContextCredential -f (Get-CurrentUser).Name) -Verbose
    }

    $newObjectParameters = @{
        TypeName = $typeName
        ArgumentList = $newObjectArgumentList
    }

    return New-Object @newObjectParameters
}

<#
    .SYNOPSIS
        Gets the specified Active Directory domain

    .PARAMETER DomainName
        Specifies the fully qualified domain name to wait for..

    .PARAMETER DomainName
        Specifies the site in the domain where to look for a domain controller.

    .PARAMETER Credential
        Specifies the credentials that are used when accessing the domain,
        or uses the current user if not specified.

    .PARAMETER WaitForValidCredentials
        Specifies if authentication exceptions should be ignored.

    .NOTES
        This function is designed so that it can run on any computer without
        having the ActiveDirectory module installed.
#>
function Find-DomainController
{
    [OutputType([System.DirectoryServices.ActiveDirectory.DomainController])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [Parameter()]
        [System.String]
        $SiteName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $WaitForValidCredentials
    )

    if ($PSBoundParameters.ContainsKey('SiteName'))
    {
        Write-Verbose -Message ($script:localizedData.SearchingForDomainControllerInSite -f $SiteName, $DomainName) -Verbose
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.SearchingForDomainController -f $DomainName) -Verbose
    }

    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        $adDirectoryContext = Get-ADDirectoryContext -DirectoryContextType 'Domain' -Name $DomainName -Credential $Credential
    }
    else
    {
        $adDirectoryContext = Get-ADDirectoryContext -DirectoryContextType 'Domain' -Name $DomainName
    }

    $domainControllerObject = $null

    try
    {
        if ($PSBoundParameters.ContainsKey('SiteName'))
        {
            $domainControllerObject = Find-DomainControllerFindOneInSiteWrapper -DirectoryContext $adDirectoryContext -SiteName $SiteName

            Write-Verbose -Message ($script:localizedData.FoundDomainControllerInSite -f $SiteName, $DomainName) -Verbose
        }
        else
        {
            $domainControllerObject = Find-DomainControllerFindOneWrapper -DirectoryContext $adDirectoryContext

            Write-Verbose -Message ($script:localizedData.FoundDomainController -f $DomainName) -Verbose
        }
    }
    catch [System.DirectoryServices.ActiveDirectory.ActiveDirectoryObjectNotFoundException]
    {
        Write-Verbose -Message ($script:localizedData.FailedToFindDomainController -f $DomainName) -Verbose
    }
    catch [System.Management.Automation.MethodInvocationException]
    {
        $isTypeNameToSuppress = $_.Exception.InnerException -is [System.Security.Authentication.AuthenticationException]

        if ($WaitForValidCredentials.IsPresent -and $isTypeNameToSuppress)
        {
            Write-Warning -Message (
                $script:localizedData.IgnoreCredentialError -f $_.FullyQualifiedErrorId, $_.Exception.Message
            )
        }
        else
        {
            throw $_
        }
    }
    catch
    {
        throw $_
    }

    return $domainControllerObject
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
        This is a wrapper to enable unit testing of the function Find-DomainController.
        It is not possible to make a stub class to mock these, since these classes
        are loaded into the PowerShell session when it starts.

        This function is not exported.
#>
function Find-DomainControllerFindOneWrapper
{
    [CmdletBinding()]
    [OutputType([System.DirectoryServices.ActiveDirectory.DomainController])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.DirectoryServices.ActiveDirectory.DirectoryContext]
        $DirectoryContext
    )

    return [System.DirectoryServices.ActiveDirectory.DomainController]::FindOne($DirectoryContext)
}

<#
    .SYNOPSIS
        This returns a new object of the type System.DirectoryServices.ActiveDirectory.Forest
        which is a class that represents an Active Directory Domain Services forest.

    .PARAMETER DirectoryContext
        The Active Directory context from which the forest object is returned.
        Calling the Get-ADDirectoryContext gets a value that can be provided in
        this parameter.

    .PARAMETER SiteName
        Specifies the site in the domain where to look for a domain controller.

    .NOTES
        This is a wrapper to enable unit testing of the function Find-DomainController.
        It is not possible to make a stub class to mock these, since these classes
        are loaded into the PowerShell session when it starts.

        This function is not exported.
#>
function Find-DomainControllerFindOneInSiteWrapper
{
    [CmdletBinding()]
    [OutputType([System.DirectoryServices.ActiveDirectory.DomainController])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.DirectoryServices.ActiveDirectory.DirectoryContext]
        $DirectoryContext,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteName
    )

    return [System.DirectoryServices.ActiveDirectory.DomainController]::FindOne($DirectoryContext, $SiteName)
}

<#
    .SYNOPSIS
        This is used to get the current user context when the resource
        script runs.

    .NOTES
        We are putting this in a function so we can mock it with pester
#>
function Get-CurrentUser
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    return [System.Security.Principal.WindowsIdentity]::GetCurrent()
}

$script:localizedData = Get-LocalizedData -ResourceName 'ActiveDirectoryDsc.Common' -ScriptRoot $PSScriptRoot

Export-ModuleMember -Function @(
    'New-InvalidArgumentException'
    'New-InvalidOperationException'
    'New-ObjectNotFoundException'
    'New-InvalidResultException'
    'Get-LocalizedData'
    'Test-DscParameterState'
    'Start-ProcessWithTimeout'
    'Assert-Module'
    'Test-DomainMember'
    'Get-DomainName'
    'Resolve-DomainFQDN'
    'Get-ADObjectParentDN'
    'Assert-MemberParameters'
    'Remove-DuplicateMembers'
    'Test-Members'
    'ConvertTo-TimeSpan'
    'ConvertFrom-TimeSpan'
    'Get-ADCommonParameters'
    'Test-ADReplicationSite'
    'ConvertTo-DeploymentForestMode'
    'ConvertTo-DeploymentDomainMode'
    'Restore-ADCommonObject'
    'Get-ADDomainNameFromDistinguishedName'
    'Add-ADCommonGroupMember'
    'Get-DomainControllerObject'
    'Test-IsDomainController'
    'Convert-PropertyMapToObjectProperties'
    'Compare-ResourcePropertyState'
    'Test-DscPropertyState'
    'Assert-ADPSDrive'
    'Set-DscADComputer'
    'New-CimCredentialInstance'
    'Add-TypeAssembly'
    'Get-ADDirectoryContext'
    'Find-DomainController'
    'Get-CurrentUser'
)
