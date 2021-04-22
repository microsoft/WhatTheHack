$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

<#
    Import CommonResourceHelper for:
        Get-LocalizedData,
        Test-IsNanoServer,
        New-InvalidOperationException,
        New-InvalidArgumentException
#>
$script:dscResourcesFolderFilePath = Split-Path $PSScriptRoot -Parent
$script:commonResourceHelperFilePath = Join-Path -Path $script:dscResourcesFolderFilePath -ChildPath 'CommonResourceHelper.psm1'
Import-Module -Name $script:commonResourceHelperFilePath

# Localized messages for verbose and error statements in this resource
$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_Archive'

# Import Microsoft.PowerShell.Utility for Get-FileHash
$fileHashCommand = Get-Command -Name 'Get-FileHash' -Module 'Microsoft.PowerShell.Utility' -ErrorAction 'SilentlyContinue'
if ($null -eq $fileHashCommand)
{
    Import-Module -Name 'Microsoft.PowerShell.Utility' -Function 'Get-FileHash'
}

Add-Type -AssemblyName 'System.IO.Compression'

# This resource has not yet been tested on a Nano server.
if (-not (Test-IsNanoServer))
{
    Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
}

<#
    .SYNOPSIS
        Retrieves the current state of the archive resource with the specified path and
        destination.

        The returned object provides the following properties:
            Path: The specified path.
            Destination: The specified destination.
            Ensure: Present if the archive at the specified path is expanded at the specified
                destination. Absent if the archive at the specified path is not expanded at the
                specified destination.

    .PARAMETER Path
        The path to the archive file that should or should not be expanded at the specified
        destination.

    .PARAMETER Destination
        The path where the archive file should or should not be expanded.

    .PARAMETER Validate
        Specifies whether or not to validate that a file at the destination with the same name as a
        file in the archive actually matches that corresponding file in the archive by the
        specified checksum method.

        If a file does not match it will be considered not present.

        The default value is false.

    .PARAMETER Checksum
        The Checksum method to use to validate whether or not a file at the destination with the
        same name as a file in the archive actually matches that corresponding file in the archive.

        An invalid argument exception will be thrown if Checksum is specified while Validate is
        specified as false.

        ModifiedDate will check that the LastWriteTime property of the file at the destination
        matches the LastWriteTime property of the file in the archive.
        CreatedDate will check that the CreationTime property of the file at the destination
        matches the CreationTime property of the file in the archive.
        SHA-1, SHA-256, and SHA-512 will check that the hash of the file at the destination by the
        specified SHA method matches the hash of the file in the archive by the specified SHA
        method.

        The default value is ModifiedDate.

    .PARAMETER Credential
        The credential of a user account with permissions to access the specified archive path and
        destination if needed.
#>
function Get-TargetResource
{
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Destination,

        [Parameter()]
        [System.Boolean]
        $Validate = $false,

        [Parameter()]
        [ValidateSet('SHA-1', 'SHA-256', 'SHA-512', 'CreatedDate', 'ModifiedDate')]
        [System.String]
        $Checksum = 'ModifiedDate',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    if ($PSBoundParameters.ContainsKey('Checksum') -and -not $Validate)
    {
        $errorMessage = $script:localizedData.ChecksumSpecifiedAndValidateFalse -f $Checksum, $Path, $Destination
        New-InvalidArgumentException -ArgumentName 'Checksum or Validate' -Message $errorMessage
    }

    $archiveState = @{
        Path = $Path
        Destination = $Destination
    }

    # In case an error occurs, we assume that the archive is not expanded at the destination
    $archiveExpandedAtDestination = $false

    $psDrive = $null

    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        $psDrive = Mount-PSDriveWithCredential -Path $Path -Credential $Credential
    }

    try
    {
        Assert-PathExistsAsLeaf -Path $Path
        Assert-DestinationDoesNotExistAsFile -Destination $Destination

        Write-Verbose -Message ($script:localizedData.RetrievingArchiveState -f $Path, $Destination)

        $testArchiveExistsAtDestinationParameters = @{
            ArchiveSourcePath = $Path
            Destination = $Destination
        }

        if ($Validate)
        {
            $testArchiveExistsAtDestinationParameters['Checksum'] = $Checksum
        }

        if (Test-Path -LiteralPath $Destination)
        {
            Write-Verbose -Message ($script:localizedData.DestinationExists -f $Destination)

            $archiveExpandedAtDestination = Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters
        }
        else
        {
            Write-Verbose -Message ($script:localizedData.DestinationDoesNotExist -f $Destination)
        }
    }
    finally
    {
        if ($null -ne $psDrive)
        {
            Write-Verbose -Message ($script:localizedData.RemovingPSDrive -f $psDrive.Root)

            $null = Remove-PSDrive -Name $psDrive -Force -ErrorAction 'SilentlyContinue'
        }
    }

    if ($archiveExpandedAtDestination)
    {
        $archiveState['Ensure'] = 'Present'
    }
    else
    {
        $archiveState['Ensure'] = 'Absent'
    }

    return $archiveState
}

