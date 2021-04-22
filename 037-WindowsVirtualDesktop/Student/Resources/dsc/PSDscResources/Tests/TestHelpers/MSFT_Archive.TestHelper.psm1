$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

Add-Type -AssemblyName 'System.IO.Compression.FileSystem'

<#
    .SYNOPSIS
        Converts the specified hashtable to a file structure under the specified parent path.

    .PARAMETER ParentPath
        The path to the directory that should contain the specified file structure.

    .PARAMETER FileStructure
        The hashtable defining the file structure.
        Nested hashtable values denote directories with the key as the name of the directory and the
        hashtable value as the contents.
        String values denote files with the key as the name of the file and the value as the contents.

    .EXAMPLE
        $fileStructure = @{
            DirectoryName = @{
                FileName = 'File contents'
            }
        }

        ConvertTo-FileStructure -ParentPath $env:temp -FileStructure $fileStructure
#>
function ConvertTo-FileStructure
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ParentPath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Hashtable]
        $FileStructure
    )

    foreach ($itemName in $FileStructure.Keys)
    {
        if ($FileStructure[$itemName] -is [Hashtable])
        {
            $newDirectoryPath = Join-Path -Path $ParentPath -ChildPath $itemName
            $null = New-Item -Path $newDirectoryPath -ItemType 'Directory'
            ConvertTo-FileStructure -ParentPath $newDirectoryPath -FileStructure $FileStructure[$itemName]
        }
        elseif ($FileStructure[$itemName] -is [String])
        {
            $newFilePath = Join-Path -Path $ParentPath -ChildPath $itemName
            $null = New-Item -Path $newFilePath -ItemType 'File'
            Set-Content -LiteralPath $newFilePath -Value $FileStructure[$itemName]
        }
        else
        {
            throw 'Zip file structure must be made of strings and hashtable values. Found a different type.'
        }
    }
}

<#
    .SYNOPSIS
        Creates a new zip file with the specified name and file structure under the specified parent path.
        Returns the file path to the compressed zip file.

    .PARAMETER ParentPath
        The path under which the new zip file should be created.

    .PARAMETER Name
        The name of the zip file to create.

    .PARAMETER ZipFileStructure
        The hashtable defining the file structure.
        Nested hashtable values denote directories with the key as the name of the directory and the
        hashtable value as the contents.
        String values denote files with the key as the name of the file and the value as the contents.

    .EXAMPLE
        $zipFileStructure = @{
            DirectoryName = @{
                FileName = 'File contents'
            }
        }

        New-ZipFileFromHashtable -ParentPath $env:temp -Name 'ArchiveName' -ZipFileStructure $zipFileStructure

    .NOTES
        The expanded file structure that the zip file is created from is not removed as part of this function.
        This is to allow tests to compare the structure of the 'zip file' against another file structure.
#>
function New-ZipFileFromHashtable
{
    [OutputType([String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ParentPath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Hashtable]
        $ZipFileStructure
    )

    $expandedZipPath = Join-Path -Path $ParentPath -ChildPath $Name
    $compressedZipPath = Join-Path -Path $ParentPath -ChildPath "$Name.zip"

    $null = New-Item -Path $expandedZipPath -ItemType 'Directory'
    ConvertTo-FileStructure -ParentPath $expandedZipPath -FileStructure $ZipFileStructure

    $null = [System.IO.Compression.ZipFile]::CreateFromDirectory($expandedZipPath, $compressedZipPath, 'NoCompression', $false)

    return $compressedZipPath
}

<#
    .SYNOPSIS
        Tests if the two specified file structures match.

    .PARAMETER SourcePath
        The path to the root of the file structure to test against.

    .PARAMETER DestinationPath
        The path to the root of the file structure to test

    .PARAMETER CheckLastWriteTime
        Indicates whether or not to test that the last write times of the files in the structure match.

    .PARAMETER CheckCreationTime
        Indicates whether or not to test that the creation times of the files in the structure match.

    .PARAMETER CheckContents
        Indicates whether or not to test that the contents of the files in the structure match.
#>
function Test-FileStructuresMatch
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $SourcePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $DestinationPath,

        [Parameter()]
        [Switch] $CheckLastWriteTime,

        [Parameter()]
        [Switch] $CheckCreationTime,

        [Parameter()]
        [Switch] $CheckContents
    )

    $sourcePathLength = $SourcePath.Length
    $destinationPathLength = $DestinationPath.Length

    $destinationContents = @{}
    $destinationChildItems = Get-ChildItem -Path $DestinationPath -Recurse

    foreach ($destinationChildItem in $destinationChildItems)
    {
        $destinationChildItemName = Split-Path -Path $destinationChildItem.FullName -Leaf
        $destinationContents[$destinationChildItemName] = $destinationChildItem
    }

    $sourceChildItems = Get-ChildItem -Path $SourcePath -Recurse

    foreach ($sourceChildItem in $sourceChildItems)
    {
        $sourceChildItemName = Split-Path -Path $sourceChildItem.FullName -Leaf
        $destinationChildItem = $destinationContents[$sourceChildItemName]

        if ($destinationChildItem -eq $null)
        {
            return $false
        }
        else
        {
            if (-not $destinationChildItem.GetType() -eq $sourceChildItem.GetType())
            {
                return $false
            }

            if ($destinationChildItem.GetType() -eq [System.IO.FileInfo])
            {
                if ($CheckLastWriteTime)
                {
                    if ($sourceChildItem.LastWriteTime -ne $destinationChildItem.LastWriteTime)
                    {
                        return $false
                    }
                }

                if ($CheckCreationTime)
                {
                    if ($sourceChildItem.CreationTime -ne $destinationChildItem.CreationTime)
                    {
                        return $false
                    }
                }

                if ($CheckContents)
                {
                    $sourceFileContents = Get-Content -Path $sourceChildItem.FullName -Raw
                    $destinationFileContents = Get-Content -Path $destinationChildItem.FullName -Raw

                    if ($sourceFileContents -ne $destinationFileContents)
                    {
                        return $false
                    }
                }
            }
        }
    }

    return $true
}

Export-ModuleMember -Function @( 'New-ZipFileFromHashtable', 'Test-FileStructuresMatch' )
