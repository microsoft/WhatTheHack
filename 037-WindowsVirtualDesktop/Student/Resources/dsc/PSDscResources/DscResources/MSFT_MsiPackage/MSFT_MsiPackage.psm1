# Suppress Global Vars PSSA Error because $global:DSCMachineStatus must be allowed
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
param()

$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

# Import CommonResourceHelper for Get-LocalizedData
$script:dscResourcesFolderFilePath = Split-Path $PSScriptRoot -Parent
$script:commonResourceHelperFilePath = Join-Path -Path $script:dscResourcesFolderFilePath -ChildPath 'CommonResourceHelper.psm1'
Import-Module -Name $script:commonResourceHelperFilePath

# Localized messages for verbose and error statements in this resource
$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_MsiPackage'

# Path to the directory where the files for a package from a file server will be downloaded to
$script:packageCacheLocation = "$env:ProgramData\Microsoft\Windows\PowerShell\Configuration\BuiltinProvCache\MSFT_MsiPackage"
$script:msiTools = $null

<#
    .SYNOPSIS
        Retrieves the current state of the MSI file with the given Product ID.

    .PARAMETER ProductId
        The ID of the MSI file to retrieve the state of, usually a GUID.

    .PARAMETER Path
        Not used in Get-TargetResource.
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
        $ProductId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path
    )

    $identifyingNumber = Convert-ProductIdToIdentifyingNumber -ProductId $ProductId

    $packageResourceResult = @{}

    $productEntry = Get-ProductEntry -IdentifyingNumber $identifyingNumber

    if ($null -eq $productEntry)
    {
        $packageResourceResult = @{
            Ensure = 'Absent'
            ProductId = $identifyingNumber
        }

        Write-Verbose -Message ($script:localizedData.GetTargetResourceNotFound -f $ProductId)
    }
    else
    {
        $packageResourceResult = Get-ProductEntryInfo -ProductEntry $productEntry
        $packageResourceResult['ProductId'] = $identifyingNumber
        $packageResourceResult['Ensure'] = 'Present'

        Write-Verbose -Message ($script:localizedData.GetTargetResourceFound -f $ProductId)
    }

    return $packageResourceResult
}