<#
    .SYNOPSIS
        Expands the archive (.zip) file at the specified path to the specified destination or
        removes the expanded archive (.zip) file at the specified path from the specified
        destination.

    .PARAMETER Path
        The path to the archive file that should be expanded to or removed from the specified
        destination.

    .PARAMETER Destination
        The path where the specified archive file should be expanded to or removed from.

    .PARAMETER Ensure
        Specifies whether or not the expanded content of the archive file at the specified path
        should exist at the specified destination.

        To update the specified destination to have the expanded content of the archive file at the
        specified path, specify this property as Present.
        To remove the expanded content of the archive file at the specified path from the specified
        destination, specify this property as Absent.

        The default value is Present.

    .PARAMETER Validate
        Specifies whether or not to validate that a file at the destination with the same name as a
        file in the archive actually matches that corresponding file in the archive by the
        specified checksum method.

        If the file does not match and Ensure is specified as Present and Force is not specified,
        the resource will throw an error that the file at the destination cannot be overwritten.
        If the file does not match and Ensure is specified as Present and Force is specified, the
        file at the destination will be overwritten.
        If the file does not match and Ensure is specified as Absent, the file at the destination
        will not be removed.

        The default value is false.

    .PARAMETER Checksum
        The Checksum method to use to validate whether or not a file at the destination with the
        same name as a file in the archive actually matches that corresponding file in the archive.

        An invalid argument exception will be thrown if Checksum is specified while Validate is
        specified as false.

        ModifiedDate will check that the LastWriteTime property of the file at the destination
        matches the LastWriteTime property of the file in the archive.
        CreatedDate will check that the CreationTime property of the file at the destination
        matches the CreationTime property of the file in the archive.
        SHA-1, SHA-256, and SHA-512 will check that the hash of the file at the destination by the
        specified SHA method matches the hash of the file in the archive by the specified SHA
        method.

        The default value is ModifiedDate.

    .PARAMETER Credential
        The credential of a user account with permissions to access the specified archive path and
        destination if needed.

    .PARAMETER Force
        Specifies whether or not any existing files or directories at the destination with the same
        name as a file or directory in the archive should be overwritten to match the file or
        directory in the archive.

        When this property is false, an error will be thrown if an item at the destination needs to
        be overwritten.

        The default value is false.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Destination,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Boolean]
        $Validate = $false,

        [Parameter()]
        [ValidateSet('SHA-1', 'SHA-256', 'SHA-512', 'CreatedDate', 'ModifiedDate')]
        [System.String]
        $Checksum = 'ModifiedDate',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.Boolean]
        $Force = $false
    )

    if ($PSBoundParameters.ContainsKey('Checksum') -and -not $Validate)
    {
        $errorMessage = $script:localizedData.ChecksumSpecifiedAndValidateFalse -f $Checksum, $Path, $Destination
        New-InvalidArgumentException -ArgumentName 'Checksum or Validate' -Message $errorMessage
    }

    $psDrive = $null

    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        $psDrive = Mount-PSDriveWithCredential -Path $Path -Credential $Credential
    }

    try
    {
        Assert-PathExistsAsLeaf -Path $Path
        Assert-DestinationDoesNotExistAsFile -Destination $Destination

        Write-Verbose -Message ($script:localizedData.SettingArchiveState -f $Path, $Destination)

        $expandArchiveToDestinationParameters = @{
            ArchiveSourcePath = $Path
            Destination = $Destination
            Force = $Force
        }

        $removeArchiveFromDestinationParameters = @{
            ArchiveSourcePath = $Path
            Destination = $Destination
        }

        if ($Validate)
        {
            $expandArchiveToDestinationParameters['Checksum'] = $Checksum
            $removeArchiveFromDestinationParameters['Checksum'] = $Checksum
        }

        if (Test-Path -LiteralPath $Destination)
        {
            Write-Verbose -Message ($script:localizedData.DestinationExists -f $Destination)

            if ($Ensure -eq 'Present')
            {
                Expand-ArchiveToDestination @expandArchiveToDestinationParameters
            }
            else
            {
                Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters
            }
        }
        else
        {
            Write-Verbose -Message ($script:localizedData.DestinationDoesNotExist -f $Destination)

            if ($Ensure -eq 'Present')
            {
                Write-Verbose -Message ($script:localizedData.CreatingDirectoryAtDestination -f $Destination)

                $null = New-Item -Path $Destination -ItemType 'Directory'
                Expand-ArchiveToDestination @expandArchiveToDestinationParameters
            }
        }

        Write-Verbose -Message ($script:localizedData.ArchiveStateSet -f $Path, $Destination)
    }
    finally
    {
        if ($null -ne $psDrive)
        {
            Write-Verbose -Message ($script:localizedData.RemovingPSDrive -f $psDrive.Root)

            $null = Remove-PSDrive -Name $psDrive -Force -ErrorAction 'SilentlyContinue'
        }
    }
}

<#
    .SYNOPSIS
        Tests whether or not the archive (.zip) file at the specified path is expanded at the
        specified destination.

    .PARAMETER Path
        The path to the archive file that should or should not be expanded at the specified
        destination.

    .PARAMETER Destination
        The path where the archive file should or should not be expanded.

    .PARAMETER Ensure
        Specifies whether or not the archive file should be expanded to the specified destination.

        To test whether the archive file is expanded at the specified destination, specify this
        property as Present.
        To test whether the archive file is not expanded at the specified destination, specify this
        property as Absent.

        The default value is Present.

    .PARAMETER Validate
        Specifies whether or not to validate that a file at the destination with the same name as a
        file in the archive actually matches that corresponding file in the archive by the
        specified checksum method.

        If a file does not match it will be considered not present.

        The default value is false.

    .PARAMETER Checksum
        The Checksum method to use to validate whether or not a file at the destination with the
        same name as a file in the archive actually matches that corresponding file in the archive.

        An invalid argument exception will be thrown if Checksum is specified while Validate is
        specified as false.

        ModifiedDate will check that the LastWriteTime property of the file at the destination
        matches the LastWriteTime property of the file in the archive.
        CreatedDate will check that the CreationTime property of the file at the destination
        matches the CreationTime property of the file in the archive.
        SHA-1, SHA-256, and SHA-512 will check that the hash of the file at the destination by the
        specified SHA method matches the hash of the file in the archive by the specified SHA
        method.

        The default value is ModifiedDate.

    .PARAMETER Credential
        The credential of a user account with permissions to access the specified archive path and
        destination if needed.

    .PARAMETER Force
        Not used in Test-TargetResource.
