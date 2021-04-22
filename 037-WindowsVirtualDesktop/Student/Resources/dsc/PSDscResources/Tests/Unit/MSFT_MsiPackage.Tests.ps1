$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

Describe 'MsiPackage Unit Tests' {
    BeforeAll {
        # Import CommonTestHelper
        $testsFolderFilePath = Split-Path $PSScriptRoot -Parent
        $testHelperFolderFilePath = Join-Path -Path $testsFolderFilePath -ChildPath 'TestHelpers'
        $commonTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'CommonTestHelper.psm1'
        Import-Module -Name $commonTestHelperFilePath

        $script:testEnvironment = Enter-DscResourceTestEnvironment `
            -DscResourceModuleName 'PSDscResources' `
            -DscResourceName 'MSFT_MsiPackage' `
            -TestType 'Unit'
    }

    AfterAll {
        Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
    }

    InModuleScope 'MSFT_MsiPackage' {
        $script:testsFolderFilePath = Split-Path $PSScriptRoot -Parent
        $testHelperFolderFilePath = Join-Path -Path $testsFolderFilePath -ChildPath 'TestHelpers'
        $script:commonTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'CommonTestHelper.psm1'

        # This must be imported again within the InModuleScope so that the helper functions can be accessed
        Import-Module -Name $commonTestHelperFilePath

        $testUsername = 'TestUsername'
        $testPassword = 'TestPassword'
        $secureTestPassword = ConvertTo-SecureString -String $testPassword -AsPlainText -Force

        $script:testCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @( $testUsername, $secureTestPassword )
        $script:testProductId = '{deadbeef-80c6-41e6-a1b9-8bdb8a05027f}'
        $script:testIdentifyingNumber = '{DEADBEEF-80C6-41E6-A1B9-8BDB8A05027F}'
        $script:testWrongProductId = 'wrongId'
        $script:testPath = 'file://test.msi'
        $script:destinationPath = Join-Path -Path $script:packageCacheLocation -ChildPath 'C:\'
        $script:testUriHttp = [System.Uri] 'http://test.msi'
        $script:testUriHttps = [System.Uri] 'https://test.msi'
        $script:testUriFile = [System.Uri] 'file://test.msi'
        $script:testUriNonUnc = [System.Uri] 'file:///C:/test.msi'
        $script:testUriQuery = [System.Uri] 'http://C:/directory/test/test.msi?sv=2017-01-31&spr=https'
        $script:testUriOnlyFile = [System.Uri] 'test.msi'

        $script:mockStream = New-MockObject -Type 'System.IO.FileStream'
        $script:mockWebRequest = New-MockObject -Type 'System.Net.HttpWebRequest'
        $script:mockStartInfo = New-MockObject -Type 'System.Diagnostics.ProcessStartInfo'
        $script:mockProcess = New-MockObject -Type 'System.Diagnostics.Process'
        $script:mockProductEntry = New-MockObject -Type 'Microsoft.Win32.RegistryKey'

        $script:mockPSDrive = @{
            Root = 'mockRoot'
        }

        $script:mockProductEntryInfo = @{
            Name = 'TestDisplayName'
            InstallSource = 'TestInstallSource'
            InstalledOn = ([DateTime]::new(2017, 4, 24).ToShortDateString())
            Size = 2048
            Version = '1.2.3.4'
            PackageDescription = 'Test Description'
            Publisher = 'Test Publisher'
            Ensure = 'Present'
        }

        # Used to create the names of the tests that check to ensure the correct error is thrown.
        $script:errorMessageTitles = @{
            CouldNotOpenLog = 'not being able to open the log path'
            InvalidId = 'the specified product ID not matching the actual product ID'
            CouldNotOpenDestFile = 'not being able to open the destination file to write to'
            PathDoesNotExist = 'not being able to find the path'
            CouldNotStartProcess = 'not being able to start the process'
            PostValidationError = 'not being able to find the package after installation'
        }

        Describe 'Get-TargetResource' {
            Mock -CommandName 'Convert-ProductIdToIdentifyingNumber' -MockWith { return $script:testIdentifyingNumber }
            Mock -CommandName 'Get-ProductEntry' -MockWith { return $null }
            Mock -CommandName 'Get-ProductEntryInfo' -MockWith { return $script:mockProductEntryInfo }

            Context 'MSI package does not exist' {
                $getTargetResourceParameters = @{
                    ProductId = $script:testProductId
                    Path = $script:testPath
                }

                $mocksCalled = @(
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                    @{ Command = 'Get-ProductEntryInfo'; Times = 0 }
                )

                $expectedReturnValue = @{
                    Ensure = 'Absent'
                    ProductId = $script:testIdentifyingNumber
                }

                Invoke-GetTargetResourceUnitTest -GetTargetResourceParameters $getTargetResourceParameters `
                                             -MocksCalled $mocksCalled `
                                             -ExpectedReturnValue $expectedReturnValue
            }

            Mock -CommandName 'Get-ProductEntry' -MockWith { return $script:mockProductEntry }

            Context 'MSI package does exist' {
                $getTargetResourceParameters = @{
                    ProductId = $script:testProductId
                    Path = $script:testPath
                }

                $mocksCalled = @(
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                    @{ Command = 'Get-ProductEntryInfo'; Times = 1 }
                )

                $expectedReturnValue = $script:mockProductEntryInfo

                Invoke-GetTargetResourceUnitTest -GetTargetResourceParameters $getTargetResourceParameters `
                                             -MocksCalled $mocksCalled `
                                             -ExpectedReturnValue $expectedReturnValue
            }
        }

        Describe 'Set-TargetResource' {
            $setTargetResourceParameters = @{
                ProductId = 'TestProductId'
                Path = $script:testPath
                Ensure = 'Present'
                Arguments = 'TestArguments'
                LogPath = 'TestLogPath'
                FileHash = 'TestFileHash'
                HashAlgorithm = 'Sha256'
                SignerSubject = 'TestSignerSubject'
                SignerThumbprint = 'TestSignerThumbprint'
                ServerCertificateValidationCallback = 'TestValidationCallback'
                RunAsCredential = $script:testCredential
            }

            Mock -CommandName 'Convert-PathToUri' -MockWith { return $script:testUriNonUnc }
            Mock -CommandName 'Convert-ProductIdToIdentifyingNumber' -MockWith { return $script:testIdentifyingNumber }
            Mock -CommandName 'Assert-PathExtensionValid' -MockWith {}
            Mock -CommandName 'New-LogFile' -MockWith {}
            Mock -CommandName 'New-PSDrive' -MockWith { return $script:mockPSDrive }
            Mock -CommandName 'Test-Path' -MockWith { return $true }
            Mock -CommandName 'New-Item' -MockWith {}
            Mock -CommandName 'New-Object' -MockWith { return $script:mockStream }
            Mock -CommandName 'Get-WebRequestResponse' -MockWith { return $script:mockStream }
            Mock -CommandName 'Copy-ResponseStreamToFileStream' -MockWith {}
            Mock -CommandName 'Close-Stream' -MockWith {}
            Mock -CommandName 'Assert-FileValid' -MockWith {}
            Mock -CommandName 'Get-MsiProductCode' -MockWith { return $script:testIdentifyingNumber }
            Mock -CommandName 'Start-MsiProcess' -MockWith {
                # Returns the exit code
                return 0
            }
            Mock -CommandName 'Remove-PSDrive' -MockWith {}
            Mock -CommandName 'Remove-Item' -MockWith {}
            Mock -CommandName 'Invoke-CimMethod' -MockWith {}
            Mock -CommandName 'Get-ItemProperty' -MockWith { return $null }
            Mock -CommandName 'Get-ProductEntry' -MockWith { return $script:mockProductEntry }

            Context 'Uri scheme is non-UNC file and installation succeeds' {
                $mocksCalled = @(
                    @{ Command = 'Convert-PathToUri'; Times = 1 }
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Assert-PathExtensionValid'; Times = 1 }
                    @{ Command = 'New-LogFile'; Times = 1 }
                    @{ Command = 'New-PSDrive'; Times = 0 }
                    @{ Command = 'Get-WebRequestResponse'; Times = 0 }
                    @{ Command = 'Test-Path'; Times = 1; Custom = 'to the MSI file' }
                    @{ Command = 'Assert-FileValid'; Times = 1 }
                    @{ Command = 'Get-MsiProductCode'; Times = 1 }
                    @{ Command = 'Start-MsiProcess'; Times = 1 }
                    @{ Command = 'Remove-PSDrive'; Times = 0 }
                    @{ Command = 'Remove-Item'; Times = 0; Custom = 'the downloaded file from the http server' }
                    @{ Command = 'Invoke-CimMethod'; Times = 1 }
                    @{ Command = 'Get-ItemProperty'; Times = 1; Custom = 'the registry data for pending file rename operations' }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                )

                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -MocksCalled $mocksCalled `
                                             -ShouldThrow $false
            }

            Mock -CommandName 'Convert-PathToUri' -MockWith { return $script:testUriFile }
            $setTargetResourceParameters.Ensure = 'Present'

            Context 'Uri scheme is UNC file and installation succeeds' {
                $mocksCalled = @(
                    @{ Command = 'Convert-PathToUri'; Times = 1 }
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Assert-PathExtensionValid'; Times = 1 }
                    @{ Command = 'New-LogFile'; Times = 1 }
                    @{ Command = 'New-PSDrive'; Times = 1 }
                    @{ Command = 'Get-WebRequestResponse'; Times = 0 }
                    @{ Command = 'Test-Path'; Times = 1; Custom = 'to the MSI file' }
                    @{ Command = 'Assert-FileValid'; Times = 1 }
                    @{ Command = 'Get-MsiProductCode'; Times = 1 }
                    @{ Command = 'Start-MsiProcess'; Times = 1 }
                    @{ Command = 'Remove-PSDrive'; Times = 1 }
                    @{ Command = 'Remove-Item'; Times = 0; Custom = 'the downloaded file from the http server' }
                    @{ Command = 'Invoke-CimMethod'; Times = 1 }
                    @{ Command = 'Get-ItemProperty'; Times = 1; Custom = 'the registry data for pending file rename operations' }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                )

                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -MocksCalled $mocksCalled `
                                             -ShouldThrow $false
            }

            Mock -CommandName 'Convert-PathToUri' -MockWith { return $script:testUriHttp }

            Context 'Uri scheme is Http and installation succeeds' {
                $mocksCalled = @(
                    @{ Command = 'Convert-PathToUri'; Times = 1 }
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Assert-PathExtensionValid'; Times = 1 }
                    @{ Command = 'New-LogFile'; Times = 1 }
                    @{ Command = 'New-PSDrive'; Times = 0 }
                    @{ Command = 'Test-Path'; Times = 3; Custom = 'to the package cache' }
                    @{ Command = 'New-Item'; Times = 0; Custom = 'directory for the package cache' }
                    @{ Command = 'New-Object'; Times = 1; Custom = 'file stream to copy the response to' }
                    @{ Command = 'Get-WebRequestResponse'; Times = 1 }
                    @{ Command = 'Copy-ResponseStreamToFileStream'; Times = 1 }
                    @{ Command = 'Close-Stream'; Times = 2 }
                    @{ Command = 'Test-Path'; Times = 3; Custom = 'to the MSI file' }
                    @{ Command = 'Assert-FileValid'; Times = 1 }
                    @{ Command = 'Get-MsiProductCode'; Times = 1 }
                    @{ Command = 'Start-MsiProcess'; Times = 1 }
                    @{ Command = 'Remove-PSDrive'; Times = 0 }
                    @{ Command = 'Remove-Item'; Times = 1; Custom = 'the directory used for the package cache' }
                    @{ Command = 'Invoke-CimMethod'; Times = 1 }
                    @{ Command = 'Get-ItemProperty'; Times = 1; Custom = 'the registry data for pending file rename operations' }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                )

                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -MocksCalled $mocksCalled `
                                             -ShouldThrow $false
            }

            Mock -CommandName 'Convert-PathToUri' -MockWith { return $script:testUriHttps }

            Context 'Uri scheme is Https and installation succeeds' {
                $mocksCalled = @(
                    @{ Command = 'Convert-PathToUri'; Times = 1 }
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Assert-PathExtensionValid'; Times = 1 }
                    @{ Command = 'New-LogFile'; Times = 1 }
                    @{ Command = 'New-PSDrive'; Times = 0 }
                    @{ Command = 'Test-Path'; Times = 3; Custom = 'to the package cache' }
                    @{ Command = 'New-Item'; Times = 0; Custom = 'directory for the package cache' }
                    @{ Command = 'New-Object'; Times = 1; Custom = 'file stream to copy the response to' }
                    @{ Command = 'Get-WebRequestResponse'; Times = 1 }
                    @{ Command = 'Copy-ResponseStreamToFileStream'; Times = 1 }
                    @{ Command = 'Close-Stream'; Times = 2 }
                    @{ Command = 'Test-Path'; Times = 3; Custom = 'to the MSI file' }
                    @{ Command = 'Assert-FileValid'; Times = 1 }
                    @{ Command = 'Get-MsiProductCode'; Times = 1 }
                    @{ Command = 'Start-MsiProcess'; Times = 1 }
                    @{ Command = 'Remove-PSDrive'; Times = 0 }
                    @{ Command = 'Remove-Item'; Times = 1; Custom = 'the directory used for the package cache' }
                    @{ Command = 'Invoke-CimMethod'; Times = 1 }
                    @{ Command = 'Get-ItemProperty'; Times = 1; Custom = 'the registry data for pending file rename operations' }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                )

                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -MocksCalled $mocksCalled `
                                             -ShouldThrow $false
            }

            $setTargetResourceParameters.Ensure = 'Absent'

            # The URI scheme doesn't matter for uninstallation - it will always do the same thing
            Context 'Uninstallation succeeds' {
                $mocksCalled = @(
                    @{ Command = 'Convert-PathToUri'; Times = 1 }
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Assert-PathExtensionValid'; Times = 1 }
                    @{ Command = 'New-LogFile'; Times = 1 }
                    @{ Command = 'New-PSDrive'; Times = 0 }
                    @{ Command = 'Get-WebRequestResponse'; Times = 0 }
                    @{ Command = 'Test-Path'; Times = 0; Custom = 'to the MSI file' }
                    @{ Command = 'Assert-FileValid'; Times = 0 }
                    @{ Command = 'Get-MsiProductCode'; Times = 0 }
                    @{ Command = 'Start-MsiProcess'; Times = 1 }
                    @{ Command = 'Remove-PSDrive'; Times = 0 }
                    @{ Command = 'Remove-Item'; Times = 0; Custom = 'the downloaded file from the http server' }
                    @{ Command = 'Invoke-CimMethod'; Times = 1 }
                    @{ Command = 'Get-ItemProperty'; Times = 1; Custom = 'the registry data for pending file rename operations' }
                    @{ Command = 'Get-ProductEntry'; Times = 0 }
                )

                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -MocksCalled $mocksCalled `
                                             -ShouldThrow $false
            }

            Mock -CommandName 'Convert-PathToUri' -MockWith { return $script:testUriQuery }

            Context 'Path is a query path' {
                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -ShouldThrow $false

                It 'Should assert that the file without the query string has a valid extension' {
                    Assert-MockCalled -CommandName 'Assert-PathExtensionValid' -Exactly 1 -Scope 'Context' -ParameterFilter { $Path -eq (Split-Path -Path $script:testuriQuery.LocalPath -Leaf) }
                }
            }

            Mock -CommandName 'Convert-PathToUri' -MockWith { return $script:testUriOnlyFile }

            Context 'Converted URI does not have a local path' {
                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -ShouldThrow $false

                It 'Should assert that the original path has a valid extension' {
                    Assert-MockCalled -CommandName 'Assert-PathExtensionValid' -Exactly 1 -Scope 'Context' -ParameterFilter { $Path -eq $script:testPath }
                }
            }

            $setTargetResourceParameters.Remove('LogPath')

            Context 'Converted URI does not have a local path' {
                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -MocksCalled @(@{ Command = 'New-LogFile'; Times = 0 }) `
                                             -ShouldThrow $false
            }

            Mock -CommandName 'Convert-PathToUri' -MockWith { return $script:testUriHttp }
            Mock -CommandName 'Test-Path' -MockWith { return $false } -ParameterFilter { $Path -eq $script:packageCacheLocation }
            $setTargetResourceParameters.Ensure = 'Present'

            Context 'URI scheme is Http and package cache location does not exist yet' {
                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -MocksCalled @(@{ Command = 'New-Item'; Times = 1; Custom = 'directory for the package cache' }) `
                                             -ShouldThrow $false
            }

            # Error Tests

            Mock -CommandName 'Get-ProductEntry' -MockWith { return $null }

            Context 'Package could not be found after installation' {
                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -ShouldThrow $true `
                                             -ErrorMessage ($script:localizedData.PostValidationError -f $setTargetResourceParameters.Path) `
                                             -ErrorTestName $script:errorMessageTitles.PostValidationError
            }

            Mock -CommandName 'Get-MsiProductCode' -MockWith { return $script:testWrongProductId }

            Context 'Product code from downloaded MSI package does not match specified ID' {
                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -ShouldThrow $true `
                                             -ErrorMessage ($script:localizedData.InvalidId -f $script:testIdentifyingNumber, $script:testWrongProductId) `
                                             -ErrorTestName $script:errorMessageTitles.InvalidId
            }

            Mock -CommandName 'New-Object' -MockWith { Throw }

            Context 'Failure while creating the file stream object to download to' {
                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -ShouldThrow $true `
                                             -ErrorMessage ($script:localizedData.CouldNotOpenDestFile -f $script:destinationPath) `
                                             -ErrorTestName $script:errorMessageTitles.CouldNotOpenDestFile
            }

            Mock -CommandName 'Convert-PathToUri' -MockWith { return $script:testUriNonUnc }
            Mock -CommandName 'Test-Path' -MockWith { return $false } -ParameterFilter { $Path -eq $script:testPath }

            Context 'Invalid path was passed in' {
                Invoke-SetTargetResourceUnitTest -SetTargetResourceParameters $setTargetResourceParameters `
                                             -ShouldThrow $true `
                                             -ErrorMessage ($script:localizedData.PathDoesNotExist -f $script:testPath) `
                                             -ErrorTestName $script:errorMessageTitles.PathDoesNotExist
            }
        }

        Describe 'Test-TargetResource' {
            Mock -CommandName 'Convert-ProductIdToIdentifyingNumber' -MockWith { return $script:testIdentifyingNumber }
            Mock -CommandName 'Get-ProductEntry' -MockWith { return $script:mockProductEntry }
            Mock -CommandName 'Get-ProductEntryValue' -MockWith { return $script:mockProductEntryInfo.Name }

            Context 'Specified package is present and should be' {
                $testTargetResourceParameters = @{
                    ProductId = $script:testProductId
                    Path = $script:testPath
                    Ensure = 'Present'
                }

                $mocksCalled = @(
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                    @{ Command = 'Get-ProductEntryValue'; Times = 1 }
                )

                Invoke-TestTargetResourceUnitTest -TestTargetResourceParameters $testTargetResourceParameters `
                                              -MocksCalled $mocksCalled `
                                              -ExpectedReturnValue $true
            }

            Context 'Specified package is present but should not be' {
                $testTargetResourceParameters = @{
                    ProductId = $script:testProductId
                    Path = $script:testPath
                    Ensure = 'Absent'
                }

                $mocksCalled = @(
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                    @{ Command = 'Get-ProductEntryValue'; Times = 1 }
                )

                Invoke-TestTargetResourceUnitTest -TestTargetResourceParameters $testTargetResourceParameters `
                                              -MocksCalled $mocksCalled `
                                              -ExpectedReturnValue $false
            }

            Mock -CommandName 'Get-ProductEntry' -MockWith { return $null }

            Context 'Specified package is Absent but should not be' {
                $testTargetResourceParameters = @{
                    ProductId = $script:testProductId
                    Path = $script:testPath
                    Ensure = 'Present'
                }

                $mocksCalled = @(
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                    @{ Command = 'Get-ProductEntryValue'; Times = 0 }
                )

                Invoke-TestTargetResourceUnitTest -TestTargetResourceParameters $testTargetResourceParameters `
                                              -MocksCalled $mocksCalled `
                                              -ExpectedReturnValue $false
            }

            Context 'Specified package is Absent and should be' {
                $testTargetResourceParameters = @{
                    ProductId = $script:testProductId
                    Path = $script:testPath
                    Ensure = 'Absent'
                }

                $mocksCalled = @(
                    @{ Command = 'Convert-ProductIdToIdentifyingNumber'; Times = 1 }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                    @{ Command = 'Get-ProductEntryValue'; Times = 0 }
                )

                Invoke-TestTargetResourceUnitTest -TestTargetResourceParameters $testTargetResourceParameters `
                                              -MocksCalled $mocksCalled `
                                              -ExpectedReturnValue $true
            }
        }

        Describe 'Assert-PathExtensionValid' {
            Context 'Path is a valid .msi path' {
                It 'Should not throw' {
                    { Assert-PathExtensionValid -Path 'testMsiFile.msi' } | Should -Not -Throw
                }
            }

            Context 'Path is not a valid .msi path' {
                It 'Should throw an invalid argument exception when an EXE file is passed in' {
                    $invalidPath = 'testMsiFile.exe'
                    $expectedErrorMessage = ($script:localizedData.InvalidBinaryType -f $invalidPath)

                    { Assert-PathExtensionValid -Path $invalidPath } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }

                It 'Should throw an invalid argument exception when an invalid file type is passed in' {
                    $invalidPath = 'testMsiFilemsi'
                    $expectedErrorMessage = ($script:localizedData.InvalidBinaryType -f $invalidPath)

                    { Assert-PathExtensionValid -Path $invalidPath } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }
        }

        Describe 'Convert-PathToUri' {
            Context 'Path has a valid URI scheme' {
                It 'Should return the expected URI when scheme is a file' {
                    $filePath = (Join-Path -Path $PSScriptRoot -ChildPath 'testMsi.msi')
                    $expectedReturnValue = [System.Uri] $filePath

                    Convert-PathToUri -Path $filePath | Should -Be $expectedReturnValue
                }

                It 'Should return the expected URI when scheme is http' {
                    $uriBuilder = [System.UriBuilder]::new('http', 'localhost')
                    $uriBuilder.Path = 'testMsi.msi'
                    $filePath = $uriBuilder.Uri.AbsoluteUri

                    Convert-PathToUri -Path $filePath | Should -Be $uriBuilder.Uri
                }

                It 'Should return the expected URI when scheme is https' {
                    $uriBuilder = [System.UriBuilder]::new('https', 'localhost')
                    $uriBuilder.Path = 'testMsi.msi'
                    $filePath = $uriBuilder.Uri.AbsoluteUri

                    Convert-PathToUri -Path $filePath | Should -Be $uriBuilder.Uri
                }
            }

            Context 'Invalid path passed in' {
                It 'Should throw an error when uri scheme is invalid' {
                    $filePath = 'ht://localhost/testMsi.msi'
                    $expectedErrorMessage = ($script:localizedData.InvalidPath -f $filePath)

                    { Convert-PathToUri -Path $filePath } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }

                It 'Should throw an error when path is not in valid format' {
                    $filePath = 'mri'
                    $expectedErrorMessage = ($script:localizedData.InvalidPath -f $filePath)

                    { Convert-PathToUri -Path $filePath } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }
        }

        Describe 'Convert-ProductIdToIdentifyingNumber' {
            Context 'Valid Product ID is passed in' {
                It 'Should return the same value that is passed in when the Product ID is already in the correct format' {
                    Convert-ProductIdToIdentifyingNumber -ProductId $script:testIdentifyingNumber | Should -Be $script:testIdentifyingNumber
                }

                It 'Should convert a valid poduct ID to the identifying number format' {
                    Convert-ProductIdToIdentifyingNumber -ProductId $script:testProductId | Should -Be $script:testIdentifyingNumber
                }
            }

            Context 'Invalid Product ID is passed in' {
                It 'Should throw an exception when an invalid product ID is passed in' {
                    $expectedErrorMessage = ($script:localizedData.InvalidIdentifyingNumber -f $script:testWrongProductId)
                    { Convert-ProductIdToIdentifyingNumber -ProductId $script:testWrongProductId } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }
        }

        Describe 'Get-ProductEntry' {
            $uninstallRegistryKeyLocation = (Join-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' -ChildPath $script:testIdentifyingNumber)
            $uninstallRegistryKeyWow64Location = (Join-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall' -ChildPath $script:testIdentifyingNumber)

            Mock -CommandName 'Get-Item' -MockWith { return $script:mockProductEntry } -ParameterFilter { $Path -eq $uninstallRegistryKeyLocation }
            Mock -CommandName 'Get-Item' -MockWith { return $script:mockProductEntry } -ParameterFilter { $Path -eq $uninstallRegistryKeyWow64Location }

            Context 'Product entry is found in the expected location' {
                It 'Should return the expected product entry' {
                    Get-ProductEntry -IdentifyingNumber $script:testIdentifyingNumber | Should -Be $script:mockProductEntry
                }

                It 'Should retrieve the item' {
                    Assert-MockCalled -CommandName 'Get-Item' -Exactly 1 -Scope 'Context'
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $null } -ParameterFilter { $Path -eq $uninstallRegistryKeyLocation }

            Context 'Product entry is found under Wow6432Node' {
                It 'Should return the expected product entry' {
                    Get-ProductEntry -IdentifyingNumber $script:testIdentifyingNumber | Should -Be $script:mockProductEntry
                }

                It 'Should attempt to retrieve the item twice' {
                    Assert-MockCalled -CommandName 'Get-Item' -Exactly 2 -Scope 'Context'
                }
            }

            Mock -CommandName 'Get-Item' -MockWith { return $null } -ParameterFilter { $Path -eq $uninstallRegistryKeyWow64Location }

            Context 'Product entry is not found' {
                It 'Should return $null' {
                    Get-ProductEntry -IdentifyingNumber $script:testIdentifyingNumber | Should -Be $null
                }

                It 'Should attempt to retrieve the item twice' {
                    Assert-MockCalled -CommandName 'Get-Item' -Exactly 2 -Scope 'Context'
                }
            }
        }

        Describe 'Get-ProductEntryInfo' {
            Mock -CommandName Get-ProductEntryValue -MockWith { return '20170424' } -ParameterFilter { $Property -eq 'InstallDate' }
            Mock -CommandName Get-ProductEntryValue -MockWith { return $script:mockProductEntryInfo.Publisher } -ParameterFilter { $Property -eq 'Publisher' }
            Mock -CommandName Get-ProductEntryValue -MockWith { return $script:mockProductEntryInfo.Size } -ParameterFilter { $Property -eq 'EstimatedSize' }
            Mock -CommandName Get-ProductEntryValue -MockWith { return $script:mockProductEntryInfo.Version } -ParameterFilter { $Property -eq 'DisplayVersion' }
            Mock -CommandName Get-ProductEntryValue -MockWith { return $script:mockProductEntryInfo.PackageDescription } -ParameterFilter { $Property -eq 'Comments' }
            Mock -CommandName Get-ProductEntryValue -MockWith { return $script:mockProductEntryInfo.Name } -ParameterFilter { $Property -eq 'DisplayName' }
            Mock -CommandName Get-ProductEntryValue -MockWith { return $script:mockProductEntryInfo.InstallSource } -ParameterFilter { $Property -eq 'InstallSource' }

            Context 'All properties are retrieved successfully' {

                $getProductEntryInfoResult = Get-ProductEntryInfo -ProductEntry $script:mockProductEntry

                It 'Should return the expected installed date' {
                     $getProductEntryInfoResult.InstalledOn | Should -Be $script:mockProductEntryInfo.InstalledOn
                }

                It 'Should return the expected publisher' {
                     $getProductEntryInfoResult.Publisher | Should -Be $script:mockProductEntryInfo.Publisher
                }

                It 'Should return the expected size' {
                     $getProductEntryInfoResult.Size | Should -Be ($script:mockProductEntryInfo.Size / 1024)
                }

                It 'Should return the expected Version' {
                     $getProductEntryInfoResult.Version | Should -Be $script:mockProductEntryInfo.Version
                }

                It 'Should return the expected package description' {
                     $getProductEntryInfoResult.PackageDescription | Should -Be $script:mockProductEntryInfo.PackageDescription
                }

                It 'Should return the expected name' {
                     $getProductEntryInfoResult.Name | Should -Be $script:mockProductEntryInfo.Name
                }

                It 'Should return the expected install source' {
                     $getProductEntryInfoResult.InstallSource | Should -Be $script:mockProductEntryInfo.InstallSource
                }

                It 'Should retrieve 7 product entry values' {
                    Assert-MockCalled -CommandName 'Get-ProductEntryValue' -Exactly 7 -Scope 'Context'
                }
            }

            Mock -CommandName Get-ProductEntryValue -MockWith { return '4/4/2017' } -ParameterFilter { $Property -eq 'InstallDate' }

            Context 'Install date is in incorrect format' {

                $getProductEntryInfoResult = Get-ProductEntryInfo -ProductEntry $script:mockProductEntry

                It 'Should return $null for InstalledOn' {
                    $getProductEntryInfoResult.InstalledOn | Should -Be $null
                }
            }
        }

        Describe 'New-LogFile' {
            Mock -CommandName 'Test-Path' -MockWith { return $true }
            Mock -CommandName 'Remove-Item' -MockWith {}
            Mock -CommandName 'New-Item' -MockWith {}

            Context 'File with name of given log file already exists and creation of new log file succeeds' {
                $mocksCalled = @(
                    @{ Command = 'Test-Path'; Times = 1; Custom = 'to the log file' }
                    @{ Command = 'Remove-Item'; Times = 1; Custom = 'any file with the same name as the log file' }
                    @{ Command = 'New-Item'; Times = 1; Custom = 'log file' }
                )

                Invoke-GenericUnitTest -Function { Param($script:testPath) New-LogFile $script:testPath } `
                                       -FunctionParameters @{ LogPath = $script:testPath } `
                                       -MocksCalled $mocksCalled `
                                       -ShouldThrow $false
            }

            Mock -CommandName 'Test-Path' -MockWith { return $false }

            Context 'File with name of given log file does not exist and creation of new log file succeeds' {
                $mocksCalled = @(
                    @{ Command = 'Test-Path'; Times = 1; Custom = 'to the log file' }
                    @{ Command = 'Remove-Item'; Times = 0; Custom = 'any file with the same name as the log file' }
                    @{ Command = 'New-Item'; Times = 1; Custom = 'log file' }
                )

                Invoke-GenericUnitTest -Function { Param($script:testPath) New-LogFile $script:testPath } `
                                       -FunctionParameters @{ LogPath = $script:testPath } `
                                       -MocksCalled $mocksCalled `
                                       -ShouldThrow $false
            }

            Mock -CommandName 'New-Item' -MockWith { Throw }

            Context 'Creation of new log file fails' {
                Invoke-GenericUnitTest -Function { Param($script:testPath) New-LogFile $script:testPath } `
                                       -FunctionParameters @{ LogPath = $script:testPath } `
                                       -ShouldThrow $true `
                                       -ErrorMessage ($script:localizedData.CouldNotOpenLog -f $script:testPath) `
                                       -ErrorTestName $script:errorMessageTitles.CouldNotOpenLog
            }
        }

        Describe 'Get-WebRequestResponse' {
            Mock -CommandName 'Get-WebRequest' -MockWith { return $script:mockWebRequest }
            Mock -CommandName 'Get-ScriptBlock' -MockWith { return { Write-Verbose 'Hello World' } }
            Mock -CommandName 'Get-WebRequestResponseStream' -MockWith { return $script:mockStream }

            Context 'URI scheme is Http and response is successfully retrieved' {
                $mocksCalled = @(
                    @{ Command = 'Get-WebRequest'; Times = 1 }
                    @{ Command = 'Get-ScriptBlock'; Times = 0 }
                    @{ Command = 'Get-WebRequestResponseStream'; Times = 1 }
                )

                It 'Should return the expected response stream' {
                    Get-WebRequestResponse -Uri $script:testUriHttp | Should -Be $script:mockStream
                }

                Invoke-ExpectedMocksAreCalledTest -MocksCalled $mocksCalled
            }

            Context 'URI scheme is Https with no callback and response is successfully retrieved' {
                $mocksCalled = @(
                    @{ Command = 'Get-WebRequest'; Times = 1 }
                    @{ Command = 'Get-ScriptBlock'; Times = 0 }
                    @{ Command = 'Get-WebRequestResponseStream'; Times = 1 }
                )

                It 'Should return the expected response stream' {
                    Get-WebRequestResponse -Uri $script:testUriHttps | Should -Be $script:mockStream
                }

                Invoke-ExpectedMocksAreCalledTest -MocksCalled $mocksCalled
            }

            Context 'URI scheme is Https with callback and response is successfully retrieved' {
                $mocksCalled = @(
                    @{ Command = 'Get-WebRequest'; Times = 1 }
                    @{ Command = 'Get-ScriptBlock'; Times = 1 }
                    @{ Command = 'Get-WebRequestResponseStream'; Times = 1 }
                )

                It 'Should return the expected response stream' {
                    Get-WebRequestResponse -Uri $script:testUriHttps -ServerCertificateValidationCallback 'TestCallbackFunction' | Should -Be $script:mockStream
                }

                Invoke-ExpectedMocksAreCalledTest -MocksCalled $mocksCalled
            }

            Mock -CommandName 'Get-WebRequestResponseStream' -MockWith { Throw }

            Context 'Error occurred during while retrieving the response' {
                It 'Should throw the expected exception' {
                    $expectedErrorMessage = ($script:localizedData.CouldNotGetResponseFromWebRequest -f $script:testUriHttp.Scheme, $script:testUriHttp.OriginalString)
                    { Get-WebRequestResponse -Uri $script:testUriHttp } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }
        }

        Describe 'Assert-FileValid' {
            Mock -CommandName 'Assert-FileHashValid' -MockWith {}
            Mock -CommandName 'Assert-FileSignatureValid' -MockWith {}

            Context 'FileHash is passed in and SignerThumbprint and SignerSubject are not' {
                $mocksCalled = @(
                    @{ Command = 'Assert-FileHashValid'; Times = 1 }
                    @{ Command = 'Assert-FileSignatureValid'; Times = 0 }
                )

                It 'Should not throw' {
                    { Assert-FileValid -Path $script:testPath -FileHash 'mockFileHash' } | Should -Not -Throw
                }

                Invoke-ExpectedMocksAreCalledTest -MocksCalled $mocksCalled
            }

            Context 'FileHash and SignerThumbprint are passed in but SignerSubject is not' {
                $mocksCalled = @(
                    @{ Command = 'Assert-FileHashValid'; Times = 1 }
                    @{ Command = 'Assert-FileSignatureValid'; Times = 1 }
                )

                It 'Should not throw' {
                    { Assert-FileValid -Path $script:testPath -FileHash 'mockFileHash' -SignerThumbprint 'mockSignerThumbprint' } | Should -Not -Throw
                }

                Invoke-ExpectedMocksAreCalledTest -MocksCalled $mocksCalled
            }

            Context 'Only Path and SignerSubject are passed in' {
                $mocksCalled = @(
                    @{ Command = 'Assert-FileHashValid'; Times = 0 }
                    @{ Command = 'Assert-FileSignatureValid'; Times = 1 }
                )

                It 'Should not throw' {
                    { Assert-FileValid -Path $script:testPath -SignerSubject 'mockSignerSubject' } | Should -Not -Throw
                }

                Invoke-ExpectedMocksAreCalledTest -MocksCalled $mocksCalled
            }

            Context 'FileHash, SignerThumbprint, and SignerSubject are passed in' {
                $mocksCalled = @(
                    @{ Command = 'Assert-FileHashValid'; Times = 1 }
                    @{ Command = 'Assert-FileSignatureValid'; Times = 1 }
                )

                It 'Should not throw' {
                    { Assert-FileValid -Path $script:testPath -FileHash 'mockFileHash' `
                                                              -SignerThumbprint 'mockSignerThumbprint' `
                                                              -SignerSubject 'mockSignerSubject'
                    } | Should -Not -Throw
                }

                Invoke-ExpectedMocksAreCalledTest -MocksCalled $mocksCalled
            }

            Context 'SignerThumbprint and SignerSubject are passed in but FileHash is not' {
                $mocksCalled = @(
                    @{ Command = 'Assert-FileHashValid'; Times = 0 }
                    @{ Command = 'Assert-FileSignatureValid'; Times = 1 }
                )

                It 'Should not throw' {
                    { Assert-FileValid -Path $script:testPath -SignerThumbprint 'mockSignerThumbprint' `
                                                              -SignerSubject 'mockSignerSubject'
                    } | Should -Not -Throw
                }

                Invoke-ExpectedMocksAreCalledTest -MocksCalled $mocksCalled
            }

            Context 'Only path is passed in' {
                $mocksCalled = @(
                    @{ Command = 'Assert-FileHashValid'; Times = 0 }
                    @{ Command = 'Assert-FileSignatureValid'; Times = 0 }
                )

                It 'Should not throw' {
                    { Assert-FileValid -Path $script:testPath } | Should -Not -Throw
                }

                Invoke-ExpectedMocksAreCalledTest -MocksCalled $mocksCalled
            }
        }

        Describe 'Assert-FileHashValid' {
            $mockHash = @{ Hash = 'testHash' }
            Mock -CommandName 'Get-FileHash' -MockWith { return $mockHash }

            Context 'File hash is valid' {
                It 'Should not throw when hashes match' {
                    { Assert-FileHashValid -Path $script:testPath -Hash $mockHash.Hash -Algorithm 'SHA256' } | Should -Not -Throw
                }

                It 'Should fetch the file hash' {
                    Assert-MockCalled -CommandName 'Get-FileHash' -Exactly 1 -Scope 'Context'
                }
            }

            Context 'File hash is invalid' {
                $badHash = 'BadHash'
                $expectedErrorMessage = ($script:localizedData.InvalidFileHash -f $script:testPath, $badHash, 'SHA256')

                It 'Should throw when hashes do not match' {
                    { Assert-FileHashValid -Path $script:testPath -Hash $badHash -Algorithm 'SHA256' } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }
        }

        Describe 'Assert-FileSignatureValid' {
            $mockThumbprint = 'mockThumbprint'
            $mockSubject = 'mockSubject'
            $mockSignature = @{
                Status = [System.Management.Automation.SignatureStatus]::Valid
                SignerCertificate = @{ Thumbprint = $mockThumbprint; Subject = $mockSubject }
            }

            Mock -CommandName 'Get-AuthenticodeSignature' -MockWith { return $mockSignature }

            Context 'File signature status, thumbprint and subject are valid' {
                It 'Should not throw' {
                    { Assert-FileSignatureValid -Path $script:testPath -Thumbprint $mockThumbprint -Subject $mockSubject } | Should -Not -Throw
                }
            }

            Context 'File signature status and thumbprint are valid and Subject not passed in' {
                It 'Should not throw' {
                    { Assert-FileSignatureValid -Path $script:testPath -Thumbprint $mockThumbprint } | Should -Not -Throw
                }
            }

            Context 'File signature status and subject are valid and Thumbprint not passed in' {
                It 'Should not throw' {
                    { Assert-FileSignatureValid -Path $script:testPath -Subject $mockSubject } | Should -Not -Throw
                }
            }

            Context 'Only Path is passed in' {
                It 'Should not throw' {
                    { Assert-FileSignatureValid -Path $script:testPath } | Should -Not -Throw
                }
            }

            Context 'File signature status and thumbprint are valid and subject is invalid' {
                $badSubject = 'BadSubject'
                $expectedErrorMessage = ($script:localizedData.WrongSignerSubject -f $script:testPath, $badSubject)

                It 'Should throw expected error message' {
                    { Assert-FileSignatureValid -Path $script:testPath -Thumbprint $mockThumbprint -Subject $badSubject } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }

            Context 'File signature status and subject are valid and thumbprint is invalid' {
                $badThumbprint = 'BadThumbprint'
                $expectedErrorMessage = ($script:localizedData.WrongSignerThumbprint -f $script:testPath, $badThumbprint)

                It 'Should throw expected error message' {
                    { Assert-FileSignatureValid -Path $script:testPath -Thumbprint $badThumbprint -Subject $mockSubject } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }

            Context 'File signature status is invalid and subject and thumbprint are valid' {
                $mockSignature.Status = 'Invalid'
                $expectedErrorMessage = ($script:localizedData.InvalidFileSignature -f $script:testPath, $mockSignature.Status)

                It 'Should throw expected error message' {
                    { Assert-FileSignatureValid -Path $script:testPath -Thumbprint $mockThumbprint -Subject $mockSubject } | Should -Throw -ExpectedMessage $expectedErrorMessage
                }
            }
        }

        Describe 'Start-MsiProcess' {
            Mock -CommandName 'New-Object' -MockWith { return $script:mockStartInfo } -ParameterFilter { $TypeName -eq 'System.Diagnostics.ProcessStartInfo' }
            Mock -CommandName 'New-Object' -MockWith { return $script:mockProcess } -ParameterFilter { $TypeName -eq 'System.Diagnostics.Process' }
            Mock -CommandName 'Get-ProductEntry' -MockWith { return $script:mockProductEntryInfo }
            Mock -CommandName 'Invoke-PInvoke' -MockWith { return 0 }
            Mock -CommandName 'Invoke-Process' -MockWith { return 0 }

            $startMsiProcessParameters = @{
                IdentifyingNumber = $script:testIdentifyingNumber
                Path = $script:testPath
                Ensure = 'Present'
                Arguments = 'TestArguments'
                LogPath = 'TestLogPath'
                RunAsCredential = $script:testCredential
            }

            Context 'Install MSI package with RunAsCredential specified' {
                $mocksCalled = @(
                    @{ Command = 'New-Object'; Times = 1; Custom = 'process start info object' }
                    @{ Command = 'Get-ProductEntry'; Times = 0 }
                    @{ Command = 'Invoke-PInvoke'; Times = 1; Custom = 'install' }
                    @{ Command = 'Invoke-Process'; Times = 0; Custom = 'install' }
                )

                Invoke-GenericUnitTest -Function { Param($startMsiProcessParameters) Start-MsiProcess @startMsiProcessParameters } `
                                       -FunctionParameters $startMsiProcessParameters `
                                       -MocksCalled $mocksCalled `
                                       -ShouldThrow $false
            }

            $startMsiProcessParameters.Ensure = 'Absent'

            Context 'Uninstall MSI package with RunAsCredential specified' {
                $mocksCalled = @(
                    @{ Command = 'New-Object'; Times = 1; Custom = 'process start info object' }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                    @{ Command = 'Invoke-PInvoke'; Times = 1; Custom = 'uninstall' }
                    @{ Command = 'Invoke-Process'; Times = 0; Custom = 'uninstall' }
                )

                Invoke-GenericUnitTest -Function { Param($startMsiProcessParameters) Start-MsiProcess @startMsiProcessParameters } `
                                       -FunctionParameters $startMsiProcessParameters `
                                       -MocksCalled $mocksCalled `
                                       -ShouldThrow $false
            }

            $startMsiProcessParameters.Ensure = 'Present'
            $startMsiProcessParameters.Remove('RunAsCredential')

            Context 'Install MSI package without RunAsCredential' {
                $mocksCalled = @(
                    @{ Command = 'New-Object'; Times = 2; Custom = 'process start info object and process' }
                    @{ Command = 'Get-ProductEntry'; Times = 0 }
                    @{ Command = 'Invoke-PInvoke'; Times = 0; Custom = 'install' }
                    @{ Command = 'Invoke-Process'; Times = 1; Custom = 'install' }
                )

                Invoke-GenericUnitTest -Function { Param($startMsiProcessParameters) Start-MsiProcess @startMsiProcessParameters } `
                                       -FunctionParameters $startMsiProcessParameters `
                                       -MocksCalled $mocksCalled `
                                       -ShouldThrow $false
            }

            $startMsiProcessParameters.Ensure = 'Absent'

            Context 'Uninstall MSI package without RunAsCredential' {
                $mocksCalled = @(
                    @{ Command = 'New-Object'; Times = 2; Custom = 'process start info object and process object' }
                    @{ Command = 'Get-ProductEntry'; Times = 1 }
                    @{ Command = 'Invoke-PInvoke'; Times = 0; Custom = 'uninstall' }
                    @{ Command = 'Invoke-Process'; Times = 1; Custom = 'uninstall' }
                )

                Invoke-GenericUnitTest -Function { Param($startMsiProcessParameters) Start-MsiProcess @startMsiProcessParameters } `
                                       -FunctionParameters $startMsiProcessParameters `
                                       -MocksCalled $mocksCalled `
                                       -ShouldThrow $false
            }

            Mock -CommandName 'Invoke-Process' -MockWith { Throw }

            Context 'Error occurred while trying to invoke the process' {
                Invoke-GenericUnitTest -Function { Param($startMsiProcessParameters) Start-MsiProcess @startMsiProcessParameters } `
                                       -FunctionParameters $startMsiProcessParameters `
                                       -ShouldThrow $true `
                                       -ErrorMessage ($script:localizedData.CouldNotStartProcess -f $script:testPath) `
                                       -ErrorTestName $script:errorMessageTitles.CouldNotStartProcess
            }
        }
    }
}