<#
    .SYNOPSIS
        Installs or uninstalls the MSI file at the given path.

    .PARAMETER ProductId
         The identifying number used to find the package, usually a GUID.

    .PARAMETER Path
        The path to the MSI file to install or uninstall.

    .PARAMETER Ensure
        Indicates whether the given MSI file should be installed or uninstalled.
        Set this property to Present to install the MSI, and Absent to uninstall
        the MSI.

    .PARAMETER Arguments
        The arguments to pass to the MSI package during installation or uninstallation
        if needed.

    .PARAMETER Credential
        The credential of a user account to be used to mount a UNC path if needed.

    .PARAMETER LogPath
        The path to the log file to log the output from the MSI execution.

    .PARAMETER FileHash
        The expected hash value of the MSI file at the given path.

    .PARAMETER HashAlgorithm
        The algorithm used to generate the given hash value.

    .PARAMETER SignerSubject
        The subject that should match the signer certificate of the digital signature of the MSI file.

    .PARAMETER SignerThumbprint
        The certificate thumbprint that should match the signer certificate of the digital signature of the MSI file.

    .PARAMETER ServerCertificateValidationCallback
        PowerShell code to be used to validate SSL certificates for paths using HTTPS.

    .PARAMETER RunAsCredential
        The credential of a user account under which to run the installation or uninstallation of the MSI package.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ProductId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $Arguments,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.String]
        $LogPath,

        [Parameter()]
        [System.String]
        $FileHash,

        [Parameter()]
        [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MD5', 'RIPEMD160')]
        [System.String]
        $HashAlgorithm = 'SHA256',

        [Parameter()]
        [System.String]
        $SignerSubject,

        [Parameter()]
        [System.String]
        $SignerThumbprint,

        [Parameter()]
        [System.String]
        $ServerCertificateValidationCallback,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $RunAsCredential
    )

    $uri = Convert-PathToUri -Path $Path
    $identifyingNumber = Convert-ProductIdToIdentifyingNumber -ProductId $ProductId

    # Ensure that the actual file extension is checked if a query string is passed in
    if ($null -ne $uri.LocalPath)
    {
        $uriLocalPath = (Split-Path -Path $uri.LocalPath -Leaf)
        Assert-PathExtensionValid -Path $uriLocalPath
    }
    else
    {
        Assert-PathExtensionValid -Path $Path
    }

    <#
        Path gets overwritten in the download code path. Retain the user's original Path so as
        to provide a more descriptive error message in case the install succeeds but the named
        package can't be found on the system afterward.
    #>
    $originalPath = $Path

    Write-Verbose -Message $script:localizedData.PackageConfigurationStarting

    $psDrive = $null
    $downloadedFileName = $null

    $exitCode = 0

    try
    {
        if ($PSBoundParameters.ContainsKey('LogPath'))
        {
            New-LogFile -LogPath $LogPath
        }

        # Download or mount file as necessary
        if ($Ensure -eq 'Present')
        {
            $localPath = $Path

            if ($null -ne $uri.LocalPath)
            {
                $localPath = $uri.LocalPath
            }

            if ($uri.IsUnc)
            {
                $psDriveArgs = @{
                    Name = [System.Guid]::NewGuid()
                    PSProvider = 'FileSystem'
                    Root = Split-Path -Path $localPath
                }

                if ($PSBoundParameters.ContainsKey('Credential'))
                {
                    $psDriveArgs['Credential'] = $Credential
                }

                $psDrive = New-PSDrive @psDriveArgs
                $Path = Join-Path -Path $psDrive.Root -ChildPath (Split-Path -Path $localPath -Leaf)
            }
            elseif (@( 'http', 'https' ) -contains $uri.Scheme)
            {
                $outStream = $null

                try
                {
                    if (-not (Test-Path -Path $script:packageCacheLocation -PathType 'Container'))
                    {
                        Write-Verbose -Message ($script:localizedData.CreatingCacheLocation)
                        $null = New-Item -Path $script:packageCacheLocation -ItemType 'Directory'
                    }

                    $destinationPath = Join-Path -Path $script:packageCacheLocation -ChildPath (Split-Path -Path $localPath -Leaf)

                    try
                    {
                        Write-Verbose -Message ($script:localizedData.CreatingTheDestinationCacheFile)
                        $outStream = New-Object -TypeName 'System.IO.FileStream' -ArgumentList @( $destinationPath, 'Create' )
                    }
                    catch
                    {
                        # Should never happen since we own the cache directory
                        New-InvalidOperationException -Message ($script:localizedData.CouldNotOpenDestFile -f $destinationPath) -ErrorRecord $_
                    }

                    try
                    {
                        $responseStream = Get-WebRequestResponse -Uri $uri -ServerCertificateValidationCallback $ServerCertificateValidationCallback

                        Copy-ResponseStreamToFileStream -ResponseStream $responseStream -FileStream $outStream
                    }
                    finally
                    {
                        if ((Test-Path -Path variable:responseStream) -and ($null -ne $responseStream))
                        {
                            Close-Stream -Stream $responseStream
                        }
                    }
                }
                finally
                {
                    if ($null -ne $outStream)
                    {
                        Close-Stream -Stream $outStream
                    }
                }

                Write-Verbose -Message ($script:localizedData.RedirectingPackagePathToCacheFileLocation)
                $Path = $destinationPath
                $downloadedFileName = $destinationPath
            }

            # At this point the Path should be valid if this is an install case
            if (-not (Test-Path -Path $Path -PathType 'Leaf'))
            {
                New-InvalidOperationException -Message ($script:localizedData.PathDoesNotExist -f $Path)
            }

            Assert-FileValid -Path $Path -HashAlgorithm $HashAlgorithm -FileHash $FileHash -SignerSubject $SignerSubject -SignerThumbprint $SignerThumbprint

            # Check if the MSI package specifies the ProductCode, and if so make sure they match
            $productCode = Get-MsiProductCode -Path $Path

            if ((-not [System.String]::IsNullOrEmpty($identifyingNumber)) -and ($identifyingNumber -ne $productCode))
            {
                New-InvalidArgumentException -ArgumentName 'ProductId' -Message ($script:localizedData.InvalidId -f $identifyingNumber, $productCode)
            }
        }

        $exitCode = Start-MsiProcess -IdentifyingNumber $identifyingNumber -Path $Path -Ensure $Ensure -Arguments $Arguments -LogPath $LogPath -RunAsCredential $RunAsCredential
    }
    finally
    {
        if ($null -ne $psDrive)
        {
            $null = Remove-PSDrive -Name $psDrive -Force
        }
    }

    if ($null -ne $downloadedFileName)
    {
        <#
            This is deliberately not in the finally block because we want to leave the downloaded
            file on disk if an error occurred as a debugging aid for the user.
        #>
        $null = Remove-Item -Path $downloadedFileName
    }

    <#
        Check if a reboot is required, if so notify CA. The MSFT_ServerManagerTasks provider is
        missing on some client SKUs (worked on both Server and Client Skus in Windows 10).
    #>
    $serverFeatureData = Invoke-CimMethod -Name 'GetServerFeature' `
                                          -Namespace 'root\microsoft\windows\servermanager' `
                                          -Class 'MSFT_ServerManagerTasks' `
                                          -Arguments @{ BatchSize = 256 } `
                                          -ErrorAction 'Ignore'

    $registryData = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'PendingFileRenameOperations' -ErrorAction 'Ignore'

    $rebootRequired = (($exitcode -eq 3010) -or ($exitcode -eq 1641) -or ($null -ne $registryData))

    if (($serverFeatureData -and $serverFeatureData.RequiresReboot) -or $rebootRequired)
    {
        Write-Verbose $script:localizedData.MachineRequiresReboot
        $global:DSCMachineStatus = 1
    }
    elseif ($Ensure -eq 'Present')
    {
        $productEntry = Get-ProductEntry -IdentifyingNumber $identifyingNumber

        if ($null -eq $productEntry)
        {
            New-InvalidOperationException -Message ($script:localizedData.PostValidationError -f $originalPath)
        }
    }

    if ($Ensure -eq 'Present')
    {
        Write-Verbose -Message $script:localizedData.PackageInstalled
    }
    else
    {
        Write-Verbose -Message $script:localizedData.PackageUninstalled
    }
}