#>
function Test-TargetResource
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Destination,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Boolean]
        $Validate = $false,

        [Parameter()]
        [ValidateSet('SHA-1', 'SHA-256', 'SHA-512', 'CreatedDate', 'ModifiedDate')]
        [System.String]
        $Checksum = 'ModifiedDate',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.Boolean]
        $Force = $false
    )

    $getTargetResourceParameters = @{
        Path = $Path
        Destination = $Destination
    }

    $optionalGetTargetResourceParameters = @( 'Validate', 'Checksum', 'Credential' )

    foreach ($optionalGetTargetResourceParameter in $optionalGetTargetResourceParameters)
    {
        if ($PSBoundParameters.ContainsKey($optionalGetTargetResourceParameter))
        {
            $getTargetResourceParameters[$optionalGetTargetResourceParameter] = $PSBoundParameters[$optionalGetTargetResourceParameter]
        }
    }

    $archiveResourceState = Get-TargetResource @getTargetResourceParameters

    Write-Verbose -Message ($script:localizedData.TestingArchiveState -f $Path, $Destination)

    $archiveInDesiredState = $archiveResourceState.Ensure -ieq $Ensure

    return $archiveInDesiredState
}

<#
    .SYNOPSIS
        Creates a new GUID.
        This is a wrapper function for unit testing.
#>
function New-Guid
{
    [OutputType([System.Guid])]
    [CmdletBinding()]
    param ()

    return [System.Guid]::NewGuid()
}

<#
    .SYNOPSIS
        Invokes the cmdlet New-PSDrive with the specified parameters.
        This is a wrapper function for unit testing due to a bug in Pester.
        Issue has been filed here: https://github.com/pester/Pester/issues/728

    .PARAMETER Parameters
        A hashtable of parameters to splat to New-PSDrive.
#>
function Invoke-NewPSDrive
{
    [OutputType([System.Management.Automation.PSDriveInfo])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Collections.Hashtable]
        $Parameters
    )

    return New-PSDrive @Parameters
}

<#
    .SYNOPSIS
        Mounts a PSDrive to access the specified path with the permissions granted by the specified
        credential.

    .PARAMETER Path
        The path to which to mount a PSDrive.

    .PARAMETER Credential
        The credential of the user account with permissions to access the specified path.
#>
function Mount-PSDriveWithCredential
{
    [OutputType([System.Management.Automation.PSDriveInfo])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    $newPSDrive = $null

    if (Test-Path -LiteralPath $Path -ErrorAction 'SilentlyContinue')
    {
        Write-Verbose -Message ($script:localizedData.PathAccessiblePSDriveNotNeeded -f $Path)
    }
    else
    {
        $pathIsADirectory = $Path.EndsWith('\')

        if ($pathIsADirectory)
        {
            $pathToPSDriveRoot = $Path
        }
        else
        {
            $lastIndexOfBackslash = $Path.LastIndexOf('\')
            $pathDoesNotContainADirectory = $lastIndexOfBackslash -eq -1

            if ($pathDoesNotContainADirectory)
            {
                $errorMessage = $script:localizedData.PathDoesNotContainValidPSDriveRoot -f $Path
                New-InvalidArgumentException -ArgumentName 'Path' -Message $errorMessage
            }
            else
            {
                $pathToPSDriveRoot = $Path.Substring(0, $lastIndexOfBackslash)
            }
        }

        $newPSDriveParameters = @{
            Name = New-Guid
            PSProvider = 'FileSystem'
            Root = $pathToPSDriveRoot
            Scope = 'Script'
            Credential = $Credential
        }

        try
        {
            Write-Verbose -Message ($script:localizedData.CreatingPSDrive -f $pathToPSDriveRoot, $Credential.UserName)
            $newPSDrive = Invoke-NewPSDrive -Parameters $newPSDriveParameters
        }
        catch
        {
            $errorMessage = $script:localizedData.ErrorCreatingPSDrive -f $pathToPSDriveRoot, $Credential.UserName
            New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
        }
    }

    return $newPSDrive
}

<#
    .SYNOPSIS
        Throws an invalid argument exception if the specified path does not exist or is not a path
        leaf.

    .PARAMETER Path
        The path to assert.
#>
function Assert-PathExistsAsLeaf
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path
    )

    $pathExistsAsLeaf = Test-Path -LiteralPath $Path -PathType 'Leaf' -ErrorAction 'SilentlyContinue'

    if (-not $pathExistsAsLeaf)
    {
        $errorMessage = $script:localizedData.PathDoesNotExistAsLeaf -f $Path
        New-InvalidArgumentException -ArgumentName 'Path' -Message $errorMessage
    }
}

<#
    .SYNOPSIS
        Throws an invalid argument exception if the specified destination path already exists as a
        file.

    .PARAMETER Destination
        The destination path to assert.
#>
function Assert-DestinationDoesNotExistAsFile
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Destination
    )

    $itemAtDestination = Get-Item -LiteralPath $Destination -ErrorAction 'SilentlyContinue'

    $itemAtDestinationExists = $null -ne $itemAtDestination
    $itemAtDestinationIsFile = $itemAtDestination -is [System.IO.FileInfo]

    if ($itemAtDestinationExists -and $itemAtDestinationIsFile)
    {
        $errorMessage = $script:localizedData.DestinationExistsAsFile -f $Destination
        New-InvalidArgumentException -ArgumentName 'Destination' -Message $errorMessage
    }
}

