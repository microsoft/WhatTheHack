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

# Internal function to throw terminating error with specified errroCategory, errorId and errorMessage
function New-TerminatingError
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ErrorId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ErrorMessage,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ErrorCategory]
        $ErrorCategory
    )

    $exception = New-Object System.InvalidOperationException $errorMessage
    $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $errorId, $errorCategory, $null
    throw $errorRecord
}

# Internal function to assert if the role specific module is installed or not
function Assert-Module
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name
    )

    if(-not (Get-Module -Name $Name -ListAvailable))
    {
        $errorMsg = $LocalizedData.RoleNotFound -f $Name
        New-TerminatingError -ErrorId ModuleNotFound -ErrorMessage $errorMsg -ErrorCategory ObjectNotFound
    }
}

#Internal function to remove all common parameters from $PSBoundParameters before it is passed to Set-CimInstance
function Remove-CommonParameter
{
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Hashtable
    )

    $inputClone = $Hashtable.Clone()
    $commonParameters = [System.Management.Automation.PSCmdlet]::CommonParameters
    $commonParameters += [System.Management.Automation.PSCmdlet]::OptionalCommonParameters

    $Hashtable.Keys | Where-Object { $_ -in $commonParameters } | ForEach-Object {
        $inputClone.Remove($_)
    }

    $inputClone
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

        .PARAMETER TurnOffTypeChecking
        Indicates that the type of the parameter should not be checked.

        .PARAMETER ReverseCheck
        Indicates that a reverse check should be done. The current and desired state are swapped for another test.

        .PARAMETER SortArrayValues
        If the sorting of array values does not matter, values are sorted internally before doing the comparison.