<#
    .SYNOPSIS
        Tests if the MSI file with the given product ID is installed or uninstalled.

    .PARAMETER ProductId
        The identifying number used to find the package, usually a GUID.

    .PARAMETER Path
        Not Used in Test-TargetResource

    .PARAMETER Ensure
        Indicates whether the MSI file should be installed or uninstalled.
        Set this property to Present if the MSI file should be installed. Set
        this property to Absent if the MSI file should be uninstalled.

    .PARAMETER Arguments
        Not Used in Test-TargetResource

    .PARAMETER Credential
        Not Used in Test-TargetResource

    .PARAMETER LogPath
        Not Used in Test-TargetResource

    .PARAMETER FileHash
        Not Used in Test-TargetResource

    .PARAMETER HashAlgorithm
        Not Used in Test-TargetResource

    .PARAMETER SignerSubject
        Not Used in Test-TargetResource

    .PARAMETER SignerThumbprint
        Not Used in Test-TargetResource

    .PARAMETER ServerCertificateValidationCallback
        Not Used in Test-TargetResource

    .PARAMETER RunAsCredential
        Not Used in Test-TargetResource
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
        $ProductId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $Arguments,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.String]
        $LogPath,

        [Parameter()]
        [System.String]
        $FileHash,

        [Parameter()]
        [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MD5', 'RIPEMD160')]
        [System.String]
        $HashAlgorithm = 'SHA256',

        [Parameter()]
        [System.String]
        $SignerSubject,

        [Parameter()]
        [System.String]
        $SignerThumbprint,

        [Parameter()]
        [System.String]
        $ServerCertificateValidationCallback,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $RunAsCredential
    )

    $identifyingNumber = Convert-ProductIdToIdentifyingNumber -ProductId $ProductId

    $productEntry = Get-ProductEntry -IdentifyingNumber $identifyingNumber

    if ($null -ne $productEntry)
    {
        $displayName = Get-ProductEntryValue -ProductEntry $productEntry -Property 'DisplayName'
        Write-Verbose -Message ($script:localizedData.PackageAppearsInstalled -f $displayName)
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.PackageDoesNotAppearInstalled -f $ProductId)
    }

    return (($null -ne $productEntry -and $Ensure -eq 'Present') -or ($null -eq $productEntry -and $Ensure -eq 'Absent'))
}

<#
    .SYNOPSIS
        Asserts that the path extension is '.msi'

    .PARAMETER Path
        The path to the file to validate the extension of.
#>
function Assert-PathExtensionValid
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path
    )

    $pathExtension = [System.IO.Path]::GetExtension($Path)
    Write-Verbose -Message ($script:localizedData.ThePathExtensionWasPathExt -f $pathExtension)

    if ($pathExtension.ToLower() -ne '.msi')
    {
        New-InvalidArgumentException -ArgumentName 'Path' -Message ($script:localizedData.InvalidBinaryType -f $Path)
    }
}

<#
    .SYNOPSIS
        Converts the given path to a URI and returns the URI object.
        Throws an exception if the path's scheme as a URI is not valid.

    .PARAMETER Path
        The path to the file to retrieve as a URI.
#>
function Convert-PathToUri
{
    [OutputType([System.Uri])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path
    )

    try
    {
        $uri = [System.Uri] $Path
    }
    catch
    {
        New-InvalidArgumentException -ArgumentName 'Path' -Message ($script:localizedData.InvalidPath -f $Path)
    }

    $validUriSchemes = @( 'file', 'http', 'https' )

    if ($validUriSchemes -notcontains $uri.Scheme)
    {
        Write-Verbose -Message ($script:localizedData.TheUriSchemeWasUriScheme -f $uri.Scheme)
        New-InvalidArgumentException -ArgumentName 'Path' -Message ($script:localizedData.InvalidPath -f $Path)
    }

    return $uri
}

<#
    .SYNOPSIS
        Converts the product ID to the identifying number format.

    .PARAMETER ProductId
        The product ID to convert to an identifying number.
#>
function Convert-ProductIdToIdentifyingNumber
{
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ProductId
    )

    try
    {
        Write-Verbose -Message ($script:localizedData.ParsingProductIdAsAnIdentifyingNumber -f $ProductId)
        $identifyingNumber = '{{{0}}}' -f [System.Guid]::Parse($ProductId).ToString().ToUpper()

        Write-Verbose -Message ($script:localizedData.ParsedProductIdAsIdentifyingNumber -f $ProductId, $identifyingNumber)
        return $identifyingNumber
    }
    catch
    {
        New-InvalidArgumentException -ArgumentName 'ProductId' -Message ($script:localizedData.InvalidIdentifyingNumber -f $ProductId)
    }
}


<#
    .SYNOPSIS
        Retrieves the product entry for the package with the given identifying number.

    .PARAMETER IdentifyingNumber
        The identifying number of the product entry to retrieve.
#>
function Get-ProductEntry
{
    [OutputType([Microsoft.Win32.RegistryKey])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $IdentifyingNumber
    )

    $uninstallRegistryKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    $uninstallRegistryKeyWow64 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'

    $productEntry = $null

    if (-not [System.String]::IsNullOrEmpty($IdentifyingNumber))
    {
        $productEntryKeyLocation = Join-Path -Path $uninstallRegistryKey -ChildPath $IdentifyingNumber
        $productEntry = Get-Item -Path $productEntryKeyLocation -ErrorAction 'SilentlyContinue'

        if ($null -eq $productEntry)
        {
            $productEntryKeyLocation = Join-Path -Path $uninstallRegistryKeyWow64 -ChildPath $IdentifyingNumber
            $productEntry = Get-Item $productEntryKeyLocation -ErrorAction 'SilentlyContinue'
        }
    }

    return $productEntry
}

<#
    .SYNOPSIS
        Retrieves the information for the given product entry and returns it as a hashtable.

    .PARAMETER ProductEntry
        The product entry to retrieve the information for.