<#
    .SYNOPSIS
        Opens the archive at the given path.
        This is a wrapper function for unit testing.

    .PARAMETER Path
        The path to the archive to open.
#>
function Open-Archive
{
    [OutputType([System.IO.Compression.ZipArchive])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path
    )

    Write-Verbose -Message ($script:localizedData.OpeningArchive -f $Path)

    try
    {
        $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
    }
    catch
    {
        $errorMessage = $script:localizedData.ErrorOpeningArchive -f $Path
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }

    return $archive
}

<#
    .SYNOPSIS
        Closes the specified archive.
        This is a wrapper function for unit testing.

    .PARAMETER Archive
        The archive to close.
#>
function Close-Archive
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Compression.ZipArchive]
        $Archive
    )

    Write-Verbose -Message ($script:localizedData.ClosingArchive -f $Path)
    $null = $Archive.Dispose()
}

<#
    .SYNOPSIS
        Retrieves the archive entries from the specified archive.
        This is a wrapper function for unit testing.

    .PARAMETER Archive
        The archive of which to retrieve the archive entries.
#>
function Get-ArchiveEntries
{
    [OutputType([System.IO.Compression.ZipArchiveEntry[]])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Compression.ZipArchive]
        $Archive
    )

    return $Archive.Entries
}

<#
    .SYNOPSIS
        Retrieves the full name of the specified archive entry.
        This is a wrapper function for unit testing.

    .PARAMETER ArchiveEntry
        The archive entry to retrieve the full name of.
#>
function Get-ArchiveEntryFullName
{
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Compression.ZipArchiveEntry]
        $ArchiveEntry
    )

    return $ArchiveEntry.FullName
}

<#
    .SYNOPSIS
        Opens the specified archive entry.
        This is a wrapper function for unit testing.

    .PARAMETER ArchiveEntry
        The archive entry to open.
#>
function Open-ArchiveEntry
{
    [OutputType([System.IO.Stream])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Compression.ZipArchiveEntry]
        $ArchiveEntry
    )

    Write-Verbose -Message ($script:localizedData.OpeningArchiveEntry -f $ArchiveEntry.FullName)
    return $ArchiveEntry.Open()
}

<#
    .SYNOPSIS
        Closes the specified stream.
        This is a wrapper function for unit testing.

    .PARAMETER Stream
        The stream to close.
#>
function Close-Stream
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Stream]
        $Stream
    )

    $null = $Stream.Dispose()
}

<#
    .SYNOPSIS
        Tests if the given checksum method name is the name of a SHA checksum method.

    .PARAMETER Checksum
        The name of the checksum method to test.
#>
function Test-ChecksumIsSha
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Checksum
    )

    return ($Checksum.Length -ge 'SHA'.Length) -and ($Checksum.Substring(0, 3) -ieq 'SHA')
}

<#
    .SYNOPSIS
        Converts the specified DSC hash algorithm name (with a hyphen) to a PowerShell hash
        algorithm name (without a hyphen). The in-box PowerShell Get-FileHash cmdlet will only hash
        algorithm names without hypens.

    .PARAMETER DscHashAlgorithmName
        The DSC hash algorithm name to convert.
#>
function ConvertTo-PowerShellHashAlgorithmName
{
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DscHashAlgorithmName
    )

    return $DscHashAlgorithmName.Replace('-', '')
}

<#
    .SYNOPSIS
        Tests if the hash of the specified file matches the hash of the specified archive entry
        using the specified hash algorithm.

    .PARAMETER FilePath
        The path to the file to test the hash of.

    .PARAMETER CacheEntry
        The cache entry to test the hash of.

    .PARAMETER HashAlgorithmName
        The name of the hash algorithm to use to retrieve the hashes of the file and archive entry.
#>
function Test-FileHashMatchesArchiveEntryHash
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $FilePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Compression.ZipArchiveEntry]
        $ArchiveEntry,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $HashAlgorithmName
    )

    $archiveEntryFullName = Get-ArchiveEntryFullName -ArchiveEntry $ArchiveEntry

    Write-Verbose -Message ($script:localizedData.ComparingHashes -f $FilePath, $archiveEntryFullName, $HashAlgorithmName)

    $fileHashMatchesArchiveEntryHash = $false

    $powerShellHashAlgorithmName = ConvertTo-PowerShellHashAlgorithmName -DscHashAlgorithmName $HashAlgorithmName

    $openStreams = @()

    try
    {
        $archiveEntryStream = Open-ArchiveEntry -ArchiveEntry $ArchiveEntry
        $openStreams += $archiveEntryStream

        # The Open mode will open the file for reading without modifying the file
        $fileStreamMode = [System.IO.FileMode]::Open

        $fileStream = New-Object -TypeName 'System.IO.FileStream' -ArgumentList @( $FilePath, $fileStreamMode )
        $openStreams += $fileStream

        $fileHash = Get-FileHash -InputStream $fileStream -Algorithm $powerShellHashAlgorithmName
        $archiveEntryHash = Get-FileHash -InputStream $archiveEntryStream -Algorithm $powerShellHashAlgorithmName

        $hashAlgorithmsMatch = $fileHash.Algorithm -eq $archiveEntryHash.Algorithm
        $hashesMatch = $fileHash.Hash -eq $archiveEntryHash.Hash

        $fileHashMatchesArchiveEntryHash = $hashAlgorithmsMatch -and $hashesMatch
    }
    catch
    {
        $errorMessage = $script:localizedData.ErrorComparingHashes -f $FilePath, $archiveEntryFullName, $HashAlgorithmName
        New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
    }
    finally
    {
        foreach ($openStream in $openStreams)
        {
            Close-Stream -Stream $openStream
        }
    }

    return $fileHashMatchesArchiveEntryHash
}