#>
function Test-DscParameterState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $CurrentValues,

        [Parameter(Mandatory = $true)]
        [System.Object]
        $DesiredValues,

        [Parameter()]
        [System.String[]]
        $ValuesToCheck,

        [Parameter()]
        [switch]
        $TurnOffTypeChecking,

        [Parameter()]
        [switch]
        $ReverseCheck,

        [Parameter()]
        [switch]
        $SortArrayValues
    )

    $returnValue = $true

    if ($CurrentValues -is [Microsoft.Management.Infrastructure.CimInstance] -or
        $CurrentValues -is [Microsoft.Management.Infrastructure.CimInstance[]])
    {
        $CurrentValues = ConvertTo-HashTable -CimInstance $CurrentValues
    }

    if ($DesiredValues -is [Microsoft.Management.Infrastructure.CimInstance] -or
        $DesiredValues -is [Microsoft.Management.Infrastructure.CimInstance[]])
    {
        $DesiredValues = ConvertTo-HashTable -CimInstance $DesiredValues
    }

    $types = 'System.Management.Automation.PSBoundParametersDictionary', 'System.Collections.Hashtable', 'Microsoft.Management.Infrastructure.CimInstance'

    if ($DesiredValues.GetType().FullName -notin $types)
    {
        New-InvalidArgumentException `
            -Message ($script:localizedData.InvalidDesiredValuesError -f $DesiredValues.GetType().FullName) `
            -ArgumentName 'DesiredValues'
    }

    if ($CurrentValues.GetType().FullName -notin $types)
    {
        New-InvalidArgumentException `
            -Message ($script:localizedData.InvalidCurrentValuesError -f $CurrentValues.GetType().FullName) `
            -ArgumentName 'CurrentValues'
    }

    if ($DesiredValues -is [Microsoft.Management.Infrastructure.CimInstance] -and -not $ValuesToCheck)
    {
        New-InvalidArgumentException `
            -Message $script:localizedData.InvalidValuesToCheckError `
            -ArgumentName 'ValuesToCheck'
    }

    $desiredValuesClean = Remove-CommonParameter -Hashtable $DesiredValues

    if (-not $ValuesToCheck)
    {
        $keyList = $desiredValuesClean.Keys
    }
    else
    {
        $keyList = $ValuesToCheck
    }

    foreach ($key in $keyList)
    {
        $desiredValue = $desiredValuesClean.$key
        $currentValue = $CurrentValues.$key

        if ($desiredValue -is [Microsoft.Management.Infrastructure.CimInstance] -or
            $desiredValue -is [Microsoft.Management.Infrastructure.CimInstance[]])
        {
            $desiredValue = ConvertTo-HashTable -CimInstance $desiredValue
        }
        if ($currentValue -is [Microsoft.Management.Infrastructure.CimInstance] -or
            $currentValue -is [Microsoft.Management.Infrastructure.CimInstance[]])
        {
            $currentValue = ConvertTo-HashTable -CimInstance $currentValue
        }

        if ($null -ne $desiredValue)
        {
            $desiredType = $desiredValue.GetType()
        }
        else
        {
            $desiredType = @{
                Name = 'Unknown'
            }
        }

        if ($null -ne $currentValue)
        {
            $currentType = $currentValue.GetType()
        }
        else
        {
            $currentType = @{
                Name = 'Unknown'
            }
        }

        if ($currentType.Name -ne 'Unknown' -and $desiredType.Name -eq 'PSCredential')
        {
            # This is a credential object. Compare only the user name
            if ($currentType.Name -eq 'PSCredential' -and $currentValue.UserName -eq $desiredValue.UserName)
            {
                Write-Verbose -Message ($script:localizedData.MatchPsCredentialUsernameMessage -f $currentValue.UserName, $desiredValue.UserName)
                continue
            }
            else
            {
                Write-Verbose -Message ($script:localizedData.NoMatchPsCredentialUsernameMessage -f $currentValue.UserName, $desiredValue.UserName)
                $returnValue = $false
            }

            # Assume the string is our username when the matching desired value is actually a credential
            if ($currentType.Name -eq 'string' -and $currentValue -eq $desiredValue.UserName)
            {
                Write-Verbose -Message ($script:localizedData.MatchPsCredentialUsernameMessage -f $currentValue, $desiredValue.UserName)
                continue
            }
            else
            {
                Write-Verbose -Message ($script:localizedData.NoMatchPsCredentialUsernameMessage -f $currentValue, $desiredValue.UserName)
                $returnValue = $false
            }
        }

        if (-not $TurnOffTypeChecking)
        {
            if (($desiredType.Name -ne 'Unknown' -and $currentType.Name -ne 'Unknown') -and
                $desiredType.FullName -ne $currentType.FullName)
            {
                Write-Verbose -Message ($script:localizedData.NoMatchTypeMismatchMessage -f $key, $currentType.Name, $desiredType.Name)
                $returnValue = $false
                continue
            }
        }

        if ($currentValue -eq $desiredValue -and -not $desiredType.IsArray)
        {
            Write-Verbose -Message ($script:localizedData.MatchValueMessage -f $desiredType.Name, $key, $currentValue, $desiredValue)
            continue
        }

        if ($desiredValuesClean.GetType().Name -in 'HashTable', 'PSBoundParametersDictionary')
        {
            $checkDesiredValue = $desiredValuesClean.ContainsKey($key)
        }
        else
        {
            $checkDesiredValue = Test-DscObjectHasProperty -Object $desiredValuesClean -PropertyName $key
        }

        if (-not $checkDesiredValue)
        {
            Write-Verbose -Message ($script:localizedData.MatchValueMessage -f $desiredType.Name, $key, $currentValue, $desiredValue)
            continue
        }

        if ($desiredType.IsArray)
        {
            Write-Verbose -Message ($script:localizedData.TestDscParameterCompareMessage -f $key)

            if (-not $currentValue)
            {
                Write-Verbose -Message ($script:localizedData.NoMatchValueMessage -f $desiredType.Name, $key, $currentValue, $desiredValue)
                $returnValue = $false
                continue
            }
            elseif ($currentValue.Count -ne $desiredValue.Count)
            {
                Write-Verbose -Message ($script:localizedData.NoMatchValueDifferentCountMessage -f $desiredType.Name, $key, $currentValue.Count, $desiredValue.Count)
                $returnValue = $false
                continue
            }
            else
            {
                $desiredArrayValues = $desiredValue
                $currentArrayValues = $currentValue

                if ($SortArrayValues)
                {
                    $desiredArrayValues = $desiredArrayValues | Sort-Object
                    $currentArrayValues = $currentArrayValues | Sort-Object
                }

                for ($i = 0; $i -lt $desiredArrayValues.Count; $i++)
                {
                    if ($null -ne $desiredArrayValues[$i])
                    {
                        $desiredType = $desiredArrayValues[$i].GetType()
                    }
                    else
                    {
                        $desiredType = @{
                            Name = 'Unknown'
                        }
                    }

                    if ($null -ne $currentArrayValues[$i])
                    {
                        $currentType = $currentArrayValues[$i].GetType()
                    }
                    else
                    {
                        $currentType = @{
                            Name = 'Unknown'
                        }
                    }

                    if (-not $TurnOffTypeChecking)
                    {
                        if (($desiredType.Name -ne 'Unknown' -and $currentType.Name -ne 'Unknown') -and
                            $desiredType.FullName -ne $currentType.FullName)
                        {
                            Write-Verbose -Message ($script:localizedData.NoMatchElementTypeMismatchMessage -f $key, $i, $currentType.Name, $desiredType.Name)
                            $returnValue = $false
                            continue
                        }
                    }

                    if ($desiredArrayValues[$i] -ne $currentArrayValues[$i])
                    {
                        Write-Verbose -Message ($script:localizedData.NoMatchElementValueMismatchMessage -f $i, $desiredType.Name, $key, $currentArrayValues[$i], $desiredArrayValues[$i])
                        $returnValue = $false
                        continue
                    }
                    else
                    {
                        Write-Verbose -Message ($script:localizedData.MatchElementValueMessage -f $i, $desiredType.Name, $key, $currentArrayValues[$i], $desiredArrayValues[$i])
                        continue
                    }
                }

            }
        }
        elseif ($desiredType -eq [System.Collections.Hashtable] -and $currentType -eq [System.Collections.Hashtable])
        {
            $param = $PSBoundParameters
            $param.CurrentValues = $currentValue
            $param.DesiredValues = $desiredValue
            [void]$param.Remove('ValuesToCheck')
            if ($returnValue)
            {
                $returnValue = Test-DscParameterState @param
            }
            else
            {
                Test-DscParameterState @param | Out-Null
            }
            continue
        }
        else
        {
            if ($desiredValue -ne $currentValue)
            {
                Write-Verbose -Message ($script:localizedData.NoMatchValueMessage -f $desiredType.Name, $key, $currentValue, $desiredValue)
                $returnValue = $false
            }
        }
    }

    if ($ReverseCheck)
    {
        Write-Verbose -Message $script:localizedData.StartingReverseCheck
        $reverseCheckParameters = $PSBoundParameters
        $reverseCheckParameters.CurrentValues = $DesiredValues
        $reverseCheckParameters.DesiredValues = $CurrentValues
        [void] $reverseCheckParameters.Remove('ReverseCheck')
        if ($returnValue)
        {
            $returnValue = Test-DscParameterState @reverseCheckParameters
        }
        else
        {
            Test-DscParameterState @reverseCheckParameters | Out-Null
        }
    }

    Write-Verbose -Message ($script:localizedData.TestDscParameterResultMessage -f $returnValue)
    return $returnValue
}