#>
function Get-ProductEntryInfo
{
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [Microsoft.Win32.RegistryKey]
        $ProductEntry
    )

    $installDate = Get-ProductEntryValue -ProductEntry $ProductEntry -Property 'InstallDate'

    if ($null -ne $installDate)
    {
        try
        {
            $installDate = '{0:d}' -f [System.DateTime]::ParseExact($installDate, 'yyyyMMdd',[System.Globalization.CultureInfo]::CurrentCulture).Date
        }
        catch
        {
            $installDate = $null
        }
    }

    $publisher = Get-ProductEntryValue -ProductEntry $ProductEntry -Property 'Publisher'

    $estimatedSizeInKB = Get-ProductEntryValue -ProductEntry $ProductEntry -Property 'EstimatedSize'

    if ($null -ne $estimatedSizeInKB)
    {
        $estimatedSizeInMB = $estimatedSizeInKB / 1024
    }

    $displayVersion = Get-ProductEntryValue -ProductEntry $ProductEntry -Property 'DisplayVersion'

    $comments = Get-ProductEntryValue -ProductEntry $ProductEntry -Property 'Comments'

    $displayName = Get-ProductEntryValue -ProductEntry $ProductEntry -Property 'DisplayName'

    $installSource = Get-ProductEntryValue -ProductEntry $ProductEntry -Property 'InstallSource'

    return @{
        Name = $displayName
        InstallSource = $installSource
        InstalledOn = $installDate
        Size = $estimatedSizeInMB
        Version = $displayVersion
        PackageDescription = $comments
        Publisher = $publisher
    }
}

<#
    .SYNOPSIS
        Retrieves the value of the given property for the given product entry.
        This is a wrapper for unit testing.

    .PARAMETER ProductEntry
        The product entry object to retrieve the property value from.

    .PARAMETER Property
        The property to retrieve the value of from the product entry.
#>
function Get-ProductEntryValue
{
    [OutputType([System.Object])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [Microsoft.Win32.RegistryKey]
        $ProductEntry,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Property
    )

    return $ProductEntry.GetValue($Property)
}

<#
    .SYNOPSIS
        Removes the file at the given path if it exists and creates a new file
        to be written to.

    .PARAMETER LogPath
        The path where the log file should be created.
#>
function New-LogFile
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $LogPath
    )

    try
    {
        <#
            Pre-verify the log path exists and is writable ahead of time so the user won't
            have to detect why the MSI log path doesn't exist.
        #>
        if (Test-Path -Path $LogPath)
        {
            $null = Remove-Item -Path $LogPath
        }

        $null = New-Item -Path $LogPath -Type 'File'
    }
    catch
    {
        New-InvalidOperationException -Message ($script:localizedData.CouldNotOpenLog -f $LogPath) -ErrorRecord $_
    }
}

<#
    .SYNOPSIS
        Retrieves the WebRequest response as a stream for the MSI file with the given URI.

    .PARAMETER Uri
        The Uri to retrieve the WebRequest from.

    .PARAMETER ServerCertificationValidationCallback
        The callback code to validate the SSL certificate for HTTPS URI schemes.
#>
function Get-WebRequestResponse
{
    [OutputType([System.IO.Stream])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Uri]
        $Uri,

        [Parameter()]
        [System.String]
        $ServerCertificateValidationCallback
    )

    try
    {
        $uriScheme = $Uri.Scheme

        Write-Verbose -Message ($script:localizedData.CreatingTheSchemeStream -f $uriScheme)
        $webRequest = Get-WebRequest -Uri $Uri

        Write-Verbose -Message ($script:localizedData.SettingDefaultCredential)
        $webRequest.Credentials = [System.Net.CredentialCache]::DefaultCredentials
        $webRequest.AuthenticationLevel = [System.Net.Security.AuthenticationLevel]::None

        if ($uriScheme -eq 'http')
        {
            # Default value is MutualAuthRequested, which applies to the https scheme
            Write-Verbose -Message ($script:localizedData.SettingAuthenticationLevel)
            $webRequest.AuthenticationLevel = [System.Net.Security.AuthenticationLevel]::None
        }
        elseif ($uriScheme -eq 'https' -and -not [System.String]::IsNullOrEmpty($ServerCertificateValidationCallback))
        {
            Write-Verbose -Message $script:localizedData.SettingCertificateValidationCallback
            $webRequest.ServerCertificateValidationCallBack = (Get-ScriptBlock -FunctionName $ServerCertificateValidationCallback)
        }

        Write-Verbose -Message ($script:localizedData.GettingTheSchemeResponseStream -f $uriScheme)
        $responseStream = Get-WebRequestResponseStream -WebRequest $webRequest

        return $responseStream
    }
    catch
    {
         New-InvalidOperationException -Message ($script:localizedData.CouldNotGetResponseFromWebRequest -f $uriScheme, $Uri.OriginalString) -ErrorRecord $_
    }
}

<#
    .SYNOPSIS
        Creates a WebRequst object based on the given Uri and returns it.
        This is a wrapper for unit testing

    .PARAMETER Uri
        The URI object to create the WebRequest from
#>
function Get-WebRequest
{
    [OutputType([System.Net.WebRequest])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Uri]
        $Uri
    )

    return [System.Net.WebRequest]::Create($Uri)
}

<#
    .SYNOPSIS
        Retrieves the response stream from the given WebRequest object.
        This is a wrapper for unit testing.

    .PARAMETER WebRequest
        The WebRequest object to retrieve the response stream from.
#>
function Get-WebRequestResponseStream
{
    [OutputType([System.IO.Stream])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Net.WebRequest]
        $WebRequest
    )

    return (([System.Net.HttpWebRequest] $WebRequest).GetResponse()).GetResponseStream()
}

<#
    .SYNOPSIS
        Converts the given function into a script block and returns it.
        This is a wrapper for unit testing

    .PARAMETER Function
        The name of the function to convert to a script block