<#
    .SYNOPSIS
        Retrieves the timestamp of the specified file for the specified checksum method
        and returns it as a checksum.

    .PARAMETER File
        The file to retrieve the timestamp of.

    .PARAMETER Checksum
        The checksum method to retrieve the timestamp checksum for.

    .NOTES
        The returned string is file timestamp normalized to the format specified in
        ConvertTo-CheckSumFromDateTime.
#>
function Get-ChecksumFromFileTimestamp
{
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]
        $File,

        [Parameter(Mandatory = $true)]
        [ValidateSet('CreatedDate', 'ModifiedDate')]
        [System.String]
        $Checksum
    )

    $timestamp = Get-TimestampForChecksum @PSBoundParameters

    return ConvertTo-ChecksumFromDateTime -Date $timestamp
}

<#
    .SYNOPSIS
        Retrieves the timestamp of the specified file for the specified checksum method.

    .PARAMETER File
        The file to retrieve the timestamp of.

    .PARAMETER Checksum
        The checksum method to retrieve the timestamp for.
#>
function Get-TimestampForChecksum
{
    [OutputType([System.DateTime])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]
        $File,

        [Parameter(Mandatory = $true)]
        [ValidateSet('CreatedDate', 'ModifiedDate')]
        [System.String]
        $Checksum
    )

    if ($Checksum -ieq 'CreatedDate')
    {
        $relevantTimestamp = 'CreationTime'
    }
    elseif ($Checksum -ieq 'ModifiedDate')
    {
        $relevantTimestamp = 'LastWriteTime'
    }

    return Get-TimestampFromFile -File $File -Timestamp $relevantTimestamp
}

<#
    .SYNOPSIS
        Retrieves a timestamp of the specified file.

    .PARAMETER File
        The file to retrieve the timestamp from.

    .PARAMETER Timestamp
        The timestamp attribute to retrieve.
#>
function Get-TimestampFromFile
{
    [OutputType([System.Datetime])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]
        $File,

        [Parameter(Mandatory = $true)]
        [ValidateSet('CreationTime', 'LastWriteTime')]
        [System.String]
        $Timestamp
    )

    return $File.$Timestamp
}

<#
    .SYNOPSIS
        Converts a datetime object into the format used for a
        checksum.

    .PARAMETER Date
        The date to use to generate the checksum.

    .NOTES
        The returned date is normalized to the General (G) date format.
        https://technet.microsoft.com/en-us/library/ee692801.aspx

        Because the General (G) is localization specific a non-localization
        specific format such as ISO9660 could be used in future.
#>
function ConvertTo-ChecksumFromDateTime
{
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.DateTime]
        $Date
    )

    return Get-Date -Date $Date -Format 'G'
}

<#
    .SYNOPSIS
        Retrieves the last write time of the specified archive entry.
        This is a wrapper function for unit testing.

    .PARAMETER ArchiveEntry
        The archive entry to retrieve the last write time of.
#>
function Get-ArchiveEntryLastWriteTime
{
    [OutputType([System.DateTime])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Compression.ZipArchiveEntry]
        $ArchiveEntry
    )

    return $ArchiveEntry.LastWriteTime.DateTime
}

<#
    .SYNOPSIS
        Tests if the specified file matches the specified archive entry based on the specified
        checksum method.

    .PARAMETER File
        The file to test against the specified archive entry.

    .PARAMETER ArchiveEntry
        The archive entry to test against the specified file.

    .PARAMETER Checksum
        The checksum method to use to determine whether or not the specified file matches the
        specified archive entry.
#>
function Test-FileMatchesArchiveEntryByChecksum
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileInfo]
        $File,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Compression.ZipArchiveEntry]
        $ArchiveEntry,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Checksum
    )

    $archiveEntryFullName = Get-ArchiveEntryFullName -ArchiveEntry $ArchiveEntry

    Write-Verbose -Message ($script:localizedData.TestingIfFileMatchesArchiveEntryByChecksum -f $File.FullName, $archiveEntryFullName, $Checksum)

    $fileMatchesArchiveEntry = $false

    if (Test-ChecksumIsSha -Checksum $Checksum)
    {
        $fileHashMatchesArchiveEntryHash = Test-FileHashMatchesArchiveEntryHash -FilePath $File.FullName -ArchiveEntry $ArchiveEntry -HashAlgorithmName $Checksum

        if ($fileHashMatchesArchiveEntryHash)
        {
            Write-Verbose -Message ($script:localizedData.FileMatchesArchiveEntryByChecksum -f $File.FullName, $archiveEntryFullName, $Checksum)

            $fileMatchesArchiveEntry = $true
        }
        else
        {
            Write-Verbose -Message ($script:localizedData.FileDoesNotMatchArchiveEntryByChecksum -f $File.FullName, $archiveEntryFullName, $Checksum)
        }
    }
    else
    {
        $fileTimestampForChecksum = Get-ChecksumFromFileTimestamp -File $File -Checksum $Checksum

        $archiveEntryLastWriteTime = Get-ArchiveEntryLastWriteTime -ArchiveEntry $ArchiveEntry
        $archiveEntryLastWriteTimeChecksum = ConvertTo-CheckSumFromDateTime -Date $archiveEntryLastWriteTime

        if ($fileTimestampForChecksum.Equals($archiveEntryLastWriteTimeChecksum))
        {
            Write-Verbose -Message ($script:localizedData.FileMatchesArchiveEntryByChecksum -f $File.FullName, $archiveEntryFullName, $Checksum)

            $fileMatchesArchiveEntry = $true
        }
        else
        {
            Write-Verbose -Message ($script:localizedData.FileDoesNotMatchArchiveEntryByChecksum -f $File.FullName, $archiveEntryFullName, $Checksum)
        }
    }

    return $fileMatchesArchiveEntry
}

