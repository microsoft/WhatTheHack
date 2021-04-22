$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

if ($PSVersionTable.PSVersion -lt [Version] '5.1')
{
    Write-Warning -Message 'Cannot run PSDscResources integration tests on PowerShell versions lower than 5.1'
    return
}

Describe 'Archive End to End Tests' {
    BeforeAll {
        # Import CommonTestHelper for Enter-DscResourceTestEnvironment, Exit-DscResourceTestEnvironment
        $testsFolderFilePath = Split-Path $PSScriptRoot -Parent
        $testHelperFolderFilePath = Join-Path -Path $testsFolderFilePath -ChildPath 'TestHelpers'
        $commonTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'CommonTestHelper.psm1'
        Import-Module -Name $commonTestHelperFilePath

        $script:testEnvironment = Enter-DscResourceTestEnvironment `
            -DscResourceModuleName 'PSDscResources' `
            -DscResourceName 'MSFT_Archive' `
            -TestType 'Integration'

        # Import Archive resource module for Test-TargetResource
        $moduleRootFilePath = Split-Path -Path $testsFolderFilePath -Parent
        $dscResourcesFolderFilePath = Join-Path -Path $moduleRootFilePath -ChildPath 'DscResources'
        $archiveResourceFolderFilePath = Join-Path -Path $dscResourcesFolderFilePath -ChildPath 'MSFT_Archive'
        $archiveResourceModuleFilePath = Join-Path -Path $archiveResourceFolderFilePath -ChildPath 'MSFT_Archive.psm1'
        Import-Module -Name $archiveResourceModuleFilePath -Force

        # Import the Archive test helper for New-ZipFileFromHashtable and Test-FileStructuresMatch
        $archiveTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'MSFT_Archive.TestHelper.psm1'
        Import-Module -Name $archiveTestHelperFilePath -Force

        # Set up the paths to the test configurations
        $script:confgurationFilePathValidateOnly = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_Archive_ValidateOnly.config.ps1'
        $script:confgurationFilePathValidateAndChecksum = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_Archive_ValidateAndChecksum.config.ps1'
        $script:confgurationFilePathCredentialOnly = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_Archive_CredentialOnly.config.ps1'

        # Create the test archive
        $script:testArchiveName = 'TestArchive1'

        $testArchiveFileStructure = @{
            Folder1 = @{}
            Folder2 = @{
                Folder21 = @{
                    Folder22 = @{
                        Folder23 = @{}
                    }
                }
            }
            Folder3 = @{
                Folder31 = @{
                    Folder31 = @{
                        Folder33 = @{
                            Folder34 = @{
                                File31 = 'Fake file contents'
                            }
                        }
                    }
                }
            }
            Folder4 = @{
                Folder41 = @{
                    Folder42 = @{
                        Folder43 = @{
                            Folder44 = @{}
                        }
                    }
                }
            }
            File1 = 'Fake file contents'
            File2 = 'Fake file contents'
        }

        $newZipFileFromHashtableParameters = @{
            Name = $script:testArchiveName
            ParentPath = $TestDrive
            ZipFileStructure = $testArchiveFileStructure
        }

        $script:testArchiveFilePath = New-ZipFileFromHashtable @newZipFileFromHashtableParameters
        $script:testArchiveFilePathWithoutExtension = $script:testArchiveFilePath.Replace('.zip', '')

        # Create another test archive with the same name and file structure but different file content
        $script:testArchiveWithDifferentFileContentName = $script:testArchiveName

        $testArchiveFileWithDifferentFileContentStructure = @{
            Folder1 = @{}
            Folder2 = @{
                Folder21 = @{
                    Folder22 = @{
                        Folder23 = @{}
                    }
                }
            }
            Folder3 = @{
                Folder31 = @{
                    Folder31 = @{
                        Folder33 = @{
                            Folder34 = @{
                                File31 = 'Different fake file contents'
                            }
                        }
                    }
                }
            }
            Folder4 = @{
                Folder41 = @{
                    Folder42 = @{
                        Folder43 = @{
                            Folder44 = @{}
                        }
                    }
                }
            }
            File1 = 'Different fake file contents'
            File2 = 'Different fake file contents'
        }

        $testArchiveFileWithDifferentFileContentParentPath = Join-Path -Path $TestDrive -ChildPath 'MismatchingArchive'
        $null = New-Item -Path $testArchiveFileWithDifferentFileContentParentPath -ItemType 'Directory'

        $newZipFileFromHashtableParameters = @{
            Name = $script:testArchiveWithDifferentFileContentName
            ParentPath = $testArchiveFileWithDifferentFileContentParentPath
            ZipFileStructure = $testArchiveFileWithDifferentFileContentStructure
        }

        $script:testArchiveFileWithDifferentFileContentPath = New-ZipFileFromHashtable @newZipFileFromHashtableParameters
        $script:testArchiveFileWithDifferentFileContentPathWithoutExtension = $script:testArchiveFileWithDifferentFileContentPath.Replace('.zip', '')
    }

    AfterAll {
        $null = Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
    }

    Context 'When expanding an archive to a destination that does not yet exist' {
        $configurationName = 'ExpandArchiveToNonExistentDestination'

        $destination = Join-Path -Path $TestDrive -ChildPath 'NonExistentDestinationForExpand'

        It 'Destination should not exist before configuration' {
            Test-Path -Path $destination | Should -BeFalse
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Present'
            Verbose = $true
        }

        It 'Should return false from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeFalse
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateOnly -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }

    Context 'When expanding an archive to an existing destination with items that are not in the archive' {
        $configurationName = 'ExpandArchiveToDestinationWithOtherItems'

        $destination = Join-Path -Path $TestDrive -ChildPath 'DestinationWithOtherItemsForExpand'
        $null = New-Item -Path $destination -ItemType 'Directory'

        # Keys are the paths to the items. Values are the items' contents with an empty string denoting a directory
        $otherItems = @{}

        $otherDirectoryPath = Join-Path -Path $destination -ChildPath 'OtherDirectory'
        $null = New-Item -Path $otherDirectoryPath -ItemType 'Directory'
        $otherItems[$otherDirectoryPath] = ''

        $otherSubDirectoryPath = Join-Path -Path $otherDirectoryPath -ChildPath 'OtherSubDirectory'
        $null = New-Item -Path $otherSubDirectoryPath -ItemType 'Directory'
        $otherItems[$otherSubDirectoryPath] = ''

        $otherFilePath = Join-Path $otherSubDirectoryPath -ChildPath 'OtherFile'
        $otherFileContent = 'Other file content'
        $null = New-Item -Path $otherFilePath -ItemType 'File'
        $null = Set-Content -Path $otherFilePath -Value $otherFileContent
        $otherItems[$otherFilePath] = $otherFileContent

        It 'Destination should exist before configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        foreach ($otherItemPath in $otherItems.Keys)
        {
            $otherItemName = Split-Path -Path $otherItemPath -Leaf
            $otherItemExpectedContent = $otherItems[$otherItemPath]
            $otherItemIsDirectory = [System.String]::IsNullOrEmpty($otherItemExpectedContent)

            if ($otherItemIsDirectory)
            {
                It "Other item under destination $otherItemName should exist as a directory before configuration" {
                    Test-Path -Path $otherItemPath -PathType 'Container' | Should -BeTrue
                }
            }
            else
            {
                It "Other item under destination $otherItemName should exist as a file before configuration" {
                    Test-Path -Path $otherItemPath -PathType 'Leaf' | Should -BeTrue
                }

                It "Other file under destination $otherItemName should have the expected content before configuration" {
                    Get-Content -Path $otherItemPath -Raw -ErrorAction 'SilentlyContinue' | Should -Be ($otherItemExpectedContent + "`r`n")
                }
            }
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Present'
            Verbose = $true
        }

        It 'Should return false from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeFalse
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateOnly -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        foreach ($otherItemPath in $otherItems.Keys)
        {
            $otherItemName = Split-Path -Path $otherItemPath -Leaf
            $otherItemExpectedContent = $otherItems[$otherItemPath]
            $otherItemIsDirectory = [System.String]::IsNullOrEmpty($otherItemExpectedContent)

            if ($otherItemIsDirectory)
            {
                It "Other item under destination $otherItemName should exist as a directory after configuration" {
                    Test-Path -Path $otherItemPath -PathType 'Container' | Should -BeTrue
                }
            }
            else
            {
                It "Other item under destination $otherItemName should exist as a file after configuration" {
                    Test-Path -Path $otherItemPath -PathType 'Leaf' | Should -BeTrue
                }

                It "Other file under destination $otherItemName should have the expected after before configuration" {
                    Get-Content -Path $otherItemPath -Raw -ErrorAction 'SilentlyContinue' | Should -Be ($otherItemExpectedContent + "`r`n")
                }
            }
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }

    Context 'When expanding an archive to an existing destination that already contains the same archive files' {
        $configurationName = 'ExpandArchiveToDestinationWithArchive'

        $destination = Join-Path -Path $TestDrive -ChildPath 'DestinationWithMatchingArchiveForExpand'
        $null = New-Item -Path $destination -ItemType 'Directory'

        $null = Expand-Archive -Path $script:testArchiveFilePath -DestinationPath $destination -Force

        It 'Destination should exist before configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Present'
            Verbose = $true
        }

        It 'Should return true from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateOnly -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }

    Context 'When expanding an archive to a destination that contains archive files that do not match by the specified SHA Checksum without Force specified' {
        $configurationName = 'ExpandArchiveToDestinationWithMismatchingArchive'

        $destination = Join-Path -Path $TestDrive -ChildPath 'DestinationWithMismatchingArchiveWithSHANoForceForExpand'
        $null = New-Item -Path $destination -ItemType 'Directory'

        $null = Expand-Archive -Path $script:testArchiveFileWithDifferentFileContentPath -DestinationPath $destination -Force

        It 'Destination should exist before configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        It 'File contents of destination should not match the file contents of the archive' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination -CheckContents | Should -BeFalse
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Present'
            Validate = $true
            Checksum = 'SHA-256'
            Force = $false
            Verbose = $true
        }

        It 'Should return false from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeFalse
        }

        It 'Should compile and run configuration and throw an error for attempting to overwrite files without Force specified' {
            # We don't know which file will throw the error, so we will only check that an error was thrown rather than checking the specific error message
            {
                . $script:confgurationFilePathValidateAndChecksum -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        It 'File contents of destination should not match the file contents of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination -CheckContents | Should -BeFalse
        }

        It 'Should return false from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeFalse
        }
    }

    Context 'When expanding an archive to a destination that contains archive files that do not match by the specified SHA Checksum with Force specified' {
        $configurationName = 'ExpandArchiveToDestinationWithMismatchingArchive'

        $destination = Join-Path -Path $TestDrive -ChildPath 'DestinationWithMismatchingArchiveWithSHAAndForceForExpand'
        $null = New-Item -Path $destination -ItemType 'Directory'

        $null = Expand-Archive -Path $script:testArchiveFileWithDifferentFileContentPath -DestinationPath $destination -Force

        It 'Destination should exist before configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        It 'File contents of destination should not match the file contents of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination -CheckContents | Should -BeFalse
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Present'
            Validate = $true
            Checksum = 'SHA-256'
            Force = $true
            Verbose = $true
        }

        It 'Should return false from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeFalse
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateAndChecksum -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        It 'File contents of destination should match the file contents of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination -CheckContents | Should -BeTrue
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }

    Context 'When expanding an archive to a destination that contains archive files that match by the specified SHA Checksum' {
        $configurationName = 'ExpandArchiveToDestinationWithMatchingArchive'

        $destination = Join-Path -Path $TestDrive -ChildPath 'DestinationWithMatchingArchiveWithSHAForExpand'
        $null = New-Item -Path $destination -ItemType 'Directory'

        $null = Expand-Archive -Path $script:testArchiveFilePath -DestinationPath $destination -Force

        It 'Destination should exist before configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        It 'File contents of destination should match the file contents of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination -CheckContents | Should -BeTrue
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Present'
            Validate = $true
            Checksum = 'SHA-256'
            Force = $true
            Verbose = $true
        }

        It 'Should return true from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateAndChecksum -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        It 'File contents of destination should match the file contents of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination -CheckContents | Should -BeTrue
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }

    Context 'When removing an expanded archive from an existing destination that contains only the expanded archive' {
        $configurationName = 'RemoveArchiveAtDestinationWithArchive'

        $destination = Join-Path -Path $TestDrive -ChildPath 'DestinationWithMatchingArchiveForRemove'
        $null = New-Item -Path $destination -ItemType 'Directory'

        $null = Expand-Archive -Path $script:testArchiveFilePath -DestinationPath $destination -Force

        It 'Destination should exist before configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Absent'
            Verbose = $true
        }

        It 'Should return false from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeFalse
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateOnly -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should not match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeFalse
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }

    Context 'When removing an expanded archive from an existing destination that contains the expanded archive and other files' {
        $configurationName = 'RemoveArchiveAtDestinationWithArchiveAndOtherFiles'

        $destination = Join-Path -Path $TestDrive -ChildPath 'DestinationWithMatchingArchiveAndOtherFilesForRemove'
        $null = New-Item -Path $destination -ItemType 'Directory'

        $null = Expand-Archive -Path $script:testArchiveFilePath -DestinationPath $destination -Force

        # Keys are the paths to the items. Values are the items' contents with an empty string denoting a directory
        $otherItems = @{}

        $otherDirectoryPath = Join-Path -Path $destination -ChildPath 'OtherDirectory'
        $null = New-Item -Path $otherDirectoryPath -ItemType 'Directory'
        $otherItems[$otherDirectoryPath] = ''

        $otherSubDirectoryPath = Join-Path -Path $otherDirectoryPath -ChildPath 'OtherSubDirectory'
        $null = New-Item -Path $otherSubDirectoryPath -ItemType 'Directory'
        $otherItems[$otherSubDirectoryPath] = ''

        $otherFilePath = Join-Path $otherSubDirectoryPath -ChildPath 'OtherFile'
        $otherFileContent = 'Other file content'
        $null = New-Item -Path $otherFilePath -ItemType 'File'
        $null = Set-Content -Path $otherFilePath -Value $otherFileContent
        $otherItems[$otherFilePath] = $otherFileContent

        It 'Destination should exist before configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        foreach ($otherItemPath in $otherItems.Keys)
        {
            $otherItemName = Split-Path -Path $otherItemPath -Leaf
            $otherItemExpectedContent = $otherItems[$otherItemPath]
            $otherItemIsDirectory = [System.String]::IsNullOrEmpty($otherItemExpectedContent)

            if ($otherItemIsDirectory)
            {
                It "Other item under destination $otherItemName should exist as a directory before configuration" {
                    Test-Path -Path $otherItemPath -PathType 'Container' | Should -BeTrue
                }
            }
            else
            {
                It "Other item under destination $otherItemName should exist as a file before configuration" {
                    Test-Path -Path $otherItemPath -PathType 'Leaf' | Should -BeTrue
                }

                It "Other file under destination $otherItemName should have the expected content before configuration" {
                    Get-Content -Path $otherItemPath -Raw -ErrorAction 'SilentlyContinue' | Should -Be ($otherItemExpectedContent + "`r`n")
                }
            }
        }

        It 'File structure of destination should match the file structure of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Absent'
            Verbose = $true
        }

        It 'Should return false from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeFalse
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateOnly -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        foreach ($otherItemPath in $otherItems.Keys)
        {
            $otherItemName = Split-Path -Path $otherItemPath -Leaf
            $otherItemExpectedContent = $otherItems[$otherItemPath]
            $otherItemIsDirectory = [System.String]::IsNullOrEmpty($otherItemExpectedContent)

            if ($otherItemIsDirectory)
            {
                It "Other item under destination $otherItemName should exist as a directory before configuration" {
                    Test-Path -Path $otherItemPath -PathType 'Container' | Should -BeTrue
                }
            }
            else
            {
                It "Other item under destination $otherItemName should exist as a file before configuration" {
                    Test-Path -Path $otherItemPath -PathType 'Leaf' | Should -BeTrue
                }

                It "Other file under destination $otherItemName should have the expected content before configuration" {
                    Get-Content -Path $otherItemPath -Raw -ErrorAction 'SilentlyContinue' | Should -Be ($otherItemExpectedContent + "`r`n")
                }
            }
        }

        It 'File structure of destination should not match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeFalse
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }

    Context 'When removing an expanded archive from an existing destination that does not contain any archive files' {
        $configurationName = 'RemoveArchiveAtDestinationWithoutArchive'

        $destination = Join-Path -Path $TestDrive -ChildPath 'EmptyDestinationForRemove'
        $null = New-Item -Path $destination -ItemType 'Directory'

        It 'Destination should exist before configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should not match the file structure of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeFalse
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Absent'
            Verbose = $true
        }

        It 'Should return true from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateOnly -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should not match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeFalse
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }

    Context 'When removing an expanded archive from a destination that does not exist' {
        $configurationName = 'RemoveArchiveFromMissingDestination'

        $destination = Join-Path -Path $TestDrive -ChildPath 'NonexistentDestinationForRemove'

        It 'Destination should not exist before configuration' {
            Test-Path -Path $destination | Should -BeFalse
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Absent'
            Verbose = $true
        }

        It 'Should return true from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateOnly -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should not exist after configuration' {
            Test-Path -Path $destination | Should -BeFalse
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }

    Context 'When removing an archive from a destination that contains archive files that do not match by the specified SHA Checksum' {
        $configurationName = 'RemoveArchiveFromDestinationWithMismatchingArchiveWithSHA'

        $destination = Join-Path -Path $TestDrive -ChildPath 'DestinationWithMismatchingArchiveWithSHAForRemove'
        $null = New-Item -Path $destination -ItemType 'Directory'

        $null = Expand-Archive -Path $script:testArchiveFileWithDifferentFileContentPath -DestinationPath $destination -Force

        It 'Destination should exist before configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        It 'File contents of destination should not match the file contents of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination -CheckContents | Should -BeFalse
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Absent'
            Validate = $true
            Checksum = 'SHA-256'
            Force = $true
            Verbose = $true
        }

        It 'Should return true from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateAndChecksum -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeTrue
        }

        It 'File contents of destination should not match the file contents of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination -CheckContents | Should -BeFalse
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }

    Context 'When removing an archive from a destination that contains archive files that match by the specified SHA Checksum' {
        $configurationName = 'RemoveArchiveFromDestinationWithMatchingArchiveWithSHA'

        $destination = Join-Path -Path $TestDrive -ChildPath 'DestinationWithMatchingArchiveWithSHAForRemove'
        $null = New-Item -Path $destination -ItemType 'Directory'

        $null = Expand-Archive -Path $script:testArchiveFilePath -DestinationPath $destination -Force

        It 'Destination should exist before configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure and contents of destination should match the file contents of the archive before configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination -CheckContents | Should -BeTrue
        }

        $archiveParameters = @{
            Path = $script:testArchiveFilePath
            Destination = $destination
            Ensure = 'Absent'
            Validate = $true
            Checksum = 'SHA-256'
            Force = $true
            Verbose = $true
        }

        It 'Should return false from Test-TargetResource with the same parameters before configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeFalse
        }

        It 'Should compile and apply the MOF without throwing an exception' {
            {
                . $script:confgurationFilePathValidateAndChecksum -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @archiveParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction Stop -Wait -Force -Verbose
            } | Should -Not -Throw
        }

        It 'Destination should exist after configuration' {
            Test-Path -Path $destination | Should -BeTrue
        }

        It 'File structure of destination should not match the file structure of the archive after configuration' {
            Test-FileStructuresMatch -SourcePath $script:testArchiveFilePathWithoutExtension -DestinationPath $destination | Should -BeFalse
        }

        It 'Should return false from Test-TargetResource with the same parameters after configuration' {
            MSFT_Archive\Test-TargetResource @archiveParameters | Should -BeTrue
        }
    }
}