#>
function Get-ScriptBlock
{
    [OutputType([System.Management.Automation.ScriptBlock])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FunctionName
    )

    return [System.Management.Automation.ScriptBlock]::Create($FunctionName)
}

<#
    .SYNOPSIS
        Copies the given response stream to the given file stream.

    .PARAMETER ResponseStream
        The response stream to copy over.

    .PARAMETER FileStream
        The file stream to copy to.
#>
function Copy-ResponseStreamToFileStream
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.IO.Stream]
        $ResponseStream,

        [Parameter(Mandatory = $true)]
        [System.IO.Stream]
        $FileStream
    )

    try
    {
        Write-Verbose -Message ($script:localizedData.CopyingTheSchemeStreamBytesToTheDiskCache)
        $null = $ResponseStream.CopyTo($FileStream)
        $null = $ResponseStream.Flush()
        $null = $FileStream.Flush()
    }
    catch
    {
        New-InvalidOperationException -Message ($script:localizedData.ErrorCopyingDataToFile) -ErrorRecord $_
    }
}

<#
    .SYNOPSIS
        Closes the given stream.
        Wrapper function for unit testing.

    .PARAMETER Stream
        The stream to close.
#>
function Close-Stream
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.IO.Stream]
        $Stream
    )

    $null = $Stream.Close()
}

<#
    .SYNOPSIS
        Asserts that the file at the given path has a valid hash, signer thumbprint, and/or
        signer subject. If only Path is provided, then this function will never throw.
        If FileHash is provided and HashAlgorithm is not, then Sha-256 will be used as the hash
        algorithm by default.

    .PARAMETER Path
        The path to the file to check.

    .PARAMETER FileHash
        The hash that should match the hash of the file.

    .PARAMETER HashAlgorithm
        The algorithm to use to retrieve the file hash.

    .PARAMETER SignerThumbprint
        The certificate thumbprint that should match the file's signer certificate.

    .PARAMETER SignerSubject
        The certificate subject that should match the file's signer certificate.
#>
function Assert-FileValid
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.String]
        $FileHash,

        [Parameter()]
        [System.String]
        $HashAlgorithm = 'SHA256',

        [Parameter()]
        [System.String]
        $SignerThumbprint,

        [Parameter()]
        [System.String]
        $SignerSubject
    )

    if (-not [System.String]::IsNullOrEmpty($FileHash))
    {
        Assert-FileHashValid -Path $Path -Hash $FileHash -Algorithm $HashAlgorithm
    }

    if (-not [System.String]::IsNullOrEmpty($SignerThumbprint) -or -not [System.String]::IsNullOrEmpty($SignerSubject))
    {
        Assert-FileSignatureValid -Path $Path -Thumbprint $SignerThumbprint -Subject $SignerSubject
    }
}

<#
    .SYNOPSIS
        Asserts that the hash of the file at the given path matches the given hash.

    .PARAMETER Path
        The path to the file to check the hash of.

    .PARAMETER Hash
        The hash to check against.

    .PARAMETER Algorithm
        The algorithm to use to retrieve the file's hash.
        Default is 'Sha256'
#>
function Assert-FileHashValid
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Hash,

        [Parameter()]
        [System.String]
        $Algorithm = 'SHA256'
    )

    Write-Verbose -Message ($script:localizedData.CheckingFileHash -f $Path, $Hash, $Algorithm)

    $fileHash = Get-FileHash -LiteralPath $Path -Algorithm $Algorithm

    if ($fileHash.Hash -ne $Hash)
    {
        New-InvalidArgumentException -ArgumentName 'FileHash' -Message ($script:localizedData.InvalidFileHash -f $Path, $Hash, $Algorithm)
    }
}

<#
    .SYNOPSIS
        Asserts that the signature of the file at the given path is valid.

    .PARAMETER Path
        The path to the file to check the signature of

    .PARAMETER Thumbprint
        The certificate thumbprint that should match the file's signer certificate.

    .PARAMETER Subject
        The certificate subject that should match the file's signer certificate.
#>
function Assert-FileSignatureValid
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.String]
        $Thumbprint,

        [Parameter()]
        [System.String]
        $Subject
    )

    Write-Verbose -Message ($script:localizedData.CheckingFileSignature -f $Path)

    $signature = Get-AuthenticodeSignature -LiteralPath $Path

    if ($signature.Status -ne [System.Management.Automation.SignatureStatus]::Valid)
    {
        New-InvalidArgumentException -ArgumentName 'Path' -Message ($script:localizedData.InvalidFileSignature -f $Path, $signature.Status)
    }
    else
    {
        Write-Verbose -Message ($script:localizedData.FileHasValidSignature -f $Path, $signature.SignerCertificate.Thumbprint, $signature.SignerCertificate.Subject)
    }

    if (-not [System.String]::IsNullOrEmpty($Subject) -and ($signature.SignerCertificate.Subject -notlike $Subject))
    {
        New-InvalidArgumentException -ArgumentName 'SignerSubject' -Message ($script:localizedData.WrongSignerSubject -f $Path, $Subject)
    }

    if (-not [System.String]::IsNullOrEmpty($Thumbprint) -and ($signature.SignerCertificate.Thumbprint -ne $Thumbprint))
    {
        New-InvalidArgumentException -ArgumentName 'SignerThumbprint' -Message ($script:localizedData.WrongSignerThumbprint -f $Path, $Thumbprint)
    }
}