<#
    .SYNOPSIS
        Tests if the given archive entry name represents a directory.

    .PARAMETER ArchiveEntryName
        The archive entry name to test.
#>
function Test-ArchiveEntryIsDirectory
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ArchiveEntryName
    )

    return $ArchiveEntryName.EndsWith('\') -or $ArchiveEntryName.EndsWith('/')
}

<#
    .SYNOPSIS
        Tests if the specified archive exists in its expanded form at the destination.

    .PARAMETER Archive
        The archive to test for existence at the specified destination.

    .PARAMETER Destination
        The path to the destination to check for the presence of the expanded form of the specified
        archive.

    .PARAMETER Checksum
        The checksum method to use to determine whether a file in the archive matches a file at the
        destination.

        If not provided, only the existence of the items in the archive will be checked.
#>
function Test-ArchiveExistsAtDestination
{
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ArchiveSourcePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Destination,

        [Parameter()]
        [ValidateSet('SHA-1', 'SHA-256', 'SHA-512', 'CreatedDate', 'ModifiedDate')]
        [System.String]
        $Checksum
    )

    Write-Verbose -Message ($script:localizedData.TestingIfArchiveExistsAtDestination -f $Destination)

    $archiveExistsAtDestination = $true

    $archive = Open-Archive -Path $ArchiveSourcePath

    try
    {
        $archiveEntries = Get-ArchiveEntries -Archive $archive

        foreach ($archiveEntry in $archiveEntries)
        {
            $archiveEntryFullName = Get-ArchiveEntryFullName -ArchiveEntry $archiveEntry
            $archiveEntryPathAtDestination = Join-Path -Path $Destination -ChildPath $archiveEntryFullName

            $archiveEntryItemAtDestination = Get-Item -LiteralPath $archiveEntryPathAtDestination -ErrorAction 'SilentlyContinue'

            if ($null -eq $archiveEntryItemAtDestination)
            {
                Write-Verbose -Message ($script:localizedData.ItemWithArchiveEntryNameDoesNotExist -f $archiveEntryPathAtDestination)

                $archiveExistsAtDestination = $false
                break
            }
            else
            {
                Write-Verbose -Message ($script:localizedData.ItemWithArchiveEntryNameExists -f $archiveEntryPathAtDestination)

                if (Test-ArchiveEntryIsDirectory -ArchiveEntryName $archiveEntryFullName)
                {
                    if (-not ($archiveEntryItemAtDestination -is [System.IO.DirectoryInfo]))
                    {
                        Write-Verbose -Message ($script:localizedData.ItemWithArchiveEntryNameIsNotDirectory -f $archiveEntryPathAtDestination)

                        $archiveExistsAtDestination = $false
                        break
                    }
                }
                else
                {
                    if ($archiveEntryItemAtDestination -is [System.IO.FileInfo])
                    {
                        if ($PSBoundParameters.ContainsKey('Checksum'))
                        {
                            if (-not (Test-FileMatchesArchiveEntryByChecksum -File $archiveEntryItemAtDestination -ArchiveEntry $archiveEntry -Checksum $Checksum))
                            {
                                $archiveExistsAtDestination = $false
                                break
                            }
                        }
                    }
                    else
                    {
                        Write-Verbose -Message ($script:localizedData.ItemWithArchiveEntryNameIsNotFile -f $archiveEntryPathAtDestination)

                        $archiveExistsAtDestination = $false
                        break
                    }
                }
            }
        }
    }
    finally
    {
        Close-Archive -Archive $archive
    }

    if ($archiveExistsAtDestination)
    {
        Write-Verbose -Message ($script:localizedData.ArchiveExistsAtDestination -f $ArchiveSourcePath, $Destination)
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.ArchiveDoesNotExistAtDestination -f $ArchiveSourcePath, $Destination)
    }

    return $archiveExistsAtDestination
}

<#
    .SYNOPSIS
        Copies the contents of the specified source stream to the specified destination stream.
        This is a wrapper function for unit testing.

    .PARAMETER SourceStream
        The stream to copy from.

    .PARAMETER DestinationStream
        The stream to copy to.
#>
function Copy-FromStreamToStream
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Stream]
        $SourceStream,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Stream]
        $DestinationStream
    )

    $null = $SourceStream.CopyTo($DestinationStream)
}

<#
    .SYNOPSIS
        Copies the specified archive entry to the specified destination path.

    .PARAMETER ArchiveEntry
        The archive entry to copy to the destination.

    .PARAMETER DestinationPath
        The destination file path to copy the archive entry to.
