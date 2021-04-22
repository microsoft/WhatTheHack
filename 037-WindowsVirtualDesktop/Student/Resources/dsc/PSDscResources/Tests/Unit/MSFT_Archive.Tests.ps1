$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

Describe 'Archive Unit Tests' {
    BeforeAll {
        # Import CommonTestHelper for Enter-DscResourceTestEnvironment, Exit-DscResourceTestEnvironment
        $testsFolderFilePath = Split-Path $PSScriptRoot -Parent
        $testHelperFolderFilePath = Join-Path -Path $testsFolderFilePath -ChildPath 'TestHelpers'
        $commonTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'CommonTestHelper.psm1'
        Import-Module -Name $commonTestHelperFilePath

        $script:testEnvironment = Enter-DscResourceTestEnvironment `
            -DscResourceModuleName 'PSDscResources' `
            -DscResourceName 'MSFT_Archive' `
            -TestType 'Unit'
    }

    AfterAll {
        $null = Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
    }

    InModuleScope 'MSFT_Archive' {
        $script:validChecksumValues = @( 'SHA-1', 'SHA-256', 'SHA-512', 'CreatedDate', 'ModifiedDate' )

        $testUsername = 'TestUsername'
        $testPassword = 'TestPassword'
        $secureTestPassword = ConvertTo-SecureString -String $testPassword -AsPlainText -Force

        $script:testCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @( $testUsername, $secureTestPassword )

        $script:testGuid = [System.Guid]::NewGuid()

        Describe 'Get-TargetResource' {
            $testPSDrive = @{
                Root = 'Test PSDrive Name'
            }
            Mock -CommandName 'Mount-PSDriveWithCredential' -MockWith { return $testPSDrive }

            $testInvalidArchivePathErrorMessage = 'Test invalid archive path error message'
            Mock -CommandName 'Assert-PathExistsAsLeaf' -MockWith { throw $testInvalidArchivePathErrorMessage }

            $testInvalidDestinationErrorMessage = 'Test invalid destination error message'
            Mock -CommandName 'Assert-DestinationDoesNotExistAsFile' -MockWith { throw $testInvalidDestinationErrorMessage }

            Mock -CommandName 'Test-Path' -MockWith { return $false }
            Mock -CommandName 'Test-ArchiveExistsAtDestination' -MockWith { return $false }
            Mock -CommandName 'Remove-PSDrive' -MockWith { }

            Context 'When checksum specified and Validate not specified' {
                $getTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Checksum = 'ModifiedDate'
                }

                It 'Should throw an error for Checksum specified while Validate is false' {
                    $errorMessage = $script:localizedData.ChecksumSpecifiedAndValidateFalse -f $getTargetResourceParameters.Checksum, $getTargetResourceParameters.Path, $getTargetResourceParameters.Destination
                    { $null = Get-TargetResource @getTargetResourceParameters } | Should -Throw -ExpectedMessage $errorMessage
                }
            }

            Context 'When invalid archive path specified' {
                $getTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                }

                It 'Should throw an error for invalid archive path' {
                    { $null = Get-TargetResource @getTargetResourceParameters } | Should -Throw -ExpectedMessage $testInvalidArchivePathErrorMessage
                }
            }

            Mock -CommandName 'Assert-PathExistsAsLeaf' -MockWith { }

            Context 'When invalid destination specified' {
                $getTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                }

                It 'Should throw an error for invalid destination' {
                    { $null = Get-TargetResource @getTargetResourceParameters } | Should -Throw -ExpectedMessage $testInvalidDestinationErrorMessage
                }
            }

            Mock -CommandName 'Assert-DestinationDoesNotExistAsFile' -MockWith { }

            Context 'When valid archive path and destination specified and destination does not exist' {
                $getTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { $null = Get-TargetResource @getTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $getTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $getTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the specified archive exists at the specified destination' {
                    Assert-MockCalled -CommandName 'Test-ArchiveExistsAtDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                It 'Should return a Hashtable' {
                    $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                }

                It 'Should return a Hashtable with 3 properties' {
                    $getTargetResourceResult.Keys.Count | Should -Be 3
                }

                It 'Should return a Hashtable with the Path property as the specified path' {
                    $getTargetResourceResult.Path | Should -Be $getTargetResourceParameters.Path
                }

                It 'Should return a Hashtable with the Destination property as the specified destination' {
                    $getTargetResourceResult.Destination | Should -Be $getTargetResourceParameters.Destination
                }

                It 'Should return a Hashtable with the Ensure property as Absent' {
                    $getTargetResourceResult.Ensure | Should -Be 'Absent'
                }
            }

            Context 'When valid archive path and destination specified, destination does not exist, Validate specified as true, and Checksum specified' {
                $getTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Validate = $true
                    Checksum = 'ModifiedDate'
                }

                It 'Should not throw' {
                    { $null = Get-TargetResource @getTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $getTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $getTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the specified archive exists at the specified destination' {
                    Assert-MockCalled -CommandName 'Test-ArchiveExistsAtDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                It 'Should return a Hashtable' {
                    $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                }

                It 'Should return a Hashtable with 3 properties' {
                    $getTargetResourceResult.Keys.Count | Should -Be 3
                }

                It 'Should return a Hashtable with the Path property as the specified path' {
                    $getTargetResourceResult.Path | Should -Be $getTargetResourceParameters.Path
                }

                It 'Should return a Hashtable with the Destination property as the specified destination' {
                    $getTargetResourceResult.Destination | Should -Be $getTargetResourceParameters.Destination
                }

                It 'Should return a Hashtable with the Ensure property as Absent' {
                    $getTargetResourceResult.Ensure | Should -Be 'Absent'
                }
            }

            Mock -CommandName 'Test-Path' -MockWith { return $true }

            Context 'When valid archive path and destination specified, destination exists, and archive is not expanded at destination' {
                $getTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { $null = Get-TargetResource @getTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $getTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $getTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified archive exists at the specified destination' {
                    $testArchiveExistsAtDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $getTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveExistsAtDestination' -ParameterFilter $testArchiveExistsAtDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                It 'Should return a Hashtable' {
                    $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                }

                It 'Should return a Hashtable with 3 properties' {
                    $getTargetResourceResult.Keys.Count | Should -Be 3
                }

                It 'Should return a Hashtable with the Path property as the specified path' {
                    $getTargetResourceResult.Path | Should -Be $getTargetResourceParameters.Path
                }

                It 'Should return a Hashtable with the Destination property as the specified destination' {
                    $getTargetResourceResult.Destination | Should -Be $getTargetResourceParameters.Destination
                }

                It 'Should return a Hashtable with the Ensure property as Absent' {
                    $getTargetResourceResult.Ensure | Should -Be 'Absent'
                }
            }

            Context 'When valid archive path and destination specified, destination exists, archive is not expanded at destination, Validate specified as true, and Checksum specified' {
                $getTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Validate = $true
                    Checksum = 'CreatedDate'
                }

                It 'Should not throw' {
                    { $null = Get-TargetResource @getTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $getTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $getTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified archive exists at the specified destination' {
                    $testArchiveExistsAtDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $getTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination
                        $checksumParameterCorrect = $Checksum -eq $getTargetResourceParameters.Checksum

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveExistsAtDestination' -ParameterFilter $testArchiveExistsAtDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                It 'Should return a Hashtable' {
                    $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                }

                It 'Should return a Hashtable with 3 properties' {
                    $getTargetResourceResult.Keys.Count | Should -Be 3
                }

                It 'Should return a Hashtable with the Path property as the specified path' {
                    $getTargetResourceResult.Path | Should -Be $getTargetResourceParameters.Path
                }

                It 'Should return a Hashtable with the Destination property as the specified destination' {
                    $getTargetResourceResult.Destination | Should -Be $getTargetResourceParameters.Destination
                }

                It 'Should return a Hashtable with the Ensure property as Absent' {
                    $getTargetResourceResult.Ensure | Should -Be 'Absent'
                }
            }

            Mock -CommandName 'Test-ArchiveExistsAtDestination' -MockWith { return $true }

            Context 'When valid archive path and destination specified, destination exists, and archive is expanded at destination' {
                $getTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { $null = Get-TargetResource @getTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $getTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $getTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified archive exists at the specified destination' {
                    $testArchiveExistsAtDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $getTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveExistsAtDestination' -ParameterFilter $testArchiveExistsAtDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                It 'Should return a Hashtable' {
                    $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                }

                It 'Should return a Hashtable with 3 properties' {
                    $getTargetResourceResult.Keys.Count | Should -Be 3
                }

                It 'Should return a Hashtable with the Path property as the specified path' {
                    $getTargetResourceResult.Path | Should -Be $getTargetResourceParameters.Path
                }

                It 'Should return a Hashtable with the Destination property as the specified destination' {
                    $getTargetResourceResult.Destination | Should -Be $getTargetResourceParameters.Destination
                }

                It 'Should return a Hashtable with the Ensure property as Present' {
                    $getTargetResourceResult.Ensure | Should -Be 'Present'
                }
            }

            Context 'When valid archive path and destination specified, destination exists, archive is expanded at destination, Validate specified as true, and Checksum specified' {
                $getTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Validate = $true
                    Checksum = 'CreatedDate'
                }

                It 'Should not throw' {
                    { $null = Get-TargetResource @getTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $getTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $getTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified archive exists at the specified destination' {
                    $testArchiveExistsAtDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $getTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination
                        $checksumParameterCorrect = $Checksum -eq $getTargetResourceParameters.Checksum

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveExistsAtDestination' -ParameterFilter $testArchiveExistsAtDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                It 'Should return a Hashtable' {
                    $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                }

                It 'Should return a Hashtable with 3 properties' {
                    $getTargetResourceResult.Keys.Count | Should -Be 3
                }

                It 'Should return a Hashtable with the Path property as the specified path' {
                    $getTargetResourceResult.Path | Should -Be $getTargetResourceParameters.Path
                }

                It 'Should return a Hashtable with the Destination property as the specified destination' {
                    $getTargetResourceResult.Destination | Should -Be $getTargetResourceParameters.Destination
                }

                It 'Should return a Hashtable with the Ensure property as Present' {
                    $getTargetResourceResult.Ensure | Should -Be 'Present'
                }
            }

            Context 'When valid archive path and destination specified, destination exists, archive is expanded at destination, and credential specified' {
                $getTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Credential = $script:testCredential
                }

                It 'Should not throw' {
                    { $null = Get-TargetResource @getTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should mount a PSDrive' {
                    $mountPSDriveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $getTargetResourceParameters.Path
                        $credentialParameterCorrect = $null -eq (Compare-Object -ReferenceObject $getTargetResourceParameters.Credential -DifferenceObject $Credential)

                        return $pathParameterCorrect -and $credentialParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -ParameterFilter $mountPSDriveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $getTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $getTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified archive exists at the specified destination' {
                    $testArchiveExistsAtDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $getTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $getTargetResourceParameters.Destination

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveExistsAtDestination' -ParameterFilter $testArchiveExistsAtDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should remove the mounted PSDrive' {
                    $removePSDriveParameterFilter = {
                        $nameParameterCorrect = $null -eq (Compare-Object -ReferenceObject $testPSDrive -DifferenceObject $Name)
                        $forceParameterCorrect = $Force -eq $true

                        return $nameParameterCorrect -and $forceParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-PSDrive' -ParameterFilter $removePSDriveParameterFilter -Exactly 1 -Scope 'Context'
                }

                $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                It 'Should return a Hashtable' {
                    $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                }

                It 'Should return a Hashtable with 3 properties' {
                    $getTargetResourceResult.Keys.Count | Should -Be 3
                }

                It 'Should return a Hashtable with the Path property as the specified path' {
                    $getTargetResourceResult.Path | Should -Be $getTargetResourceParameters.Path
                }

                It 'Should return a Hashtable with the Destination property as the specified destination' {
                    $getTargetResourceResult.Destination | Should -Be $getTargetResourceParameters.Destination
                }

                It 'Should return a Hashtable with the Ensure property as Present' {
                    $getTargetResourceResult.Ensure | Should -Be 'Present'
                }
            }
        }

        Describe 'Set-TargetResource' {
            $testPSDrive = @{
                Root = 'Test PSDrive Name'
            }
            Mock -CommandName 'Mount-PSDriveWithCredential' -MockWith { return $testPSDrive }

            $testInvalidArchivePathErrorMessage = 'Test invalid archive path error message'
            Mock -CommandName 'Assert-PathExistsAsLeaf' -MockWith { throw $testInvalidArchivePathErrorMessage }

            $testInvalidDestinationErrorMessage = 'Test invalid destination error message'
            Mock -CommandName 'Assert-DestinationDoesNotExistAsFile' -MockWith { throw $testInvalidDestinationErrorMessage }

            Mock -CommandName 'Test-Path' -MockWith { return $false }
            Mock -CommandName 'Expand-ArchiveToDestination' -MockWith { }
            Mock -CommandName 'Remove-ArchiveFromDestination' -MockWith { }
            Mock -CommandName 'New-Item' -MockWith { }
            Mock -CommandName 'Remove-PSDrive' -MockWith { }

            Context 'When checksum specified and Validate not specified' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Checksum = 'ModifiedDate'
                }

                It 'Should throw an error for Checksum specified while Validate is false' {
                    $errorMessage = $script:localizedData.ChecksumSpecifiedAndValidateFalse -f $setTargetResourceParameters.Checksum, $setTargetResourceParameters.Path, $setTargetResourceParameters.Destination
                    { Set-TargetResource @setTargetResourceParameters } | Should -Throw -ExpectedMessage $errorMessage
                }
            }

            Context 'When invalid archive path specified' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                }

                It 'Should throw an error for invalid archive path' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Throw -ExpectedMessage $testInvalidArchivePathErrorMessage
                }
            }

            Mock -CommandName 'Assert-PathExistsAsLeaf' -MockWith { }

            Context 'When invalid destination specified' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                }

                It 'Should throw an error for invalid destination' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Throw -ExpectedMessage $testInvalidDestinationErrorMessage
                }
            }

            Mock -CommandName 'Assert-DestinationDoesNotExistAsFile' -MockWith { }

            Context 'When valid archive path and destination specified, destination does not exist, and Ensure specified as Present' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Present'
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $setTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should create a new directory at the specified destination' {
                    $newItemParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Destination
                        $itemTypeParameterCorrect = $ItemType -eq 'Directory'

                        return $pathParameterCorrect -and $itemTypeParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'New-Item' -ParameterFilter $newItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should expand the archive to the specified destination' {
                    $expandArchiveToDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $setTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        $forceParameterCorrect = $Force -eq $false

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect -and $forceParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Expand-ArchiveToDestination' -ParameterFilter $expandArchiveToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove the content of the opened archive from the directory at the specified destination' {
                    Assert-MockCalled -CommandName 'Remove-ArchiveFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                It 'Should not return' {
                    Set-TargetResource @setTargetResourceParameters | Should -Be $null
                }
            }

            Context 'When valid archive path and destination specified, destination does not exist, and Ensure specified as Absent' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Absent'
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $setTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to create a new directory at the specified destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to expand the archive to the specified destination' {
                    Assert-MockCalled -CommandName 'Expand-ArchiveToDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove the content of the opened archive from the directory at the specified destination' {
                    Assert-MockCalled -CommandName 'Remove-ArchiveFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                It 'Should not return' {
                    Set-TargetResource @setTargetResourceParameters | Should -Be $null
                }
            }

            Context 'When valid archive path and destination specified, destination does not exist, Ensure specified as Present, Validate specified as true, and Checksum specified' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Present'
                    Validate = $true
                    Checksum = 'ModifiedDate'
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $setTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should create a new directory at the specified destination' {
                    $newItemParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Destination
                        $itemTypeParameterCorrect = $ItemType -eq 'Directory'

                        return $pathParameterCorrect -and $itemTypeParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'New-Item' -ParameterFilter $newItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should expand the archive to the specified destination based on the specified Checksum method' {
                    $expandArchiveToDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $setTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        $checksumParameterCorrect = $Checksum -eq $setTargetResourceParameters.Checksum
                        $forceParameterCorrect = $Force -eq $false

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect -and $checksumParameterCorrect -and $forceParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Expand-ArchiveToDestination' -ParameterFilter $expandArchiveToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove the content of the opened archive from the directory at the specified destination' {
                    Assert-MockCalled -CommandName 'Remove-ArchiveFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                It 'Should not return' {
                    Set-TargetResource @setTargetResourceParameters | Should -Be $null
                }
            }

            Context 'When valid archive path and destination specified, destination does not exist, Ensure specified as Absent, Validate specified as true, and Checksum specified' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Absent'
                    Validate = $true
                    Checksum = 'SHA-256'
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $setTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to create a new directory at the specified destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to expand the archive to the specified destination' {
                    Assert-MockCalled -CommandName 'Expand-ArchiveToDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove the content of the opened archive from the directory at the specified destination' {
                    Assert-MockCalled -CommandName 'Remove-ArchiveFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                It 'Should not return' {
                    Set-TargetResource @setTargetResourceParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Test-Path' -MockWith { return $true }

            Context 'When valid archive path and destination specified, destination exists, and Ensure specified as Present' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Present'
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $setTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to create a new directory at the specified destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should expand the archive to the specified destination' {
                    $expandArchiveToDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $setTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        $forceParameterCorrect = $Force -eq $false

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect -and $forceParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Expand-ArchiveToDestination' -ParameterFilter $expandArchiveToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove the content of the opened archive from the directory at the specified destination' {
                    Assert-MockCalled -CommandName 'Remove-ArchiveFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                It 'Should not return' {
                    Set-TargetResource @setTargetResourceParameters | Should -Be $null
                }
            }

            Context 'When valid archive path and destination specified, destination exists, and Ensure specified as Absent' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Absent'
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $setTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to create a new directory at the specified destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to expand the archive to the specified destination' {
                    Assert-MockCalled -CommandName 'Expand-ArchiveToDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should remove the content of the opened archive from the directory at the specified destination' {
                    $removeArchiveFromDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $setTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-ArchiveFromDestination' -ParameterFilter $removeArchiveFromDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                It 'Should not return' {
                    Set-TargetResource @setTargetResourceParameters | Should -Be $null
                }
            }

            Context 'When valid archive path and destination specified, destination exists, Ensure specified as Present, Validate specified as true, and Checksum specified' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Present'
                    Validate = $true
                    Checksum = 'CreatedDate'
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $setTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to create a new directory at the specified destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should expand the archive to the specified destination based on the specified Checksum method' {
                    $expandArchiveToDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $setTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        $checksumParameterCorrect = $Checksum -eq $setTargetResourceParameters.Checksum
                        $forceParameterCorrect = $Force -eq $false

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect -and $checksumParameterCorrect -and $forceParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Expand-ArchiveToDestination' -ParameterFilter $expandArchiveToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove the content of the opened archive from the directory at the specified destination' {
                    Assert-MockCalled -CommandName 'Remove-ArchiveFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                It 'Should not return' {
                    Set-TargetResource @setTargetResourceParameters | Should -Be $null
                }
            }

            Context 'When valid archive path and destination specified, destination exists, Ensure specified as Absent, Validate specified as true, and Checksum specified' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Absent'
                    Validate = $true
                    Checksum = 'SHA-512'
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should not attempt to mount a PSDrive' {
                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -Exactly 0 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $setTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to create a new directory at the specified destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to expand the archive to the specified destination' {
                    Assert-MockCalled -CommandName 'Expand-ArchiveToDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should remove the content of the opened archive from the directory at the specified destination' {
                    $removeArchiveFromDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $setTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        $checksumParameterCorrect = $Checksum -eq $setTargetResourceParameters.Checksum

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-ArchiveFromDestination' -ParameterFilter $removeArchiveFromDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove a mounted PSDrive' {
                    Assert-MockCalled -CommandName 'Remove-PSDrive' -Exactly 0 -Scope 'Context'
                }

                It 'Should not return' {
                    Set-TargetResource @setTargetResourceParameters | Should -Be $null
                }
            }

            Context 'When valid archive path and destination specified, destination exists, and credential specified' {
                $setTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Credential = $script:testCredential
                }

                It 'Should not throw' {
                    { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should mount a PSDrive' {
                    $mountPSDriveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Path
                        $credentialParameterCorrect = $null -eq (Compare-Object -ReferenceObject $setTargetResourceParameters.Credential -DifferenceObject $Credential)

                        return $pathParameterCorrect -and $credentialParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Mount-PSDriveWithCredential' -ParameterFilter $mountPSDriveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified archive path is valid' {
                    $assertPathExistsAsLeafParameterFilter = {
                        $pathParameterCorrect = $Path -eq $setTargetResourceParameters.Path
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-PathExistsAsLeaf' -ParameterFilter $assertPathExistsAsLeafParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should assert that the specified destination is valid' {
                    $assertDestinationDoesNotExistAsFileParameterFilter = {
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        return $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Assert-DestinationDoesNotExistAsFile' -ParameterFilter $assertDestinationDoesNotExistAsFileParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified destination exists' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $setTargetResourceParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to create a new directory at the specified destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should expand the archive to the specified destination' {
                    $expandArchiveToDestinationParameterFilter = {
                        $archiveSourcePathParameterCorrect = $ArchiveSourcePath -eq $setTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $setTargetResourceParameters.Destination
                        $forceParameterCorrect = $Force -eq $false

                        return $archiveSourcePathParameterCorrect -and $destinationParameterCorrect -and $forceParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Expand-ArchiveToDestination' -ParameterFilter $expandArchiveToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove the content of the opened archive from the directory at the specified destination' {
                    Assert-MockCalled -CommandName 'Remove-ArchiveFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should remove the mounted PSDrive' {
                    $removePSDriveParameterFilter = {
                        $nameParameterCorrect = $null -eq (Compare-Object -ReferenceObject $testPSDrive -DifferenceObject $Name)
                        $forceParameterCorrect = $Force -eq $true

                        return $nameParameterCorrect -and $forceParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-PSDrive' -ParameterFilter $removePSDriveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return' {
                    Set-TargetResource @setTargetResourceParameters | Should -Be $null
                }
            }
        }

        Describe 'Test-TargetResource' {
            Mock -CommandName 'Get-TargetResource' -MockWith { return @{ Ensure = 'Absent' } }

            Context 'When archive with specified path is not expanded at the specified destination and Ensure is specified as Present' {
                $testTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Present'
                }

                It 'Should not throw' {
                    { $null = Test-TargetResource @testTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should retrieve the state of the specified archive' {
                    $getTargetResourceParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $testTargetResourceParameters.Destination

                        return $pathParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-TargetResource' -ParameterFilter $getTargetResourceParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-TargetResource @testTargetResourceParameters | Should -BeFalse
                }
            }

            Context 'When archive with specified path is not expanded at the specified destination and Ensure is specified as Absent' {
                $testTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Absent'
                }

                It 'Should not throw' {
                    { $null = Test-TargetResource @testTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should retrieve the state of the specified archive' {
                    $getTargetResourceParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $testTargetResourceParameters.Destination

                        return $pathParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-TargetResource' -ParameterFilter $getTargetResourceParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-TargetResource @testTargetResourceParameters | Should -BeTrue
                }
            }

            Mock -CommandName 'Get-TargetResource' -MockWith { return @{ Ensure = 'Present' } }

            Context 'When archive with specified path is expanded at the specified destination and Ensure is specified as Present' {
                $testTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Present'
                }

                It 'Should not throw' {
                    { $null = Test-TargetResource @testTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should retrieve the state of the specified archive' {
                    $getTargetResourceParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $testTargetResourceParameters.Destination

                        return $pathParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-TargetResource' -ParameterFilter $getTargetResourceParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-TargetResource @testTargetResourceParameters | Should -BeTrue
                }
            }

            Context 'When archive with specified path is expanded at the specified destination and Ensure is specified as Absent' {
                $testTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Absent'
                }

                It 'Should not throw' {
                    { $null = Test-TargetResource @testTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should retrieve the state of the specified archive' {
                    $getTargetResourceParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $testTargetResourceParameters.Destination

                        return $pathParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-TargetResource' -ParameterFilter $getTargetResourceParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-TargetResource @testTargetResourceParameters | Should -BeFalse
                }
            }

            Context 'When archive with specified path is expanded at the specified destination, Validate and Checksum specified, and Ensure is specified as Present' {
                $testTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Present'
                    Validate = $true
                    Checksum = 'SHA-256'
                }

                It 'Should not throw' {
                    { $null = Test-TargetResource @testTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should retrieve the state of the specified archive' {
                    $getTargetResourceParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $testTargetResourceParameters.Destination
                        $validateParameterCorrect = $Validate -eq $testTargetResourceParameters.Validate
                        $checksumParameterCorrect = $Checksum -eq $testTargetResourceParameters.Checksum

                        return $pathParameterCorrect -and $destinationParameterCorrect -and $validateParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-TargetResource' -ParameterFilter $getTargetResourceParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-TargetResource @testTargetResourceParameters | Should -BeTrue
                }
            }

            Context 'When archive with specified path is expanded at the specified destination, Credential specified, and Ensure is specified as Present' {
                $testTargetResourceParameters = @{
                    Path = 'TestPath'
                    Destination = 'TestDestination'
                    Ensure = 'Present'
                    Credential = $script:testCredential
                }

                It 'Should not throw' {
                    { $null = Test-TargetResource @testTargetResourceParameters } | Should -Not -Throw
                }

                It 'Should retrieve the state of the specified archive' {
                    $getTargetResourceParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testTargetResourceParameters.Path
                        $destinationParameterCorrect = $Destination -eq $testTargetResourceParameters.Destination
                        $credentialParameterCorrect = $null -eq (Compare-Object -ReferenceObject $testTargetResourceParameters.Credential -DifferenceObject $Credential)

                        return $pathParameterCorrect -and $destinationParameterCorrect -and $credentialParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-TargetResource' -ParameterFilter $getTargetResourceParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-TargetResource @testTargetResourceParameters | Should -BeTrue
                }
            }
        }

        Describe 'Mount-PSDriveWithCredential' {
            Mock -CommandName 'Test-Path' -MockWith { return $true }
            Mock -CommandName 'New-Guid' -MockWith { return $script:testGuid }
            Mock -CommandName 'Invoke-NewPSDrive' -MockWith { throw 'Test error from New-PSDrive' }

            Context 'When specified path is already accessible' {
                $mountPSDriveWithCredentialParameters = @{
                    Path = 'TestPath'
                    Credential = $script:testCredential
                }

                It 'Should not throw' {
                    { $null = Mount-PSDriveWithCredential @mountPSDriveWithCredentialParameters } | Should -Not -Throw
                }

                It 'Should test if the given path is already accessible' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $mountPSDriveWithCredentialParameters.Path
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to create a new guid' {
                    Assert-MockCalled -CommandName 'New-Guid' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create a new PSDrive' {
                    Assert-MockCalled -CommandName 'Invoke-NewPSDrive' -Exactly 0 -Scope 'Context'
                }

                $mountPSDriveWithCredentialResult = Mount-PSDriveWithCredential @mountPSDriveWithCredentialParameters

                It 'Should return null' {
                    $mountPSDriveWithCredentialResult | Should -Be $null
                }
            }

            Mock -CommandName 'Test-Path' -MockWith { return $false }

            Context 'When specified path is not accessible, path contains a backslash but does not end with a backslash, and new PSDrive creation fails' {
                $mountPSDriveWithCredentialParameters = @{
                    Path = 'Test\Path'
                    Credential = $script:testCredential
                }

                It 'Should throw an error for failed PSDrive creation' {
                    $expectedPath = $mountPSDriveWithCredentialParameters.Path.Substring(0, $mountPSDriveWithCredentialParameters.Path.IndexOf('\'))
                    $expectedErrorMessage = $script:localizedData.ErrorCreatingPSDrive -f $expectedPath, $mountPSDriveWithCredentialParameters.Credential.UserName
                    { $null = Mount-PSDriveWithCredential @mountPSDriveWithCredentialParameters } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }

            $expectedPSDrive = New-MockObject -Type 'System.Management.Automation.PSDriveInfo'
            Mock -CommandName 'Invoke-NewPSDrive' -MockWith { return $expectedPSDrive }

            Context 'When specified path is not accessible, path contains a backslash but does not end with a backslash, and new PSDrive creation succeeds' {
                $mountPSDriveWithCredentialParameters = @{
                    Path = 'Test\Path'
                    Credential = $script:testCredential
                }

                $expectedPSDrivePath = $mountPSDriveWithCredentialParameters.Path.Substring(0, $mountPSDriveWithCredentialParameters.Path.IndexOf('\'))

                It 'Should not throw' {
                    { $null = Mount-PSDriveWithCredential @mountPSDriveWithCredentialParameters } | Should -Not -Throw
                }

                It 'Should test if the given path is already accessible' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $mountPSDriveWithCredentialParameters.Path
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should create a new guid' {
                    Assert-MockCalled -CommandName 'New-Guid' -Exactly 1 -Scope 'Context'
                }

                It 'Should create a new PSDrive' {
                    $newPSDriveParameterFilter = {
                        $nameParameterCorrect = $Parameters.Name -eq $script:testGuid
                        $psProviderParameterCorrect = $Parameters.PSProvider -eq 'FileSystem'
                        $rootParameterCorrect = $Parameters.Root -eq $expectedPSDrivePath
                        $scopeParameterCorrect = $Parameters.Scope -eq 'Script'
                        $credentialParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mountPSDriveWithCredentialParameters.Credential -DifferenceObject $Parameters.Credential)

                        return $nameParameterCorrect -and $psProviderParameterCorrect -and $rootParameterCorrect -and $scopeParameterCorrect -and $credentialParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Invoke-NewPSDrive' -ParameterFilter $newPSDriveParameterFilter -Exactly 1 -Scope 'Context'
                }

                $mountPSDriveWithCredentialResult = Mount-PSDriveWithCredential @mountPSDriveWithCredentialParameters

                It 'Should return the PSDrive outputted from New-PSDrive' {
                    $mountPSDriveWithCredentialResult | Should -Be $expectedPSDrive
                }
            }

            Context 'When specified path is not accessible, path ends with a backslash, and new PSDrive creation succeeds' {
                $mountPSDriveWithCredentialParameters = @{
                    Path = 'TestPath\'
                    Credential = $script:testCredential
                }

                It 'Should not throw' {
                    { $null = Mount-PSDriveWithCredential @mountPSDriveWithCredentialParameters } | Should -Not -Throw
                }

                It 'Should test if the given path is already accessible' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $mountPSDriveWithCredentialParameters.Path
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should create a new guid' {
                    Assert-MockCalled -CommandName 'New-Guid' -Exactly 1 -Scope 'Context'
                }

                It 'Should create a new PSDrive' {
                    $newPSDriveParameterFilter = {
                        $nameParameterCorrect = $Parameters.Name -eq $script:testGuid
                        $psProviderParameterCorrect = $Parameters.PSProvider -eq 'FileSystem'
                        $rootParameterCorrect = $Parameters.Root -eq $mountPSDriveWithCredentialParameters.Path
                        $scopeParameterCorrect = $Parameters.Scope -eq 'Script'
                        $credentialParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mountPSDriveWithCredentialParameters.Credential -DifferenceObject $Parameters.Credential)

                        return $nameParameterCorrect -and $psProviderParameterCorrect -and $rootParameterCorrect -and $scopeParameterCorrect -and $credentialParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Invoke-NewPSDrive' -ParameterFilter $newPSDriveParameterFilter -Exactly 1 -Scope 'Context'
                }

                $mountPSDriveWithCredentialResult = Mount-PSDriveWithCredential @mountPSDriveWithCredentialParameters

                It 'Should return the PSDrive outputted from New-PSDrive' {
                    $mountPSDriveWithCredentialResult | Should -Be $expectedPSDrive
                }
            }

            Context 'When specified path is not accessible and path does not contain a backslash' {
                $mountPSDriveWithCredentialParameters = @{
                    Path = 'TestPath'
                    Credential = $script:testCredential
                }

                It 'Should throw an error for an invalid path' {
                    $expectedErrorMessage = $script:localizedData.PathDoesNotContainValidPSDriveRoot -f $mountPSDriveWithCredentialParameters.Path
                    { $null = Mount-PSDriveWithCredential @mountPSDriveWithCredentialParameters } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }
        }

        Describe 'Assert-PathExistsAsLeaf' {
            Mock -CommandName 'Test-Path' -MockWith { return $true }

            Context 'When path exists as a leaf' {
                $assertPathExistsAsLeafParameters = @{
                    Path = 'TestPath'
                }

                It 'Should not throw' {
                    { Assert-PathExistsAsLeaf @assertPathExistsAsLeafParameters } | Should -Not -Throw
                }

                It 'Should test if path exists as a leaf' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $assertPathExistsAsLeafParameters.Path
                        $pathTypeParameterCorrect = $PathType -eq 'Leaf'

                        return $literalPathParameterCorrect -and $pathTypeParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }
            }

            Mock -CommandName 'Test-Path' -MockWith { return $false }

            Context 'When path does not exist' {
                $assertPathExistsAsLeafParameters = @{
                    Path = 'TestPath'
                }

                It 'Should throw an error for non-existent path' {
                    $expectedErrorMessage = $script:localizedData.PathDoesNotExistAsLeaf -f $assertPathExistsAsLeafParameters.Path
                    { Assert-PathExistsAsLeaf @assertPathExistsAsLeafParameters } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }
        }

        Describe 'Assert-DestinationDoesNotExistAsFile' {
            Mock -CommandName 'Get-Item' -MockWith { return $null }

            Context 'When item at destination does not exist' {
                $assertDestinationDoesNotExistAsFileParameters = @{
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Assert-DestinationDoesNotExistAsFile @assertDestinationDoesNotExistAsFileParameters } | Should -Not -Throw
                }

                It 'Should retrieve item at destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $assertDestinationDoesNotExistAsFileParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }
            }

            $directoryItem = New-Object -TypeName 'System.IO.DirectoryInfo' -ArgumentList @( 'TestDirectory' )
            Mock -CommandName 'Get-Item' -MockWith { return $directoryItem }

            Context 'When item at destination exists as a directory' {
                $assertDestinationDoesNotExistAsFileParameters = @{
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Assert-DestinationDoesNotExistAsFile @assertDestinationDoesNotExistAsFileParameters } | Should -Not -Throw
                }

                It 'Should retrieve item at destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $assertDestinationDoesNotExistAsFileParameters.Destination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }
            }

            $fileItem = New-Object -TypeName 'System.IO.FileInfo' -ArgumentList @( 'TestFile' )

            Mock -CommandName 'Get-Item' -MockWith { return $fileItem }

            Context 'When item at destination exists as a file' {
                $assertDestinationDoesNotExistAsFileParameters = @{
                    Destination = 'TestDestination'
                }

                It 'Should throw error for file at destination' {
                    $expectedErrorMessage = $script:localizedData.DestinationExistsAsFile -f $assertDestinationDoesNotExistAsFileParameters.Destination
                    { Assert-DestinationDoesNotExistAsFile @assertDestinationDoesNotExistAsFileParameters } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }
        }

        Describe 'Test-ChecksumIsSha' {
            Context 'When specified checksum method name is a SHA method name' {
                $testChecksumIsShaParameters = @{
                    Checksum = 'SHA-256'
                }

                It 'Should not throw' {
                    { $null = Test-ChecksumIsSha @testChecksumIsShaParameters } | Should -Not -Throw
                }

                $testChecksumIsShaResult = Test-ChecksumIsSha @testChecksumIsShaParameters

                It 'Should return true' {
                    $testChecksumIsShaResult | Should -BeTrue
                }
            }

            Context 'When specified checksum method name is not a SHA method name' {
                $testChecksumIsShaParameters = @{
                    Checksum = 'CreatedDate'
                }

                It 'Should not throw' {
                    { $null = Test-ChecksumIsSha @testChecksumIsShaParameters } | Should -Not -Throw
                }

                $testChecksumIsShaResult = Test-ChecksumIsSha @testChecksumIsShaParameters

                It 'Should return false' {
                    $testChecksumIsShaResult | Should -BeFalse
                }
            }

            Context 'When specified checksum method name is less than 3 characters' {
                $testChecksumIsShaParameters = @{
                    Checksum = 'AB'
                }

                It 'Should not throw' {
                    { $null = Test-ChecksumIsSha @testChecksumIsShaParameters } | Should -Not -Throw
                }

                $testChecksumIsShaResult = Test-ChecksumIsSha @testChecksumIsShaParameters

                It 'Should return false' {
                    $testChecksumIsShaResult | Should -BeFalse
                }
            }
        }

        Describe 'ConvertTo-PowerShellHashAlgorithmName' {
            $convertToPowerShellHashAlgorithmNameParameters = @{
                DscHashAlgorithmName = 'SHA-256'
            }

            It 'Should not throw' {
                { $null = ConvertTo-PowerShellHashAlgorithmName @convertToPowerShellHashAlgorithmNameParameters } | Should -Not -Throw
            }

            $convertToPowerShellHashAlgorithmNameResult = ConvertTo-PowerShellHashAlgorithmName @convertToPowerShellHashAlgorithmNameParameters

            It 'Should return the specified algorithm name without the hyphen' {
                $convertToPowerShellHashAlgorithmNameResult | Should -Be 'SHA256'
            }
        }

        Describe 'Test-FileHashMatchesArchiveEntryHash' {
            $testArchiveEntryFullName = 'TestArchiveEntryFullName'
            $expectedPowerShellHashAlgorithmName = 'SHA256'

            $mockArchiveEntry = New-MockObject -Type 'System.IO.Compression.ZipArchiveEntry'
            $mockFileStream = New-MockObject -Type 'System.IO.FileStream'

            Mock -CommandName 'Get-ArchiveEntryFullName' -MockWith { return $testArchiveEntryFullName }
            Mock -CommandName 'ConvertTo-PowerShellHashAlgorithmName' -MockWith { return $expectedPowerShellHashAlgorithmName }
            Mock -CommandName 'Open-ArchiveEntry' -MockWith { throw 'Error opening archive entry' }
            Mock -CommandName 'New-Object' -MockWith { throw 'Error opening stream to file' }
            Mock -CommandName 'Get-FileHash' -MockWith { throw 'Error retrieving hash'}
            Mock -CommandName 'Close-Stream' -MockWith { }

            Context 'When opening the specified archive entry fails' {
                $testFileHashMatchesArchiveEntryHashParameters = @{
                    FilePath = 'TestPath'
                    ArchiveEntry = $mockArchiveEntry
                    HashAlgorithmName = 'SHA-256'
                }

                It 'Should throw error for failure while opening archive entry' {
                    $expectedErrorMessage = $script:localizedData.ErrorComparingHashes -f $testFileHashMatchesArchiveEntryHashParameters.FilePath, $testArchiveEntryFullName, $testFileHashMatchesArchiveEntryHashParameters.HashAlgorithmName
                    { $null = Test-FileHashMatchesArchiveEntryHash @testFileHashMatchesArchiveEntryHashParameters } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }

            Mock -CommandName 'Open-ArchiveEntry' -MockWith { return $mockFileStream }

            Context 'When opening a stream to the specified file fails' {
                $testFileHashMatchesArchiveEntryHashParameters = @{
                    FilePath = 'TestPath'
                    ArchiveEntry = $mockArchiveEntry
                    HashAlgorithmName = 'SHA-256'
                }

                It 'Should throw error for failure while opening a stream to the file' {
                    $expectedErrorMessage = $script:localizedData.ErrorComparingHashes -f $testFileHashMatchesArchiveEntryHashParameters.FilePath, $testArchiveEntryFullName, $testFileHashMatchesArchiveEntryHashParameters.HashAlgorithmName
                    { $null = Test-FileHashMatchesArchiveEntryHash @testFileHashMatchesArchiveEntryHashParameters } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }

            Mock -CommandName 'New-Object' -MockWith { return $mockFileStream }

            Context 'When retrieving the file hash fails' {
                $testFileHashMatchesArchiveEntryHashParameters = @{
                    FilePath = 'TestPath'
                    ArchiveEntry = $mockArchiveEntry
                    HashAlgorithmName = 'SHA-256'
                }

                It 'Should throw error for failure to retrieve the file hash or archive entry hash' {
                    $expectedErrorMessage = $script:localizedData.ErrorComparingHashes -f $testFileHashMatchesArchiveEntryHashParameters.FilePath, $testArchiveEntryFullName, $testFileHashMatchesArchiveEntryHashParameters.HashAlgorithmName
                    { $null = Test-FileHashMatchesArchiveEntryHash @testFileHashMatchesArchiveEntryHashParameters } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }

            Mock -CommandName 'Get-FileHash' -MockWith {
                return @{
                    Algorithm = 'SHA-256'
                    Hash = 'TestHash1'
                }
            }

            Context 'When file hash matches archive entry hash' {
                $testFileHashMatchesArchiveEntryHashParameters = @{
                    FilePath = 'TestPath'
                    ArchiveEntry = $mockArchiveEntry
                    HashAlgorithmName = 'SHA-256'
                }

                It 'Should not throw' {
                    { $null = Test-FileHashMatchesArchiveEntryHash @testFileHashMatchesArchiveEntryHashParameters } | Should -Not -Throw
                }

                It 'Should convert the specified DSC hash algorithm name to a PowerShell hash algorithm name' {
                    $convertToPowerShellHashAlgorithmNameParameterFilter = {
                        $dscHashAlgorithmNameParameterCorrect = $DscHashAlgorithmName -eq $testFileHashMatchesArchiveEntryHashParameters.HashAlgorithmName
                        return $dscHashAlgorithmNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'ConvertTo-PowerShellHashAlgorithmName' -ParameterFilter $convertToPowerShellHashAlgorithmNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should open the specified archive entry' {
                    $openArchiveEntryParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-ArchiveEntry' -ParameterFilter $openArchiveEntryParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should open a stream to the specified file' {
                    $expectedArgumentList = @( $testFileHashMatchesArchiveEntryHashParameters.FilePath, [System.IO.FileMode]::Open )

                    $newObjectParameterFilter = {
                        $typeNameParameterCorrect = $TypeName -eq 'System.IO.FileStream'
                        $argumentListParameterCorrect = $null -eq (Compare-Object -ReferenceObject $expectedArgumentList -DifferenceObject $ArgumentList)

                        return $typeNameParameterCorrect -and $argumentListParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'New-Object' -ParameterFilter $newObjectParameterFilter -Exactly 1 -Scope 'Context'
                }



                It 'Should retrieve the hashes of the specified file and the specified archive entry with the specified hash algorithm name' {
                    $getFileHashParameterFilter = {
                        $inputStreamParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFileStream -DifferenceObject $InputStream)
                        $algorithmParameterCorrect = $Algorithm -eq $expectedPowerShellHashAlgorithmName

                        return $inputStreamParameterCorrect -and $algorithmParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-FileHash' -ParameterFilter $getFileHashParameterFilter -Exactly 2 -Scope 'Context'
                }

                It 'Should close the file stream and the archive entry stream' {
                    $closeStreamParameterFilter = {
                        $streamParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFileStream -DifferenceObject $Stream)
                        return $streamParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Stream' -ParameterFilter $closeStreamParameterFilter -Exactly 2 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-FileHashMatchesArchiveEntryHash @testFileHashMatchesArchiveEntryHashParameters | Should -BeTrue
                }
            }

            $script:timesGetFileHashCalled = 0

            Mock -CommandName 'Get-FileHash' -MockWith {
                $script:timesGetFileHashCalled++

                if ($script:timesGetFileHashCalled -eq 1)
                {
                    return @{
                        Algorithm = 'SHA-256'
                        Hash = 'TestHash1'
                    }
                }
                else
                {
                    return @{
                        Algorithm = 'SHA-1'
                        Hash = 'TestHash2'
                    }
                }
            }

            Context 'When file hash does not match archive entry hash' {
                $testFileHashMatchesArchiveEntryHashParameters = @{
                    FilePath = 'TestPath'
                    ArchiveEntry = $mockArchiveEntry
                    HashAlgorithmName = 'SHA-256'
                }

                It 'Should not throw' {
                    { $null = Test-FileHashMatchesArchiveEntryHash @testFileHashMatchesArchiveEntryHashParameters } | Should -Not -Throw
                }

                It 'Should convert the specified DSC hash algorithm name to a PowerShell hash algorithm name' {
                    $convertToPowerShellHashAlgorithmNameParameterFilter = {
                        $dscHashAlgorithmNameParameterCorrect = $DscHashAlgorithmName -eq $testFileHashMatchesArchiveEntryHashParameters.HashAlgorithmName
                        return $dscHashAlgorithmNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'ConvertTo-PowerShellHashAlgorithmName' -ParameterFilter $convertToPowerShellHashAlgorithmNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should open the specified archive entry' {
                    $openArchiveEntryParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-ArchiveEntry' -ParameterFilter $openArchiveEntryParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should open a stream to the specified file' {
                    $expectedArgumentList = @( $testFileHashMatchesArchiveEntryHashParameters.FilePath, [System.IO.FileMode]::Open )

                    $newObjectParameterFilter = {
                        $typeNameParameterCorrect = $TypeName -eq 'System.IO.FileStream'
                        $argumentListParameterCorrect = $null -eq (Compare-Object -ReferenceObject $expectedArgumentList -DifferenceObject $ArgumentList)

                        return $typeNameParameterCorrect -and $argumentListParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'New-Object' -ParameterFilter $newObjectParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the hashes of the specified file and the specified archive entry with the specified hash algorithm name' {
                    $getFileHashParameterFilter = {
                        $inputStreamParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFileStream -DifferenceObject $InputStream)
                        $algorithmParameterCorrect = $Algorithm -eq $expectedPowerShellHashAlgorithmName

                        return $inputStreamParameterCorrect -and $algorithmParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-FileHash' -ParameterFilter $getFileHashParameterFilter -Exactly 2 -Scope 'Context'
                }

                It 'Should close the file stream and the archive entry stream' {
                    $closeStreamParameterFilter = {
                        $streamParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFileStream -DifferenceObject $Stream)
                        return $streamParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Stream' -ParameterFilter $closeStreamParameterFilter -Exactly 2 -Scope 'Context'
                }

                It 'Should return false' {
                    $script:timesGetFileHashCalled = 0
                    Test-FileHashMatchesArchiveEntryHash @testFileHashMatchesArchiveEntryHashParameters | Should -BeFalse
                }
            }
        }

        Describe 'Get-ChecksumFromFileTimestamp' {
            $testFileInfo = New-Object -TypeName 'System.IO.FileInfo' -ArgumentList @( $TestDrive )
            $testFileCreationTimeChecksum = (Get-Date -Date $testFileInfo.CreationTime -Format 'G')
            $testFileLastWriteTimeChecksum = (Get-Date -Date $testFileInfo.LastWriteTime -Format 'G')

            Context 'When checksum specified as CreatedDate' {
                $getChecksumFromFileTimestampParameters = @{
                    File = $testFileInfo
                    Checksum = 'CreatedDate'
                }

                It 'Should not throw' {
                    { $null = Get-ChecksumFromFileTimestamp @getChecksumFromFileTimestampParameters } | Should -Not -Throw
                }

                It 'Should return the creation time of the file as a Checksum' {
                    Get-ChecksumFromFileTimestamp @getChecksumFromFileTimestampParameters | Should -Be $testFileCreationTimeChecksum
                }
            }

            Context 'When checksum specified as ModifiedDate' {
                $getChecksumFromFileTimestampParameters = @{
                    File = $testFileInfo
                    Checksum = 'ModifiedDate'
                }

                It 'Should not throw' {
                    { $null = Get-ChecksumFromFileTimestamp @getChecksumFromFileTimestampParameters } | Should -Not -Throw
                }

                It 'Should return the last write time of the file' {
                    Get-ChecksumFromFileTimestamp @getChecksumFromFileTimestampParameters | Should -Be $testFileLastWriteTimeChecksum
                }
            }
        }

        Describe 'Get-TimestampForChecksum' {
            $testFileInfo = New-Object -TypeName 'System.IO.FileInfo' -ArgumentList @( $TestDrive )

            Context 'When checksum specified as CreatedDate' {
                $getTimestampForChecksumParameters = @{
                    File = $testFileInfo
                    Checksum = 'CreatedDate'
                }

                It 'Should not throw' {
                    { $null = Get-TimestampForChecksum @getTimestampForChecksumParameters } | Should -Not -Throw
                }

                It 'Should return the creation time of the file as a Checksum' {
                    Get-TimestampForChecksum @getTimestampForChecksumParameters | Should -Be $testFileInfo.CreationTime
                }
            }

            Context 'When checksum specified as ModifiedDate' {
                $getTimestampForChecksumParameters = @{
                    File = $testFileInfo
                    Checksum = 'ModifiedDate'
                }

                It 'Should not throw' {
                    { $null = Get-TimestampForChecksum @getTimestampForChecksumParameters } | Should -Not -Throw
                }

                It 'Should return the last write time of the file' {
                    Get-TimestampForChecksum @getTimestampForChecksumParameters | Should -Be $testFileInfo.LastWriteTime
                }
            }
        }

        Describe 'Get-TimestampFromFile' {
            $testFileInfo = New-Object -TypeName 'System.IO.FileInfo' -ArgumentList @( $TestDrive )

            Context 'When Timestamp specified as CreationTime' {
                $getTimestampFromFileParameters = @{
                    File = $testFileInfo
                    Timestamp = 'CreationTime'
                }

                It 'Should not throw' {
                    { $null = Get-TimestampFromFile @getTimestampFromFileParameters } | Should -Not -Throw
                }

                It 'Should return the creation time of the file as a Checksum' {
                    Get-TimestampFromFile @getTimestampFromFileParameters | Should -Be $testFileInfo.CreationTime
                }
            }

            Context 'When Timestamp specified as LastWriteTime' {
                $getTimestampFromFileParameters = @{
                    File = $testFileInfo
                    Timestamp = 'LastWriteTime'
                }

                It 'Should not throw' {
                    { $null = Get-TimestampFromFile @getTimestampFromFileParameters } | Should -Not -Throw
                }

                It 'Should return the last write time of the file as a Checksum' {
                    Get-TimestampFromFile @getTimestampFromFileParameters | Should -Be $testFileInfo.LastWriteTime
                }
            }
        }

        Describe 'ConvertTo-CheckSumFromDateTime' {
            $testDate = Get-Date
            $testDateFromChecksum = (Get-Date -Date $testDate -Format 'G')

            Context 'When called with a datetime object set to now' {
                $convertToCheckSumFromDateTimeParameters = @{
                    Date = $testDate
                }

                It 'Should not throw' {
                    { $null = ConvertTo-CheckSumFromDateTime @convertToCheckSumFromDateTimeParameters } | Should -Not -Throw
                }

                It 'Should return the date normalized to a string using format of ''G''' {
                    ConvertTo-CheckSumFromDateTime @convertToCheckSumFromDateTimeParameters | Should -Be $testDateFromChecksum
                }
            }
        }

        Describe 'Test-FileMatchesArchiveEntryByChecksum' {
            $testArchiveEntryFullName = 'TestArchiveEntryFullName'
            $testArchiveEntryLastWriteTime = Get-Date -Month 1
            $testTimestampFromChecksum = Get-Date -Month 2

            $mockArchiveEntry = New-MockObject -Type 'System.IO.Compression.ZipArchiveEntry'

            # This is the actual file info of this file since we cannot set the properties of mock objects
            $testFileInfo = New-Object -TypeName 'System.IO.FileInfo' -ArgumentList @( $TestDrive )
            $testFileFullName = $testFileInfo.FullName

            Mock -CommandName 'Get-ArchiveEntryFullName' -MockWith { return $testArchiveEntryFullName }
            Mock -CommandName 'Test-ChecksumIsSha' -MockWith { return $false }
            Mock -CommandName 'Test-FileHashMatchesArchiveEntryHash' -MockWith { return $false }
            Mock -CommandName 'Get-TimestampForChecksum' -MockWith { return $testTimestampFromChecksum }
            Mock -CommandName 'Get-ArchiveEntryLastWriteTime' -MockWith { return $testArchiveEntryLastWriteTime }

            Context 'When specified checksum method is not a SHA method and file timestamp from checksum does not match archive entry last write time' {
                $testFileMatchesArchiveEntryByChecksumParameters = @{
                    File = $testFileInfo
                    ArchiveEntry = $mockArchiveEntry
                    Checksum = 'ModifiedDate'
                }

                It 'Should not throw' {
                    { $null = Test-FileMatchesArchiveEntryByChecksum @testFileMatchesArchiveEntryByChecksumParameters } | Should -Not -Throw
                }

                It 'Should retrieve the full name of the archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified checksum method is a SHA method' {
                    $testChecksumIsShaParameterFilter = {
                        $checksumParameterCorrect = $Checksum -eq $testFileMatchesArchiveEntryByChecksumParameters.Checksum
                        return $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ChecksumIsSha' -ParameterFilter $testChecksumIsShaParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the hash of the specified file matches the hash of the specified archive entry' {
                    Assert-MockCalled -CommandName 'Test-FileHashMatchesArchiveEntryHash' -Exactly 0 -Scope 'Context'
                }

                It 'Should retrieve the timestamp of the specified file for the specified checksum method' {
                    $getTimestampForChecksumParameterFilter = {
                        $fileParameterCorrect = $null -eq (Compare-Object -ReferenceObject $testFileInfo -DifferenceObject $File)
                        $checksumParameterCorrect = $Checksum -eq $testFileMatchesArchiveEntryByChecksumParameters.Checksum

                        return $fileParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-TimestampForChecksum' -ParameterFilter $getTimestampForChecksumParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the last write time of the specified archive entry' {
                    $getArchiveEntryLastWriteTimeParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryLastWriteTime' -ParameterFilter $getArchiveEntryLastWriteTimeParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-FileMatchesArchiveEntryByChecksum @testFileMatchesArchiveEntryByChecksumParameters | Should -BeFalse
                }
            }

            Mock -CommandName 'Get-TimestampForChecksum' -MockWith { return $testArchiveEntryLastWriteTime }

            Context 'When specified checksum method is not a SHA method and file timestamp from checksum matches archive entry last write time' {
                $testFileMatchesArchiveEntryByChecksumParameters = @{
                    File = $testFileInfo
                    ArchiveEntry = $mockArchiveEntry
                    Checksum = 'CreatedDate'
                }

                It 'Should not throw' {
                    { $null = Test-FileMatchesArchiveEntryByChecksum @testFileMatchesArchiveEntryByChecksumParameters } | Should -Not -Throw
                }

                It 'Should retrieve the full name of the archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified checksum method is a SHA method' {
                    $testChecksumIsShaParameterFilter = {
                        $checksumParameterCorrect = $Checksum -eq $testFileMatchesArchiveEntryByChecksumParameters.Checksum
                        return $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ChecksumIsSha' -ParameterFilter $testChecksumIsShaParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the hash of the specified file matches the hash of the specified archive entry' {
                    Assert-MockCalled -CommandName 'Test-FileHashMatchesArchiveEntryHash' -Exactly 0 -Scope 'Context'
                }

                It 'Should retrieve the timestamp of the specified file for the specified checksum method' {
                    $getTimestampForChecksumParameterFilter = {
                        $fileParameterCorrect = $null -eq (Compare-Object -ReferenceObject $testFileInfo -DifferenceObject $File)
                        $checksumParameterCorrect = $Checksum -eq $testFileMatchesArchiveEntryByChecksumParameters.Checksum

                        return $fileParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-TimestampForChecksum' -ParameterFilter $getTimestampForChecksumParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the last write time of the specified archive entry' {
                    $getArchiveEntryLastWriteTimeParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryLastWriteTime' -ParameterFilter $getArchiveEntryLastWriteTimeParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-FileMatchesArchiveEntryByChecksum @testFileMatchesArchiveEntryByChecksumParameters | Should -BeTrue
                }
            }

            Mock -CommandName 'Test-ChecksumIsSha' -MockWith { return $true }

            Context 'When specified checksum method is a SHA method and file hash does not match archive entry hash' {
                $testFileMatchesArchiveEntryByChecksumParameters = @{
                    File = $testFileInfo
                    ArchiveEntry = $mockArchiveEntry
                    Checksum = 'SHA-256'
                }

                It 'Should not throw' {
                    { $null = Test-FileMatchesArchiveEntryByChecksum @testFileMatchesArchiveEntryByChecksumParameters } | Should -Not -Throw
                }

                It 'Should retrieve the full name of the archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified checksum method is a SHA method' {
                    $testChecksumIsShaParameterFilter = {
                        $checksumParameterCorrect = $Checksum -eq $testFileMatchesArchiveEntryByChecksumParameters.Checksum
                        return $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ChecksumIsSha' -ParameterFilter $testChecksumIsShaParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the hash of the specified file matches the hash of the specified archive entry' {
                    $testFileHashMatchesArchiveEntryHashParameterFilter = {
                        $filePathParameterCorrect = $FilePath -eq $testFileFullName
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $hashAlgorithmNameParameterCorrect = $HashAlgorithmName -eq $testFileMatchesArchiveEntryByChecksumParameters.Checksum

                        return $filePathParameterCorrect -and $archiveEntryParameterCorrect -and $hashAlgorithmNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-FileHashMatchesArchiveEntryHash' -ParameterFilter $testFileHashMatchesArchiveEntryHashParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to retrieve the timestamp of the specified file for the specified checksum method' {
                    Assert-MockCalled -CommandName 'Get-TimestampForChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to retrieve the last write time of the specified archive entry' {
                    Assert-MockCalled -CommandName 'Get-ArchiveEntryLastWriteTime' -Exactly 0 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-FileMatchesArchiveEntryByChecksum @testFileMatchesArchiveEntryByChecksumParameters | Should -BeFalse
                }
            }

            Mock -CommandName 'Test-FileHashMatchesArchiveEntryHash' -MockWith { return $true }

            Context 'When specified checksum method is a SHA method and file hash matches archive entry hash' {
                $testFileMatchesArchiveEntryByChecksumParameters = @{
                    File = $testFileInfo
                    ArchiveEntry = $mockArchiveEntry
                    Checksum = 'SHA-512'
                }

                It 'Should not throw' {
                    { $null = Test-FileMatchesArchiveEntryByChecksum @testFileMatchesArchiveEntryByChecksumParameters } | Should -Not -Throw
                }

                It 'Should retrieve the full name of the archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the specified checksum method is a SHA method' {
                    $testChecksumIsShaParameterFilter = {
                        $checksumParameterCorrect = $Checksum -eq $testFileMatchesArchiveEntryByChecksumParameters.Checksum
                        return $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ChecksumIsSha' -ParameterFilter $testChecksumIsShaParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the hash of the specified file matches the hash of the specified archive entry' {
                    $testFileHashMatchesArchiveEntryHashParameterFilter = {
                        $filePathParameterCorrect = $FilePath -eq $testFileFullName
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $hashAlgorithmNameParameterCorrect = $HashAlgorithmName -eq $testFileMatchesArchiveEntryByChecksumParameters.Checksum

                        return $filePathParameterCorrect -and $archiveEntryParameterCorrect -and $hashAlgorithmNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-FileHashMatchesArchiveEntryHash' -ParameterFilter $testFileHashMatchesArchiveEntryHashParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to retrieve the timestamp of the specified file for the specified checksum method' {
                    Assert-MockCalled -CommandName 'Get-TimestampForChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to retrieve the last write time of the specified archive entry' {
                    Assert-MockCalled -CommandName 'Get-ArchiveEntryLastWriteTime' -Exactly 0 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-FileMatchesArchiveEntryByChecksum @testFileMatchesArchiveEntryByChecksumParameters | Should -BeTrue
                }
            }
        }

        Describe 'Test-ArchiveEntryIsDirectory' {
            Context 'When archive entry name does not contain a backslash or a foward slash' {
                $testArchiveEntryNameIsDirectoryPathParameters = @{
                    ArchiveEntryName = 'TestArchiveEntryName'
                }

                It 'Should not throw' {
                    { $null = Test-ArchiveEntryIsDirectory @testArchiveEntryNameIsDirectoryPathParameters } | Should -Not -Throw
                }

                It 'Should return false' {
                    Test-ArchiveEntryIsDirectory @testArchiveEntryNameIsDirectoryPathParameters | Should -BeFalse
                }
            }

            Context 'When archive entry name contains a backslash but does not end with a backslash' {
                $testArchiveEntryNameIsDirectoryPathParameters = @{
                    ArchiveEntryName = 'TestArchive\EntryName'
                }

                It 'Should not throw' {
                    { $null = Test-ArchiveEntryIsDirectory @testArchiveEntryNameIsDirectoryPathParameters } | Should -Not -Throw
                }

                It 'Should return false' {
                    Test-ArchiveEntryIsDirectory @testArchiveEntryNameIsDirectoryPathParameters | Should -BeFalse
                }
            }

            Context 'When archive entry name contains a foward slash but does not end with a foward slash' {
                $testArchiveEntryNameIsDirectoryPathParameters = @{
                    ArchiveEntryName = 'TestArchive/EntryName'
                }

                It 'Should not throw' {
                    { $null = Test-ArchiveEntryIsDirectory @testArchiveEntryNameIsDirectoryPathParameters } | Should -Not -Throw
                }

                It 'Should return false' {
                    Test-ArchiveEntryIsDirectory @testArchiveEntryNameIsDirectoryPathParameters | Should -BeFalse
                }
            }

            Context 'When archive entry name ends with a backslash' {
                $testArchiveEntryNameIsDirectoryPathParameters = @{
                    ArchiveEntryName = 'TestArchiveEntryName\'
                }

                It 'Should not throw' {
                    { $null = Test-ArchiveEntryIsDirectory @testArchiveEntryNameIsDirectoryPathParameters } | Should -Not -Throw
                }

                It 'Should return true' {
                    Test-ArchiveEntryIsDirectory @testArchiveEntryNameIsDirectoryPathParameters | Should -BeTrue
                }
            }

            Context 'When archive entry name ends with a forward slash' {
                $testArchiveEntryNameIsDirectoryPathParameters = @{
                    ArchiveEntryName = 'TestArchiveEntryName/'
                }

                It 'Should not throw' {
                    { $null = Test-ArchiveEntryIsDirectory @testArchiveEntryNameIsDirectoryPathParameters } | Should -Not -Throw
                }

                It 'Should return true' {
                    Test-ArchiveEntryIsDirectory @testArchiveEntryNameIsDirectoryPathParameters | Should -BeTrue
                }
            }
        }

        Describe 'Test-ArchiveExistsAtDestination' {
            $testArchiveEntryFullName = 'TestArchiveEntryFullName'
            $testItemPathAtDestination = 'TestItemPathAtDestination'

            $mockArchive = New-MockObject -Type 'System.IO.Compression.ZipArchive'
            $mockArchiveEntry = New-MockObject -Type 'System.IO.Compression.ZipArchiveEntry'
            $mockFile = New-MockObject -Type 'System.IO.FileInfo'
            $mockDirectory = New-MockObject -Type 'System.IO.DirectoryInfo'

            Mock -CommandName 'Open-Archive' -MockWith { return $mockArchive }
            Mock -CommandName 'Get-ArchiveEntries' -MockWith { return @( $mockArchiveEntry ) }
            Mock -CommandName 'Get-ArchiveEntryFullName' -MockWith { return $testArchiveEntryFullName }
            Mock -CommandName 'Join-Path' -MockWith { return $testItemPathAtDestination }
            Mock -CommandName 'Get-Item' -MockWith { return $null }
            Mock -CommandName 'Test-ArchiveEntryIsDirectory' -MockWith { return $true }
            Mock -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -MockWith { return $false }
            Mock -CommandName 'Close-Archive' -MockWith { }

            Context 'When archive entry is a directory and does not exist at destination' {
                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the archive entry is a directory' {
                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters | Should -BeFalse
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockFile }

            Context 'When archive entry is a directory and item with the same name exists at the destination but is a file' {
                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters | Should -BeFalse
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return 'NotAFileOrADirectory' }

            Context 'When archive entry is a directory and item with the same name exists at the destination but is not a file or a directory' {
                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters | Should -BeFalse
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockDirectory }

            Context 'When archive entry is a directory and directory with the same name exists at the destination' {
                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters | Should -BeTrue
                }
            }

            Mock -CommandName 'Test-ArchiveEntryIsDirectory' -MockWith { return $false }
            Mock -CommandName 'Get-Item' -MockWith { return $null }

            Context 'When archive entry is a file and does not exist at destination' {
                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the archive entry is a directory' {
                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters | Should -BeFalse
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockDirectory }

            Context 'When archive entry is a file and item with the same name exists at the destination but is a directory' {
                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters | Should -BeFalse
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return 'NotAFileOrADirectory' }

            Context 'When archive entry is a file and item with the same name exists at the destination but is not a file or a directory' {
                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters | Should -BeFalse
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockFile }

            Context 'When archive entry is a file, file with the same name exists at the destination, and a checksum method is not specified' {
                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters | Should -BeTrue
                }
            }

            Context 'When archive entry is a file, file with the same name exists at the destination, and files do not match by the specified checksum method' {
                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Checksum = 'SHA-256'
                }

                It 'Should not throw' {
                    { Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    $testFileMatchesArchiveEntryByChecksumParameterFilter = {
                        $fileParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFile -DifferenceObject $File)
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $checksumParameterCorrect = $Checksum -eq $testArchiveExistsAtDestinationParameters.Checksum

                        return $fileParameterCorrect -and $archiveEntryParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -ParameterFilter $testFileMatchesArchiveEntryByChecksumParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return false' {
                    Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters | Should -BeFalse
                }
            }

            Mock -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -MockWith { return $true }

            Context 'When archive entry is a file, file with the same name exists at the destination, and files match by the specified checksum method' {
                $testArchiveExistsAtDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Checksum = 'SHA-256'
                }

                It 'Should not throw' {
                    { Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveExistsAtDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    $testFileMatchesArchiveEntryByChecksumParameterFilter = {
                        $fileParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFile -DifferenceObject $File)
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $checksumParameterCorrect = $Checksum -eq $testArchiveExistsAtDestinationParameters.Checksum

                        return $fileParameterCorrect -and $archiveEntryParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -ParameterFilter $testFileMatchesArchiveEntryByChecksumParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should return true' {
                    Test-ArchiveExistsAtDestination @testArchiveExistsAtDestinationParameters | Should -BeTrue
                }
            }
        }

        Describe 'Copy-ArchiveEntryToDestination' {
            $testArchiveEntryFullName = 'TestArchiveEntryFullName'
            $testArchiveEntryLastWriteTime = Get-Date

            $testCopyFromStreamToStreamError = 'Test copy from stream to stream error'

            $mockArchiveEntry = New-MockObject -Type 'System.IO.Compression.ZipArchiveEntry'
            $mockFileStream = New-MockObject -Type 'System.IO.FileStream'

            Mock -CommandName 'Get-ArchiveEntryFullName' { return $testArchiveEntryFullName }
            Mock -CommandName 'Test-ArchiveEntryIsDirectory' -MockWith { return $true }
            Mock -CommandName 'New-Item' -MockWith { }
            Mock -CommandName 'Open-ArchiveEntry' -MockWith { return $mockFileStream }
            Mock -CommandName 'New-Object' -MockWith {
                if ($TypeName -eq 'System.IO.FileStream')
                {
                    return $mockFileStream
                }
                elseif ($TypeName -eq 'System.IO.FileInfo')
                {
                    return $null
                }
            }
            Mock -CommandName 'Copy-FromStreamToStream' -MockWith { throw $testCopyFromStreamToStreamError }
            Mock -CommandName 'Close-Stream' -MockWith { }
            Mock -CommandName 'Get-ArchiveEntryLastWriteTime' -MockWith { return $testArchiveEntryLastWriteTime }
            Mock -CommandName 'Set-ItemProperty' -MockWith { }

            Context 'When archive entry is a directory' {
                $copyArchiveEntryToDestinationParameters = @{
                    ArchiveEntry = $mockArchiveEntry
                    DestinationPath = 'TestDestinationPath'
                }

                It 'Should not throw' {
                    { Copy-ArchiveEntryToDestination @copyArchiveEntryToDestinationParameters } | Should -Not -Throw
                }

                It 'Should retrieve the full name of the specified archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should create a new directory at the specified destination' {
                    $newItemParameterFilter = {
                        $pathParameterCorrect = $Path -eq $copyArchiveEntryToDestinationParameters.DestinationPath
                        $itemTypeParameterCorrect = $ItemType -eq 'Directory'

                        return $pathParameterCorrect -and $itemTypeParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'New-Item' -ParameterFilter $newItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to open the specified archive entry' {
                    Assert-MockCalled -CommandName 'Open-ArchiveEntry' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create a new file stream at the specified destination' {
                    $newObjectParameterFilter = {
                        $typeNameParameterIsFileStream = $TypeName -eq 'System.IO.FileStream'
                        return $typeNameParameterIsFileStream
                    }

                    Assert-MockCalled -CommandName 'New-Object' -ParameterFilter $newObjectParameterFilter -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to copy the archive entry to the destination' {
                    Assert-MockCalled -CommandName 'Copy-FromStreamToStream' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to close a file stream' {
                    Assert-MockCalled -CommandName 'Close-Stream' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create a new file info at the specified destination' {
                    $newObjectParameterFilter = {
                        $typeNameParameterIsFileStream = $TypeName -eq 'System.IO.FileInfo'
                        return $typeNameParameterIsFileStream
                    }

                    Assert-MockCalled -CommandName 'New-Object' -ParameterFilter $newObjectParameterFilter -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to retrieve the last write time of the specified archive entry' {
                    Assert-MockCalled -CommandName 'Get-ArchiveEntryLastWriteTime' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to set the last write time of the file at the specified destination' {
                    $setItemPropertyParameterFilter = {
                        $nameParameterIsLastWriteTime = $Name -eq 'LastWriteTime'
                        return $nameParameterIsLastWriteTime
                    }

                    Assert-MockCalled -CommandName 'Set-ItemProperty' -ParameterFilter $setItemPropertyParameterFilter -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to set the last access time of the file at the specified destination' {
                    $setItemPropertyParameterFilter = {
                        $nameParameterIsLastWriteTime = $Name -eq 'LastAccessTime'
                        return $nameParameterIsLastWriteTime
                    }

                    Assert-MockCalled -CommandName 'Set-ItemProperty' -ParameterFilter $setItemPropertyParameterFilter -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to set the creation time of the file at the specified destination' {
                    $setItemPropertyParameterFilter = {
                        $nameParameterIsLastWriteTime = $Name -eq 'CreationTime'
                        return $nameParameterIsLastWriteTime
                    }

                    Assert-MockCalled -CommandName 'Set-ItemProperty' -ParameterFilter $setItemPropertyParameterFilter -Exactly 0 -Scope 'Context'
                }

                It 'Should not return' {
                    Copy-ArchiveEntryToDestination @copyArchiveEntryToDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Test-ArchiveEntryIsDirectory' -MockWith { return $false }

            Context 'When archive entry is not a directory and copying from stream to stream fails' {
                $copyArchiveEntryToDestinationParameters = @{
                    ArchiveEntry = $mockArchiveEntry
                    DestinationPath = 'TestDestinationPath'
                }

                It 'Should throw an error for failed copy from the file stream to the archive entry stream' {
                    $expectedErrorMessage = $script:localizedData.ErrorCopyingFromArchiveToDestination -f $copyArchiveEntryToDestinationParameters.DestinationPath
                    { Copy-ArchiveEntryToDestination @copyArchiveEntryToDestinationParameters } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }

            Mock -CommandName 'Copy-FromStreamToStream' -MockWith { }

            Context 'When archive entry is not a directory and copying from stream to stream succeeds' {
                $copyArchiveEntryToDestinationParameters = @{
                    ArchiveEntry = $mockArchiveEntry
                    DestinationPath = 'TestDestinationPath'
                }

                It 'Should not throw' {
                    { Copy-ArchiveEntryToDestination @copyArchiveEntryToDestinationParameters } | Should -Not -Throw
                }

                It 'Should retrieve the full name of the specified archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to create a new directory at the specified destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should open the specified archive entry' {
                    $openArchiveEntryParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-ArchiveEntry' -ParameterFilter $openArchiveEntryParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should create a new file stream at the specified destination' {
                    $expectedArgumentList = @( $copyArchiveEntryToDestinationParameters.DestinationPath, [System.IO.FileMode]::Create )

                    $newObjectParameterFilter = {
                        $typeNameParameterIsFileStream = $TypeName -eq 'System.IO.FileStream'
                        $argumentListParameterCorrect = $null -eq (Compare-Object -ReferenceObject $expectedArgumentList -DifferenceObject $ArgumentList)

                        return $typeNameParameterIsFileStream -and $argumentListParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'New-Object' -ParameterFilter $newObjectParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should copy the archive entry to the destination' {
                    $copyFromStreamToStreamParameterFilter = {
                        $sourceStreamParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFileStream -DifferenceObject $SourceStream)
                        $destinationStreamParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFileStream -DifferenceObject $DestinationStream)

                        return $sourceStreamParameterCorrect -and $destinationStreamParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Copy-FromStreamToStream' -ParameterFilter $copyFromStreamToStreamParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the archive entry stream and the file stream' {
                    $closeStreamParameterFilter = {
                        $streamParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFileStream -DifferenceObject $Stream)
                        return $streamParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Stream' -ParameterFilter $closeStreamParameterFilter -Exactly 2 -Scope 'Context'
                }

                It 'Should create a new file info at the specified destination' {
                    $expectedArgumentList = @( $copyArchiveEntryToDestinationParameters.DestinationPath )

                    $newObjectParameterFilter = {
                        $typeNameParameterIsFileStream = $TypeName -eq 'System.IO.FileInfo'
                        $argumentListParameterCorrect = $null -eq (Compare-Object -ReferenceObject $expectedArgumentList -DifferenceObject $ArgumentList)

                        return $typeNameParameterIsFileStream -and $argumentListParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'New-Object' -ParameterFilter $newObjectParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the last write time of the specified archive entry' {
                    $getArchiveEntryLastWriteTimeParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryLastWriteTime' -ParameterFilter $getArchiveEntryLastWriteTimeParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should set the last write time of the file at the specified destination' {
                    $setItemPropertyParameterFilter = {
                        $nameParameterIsLastWriteTime = $Name -eq 'LastWriteTime'
                        $literalPathParameterCorrect = $LiteralPath -eq $copyArchiveEntryToDestinationParameters.DestinationPath
                        $valueParameterCorrect = $Value -eq $testArchiveEntryLastWriteTime

                        return $nameParameterIsLastWriteTime -and $literalPathParameterCorrect -and $valueParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Set-ItemProperty' -ParameterFilter $setItemPropertyParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should set the last access time of the file at the specified destination' {
                    $setItemPropertyParameterFilter = {
                        $nameParameterIsLastWriteTime = $Name -eq 'LastAccessTime'
                        $literalPathParameterCorrect = $LiteralPath -eq $copyArchiveEntryToDestinationParameters.DestinationPath
                        $valueParameterCorrect = $Value -eq $testArchiveEntryLastWriteTime

                        return $nameParameterIsLastWriteTime -and $literalPathParameterCorrect -and $valueParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Set-ItemProperty' -ParameterFilter $setItemPropertyParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should set the creation time of the file at the specified destination' {
                    $setItemPropertyParameterFilter = {
                        $nameParameterIsLastWriteTime = $Name -eq 'CreationTime'
                        $literalPathParameterCorrect = $LiteralPath -eq $copyArchiveEntryToDestinationParameters.DestinationPath
                        $valueParameterCorrect = $Value -eq $testArchiveEntryLastWriteTime

                        return $nameParameterIsLastWriteTime -and $literalPathParameterCorrect -and $valueParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Set-ItemProperty' -ParameterFilter $setItemPropertyParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return' {
                    Copy-ArchiveEntryToDestination @copyArchiveEntryToDestinationParameters | Should -Be $null
                }
            }
        }

        Describe 'Expand-ArchiveToDestination' {
            $testArchiveEntryFullName = 'TestArchiveEntryFullName'
            $testItemPathAtDestination = 'TestItemPathAtDestination'
            $testParentDirectoryPath = 'TestParentDirectoryPath'

            $mockArchive = New-MockObject -Type 'System.IO.Compression.ZipArchive'
            $mockArchiveEntry = New-MockObject -Type 'System.IO.Compression.ZipArchiveEntry'
            $mockFile = New-MockObject -Type 'System.IO.FileInfo'
            $mockDirectory = New-MockObject -Type 'System.IO.DirectoryInfo'

            Mock -CommandName 'Open-Archive' -MockWith { return $mockArchive }
            Mock -CommandName 'Get-ArchiveEntries' -MockWith { return @( $mockArchiveEntry ) }
            Mock -CommandName 'Get-ArchiveEntryFullName' -MockWith { return $testArchiveEntryFullName }
            Mock -CommandName 'Join-Path' -MockWith { return $testItemPathAtDestination }
            Mock -CommandName 'Test-ArchiveEntryIsDirectory' -MockWith { return $true }
            Mock -CommandName 'Get-Item' -MockWith { return $null }
            Mock -CommandName 'Split-Path' -MockWith { return $testParentDirectoryPath }
            Mock -CommandName 'Test-Path' -MockWith { return $false }
            Mock -CommandName 'New-Item' -MockWith { }
            Mock -CommandName 'Copy-ArchiveEntryToDestination' -MockWith { }
            Mock -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -MockWith { return $false }
            Mock -CommandName 'Remove-Item' -MockWith { }
            Mock -CommandName 'Close-Archive' -MockWith { }

            Context 'When archive entry is a directory and does not exist at destination' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the parent directory of the desired path of the archive entry at the destination exists' {
                    Assert-MockCalled -CommandName 'Test-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should copy the archive entry to the desired path of the archive entry at the destination' {
                    $copyArchiveEntryToDestinationParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $destinationPathParameterCorrect = $DestinationPath -eq $testItemPathAtDestination

                        return $archiveEntryParameterCorrect -and $destinationPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -ParameterFilter $copyArchiveEntryToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing item at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockFile }

            Context 'When archive entry is a directory, item with the same name exists at the destination but is a file, and Force is not specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should throw an error for attempting to overwrite an existing item without specifying the Force parameter' {
                    $errorMessage = $script:localizedData.ForceNotSpecifiedToOverwriteItem -f $testItemPathAtDestination, $testArchiveEntryFullName
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Throw -ExpectedMessage $errorMessage
                }
            }

            Context 'When archive entry is a directory, item with the same name exists at the destination but is a file, and Force is specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Force = $true
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the parent directory of the desired path of the archive entry at the destination exists' {
                    Assert-MockCalled -CommandName 'Test-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should copy the archive entry to the desired path of the archive entry at the destination' {
                    $copyArchiveEntryToDestinationParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $destinationPathParameterCorrect = $DestinationPath -eq $testItemPathAtDestination

                        return $archiveEntryParameterCorrect -and $destinationPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -ParameterFilter $copyArchiveEntryToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should remove the existing item at the desired path of the archive entry at the destination' {
                    $removeItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-Item' -ParameterFilter $removeItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return 'NotAFileOrADirectory' }

            Context 'When archive entry is a directory, item with the same name exists at the destination but is not a file or a directory, and Force is not specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should throw an error for attempting to overwrite an existing item without specifying the Force parameter' {
                    $errorMessage = $script:localizedData.ForceNotSpecifiedToOverwriteItem -f $testItemPathAtDestination, $testArchiveEntryFullName
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Throw -ExpectedMessage $errorMessage
                }
            }

            Context 'When archive entry is a directory, item with the same name exists at the destination but is not a file or a directory, and Force is specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Force = $true
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the parent directory of the desired path of the archive entry at the destination exists' {
                    Assert-MockCalled -CommandName 'Test-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should copy the archive entry to the desired path of the archive entry at the destination' {
                    $copyArchiveEntryToDestinationParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $destinationPathParameterCorrect = $DestinationPath -eq $testItemPathAtDestination

                        return $archiveEntryParameterCorrect -and $destinationPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -ParameterFilter $copyArchiveEntryToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should remove the existing item at the desired path of the archive entry at the destination' {
                    $removeItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-Item' -ParameterFilter $removeItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockDirectory }

            Context 'When archive entry is a directory and directory with the same name exists at the destination' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the parent directory of the desired path of the archive entry at the destination exists' {
                    Assert-MockCalled -CommandName 'Test-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to copy the archive entry to the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing item at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Test-ArchiveEntryIsDirectory' -MockWith { return $false }
            Mock -CommandName 'Get-Item' -MockWith { return $null }

            Context 'When archive entry is a file and does not exist at destination and the parent directory of the file does not exist' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the parent directory of the desired path of the archive entry at the destination' {
                    $splitPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testItemPathAtDestination
                        $parentParameterCorrect = $Parent -eq $true

                        return $pathParameterCorrect -and $parentParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Split-Path' -ParameterFilter $splitPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the parent directory of the desired path of the archive entry at the destination exists' {
                    $testPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testParentDirectoryPath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should create the parent directory of the desired path of the archive entry at the destination' {
                    $newItemParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testParentDirectoryPath
                        $itemTypeParameterCorrect = $ItemType -eq 'Directory'

                        return $pathParameterCorrect -and $itemTypeParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'New-Item' -ParameterFilter $newItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should copy the archive entry to the desired path of the archive entry at the destination' {
                    $copyArchiveEntryToDestinationParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $destinationPathParameterCorrect = $DestinationPath -eq $testItemPathAtDestination

                        return $archiveEntryParameterCorrect -and $destinationPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -ParameterFilter $copyArchiveEntryToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing item at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Test-Path' -MockWith { return $true }

            Context 'When archive entry is a file and does not exist at destination and the parent directory of the file exists' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the parent directory of the desired path of the archive entry at the destination' {
                    $splitPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testItemPathAtDestination
                        $parentParameterCorrect = $Parent -eq $true

                        return $pathParameterCorrect -and $parentParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Split-Path' -ParameterFilter $splitPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the parent directory of the desired path of the archive entry at the destination exists' {
                    $testPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testParentDirectoryPath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to create the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should copy the archive entry to the desired path of the archive entry at the destination' {
                    $copyArchiveEntryToDestinationParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $destinationPathParameterCorrect = $DestinationPath -eq $testItemPathAtDestination

                        return $archiveEntryParameterCorrect -and $destinationPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -ParameterFilter $copyArchiveEntryToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing item at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockDirectory }

            Context 'When archive entry is a file, item with the same name exists at the destination but is a directory, and Force is not specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should throw an error for attempting to overwrite an existing item without specifying the Force parameter' {
                    $errorMessage = $script:localizedData.ForceNotSpecifiedToOverwriteItem -f $testItemPathAtDestination, $testArchiveEntryFullName
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Throw -ExpectedMessage $errorMessage
                }
            }

            Context 'When archive entry is a file, item with the same name exists at the destination but is a directory, and Force is specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Force = $true
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the parent directory of the desired path of the archive entry at the destination exists' {
                    Assert-MockCalled -CommandName 'Test-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should copy the archive entry to the desired path of the archive entry at the destination' {
                    $copyArchiveEntryToDestinationParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $destinationPathParameterCorrect = $DestinationPath -eq $testItemPathAtDestination

                        return $archiveEntryParameterCorrect -and $destinationPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -ParameterFilter $copyArchiveEntryToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should remove the existing item at the desired path of the archive entry at the destination' {
                    $removeItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-Item' -ParameterFilter $removeItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return 'NotAFileOrADirectory' }

            Context 'When archive entry is a file, item with the same name exists at the destination but is not a file or a directory, and Force is not specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should throw an error for attempting to overwrite an existing item without specifying the Force parameter' {
                    $errorMessage = $script:localizedData.ForceNotSpecifiedToOverwriteItem -f $testItemPathAtDestination, $testArchiveEntryFullName
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Throw -ExpectedMessage $errorMessage
                }
            }

            Context 'When archive entry is a file, item with the same name exists at the destination but is not a file or a directory, and Force is specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Force = $true
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the parent directory of the desired path of the archive entry at the destination exists' {
                    Assert-MockCalled -CommandName 'Test-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should copy the archive entry to the desired path of the archive entry at the destination' {
                    $copyArchiveEntryToDestinationParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $destinationPathParameterCorrect = $DestinationPath -eq $testItemPathAtDestination

                        return $archiveEntryParameterCorrect -and $destinationPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -ParameterFilter $copyArchiveEntryToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should remove the existing item at the desired path of the archive entry at the destination' {
                    $removeItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-Item' -ParameterFilter $removeItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockFile }

            Context 'When archive entry is a file, file with the same name exists at the destination, and a checksum method is not specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the parent directory of the desired path of the archive entry at the destination exists' {
                    Assert-MockCalled -CommandName 'Test-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to copy the archive entry to the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing item at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }

            Context 'When archive entry is a file, file with the same name exists at the destination, files do not match by the specified checksum method, and Force is not specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Checksum = 'SHA-256'
                }

                It 'Should throw an error for attempting to overwrite an existing item without specifying the Force parameter' {
                    $errorMessage = $script:localizedData.ForceNotSpecifiedToOverwriteItem -f $testItemPathAtDestination, $testArchiveEntryFullName
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Throw -ExpectedMessage $errorMessage
                }
            }

            Context 'When archive entry is a file, file with the same name exists at the destination, files do not match by the specified checksum method, and Force is specified' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Checksum = 'SHA-256'
                    Force = $true
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the parent directory of the desired path of the archive entry at the destination exists' {
                    Assert-MockCalled -CommandName 'Test-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should copy the archive entry to the desired path of the archive entry at the destination' {
                    $copyArchiveEntryToDestinationParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $destinationPathParameterCorrect = $DestinationPath -eq $testItemPathAtDestination

                        return $archiveEntryParameterCorrect -and $destinationPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -ParameterFilter $copyArchiveEntryToDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    $testFileMatchesArchiveEntryByChecksumParameterFilter = {
                        $fileParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFile -DifferenceObject $File)
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $checksumParameterCorrect = $Checksum -eq $expandArchiveToDestinationParameters.Checksum

                        return $fileParameterCorrect -and $archiveEntryParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -ParameterFilter $testFileMatchesArchiveEntryByChecksumParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should remove the existing item at the desired path of the archive entry at the destination' {
                    $removeItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-Item' -ParameterFilter $removeItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -MockWith { return $true }

            Context 'When archive entry is a file, file with the same name exists at the destination, and files match by the specified checksum method' {
                $expandArchiveToDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Checksum = 'SHA-256'
                }

                It 'Should not throw' {
                    { Expand-ArchiveToDestination @expandArchiveToDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $expandArchiveToDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to test if the parent directory of the desired path of the archive entry at the destination exists' {
                    Assert-MockCalled -CommandName 'Test-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to create the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'New-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to copy the archive entry to the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Copy-ArchiveEntryToDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    $testFileMatchesArchiveEntryByChecksumParameterFilter = {
                        $fileParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFile -DifferenceObject $File)
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $checksumParameterCorrect = $Checksum -eq $expandArchiveToDestinationParameters.Checksum

                        return $fileParameterCorrect -and $archiveEntryParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -ParameterFilter $testFileMatchesArchiveEntryByChecksumParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove the existing item at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Expand-ArchiveToDestination @expandArchiveToDestinationParameters | Should -Be $null
                }
            }
        }

        Describe 'Remove-DirectoryFromDestination' {
            $sortedTestDirectories = @( 'SortedTestDirectory' )
            $testDirectoryPathAtDestination = 'TestDirectoryPathAtDestination'
            $testDirectoryChildItem = @( 'TestChildItem' )

            Mock -CommandName 'Sort-Object' -MockWith { return $sortedTestDirectories }
            Mock -CommandName 'Join-Path' -MockWith { return $testDirectoryPathAtDestination }
            Mock -CommandName 'Test-Path' -MockWith { return $false }
            Mock -CommandName 'Get-ChildItem' -MockWith { return $null }
            Mock -CommandName 'Remove-Item' -MockWith { }

            Context 'When specified directory does not exist at the specified destination' {
                $removeDirectoryFromDestination = @{
                    Directory = @( 'TestDirectory' )
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-DirectoryFromDestination @removeDirectoryFromDestination } | Should -Not -Throw
                }

                It 'Should sort the specified list of directories' {
                    $sortObjectParameterFilter = {
                        $inputObjectParameterCorrect = $null -eq (Compare-Object -ReferenceObject $removeDirectoryFromDestination.Directory -DifferenceObject $InputObject)
                        $descendingParameterCorrect = $Descending -eq $true
                        $uniqueParameterCorrect = $Unique -eq $true

                        return $inputObjectParameterCorrect -and $descendingParameterCorrect -and $uniqueParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Sort-Object' -ParameterFilter $sortObjectParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the path to the specified directory at the specified destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeDirectoryFromDestination.Destination
                        $childPathParameterCorrect = $ChildPath -eq $sortedTestDirectories[0]

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the directory exists at the destination' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testDirectoryPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt retrieve the child items of the directory at the destination' {
                    Assert-MockCalled -CommandName 'Get-ChildItem' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove the item' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-DirectoryFromDestination @removeDirectoryFromDestination | Should -Be $null
                }
            }

            Mock -CommandName 'Test-Path' -MockWith { return $true }

            Context 'When specified directory exists at the specified destination and does not have child items' {
                $removeDirectoryFromDestination = @{
                    Directory = @( 'TestDirectory' )
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-DirectoryFromDestination @removeDirectoryFromDestination } | Should -Not -Throw
                }

                It 'Should sort the specified list of directories' {
                    $sortObjectParameterFilter = {
                        $inputObjectParameterCorrect = $null -eq (Compare-Object -ReferenceObject $removeDirectoryFromDestination.Directory -DifferenceObject $InputObject)
                        $descendingParameterCorrect = $Descending -eq $true
                        $uniqueParameterCorrect = $Unique -eq $true

                        return $inputObjectParameterCorrect -and $descendingParameterCorrect -and $uniqueParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Sort-Object' -ParameterFilter $sortObjectParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the path to the specified directory at the specified destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeDirectoryFromDestination.Destination
                        $childPathParameterCorrect = $ChildPath -eq $sortedTestDirectories[0]

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the directory exists at the destination' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testDirectoryPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the child items of the directory at the destination' {
                    $getChildItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testDirectoryPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ChildItem' -ParameterFilter $getChildItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should remove the item' {
                    $removeItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testDirectoryPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-Item' -ParameterFilter $removeItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-DirectoryFromDestination @removeDirectoryFromDestination | Should -Be $null
                }
            }

            Mock -CommandName 'Get-ChildItem' -MockWith { return $testDirectoryChildItem }

            Context 'When specified directory exists at the specified destination and has child items' {
                $removeDirectoryFromDestination = @{
                    Directory = @( 'TestDirectory' )
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-DirectoryFromDestination @removeDirectoryFromDestination } | Should -Not -Throw
                }

                It 'Should sort the specified list of directories' {
                    $sortObjectParameterFilter = {
                        $inputObjectParameterCorrect = $null -eq (Compare-Object -ReferenceObject $removeDirectoryFromDestination.Directory -DifferenceObject $InputObject)
                        $descendingParameterCorrect = $Descending -eq $true
                        $uniqueParameterCorrect = $Unique -eq $true

                        return $inputObjectParameterCorrect -and $descendingParameterCorrect -and $uniqueParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Sort-Object' -ParameterFilter $sortObjectParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the path to the specified directory at the specified destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeDirectoryFromDestination.Destination
                        $childPathParameterCorrect = $ChildPath -eq $sortedTestDirectories[0]

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the directory exists at the destination' {
                    $testPathParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testDirectoryPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-Path' -ParameterFilter $testPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the child items of the directory at the destination' {
                    $getChildItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testDirectoryPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ChildItem' -ParameterFilter $getChildItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove the item' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-DirectoryFromDestination @removeDirectoryFromDestination | Should -Be $null
                }
            }
        }

        Describe 'Remove-ArchiveFromDestination' {
            $testArchiveEntryFullName = 'TestArchiveEntryFullName'
            $testItemPathAtDestination = 'TestItemPathAtDestination'
            $testParentDirectoryPath = 'TestParentDirectoryPath'

            $mockArchive = New-MockObject -Type 'System.IO.Compression.ZipArchive'
            $mockArchiveEntry = New-MockObject -Type 'System.IO.Compression.ZipArchiveEntry'
            $mockFile = New-MockObject -Type 'System.IO.FileInfo'
            $mockDirectory = New-MockObject -Type 'System.IO.DirectoryInfo'

            Mock -CommandName 'Open-Archive' -MockWith { return $mockArchive }
            Mock -CommandName 'Get-ArchiveEntries' -MockWith { return @( $mockArchiveEntry ) }
            Mock -CommandName 'Get-ArchiveEntryFullName' -MockWith { return $testArchiveEntryFullName }
            Mock -CommandName 'Join-Path' -MockWith { return $testItemPathAtDestination }
            Mock -CommandName 'Test-ArchiveEntryIsDirectory' -MockWith { return $true }
            Mock -CommandName 'Get-Item' -MockWith { return $null }
            Mock -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -MockWith { return $false }
            Mock -CommandName 'Remove-Item' -MockWith { }
            Mock -CommandName 'Split-Path' -MockWith { return $null }
            Mock -CommandName 'Remove-DirectoryFromDestination' -MockWith { }
            Mock -CommandName 'Close-Archive' -MockWith { }

            Context 'When archive entry is a directory and does not exist at destination' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing file at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove any directories from the destination' {
                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockFile }

            Context 'When archive entry is a directory, item with the same name exists at the destination but is a file' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing file at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove any directories from the destination' {
                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return 'NotAFileOrADirectory' }

            Context 'When archive entry is a directory and item with the same name exists at the destination but is not a file or a directory' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing file at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove any directories from the destination' {
                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockDirectory }

            Context 'When archive entry is a directory and directory with the same name exists at the root of the destination' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing file at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    $splitPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveEntryFullName
                        $parentParameterCorrect = $Parent -eq $true
                        return $pathParameterCorrect -and $parentParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Split-Path' -ParameterFilter $splitPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should remove the specified directory from the destination' {
                    $removeDirectoryFromDestinationParameterFilter = {
                        $directoryParameterCorrect = $null -eq (Compare-Object -ReferenceObject @( $testArchiveEntryFullName ) -DifferenceObject $Directory)
                        $destinationParameterCorrect = $Destination -eq $removeArchiveFromDestinationParameters.Destination
                        return $directoryParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -ParameterFilter $removeDirectoryFromDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Split-Path' -MockWith {
                if ($Path -ne $testParentDirectoryPath)
                {
                    return $testParentDirectoryPath
                }
            }

            Context 'When archive entry is a directory and directory with the same name exists within a parent directory at the destination' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing file at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    $splitPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveEntryFullName
                        $parentParameterCorrect = $Parent -eq $true
                        return $pathParameterCorrect -and $parentParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Split-Path' -ParameterFilter $splitPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should remove the specified directory and its parent directory from the destination' {
                    $removeDirectoryFromDestinationParameterFilter = {
                        $directoryParameterCorrect = $null -eq (Compare-Object -ReferenceObject @( $testArchiveEntryFullName, $testParentDirectoryPath ) -DifferenceObject $Directory)
                        $destinationParameterCorrect = $Destination -eq $removeArchiveFromDestinationParameters.Destination
                        return $directoryParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -ParameterFilter $removeDirectoryFromDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Test-ArchiveEntryIsDirectory' -MockWith { return $false }
            Mock -CommandName 'Get-Item' -MockWith { return $null }
            Mock -CommandName 'Split-Path' -MockWith { return $null }

            Context 'When archive entry is a file and does not exist at destination' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing file at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove any directories from the destination' {
                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockDirectory }

            Context 'When archive entry is a file and item with the same name exists at the destination but is a directory' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing file at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove any directories from the destination' {
                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return 'NotAFileOrADirectory' }

            Context 'When archive entry is a file and item with the same name exists at the destination but is not a file or a directory' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing file at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove any directories from the destination' {
                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $mockFile }

            Context 'When archive entry is a file, file with the same name exists at the root of the destination, and a checksum method is not specified' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should remove the file at the desired path of the archive entry at the destination' {
                    $removeItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-Item' -ParameterFilter $removeItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    $splitPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveEntryFullName
                        $parentParameterCorrect = $Parent -eq $true
                        return $pathParameterCorrect -and $parentParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Split-Path' -ParameterFilter $splitPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove any directories from the destination' {
                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Split-Path' -MockWith {
                if ($Path -ne $testParentDirectoryPath)
                {
                    return $testParentDirectoryPath
                }
            }

            Context 'When archive entry is a file, file with the same name exists within a parent directory at the destination, and a checksum method is not specified' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -Exactly 0 -Scope 'Context'
                }

                It 'Should remove the file at the desired path of the archive entry at the destination' {
                    $removeItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-Item' -ParameterFilter $removeItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    $splitPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveEntryFullName
                        $parentParameterCorrect = $Parent -eq $true
                        return $pathParameterCorrect -and $parentParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Split-Path' -ParameterFilter $splitPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should remove the parent directory from the destination' {
                    $removeDirectoryFromDestinationParameterFilter = {
                        $directoryParameterCorrect = $null -eq (Compare-Object -ReferenceObject @( $testParentDirectoryPath ) -DifferenceObject $Directory)
                        $destinationParameterCorrect = $Destination -eq $removeArchiveFromDestinationParameters.Destination
                        return $directoryParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -ParameterFilter $removeDirectoryFromDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Context 'When archive entry is a file, file with the same name exists at the destination, and files do not match by the specified checksum method' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Checksum = 'SHA-256'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    $testFileMatchesArchiveEntryByChecksumParameterFilter = {
                        $fileParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFile -DifferenceObject $File)
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $checksumParameterCorrect = $Checksum -eq $removeArchiveFromDestinationParameters.Checksum

                        return $fileParameterCorrect -and $archiveEntryParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -ParameterFilter $testFileMatchesArchiveEntryByChecksumParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not attempt to remove an existing file at the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Remove-Item' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    Assert-MockCalled -CommandName 'Split-Path' -Exactly 0 -Scope 'Context'
                }

                It 'Should not attempt to remove any directories from the destination' {
                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -Exactly 0 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }

            Mock -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -MockWith { return $true }

            Context 'When archive entry is a file, file with the same name exists at the destination, and files match by the specified checksum method' {
                $removeArchiveFromDestinationParameters = @{
                    ArchiveSourcePath = 'TestArchiveSourcePath'
                    Destination = 'TestDestination'
                    Checksum = 'SHA-256'
                }

                It 'Should not throw' {
                    { Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters } | Should -Not -Throw
                }

                It 'Should open the archive' {
                    $openArchiveParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.ArchiveSourcePath
                        return $pathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Open-Archive' -ParameterFilter $openArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the entries of the specified archive' {
                    $getArchiveEntriesParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntries' -ParameterFilter $getArchiveEntriesParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the full name of the current archive entry' {
                    $getArchiveEntryFullNameParameterFilter = {
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        return $archiveEntryParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-ArchiveEntryFullName' -ParameterFilter $getArchiveEntryFullNameParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should find the desired path of the archive entry at the destination' {
                    $joinPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $removeArchiveFromDestinationParameters.Destination
                        $childPathParameterCorrect = $ChildPath -eq $testArchiveEntryFullName

                        return $pathParameterCorrect -and $childPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Join-Path' -ParameterFilter $joinPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should retrieve the item at the desired path of the archive entry at the destination' {
                    $getItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Get-Item' -ParameterFilter $getItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the file at the desired path of the archive entry at the destination matches the archive entry by the specified checksum method' {
                    $testFileMatchesArchiveEntryByChecksumParameterFilter = {
                        $fileParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockFile -DifferenceObject $File)
                        $archiveEntryParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchiveEntry -DifferenceObject $ArchiveEntry)
                        $checksumParameterCorrect = $Checksum -eq $removeArchiveFromDestinationParameters.Checksum

                        return $fileParameterCorrect -and $archiveEntryParameterCorrect -and $checksumParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-FileMatchesArchiveEntryByChecksum' -ParameterFilter $testFileMatchesArchiveEntryByChecksumParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should remove the file at the desired path of the archive entry at the destination' {
                    $removeItemParameterFilter = {
                        $literalPathParameterCorrect = $LiteralPath -eq $testItemPathAtDestination
                        return $literalPathParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-Item' -ParameterFilter $removeItemParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should attempt to find the parent directory of the desired path of the archive entry at the destination' {
                    $splitPathParameterFilter = {
                        $pathParameterCorrect = $Path -eq $testArchiveEntryFullName
                        $parentParameterCorrect = $Parent -eq $true
                        return $pathParameterCorrect -and $parentParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Split-Path' -ParameterFilter $splitPathParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should test if the archive entry is a directory' {
                    $testArchiveEntryIsDirectoryParameterFilter = {
                        $archiveEntryNameParameterCorrect = $ArchiveEntryName -eq $testArchiveEntryFullName
                        return $archiveEntryNameParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Test-ArchiveEntryIsDirectory' -ParameterFilter $testArchiveEntryIsDirectoryParameterFilter  -Exactly 1 -Scope 'Context'
                }

                It 'Should remove the parent directory from the destination' {
                    $removeDirectoryFromDestinationParameterFilter = {
                        $directoryParameterCorrect = $null -eq (Compare-Object -ReferenceObject @( $testParentDirectoryPath ) -DifferenceObject $Directory)
                        $destinationParameterCorrect = $Destination -eq $removeArchiveFromDestinationParameters.Destination
                        return $directoryParameterCorrect -and $destinationParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Remove-DirectoryFromDestination' -ParameterFilter $removeDirectoryFromDestinationParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should close the opened archive' {
                    $closeArchiveParameterFilter = {
                        $archiveParameterCorrect = $null -eq (Compare-Object -ReferenceObject $mockArchive -DifferenceObject $Archive)
                        return $archiveParameterCorrect
                    }

                    Assert-MockCalled -CommandName 'Close-Archive' -ParameterFilter $closeArchiveParameterFilter -Exactly 1 -Scope 'Context'
                }

                It 'Should not return anything' {
                    Remove-ArchiveFromDestination @removeArchiveFromDestinationParameters | Should -Be $null
                }
            }
        }
    }
}