<#
    .SYNOPSIS
        Starts the given MSI installation or uninstallation either as a process or
        under a user credential if RunAsCredential is specified.

    .PARAMETER IdentifyingNumber
        The identifying number used to find the package.

    .PARAMETER Path
        The path to the MSI file to install or uninstall.

    .PARAMETER Ensure
        Indicates whether the given MSI file should be installed or uninstalled.

    .PARAMETER Arguments
        The arguments to pass to the MSI package.

    .PARAMETER LogPath
        The path to the log file to log the output from the MSI execution.

    .PARAMETER RunAsCredential
        The credential of a user account under which to run the installation or uninstallation.
#>
function Start-MsiProcess
{
    [OutputType([System.Int32])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $IdentifyingNumber,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $Arguments,

        [Parameter()]
        [System.String]
        $LogPath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $RunAsCredential
    )

    $startInfo = New-Object -TypeName 'System.Diagnostics.ProcessStartInfo'

    # Necessary for I/O redirection
    $startInfo.UseShellExecute = $false

    $startInfo.FileName = "$env:winDir\system32\msiexec.exe"

    if ($Ensure -eq 'Present')
    {
        $startInfo.Arguments = '/i "{0}"' -f $Path
    }
    # Ensure -eq 'Absent'
    else
    {
        $productEntry = Get-ProductEntry -IdentifyingNumber $identifyingNumber

        $id = Split-Path -Path $productEntry.Name -Leaf
        $startInfo.Arguments = ('/x{0}' -f $id)
    }

    if (-not [System.String]::IsNullOrEmpty($LogPath))
    {
        $startInfo.Arguments += (' /log "{0}"' -f $LogPath)
    }

    $startInfo.Arguments += ' /quiet /norestart'

    if (-not [System.String]::IsNullOrEmpty($Arguments))
    {
        # Append any specified arguments with a space
        $startInfo.Arguments += (' {0}' -f $Arguments)
    }

    Write-Verbose -Message ($script:localizedData.StartingWithStartInfoFileNameStartInfoArguments -f $startInfo.FileName, $startInfo.Arguments)

    $exitCode = 0

    try
    {
        if (-not [System.String]::IsNullOrEmpty($RunAsCredential))
        {
            $commandLine = ('"{0}" {1}' -f $startInfo.FileName, $startInfo.Arguments)
            $exitCode = Invoke-PInvoke -CommandLine $commandLine -RunAsCredential $RunAsCredential
        }
        else
        {
            $process = New-Object -TypeName 'System.Diagnostics.Process'
            $process.StartInfo = $startInfo
            $exitCode = Invoke-Process -Process $process
        }
    }
    catch
    {
        New-InvalidOperationException -Message ($script:localizedData.CouldNotStartProcess -f $Path) -ErrorRecord $_
    }

    return $exitCode
}

<#
    .SYNOPSIS
        Runs a process as the specified user via PInvoke. Returns the exitCode that
        PInvoke returns.

    .PARAMETER CommandLine
        The command line (including arguments) of the process to start.

    .PARAMETER RunAsCredential
        The user credential to start the process as.
#>
function Invoke-PInvoke
{
    [OutputType([System.Int32])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CommandLine,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $RunAsCredential
    )

    Register-PInvoke
    [System.Int32] $exitCode = 0

    $null = [Source.NativeMethods]::CreateProcessAsUser($CommandLine, `
        $RunAsCredential.GetNetworkCredential().Domain, `
        $RunAsCredential.GetNetworkCredential().UserName, `
        $RunAsCredential.GetNetworkCredential().Password, `
        [ref] $exitCode
    )

    return $exitCode
}

<#
    .SYNOPSIS
        Starts and waits for a process.

    .PARAMETER Process
        The System.Diagnositics.Process object to start.
#>
function Invoke-Process
{
    [OutputType([System.Int32])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Diagnostics.Process]
        $Process
    )

    $null = $Process.Start()

    $null = $Process.WaitForExit()
    return $Process.ExitCode
}

<#
    .SYNOPSIS
        Retrieves product code from the MSI at the given path.

    .PARAMETER Path
        The path to the MSI to retrieve the product code from.
#>
function Get-MsiProductCode
{
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path
    )

    $msiTools = Get-MsiTool

    $productCode = $msiTools::GetProductCode($Path)

    return $productCode
}

<#
    .SYNOPSIS
        Retrieves the MSI tools type.