#>
function Copy-ArchiveEntryToDestination
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.Compression.ZipArchiveEntry]
        $ArchiveEntry,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DestinationPath
    )

    $archiveEntryFullName = Get-ArchiveEntryFullName -ArchiveEntry $ArchiveEntry

    Write-Verbose -Message ($script:localizedData.CopyingArchiveEntryToDestination -f $archiveEntryFullName, $DestinationPath)

    if (Test-ArchiveEntryIsDirectory -ArchiveEntryName $archiveEntryFullName)
    {
        Write-Verbose -Message ($script:localizedData.CreatingArchiveEntryDirectory -f $DestinationPath)

        $null = New-Item -Path $DestinationPath -ItemType 'Directory'
    }
    else
    {
        $openStreams = @()

        try
        {
            $archiveEntryStream = Open-ArchiveEntry -ArchiveEntry $ArchiveEntry
            $openStreams += $archiveEntryStream

            # The Create mode will create a new file if it does not exist or overwrite the file if it already exists
            $destinationStreamMode = [System.IO.FileMode]::Create

            $destinationStream = New-Object -TypeName 'System.IO.FileStream' -ArgumentList @( $DestinationPath, $destinationStreamMode )
            $openStreams += $destinationStream

            Copy-FromStreamToStream -SourceStream $archiveEntryStream -DestinationStream $destinationStream
        }
        catch
        {
            $errorMessage = $script:localizedData.ErrorCopyingFromArchiveToDestination -f $DestinationPath
            New-InvalidOperationException -Message $errorMessage -ErrorRecord $_
        }
        finally
        {
            foreach ($openStream in $openStreams)
            {
                Close-Stream -Stream $openStream
            }
        }

        $null = New-Object -TypeName 'System.IO.FileInfo' -ArgumentList @( $DestinationPath )

        $updatedTimestamp = Get-ArchiveEntryLastWriteTime -ArchiveEntry $ArchiveEntry

        $null = Set-ItemProperty -LiteralPath $DestinationPath -Name 'LastWriteTime' -Value $updatedTimestamp
        $null = Set-ItemProperty -LiteralPath $DestinationPath -Name 'LastAccessTime' -Value $updatedTimestamp
        $null = Set-ItemProperty -LiteralPath $DestinationPath -Name 'CreationTime' -Value $updatedTimestamp
    }
}

<#
    .SYNOPSIS
        Expands the archive at the specified source path to the specified destination path.

    .PARAMETER ArchiveSourcePath
        The source path of the archive to expand to the specified destination path.

    .PARAMETER Destination
        The destination path at which to expand the archive at the specified source path.

    .PARAMETER Checksum
        The checksum method to use to determine if a file at the destination already matches a file
        in the archive.

    .PARAMETER Force
        Specifies whether or not to overwrite files that exist at the destination but do not match
        the file of the same name in the archive based on the specified checksum method.
#>
function Expand-ArchiveToDestination
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ArchiveSourcePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Destination,

        [Parameter()]
        [ValidateSet('SHA-1', 'SHA-256', 'SHA-512', 'CreatedDate', 'ModifiedDate')]
        [System.String]
        $Checksum,

        [Parameter()]
        [System.Boolean]
        $Force = $false
    )

    Write-Verbose -Message ($script:localizedData.ExpandingArchiveToDestination -f $ArchiveSourcePath, $Destination)

    $archive = Open-Archive -Path $ArchiveSourcePath

    try
    {
        $archiveEntries = Get-ArchiveEntries -Archive $archive

        foreach ($archiveEntry in $archiveEntries)
        {
            $archiveEntryFullName = Get-ArchiveEntryFullName -ArchiveEntry $archiveEntry
            $archiveEntryPathAtDestination = Join-Path -Path $Destination -ChildPath $archiveEntryFullName

            $archiveEntryIsDirectory = Test-ArchiveEntryIsDirectory -ArchiveEntryName $archiveEntryFullName

            $archiveEntryItemAtDestination = Get-Item -LiteralPath $archiveEntryPathAtDestination -ErrorAction 'SilentlyContinue'

            if ($null -eq $archiveEntryItemAtDestination)
            {
                Write-Verbose -Message ($script:localizedData.ItemWithArchiveEntryNameDoesNotExist -f $archiveEntryPathAtDestination)

                if (-not $archiveEntryIsDirectory)
                {
                    $parentDirectory = Split-Path -Path $archiveEntryPathAtDestination -Parent

                    if (-not (Test-Path -Path $parentDirectory))
                    {
                        Write-Verbose -Message ($script:localizedData.CreatingParentDirectory -f $parentDirectory)

                        $null = New-Item -Path $parentDirectory -ItemType 'Directory'
                    }
                }

                Copy-ArchiveEntryToDestination -ArchiveEntry $archiveEntry -DestinationPath $archiveEntryPathAtDestination
            }
            else
            {
                Write-Verbose -Message ($script:localizedData.ItemWithArchiveEntryNameExists -f $archiveEntryPathAtDestination)

                $overwriteArchiveEntry = $true

                if ($archiveEntryIsDirectory)
                {
                    $overwriteArchiveEntry = -not ($archiveEntryItemAtDestination -is [System.IO.DirectoryInfo])
                }
                elseif ($archiveEntryItemAtDestination -is [System.IO.FileInfo])
                {
                    if ($PSBoundParameters.ContainsKey('Checksum'))
                    {
                        $overwriteArchiveEntry = -not (Test-FileMatchesArchiveEntryByChecksum -File $archiveEntryItemAtDestination -ArchiveEntry $archiveEntry -Checksum $Checksum)
                    }
                    else
                    {
                        $overwriteArchiveEntry = $false
                    }
                }

                if ($overwriteArchiveEntry)
                {
                    if ($Force)
                    {
                        Write-Verbose -Message ($script:localizedData.OverwritingItem -f $archiveEntryPathAtDestination)

                        $null = Remove-Item -LiteralPath $archiveEntryPathAtDestination
                        Copy-ArchiveEntryToDestination -ArchiveEntry $archiveEntry -DestinationPath $archiveEntryPathAtDestination
                    }
                    else
                    {
                        New-InvalidOperationException -Message ($script:localizedData.ForceNotSpecifiedToOverwriteItem -f $archiveEntryPathAtDestination, $archiveEntryFullName)
                    }
                }
            }
        }
    }
    finally
    {
        Close-Archive -Archive $archive
    }
}

