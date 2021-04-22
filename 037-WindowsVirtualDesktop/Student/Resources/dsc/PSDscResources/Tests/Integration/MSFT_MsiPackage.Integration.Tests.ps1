$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

if ($PSVersionTable.PSVersion -lt [Version] '5.1')
{
    Write-Warning -Message 'Cannot run PSDscResources integration tests on PowerShell versions lower than 5.1'
    return
}

$script:testsFolderFilePath = Split-Path $PSScriptRoot -Parent
$testHelperFolderFilePath = Join-Path -Path $testsFolderFilePath -ChildPath 'TestHelpers'
$commonTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'CommonTestHelper.psm1'
Import-Module -Name $script:commonTestHelperFilePath

$script:testEnvironment = Enter-DscResourceTestEnvironment `
    -DscResourceModuleName 'PSDscResources' `
    -DscResourceName 'MSFT_MsiPackage' `
    -TestType 'Unit'

try
{
    InModuleScope 'MSFT_MsiPackage' {
        Describe 'MSFT_MsiPackage Integration Tests' {
            BeforeAll {
                $testsFolderFilePath = Split-Path $PSScriptRoot -Parent
                $testHelperFolderFilePath = Join-Path -Path $testsFolderFilePath -ChildPath 'TestHelpers'
                $commonTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'CommonTestHelper.psm1'
                $packageTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'MSFT_MsiPackageResource.TestHelper.psm1'
                $commonTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'CommonTestHelper.psm1'

                Import-Module -Name $packageTestHelperFilePath -Force

                # The common test helper file needs to be imported twice because of the InModuleScope
                Import-Module -Name $commonTestHelperFilePath

                $script:skipHttpsTest = $false

                <#
                    This log file is used to log messages from the mock server which is important for debugging since
                    most of the work of the mock server is done within a separate process.
                #>
                $script:logFile = Join-Path -Path $PSScriptRoot -ChildPath 'PackageTestLogFile.txt'

                $script:msiName = 'DSCSetupProject.msi'
                $script:msiLocation = Join-Path -Path $TestDrive -ChildPath $script:msiName
                $script:msiArguments = '/NoReboot'

                $script:packageId = '{deadbeef-80c6-41e6-a1b9-8bdb8a05027f}'

                $null = New-TestMsi -DestinationPath $script:msiLocation

                $script:testHttpPort = Get-UnusedTcpPort
                $script:testHttpsPort = Get-UnusedTcpPort -ExcludePorts @($script:testHttpPort)

                # Clear the log file
                'Beginning integration tests' > $script:logFile
            }

            BeforeEach {
                if (Test-PackageInstalledById -ProductId $script:packageId)
                {
                    $null = Start-Process -FilePath 'msiexec.exe' -ArgumentList @("/x$script:packageId", '/passive') -Wait
                    $null = Start-Sleep -Seconds 1
                }

                if (Test-PackageInstalledById -ProductId $script:packageId)
                {
                    throw 'Test package could not be uninstalled after running all tests. It may cause errors in subsequent test runs.'
                }
            }

            AfterAll {
                if (Test-PackageInstalledById -ProductId $script:packageId)
                {
                    $null = Start-Process -FilePath 'msiexec.exe' -ArgumentList @("/x$script:packageId", '/passive') -Wait
                    $null = Start-Sleep -Seconds 1
                }

                if (Test-PackageInstalledById -ProductId $script:packageId)
                {
                    throw 'Test package could not be uninstalled after running test'
                }
            }

            Context 'Get-TargetResource' {
                It 'Should return only basic properties for absent package' {
                    $packageParameters = @{
                        Path = $script:msiLocation
                        ProductId = $script:packageId
                    }

                    $getTargetResourceResult = Get-TargetResource @packageParameters
                    $getTargetResourceResultProperties = @( 'Ensure', 'ProductId' )

                    Test-GetTargetResourceResult -GetTargetResourceResult $getTargetResourceResult -GetTargetResourceResultProperties $getTargetResourceResultProperties
                }

                It 'Should return full package properties for present package without registry check parameters specified' {
                    $packageParameters = @{
                        Path = $script:msiLocation
                        ProductId = $script:packageId
                    }

                    Set-TargetResource -Ensure 'Present' @packageParameters

                    $getTargetResourceResult = Get-TargetResource @packageParameters
                    $getTargetResourceResultProperties = @( 'Ensure', 'Name', 'InstallSource', 'InstalledOn', 'ProductId', 'Size', 'Version', 'PackageDescription', 'Publisher' )

                    Test-GetTargetResourceResult -GetTargetResourceResult $getTargetResourceResult -GetTargetResourceResultProperties $getTargetResourceResultProperties
                }
            }

            Context 'Test-TargetResource' {
                It 'Should return correct value when package is absent' {
                    $testTargetResourceResult = Test-TargetResource `
                        -Ensure 'Present' `
                        -Path $script:msiLocation `
                        -ProductId $script:packageId

                    $testTargetResourceResult | Should -BeFalse

                    $testTargetResourceResult = Test-TargetResource `
                        -Ensure 'Absent' `
                        -Path $script:msiLocation `
                        -ProductId $script:packageId

                    $testTargetResourceResult | Should -BeTrue
                }

                It 'Should return correct value when package is present' {
                    Set-TargetResource -Ensure 'Present' -Path $script:msiLocation -ProductId $script:packageId

                    Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue

                    $testTargetResourceResult = Test-TargetResource `
                            -Ensure 'Present' `
                            -Path $script:msiLocation `
                            -ProductId $script:packageId `

                    $testTargetResourceResult | Should -BeTrue

                    $testTargetResourceResult = Test-TargetResource `
                        -Ensure 'Absent' `
                        -Path $script:msiLocation `
                        -ProductId $script:packageId `

                    $testTargetResourceResult | Should -BeFalse
                }
            }

            Context 'Set-TargetResource' {
                It 'Should correctly install and remove a .msi package' {
                    Set-TargetResource -Ensure 'Present' -Path $script:msiLocation -ProductId $script:packageId

                    Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue

                    $getTargetResourceResult = Get-TargetResource -Path $script:msiLocation -ProductId $script:packageId

                    $getTargetResourceResult.Version | Should -Be '1.2.3.4'
                    $getTargetResourceResult.InstalledOn | Should -Be ('{0:d}' -f [System.DateTime]::Now.Date)
                    $getTargetResourceResult.ProductId | Should -Be $script:packageId

                    [Math]::Round($getTargetResourceResult.Size, 2) | Should -Be 0.03

                    Set-TargetResource -Ensure 'Absent' -Path $script:msiLocation -ProductId $script:packageId

                    Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
                }

                It 'Should throw with incorrect product id' {
                    $wrongPackageId = '{deadbeef-80c6-41e6-a1b9-8bdb8a050272}'

                    { Set-TargetResource -Ensure 'Present' -Path $script:msiLocation -ProductId $wrongPackageId } | Should -Throw
                }

                It 'Should correctly install and remove a package from a HTTP URL' {
                    $uriBuilder = [System.UriBuilder]::new('http', 'localhost', $script:testHttpPort)
                    $baseUrl = $uriBuilder.Uri.AbsoluteUri

                    $uriBuilder.Path = 'package.msi'
                    $msiUrl = $uriBuilder.Uri.AbsoluteUri

                    $fileServerStarted = $null
                    $job = $null

                    try
                    {
                        'Http tests:' >> $script:logFile

                        # Make sure no existing HTTP(S) test servers are running
                        Stop-EveryTestServerInstance

                        $serverResult = Start-Server -FilePath $script:msiLocation -LogPath $script:logFile -Https $false -HttpPort $script:testHttpPort -HttpsPort $script:testHttpsPort
                        $fileServerStarted = $serverResult.FileServerStarted
                        $job = $serverResult.Job

                        # Wait for the file server to be ready to receive requests
                        $fileServerStarted.WaitOne(30000)

                        { Set-TargetResource -Ensure 'Present' -Path $baseUrl -ProductId $script:packageId } | Should -Throw

                        Set-TargetResource -Ensure 'Present' -Path $msiUrl -ProductId $script:packageId
                        Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue

                        Set-TargetResource -Ensure 'Absent' -Path $msiUrl -ProductId $script:packageId
                        Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
                    }
                    catch
                    {
                        Write-Warning -Message 'Caught exception performing HTTP server tests. Outputting HTTP server log.' -Verbose
                        Get-Content -Path $script:logFile | Write-Verbose -Verbose
                        throw $_
                    }
                    finally
                    {
                        <#
                            This must be called after Start-Server to ensure the listening port is closed,
                            otherwise subsequent tests may fail until the machine is rebooted.
                        #>
                        Stop-Server -FileServerStarted $fileServerStarted -Job $job
                    }
                }

                It 'Should correctly install and remove a package from a HTTPS URL' -Skip:$script:skipHttpsTest {
                    $uriBuilder = [System.UriBuilder]::new('https', 'localhost', $script:testHttpsPort)
                    $baseUrl = $uriBuilder.Uri.AbsoluteUri

                    $uriBuilder.Path = 'package.msi'
                    $msiUrl = $uriBuilder.Uri.AbsoluteUri

                    $fileServerStarted = $null
                    $job = $null

                    try
                    {
                        'Https tests:' >> $script:logFile

                        # Make sure no existing HTTP(S) test servers are running
                        Stop-EveryTestServerInstance

                        $serverResult = Start-Server -FilePath $script:msiLocation -LogPath $script:logFile -Https $true -HttpPort $script:testHttpPort -HttpsPort $script:testHttpsPort
                        $fileServerStarted = $serverResult.FileServerStarted
                        $job = $serverResult.Job

                        # Wait for the file server to be ready to receive requests
                        $fileServerStarted.WaitOne(30000)

                        { Set-TargetResource -Ensure 'Present' -Path $baseUrl -ProductId $script:packageId } | Should -Throw

                        Set-TargetResource -Ensure 'Present' -Path $msiUrl -ProductId $script:packageId
                        Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue

                        Set-TargetResource -Ensure 'Absent' -Path $msiUrl -ProductId $script:packageId
                        Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
                    }
                    catch
                    {
                        Write-Warning -Message 'Caught exception performing HTTPS server tests. Outputting HTTPS server log.' -Verbose
                        Get-Content -Path $script:logFile | Write-Verbose -Verbose
                        throw $_
                    }
                    finally
                    {
                        <#
                            This must be called after Start-Server to ensure the listening port is closed,
                            otherwise subsequent tests may fail until the machine is rebooted.
                        #>
                        Stop-Server -FileServerStarted $fileServerStarted -Job $job
                    }
                }

                It 'Should write to the specified log path' {
                    $logPath = Join-Path -Path $TestDrive -ChildPath 'TestMsiLog.txt'

                    if (Test-Path -Path $logPath)
                    {
                        Remove-Item -Path $logPath -Force
                    }

                    Set-TargetResource -Ensure 'Present' -Path $script:msiLocation -LogPath $logPath -ProductId $script:packageId

                    Test-Path -Path $logPath | Should -BeTrue
                    Get-Content -Path $logPath | Should -Not -Be $null
                }

                It 'Should add space after .MSI installation arguments' {
                    Mock Invoke-Process -ParameterFilter { $Process.StartInfo.Arguments.EndsWith($script:msiArguments) } { return @{ ExitCode = 0 } }
                    Mock Get-ProductEntry { return $script:packageId }

                    $packageParameters = @{
                        Path = $script:msiLocation
                        ProductId = $script:packageId
                        Arguments = $script:msiArguments
                    }

                    Set-TargetResource -Ensure 'Present' @packageParameters

                    Assert-MockCalled Invoke-Process -ParameterFilter { $Process.StartInfo.Arguments.EndsWith(" $script:msiArguments") } -Scope It
                }

                It 'Should not check for product installation when rebooted is required' {
                    Mock Invoke-Process { return 3010 }
                    Mock Get-ProductEntry { }

                    $packageParameters = @{
                        Path = $script:msiLocation
                        ProductId = $script:packageId
                    }

                    { Set-TargetResource -Ensure 'Present' @packageParameters } | Should -Not -Throw
                }

                It 'Should install package using user credentials when specified' {
                    Mock Invoke-PInvoke { }
                    Mock Get-ProductEntry { return $script:packageId }

                    $packageCredential = [System.Management.Automation.PSCredential]::Empty
                    $packageParameters = @{
                        Path = $script:msiLocation
                        ProductId = $script:packageId
                        RunAsCredential = $packageCredential
                    }

                    Set-TargetResource -Ensure 'Present' @packageParameters

                    Assert-MockCalled Invoke-PInvoke -ParameterFilter { $RunAsCredential -eq $packageCredential} -Scope It
                }
            }
        }
    }
}
finally
{
    Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
}