#>
function Get-MsiTool
{
    [OutputType([System.Type])]
    [CmdletBinding()]
    param ()

    # Check if the variable is already defined
    if ($null -ne $script:msiTools)
    {
        return $script:msiTools
    }

    $msiToolsCodeDefinition = @'
    [DllImport("msi.dll", CharSet = CharSet.Unicode, PreserveSig = true, SetLastError = true, ExactSpelling = true)]
    private static extern UInt32 MsiOpenPackageExW(string szPackagePath, int dwOptions, out IntPtr hProduct);
    [DllImport("msi.dll", CharSet = CharSet.Unicode, PreserveSig = true, SetLastError = true, ExactSpelling = true)]
    private static extern uint MsiCloseHandle(IntPtr hAny);
    [DllImport("msi.dll", CharSet = CharSet.Unicode, PreserveSig = true, SetLastError = true, ExactSpelling = true)]
    private static extern uint MsiGetPropertyW(IntPtr hAny, string name, StringBuilder buffer, ref int bufferLength);
    private static string GetPackageProperty(string msi, string property)
    {
        IntPtr MsiHandle = IntPtr.Zero;
        try
        {
            var res = MsiOpenPackageExW(msi, 1, out MsiHandle);
            if (res != 0)
            {
                return null;
            }
            int length = 256;
            var buffer = new StringBuilder(length);
            res = MsiGetPropertyW(MsiHandle, property, buffer, ref length);
            return buffer.ToString();
        }
        finally
        {
            if (MsiHandle != IntPtr.Zero)
            {
                MsiCloseHandle(MsiHandle);
            }
        }
    }
    public static string GetProductCode(string msi)
    {
        return GetPackageProperty(msi, "ProductCode");
    }
    public static string GetProductName(string msi)
    {
        return GetPackageProperty(msi, "ProductName");
    }
'@

    # Check if the the type is already defined
    if (([System.Management.Automation.PSTypeName]'Microsoft.Windows.DesiredStateConfiguration.MsiPackageResource.MsiTools').Type)
    {
        $script:msiTools = ([System.Management.Automation.PSTypeName]'Microsoft.Windows.DesiredStateConfiguration.MsiPackageResource.MsiTools').Type
    }
    else
    {
        $script:msiTools = Add-Type `
            -Namespace 'Microsoft.Windows.DesiredStateConfiguration.MsiPackageResource' `
            -Name 'MsiTools' `
            -Using 'System.Text' `
            -MemberDefinition $msiToolsCodeDefinition `
            -PassThru
    }

    return $script:msiTools
}

<#
    .SYNOPSIS
        Registers PInvoke to run a process as a user.
#>
function Register-PInvoke
{
    [CmdletBinding()]
    param ()

    $programSource = @'
        using System;
        using System.Collections.Generic;
        using System.Text;
        using System.Security;
        using System.Runtime.InteropServices;
        using System.Diagnostics;
        using System.Security.Principal;
        using System.ComponentModel;
        using System.IO;
        namespace Source
        {
            [SuppressUnmanagedCodeSecurity]
            public static class NativeMethods
            {
                //The following structs and enums are used by the various Win32 API's that are used in the code below
                [StructLayout(LayoutKind.Sequential)]
                public struct STARTUPINFO
                {
                    public Int32 cb;
                    public string lpReserved;
                    public string lpDesktop;
                    public string lpTitle;
                    public Int32 dwX;
                    public Int32 dwY;
                    public Int32 dwXSize;
                    public Int32 dwXCountChars;
                    public Int32 dwYCountChars;
                    public Int32 dwFillAttribute;
                    public Int32 dwFlags;
                    public Int16 wShowWindow;
                    public Int16 cbReserved2;
                    public IntPtr lpReserved2;
                    public IntPtr hStdInput;
                    public IntPtr hStdOutput;
                    public IntPtr hStdError;
                }
                [StructLayout(LayoutKind.Sequential)]
                public struct PROCESS_INFORMATION
                {
                    public IntPtr hProcess;
                    public IntPtr hThread;
                    public Int32 dwProcessID;
                    public Int32 dwThreadID;
                }
                [Flags]
                public enum LogonType
                {
                    LOGON32_LOGON_INTERACTIVE = 2,
                    LOGON32_LOGON_NETWORK = 3,
                    LOGON32_LOGON_BATCH = 4,
                    LOGON32_LOGON_SERVICE = 5,
                    LOGON32_LOGON_UNLOCK = 7,
                    LOGON32_LOGON_NETWORK_CLEARTEXT = 8,
                    LOGON32_LOGON_NEW_CREDENTIALS = 9
                }
                [Flags]
                public enum LogonProvider
                {
                    LOGON32_PROVIDER_DEFAULT = 0,
                    LOGON32_PROVIDER_WINNT35,
                    LOGON32_PROVIDER_WINNT40,
                    LOGON32_PROVIDER_WINNT50
                }
                [StructLayout(LayoutKind.Sequential)]
                public struct SECURITY_ATTRIBUTES
                {
                    public Int32 Length;
                    public IntPtr lpSecurityDescriptor;
                    public bool bInheritHandle;
                }
                public enum SECURITY_IMPERSONATION_LEVEL
                {
                    SecurityAnonymous,
                    SecurityIdentification,
                    SecurityImpersonation,
                    SecurityDelegation
                }
                public enum TOKEN_TYPE
                {
                    TokenPrimary = 1,
                    TokenImpersonation
                }
                [StructLayout(LayoutKind.Sequential, Pack = 1)]
                internal struct TokPriv1Luid
                {
                    public int Count;
                    public long Luid;
                    public int Attr;
                }
                public const int GENERIC_ALL_ACCESS = 0x10000000;
                public const int CREATE_NO_WINDOW = 0x08000000;
                internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
                internal const int TOKEN_QUERY = 0x00000008;
                internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;
                internal const string SE_INCRASE_QUOTA = "SeIncreaseQuotaPrivilege";
                [DllImport("kernel32.dll",
                    EntryPoint = "CloseHandle", SetLastError = true,
                    CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
                public static extern bool CloseHandle(IntPtr handle);
                [DllImport("advapi32.dll",
                    EntryPoint = "CreateProcessAsUser", SetLastError = true,
                    CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
                public static extern bool CreateProcessAsUser(
                    IntPtr hToken,
                    string lpApplicationName,
                    string lpCommandLine,
                    ref SECURITY_ATTRIBUTES lpProcessAttributes,
                    ref SECURITY_ATTRIBUTES lpThreadAttributes,
                    bool bInheritHandle,
                    Int32 dwCreationFlags,
                    IntPtr lpEnvrionment,
                    string lpCurrentDirectory,
                    ref STARTUPINFO lpStartupInfo,
                    ref PROCESS_INFORMATION lpProcessInformation
                    );
                [DllImport("advapi32.dll", EntryPoint = "DuplicateTokenEx")]
                public static extern bool DuplicateTokenEx(
                    IntPtr hExistingToken,
                    Int32 dwDesiredAccess,
                    ref SECURITY_ATTRIBUTES lpThreadAttributes,
                    Int32 ImpersonationLevel,
                    Int32 dwTokenType,
                    ref IntPtr phNewToken
                    );
                [DllImport("advapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
                public static extern Boolean LogonUser(
                    String lpszUserName,
                    String lpszDomain,
                    String lpszPassword,
                    LogonType dwLogonType,
                    LogonProvider dwLogonProvider,
                    out IntPtr phToken
                    );
                [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
                internal static extern bool AdjustTokenPrivileges(
                    IntPtr htok,
                    bool disall,
                    ref TokPriv1Luid newst,
                    int len,
                    IntPtr prev,
                    IntPtr relen
                    );
                [DllImport("kernel32.dll", ExactSpelling = true)]
                internal static extern IntPtr GetCurrentProcess();
                [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
                internal static extern bool OpenProcessToken(
                    IntPtr h,
                    int acc,
                    ref IntPtr phtok
                    );
                [DllImport("kernel32.dll", ExactSpelling = true)]
                internal static extern int WaitForSingleObject(
                    IntPtr h,
                    int milliseconds
                    );
                [DllImport("kernel32.dll", ExactSpelling = true)]
                internal static extern bool GetExitCodeProcess(
                    IntPtr h,
                    out int exitcode
                    );
                [DllImport("advapi32.dll", SetLastError = true)]
                internal static extern bool LookupPrivilegeValue(
                    string host,
                    string name,
                    ref long pluid
                    );
                public static void CreateProcessAsUser(string strCommand, string strDomain, string strName, string strPassword, ref int ExitCode )
                {
                    var hToken = IntPtr.Zero;
                    var hDupedToken = IntPtr.Zero;
                    TokPriv1Luid tp;
                    var pi = new PROCESS_INFORMATION();
                    var sa = new SECURITY_ATTRIBUTES();
                    sa.Length = Marshal.SizeOf(sa);
                    Boolean bResult = false;
                    try
                    {
                        bResult = LogonUser(
                            strName,
                            strDomain,
                            strPassword,
                            LogonType.LOGON32_LOGON_BATCH,
                            LogonProvider.LOGON32_PROVIDER_DEFAULT,
                            out hToken
                            );
                        if (!bResult)
                        {
                            throw new Win32Exception("Logon error #" + Marshal.GetLastWin32Error().ToString());
                        }
                        IntPtr hproc = GetCurrentProcess();
                        IntPtr htok = IntPtr.Zero;
                        bResult = OpenProcessToken(
                                hproc,
                                TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY,
                                ref htok
                            );
                        if(!bResult)
                        {
                            throw new Win32Exception("Open process token error #" + Marshal.GetLastWin32Error().ToString());
                        }
                        tp.Count = 1;
                        tp.Luid = 0;
                        tp.Attr = SE_PRIVILEGE_ENABLED;
                        bResult = LookupPrivilegeValue(
                            null,
                            SE_INCRASE_QUOTA,
                            ref tp.Luid
                            );
                        if(!bResult)
                        {
                            throw new Win32Exception("Lookup privilege error #" + Marshal.GetLastWin32Error().ToString());
                        }
                        bResult = AdjustTokenPrivileges(
                            htok,
                            false,
                            ref tp,
                            0,
                            IntPtr.Zero,
                            IntPtr.Zero
                            );
                        if(!bResult)
                        {
                            throw new Win32Exception("Token elevation error #" + Marshal.GetLastWin32Error().ToString());
                        }
                        bResult = DuplicateTokenEx(
                            hToken,
                            GENERIC_ALL_ACCESS,
                            ref sa,
                            (int)SECURITY_IMPERSONATION_LEVEL.SecurityIdentification,
                            (int)TOKEN_TYPE.TokenPrimary,
                            ref hDupedToken
                            );
                        if(!bResult)
                        {
                            throw new Win32Exception("Duplicate Token error #" + Marshal.GetLastWin32Error().ToString());
                        }
                        var si = new STARTUPINFO();
                        si.cb = Marshal.SizeOf(si);
                        si.lpDesktop = "";
                        bResult = CreateProcessAsUser(
                            hDupedToken,
                            null,
                            strCommand,
                            ref sa,
                            ref sa,
                            false,
                            0,
                            IntPtr.Zero,
                            null,
                            ref si,
                            ref pi
                            );
                        if(!bResult)
                        {
                            throw new Win32Exception("Create process as user error #" + Marshal.GetLastWin32Error().ToString());
                        }
                        int status = WaitForSingleObject(pi.hProcess, -1);
                        if(status == -1)
                        {
                            throw new Win32Exception("Wait during create process failed user error #" + Marshal.GetLastWin32Error().ToString());
                        }
                        bResult = GetExitCodeProcess(pi.hProcess, out ExitCode);
                        if(!bResult)
                        {
                            throw new Win32Exception("Retrieving status error #" + Marshal.GetLastWin32Error().ToString());
                        }
                    }
                    finally
                    {
                        if (pi.hThread != IntPtr.Zero)
                        {
                            CloseHandle(pi.hThread);
                        }
                        if (pi.hProcess != IntPtr.Zero)
                        {
                            CloseHandle(pi.hProcess);
                        }
                        if (hDupedToken != IntPtr.Zero)
                        {
                            CloseHandle(hDupedToken);
                        }
                    }
                }
            }
        }
'@
    $null = Add-Type -TypeDefinition $programSource -ReferencedAssemblies 'System.ServiceProcess'
}