<#
    .SYNOPSIS
        Removes the specified directory from the specified destination path.

    .PARAMETER Directory
        The partial path under the destination path of the directory to remove.

    .PARAMETER Destination
        The destination from which to remove the directory.
#>
function Remove-DirectoryFromDestination
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $Directory,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Destination
    )

    # Sort-Object requires the use of a pipe to function properly
    $Directory = $Directory | Sort-Object -Descending -Unique

    foreach ($directoryToRemove in $Directory)
    {
        $directoryPathAtDestination = Join-Path -Path $Destination -ChildPath $directoryToRemove
        $directoryExists = Test-Path -LiteralPath $directoryPathAtDestination -PathType 'Container'

        if ($directoryExists)
        {
            $directoryChildItems = Get-ChildItem -LiteralPath $directoryPathAtDestination -ErrorAction 'SilentlyContinue'
            $directoryIsEmpty = $null -eq $directoryChildItems

            if ($directoryIsEmpty)
            {
                Write-Verbose -Message ($script:localizedData.RemovingDirectory -f $directoryPathAtDestination)

                $null = Remove-Item -LiteralPath $directoryPathAtDestination
            }
            else
            {
                Write-Verbose -Message ($script:localizedData.DirectoryIsNotEmpty -f $directoryPathAtDestination)
            }
        }
    }
}

<#
    .SYNOPSIS
        Removes the specified archive from the specified destination.

    .PARAMETER Archive
        The archive to remove from the specified destination.

    .PARAMETER Destination
        The path to the destination to remove the specified archive from.

    .PARAMETER Checksum
        The checksum method to use to determine whether a file in the archive matches a file at the
        destination.

        If not provided, only the existence of the items in the archive will be checked.
#>
function Remove-ArchiveFromDestination
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ArchiveSourcePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Destination,

        [Parameter()]
        [ValidateSet('SHA-1', 'SHA-256', 'SHA-512', 'CreatedDate', 'ModifiedDate')]
        [System.String]
        $Checksum
    )

    Write-Verbose -Message ($script:localizedData.RemovingArchiveFromDestination -f $Destination)

    $archive = Open-Archive -Path $ArchiveSourcePath

    try
    {
        $directoriesToRemove = @()

        $archiveEntries = Get-ArchiveEntries -Archive $archive

        foreach ($archiveEntry in $archiveEntries)
        {
            $archiveEntryFullName = Get-ArchiveEntryFullName -ArchiveEntry $archiveEntry
            $archiveEntryPathAtDestination = Join-Path -Path $Destination -ChildPath $archiveEntryFullName

            $archiveEntryIsDirectory = Test-ArchiveEntryIsDirectory -ArchiveEntryName $archiveEntryFullName

            $itemAtDestination = Get-Item -LiteralPath $archiveEntryPathAtDestination -ErrorAction 'SilentlyContinue'

            if ($null -eq $itemAtDestination)
            {
                Write-Verbose -Message ($script:localizedData.ItemWithArchiveEntryNameDoesNotExist -f $archiveEntryPathAtDestination)
            }
            else
            {
                Write-Verbose -Message ($script:localizedData.ItemWithArchiveEntryNameExists -f $archiveEntryPathAtDestination)

                $itemAtDestinationIsDirectory = $itemAtDestination -is [System.IO.DirectoryInfo]
                $itemAtDestinationIsFile = $itemAtDestination -is [System.IO.FileInfo]

                $removeArchiveEntry = $false

                if ($archiveEntryIsDirectory -and $itemAtDestinationIsDirectory)
                {
                    $removeArchiveEntry = $true
                    $directoriesToRemove += $archiveEntryFullName

                }
                elseif ((-not $archiveEntryIsDirectory) -and $itemAtDestinationIsFile)
                {
                    $removeArchiveEntry = $true

                    if ($PSBoundParameters.ContainsKey('Checksum'))
                    {
                        $removeArchiveEntry = Test-FileMatchesArchiveEntryByChecksum -File $itemAtDestination -ArchiveEntry $archiveEntry -Checksum $Checksum
                    }

                    if ($removeArchiveEntry)
                    {
                        Write-Verbose -Message ($script:localizedData.RemovingFile -f $archiveEntryPathAtDestination)
                        $null = Remove-Item -LiteralPath $archiveEntryPathAtDestination
                    }
                }
                else
                {
                    Write-Verbose -Message ($script:localizedData.CouldNotRemoveItemOfIncorrectType -f $archiveEntryPathAtDestination, $archiveEntryFullName)
                }

                if ($removeArchiveEntry)
                {
                    $parentDirectory = Split-Path -Path $archiveEntryFullName -Parent

                    while (-not [System.String]::IsNullOrEmpty($parentDirectory))
                    {
                        $directoriesToRemove += $parentDirectory
                        $parentDirectory = Split-Path -Path $parentDirectory -Parent
                    }
                }
            }
        }

        if ($directoriesToRemove.Count -gt 0)
        {
            $null = Remove-DirectoryFromDestination -Directory $directoriesToRemove -Destination $Destination
        }

        Write-Verbose -Message ($script:localizedData.ArchiveRemovedFromDestination -f $Destination)

    }
    finally
    {
        Close-Archive -Archive $archive
    }
}
