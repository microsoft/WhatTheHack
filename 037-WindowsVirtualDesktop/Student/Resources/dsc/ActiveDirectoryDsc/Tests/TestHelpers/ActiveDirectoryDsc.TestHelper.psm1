<#
    .SYNOPSIS
        Returns $true if the the environment variable APPVEYOR is set to $true,
        and the environment variable CONFIGURATION is set to the value passed
        in the parameter Type.

    .PARAMETER Name
        Name of the test script that is called. Defaults to the name of the
        calling script.

    .PARAMETER Type
        Type of tests in the test file. Can be set to Unit or Integration.

    .PARAMETER Category
        Optional. One or more categories to check if they are set in
        $env:CONFIGURATION. If this are not set, the parameter Type
        is used as category.
#>
function Test-RunForCITestCategory
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name = $MyInvocation.PSCommandPath.Split('\')[-1],

        [Parameter(Mandatory = $true)]
        [ValidateSet('Unit', 'Integration')]
        [System.String]
        $Type,

        [Parameter()]
        [System.String[]]
        $Category
    )

    # Support the use of having the Type parameter as the only category names.
    if (-not $Category)
    {
        $Category = @($Type)
    }

    $result = $true

    if ($Type -eq 'Integration' -and -not $env:CI -eq $true)
    {
        Write-Warning -Message ('{0} test for {1} will be skipped unless $env:CI is set to $true' -f $Type, $Name)
        $result = $false
    }

    if (-not (Test-ContinuousIntegrationTaskCategory -Category $Category))
    {
        Write-Verbose -Message ('Tests in category ''{0}'' will be skipped unless $env:CONFIGURATION is set to ''{0}''.' -f ($Category -join ''', or '''), $Name) -Verbose
        $result = $false
    }

    return $result
}

<#
    .SYNOPSIS
        Returns $true if the the environment variable CI is set to $true,
        and the environment variable CONFIGURATION is set to the value passed
        in the parameter Type.

    .PARAMETER Category
        One or more categories to check if they are set in $env:CONFIGURATION.
#>
function Test-ContinuousIntegrationTaskCategory
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String[]]
        $Category
    )

    $result = $true

    if ($env:CI -eq $true -and $env:CONFIGURATION -notin $Category)
    {
        $result = $false
    }

    return $result
}