<#
        .SYNOPSIS
        Tests of an object has a property

        .PARAMETER Object
        The object to test

        .PARAMETER PropertyName
        The property name
#>
function Test-DscObjectHasProperty
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Object,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PropertyName
    )

    if ($Object.PSObject.Properties.Name -contains $PropertyName)
    {
        return [System.Boolean] $Object.$PropertyName
    }

    return $false
}

<#
        .SYNOPSIS
        Converts a hashtable into a CimInstance array.

        .DESCRIPTION
        This function is used to convert a hashtable into MSFT_KeyValuePair objects. These are stored as an CimInstance array.
        DSC cannot handle hashtables but CimInstances arrays storing MSFT_KeyValuePair.

        .PARAMETER Hashtable
        A hashtable with the values to convert.

        .OUTPUTS
        An object array with CimInstance objects.
#>
function ConvertTo-CimInstance
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Collections.Hashtable]
        $Hashtable
    )

    process
    {
        foreach ($item in $Hashtable.GetEnumerator())
        {
            New-CimInstance -ClassName MSFT_KeyValuePair -Namespace root/microsoft/Windows/DesiredStateConfiguration -Property @{
                Key   = $item.Key
                Value = if ($item.Value -is [array])
                {
                    $item.Value -join ','
                }
                else
                {
                    $item.Value
                }
            } -ClientOnly
        }
    }
}

<#
        .SYNOPSIS
        Converts CimInstances into a hashtable.

        .DESCRIPTION
        This function is used to convert a CimInstance array containing MSFT_KeyValuePair objects into a hashtable.

        .PARAMETER CimInstance
        An array of CimInstances or a single CimInstance object to convert.

        .OUTPUTS
        Hashtable
#>
function ConvertTo-HashTable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [AllowEmptyCollection()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CimInstance
    )

    begin
    {
        $result = @{ }
    }

    process
    {
        foreach ($ci in $CimInstance)
        {
            $result.Add($ci.Key, $ci.Value)
        }
    }

    end
    {
        $result
    }
}

<#
        .SYNOPSIS
        Converts root hints like the DNS cmdlets are run.

        .DESCRIPTION
        This function is used to convert a CimInstance array containing MSFT_KeyValuePair objects into a hashtable.

        .PARAMETER CimInstance
        An array of CimInstances or a single CimInstance object to convert.

        .OUTPUTS
        Hashtable
#>

function Convert-RootHintsToHashtable
{
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        [AllowEmptyCollection()]
        $RootHints
    )

    $r = @{ }
    foreach ($rootHint in $RootHints)
    {
        if (-not $rootHint.IPAddress)
        {
            continue
        }
        $ip = if ($rootHint.IPAddress.RecordData.IPv4Address)
        {
            $rootHint.IPAddress.RecordData.IPv4Address.IPAddressToString -join ','
        }
        else
        {
            $rootHint.IPAddress.RecordData.IPv6Address.IPAddressToString -join ','
        }
        $r.Add($rootHint.NameServer.RecordData.NameServer, $ip)
    }

    $r
}

# Import Localization Strings
$script:localizedData = Get-LocalizedData -ResourceName Helper -ScriptRoot $PSScriptRoot
