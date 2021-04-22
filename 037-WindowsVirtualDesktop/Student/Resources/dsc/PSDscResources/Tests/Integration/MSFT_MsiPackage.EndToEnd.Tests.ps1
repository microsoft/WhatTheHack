<#
    Please note that some of these tests depend on each other.
    They must be run in the order given - if one test fails, subsequent tests may
    also fail.
#>

$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

if ($PSVersionTable.PSVersion -lt [Version] '5.1')
{
    Write-Warning -Message 'Cannot run PSDscResources integration tests on PowerShell versions lower than 5.1'
    return
}

Describe 'MsiPackage End to End Tests' {
    BeforeAll {
        # Import CommonTestHelper
        $testsFolderFilePath = Split-Path $PSScriptRoot -Parent
        $testHelperFolderFilePath = Join-Path -Path $testsFolderFilePath -ChildPath 'TestHelpers'
        $commonTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'CommonTestHelper.psm1'
        Import-Module -Name $commonTestHelperFilePath

        $script:testEnvironment = Enter-DscResourceTestEnvironment `
            -DscResourceModuleName 'PSDscResources' `
            -DscResourceName 'MSFT_MsiPackage' `
            -TestType 'Integration'

        # Import MsiPackage resource module for Test-TargetResource
        $moduleRootFilePath = Split-Path -Path $testsFolderFilePath -Parent
        $dscResourcesFolderFilePath = Join-Path -Path $moduleRootFilePath -ChildPath 'DscResources'
        $msiPackageResourceFolderFilePath = Join-Path -Path $dscResourcesFolderFilePath -ChildPath 'MSFT_MsiPackage'
        $msiPackageResourceModuleFilePath = Join-Path -Path $msiPackageResourceFolderFilePath -ChildPath 'MSFT_MsiPackage.psm1'
        Import-Module -Name $msiPackageResourceModuleFilePath -Force

        # Import the MsiPackage test helper
        $packageTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'MSFT_MsiPackageResource.TestHelper.psm1'
        Import-Module -Name $packageTestHelperFilePath -Force

        # Set up the paths to the test configurations
        $script:configurationFilePathNoOptionalParameters = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_MsiPackage_NoOptionalParameters'
        $script:configurationFilePathLogPath = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_MsiPackage_LogPath'

        <#
            This log file is used to log messages from the mock server which is important for debugging since
            most of the work of the mock server is done within a separate process.
        #>
        $script:logFile = Join-Path -Path $PSScriptRoot -ChildPath 'PackageTestLogFile.txt'
        $script:environmentInIncorrectStateErrorMessage = 'The current environment is not in the expected state for this test - either something was setup incorrectly on your machine or a previous test failed - results after this may be invalid.'

        $script:msiName = 'DSCSetupProject.msi'
        $script:msiLocation = Join-Path -Path $TestDrive -ChildPath $script:msiName

        $script:packageId = '{deadbeef-80c6-41e6-a1b9-8bdb8a05027f}'

        $null = New-TestMsi -DestinationPath $script:msiLocation

        $script:testHttpPort = Get-UnusedTcpPort
        $script:testHttpsPort = Get-UnusedTcpPort -ExcludePorts @($script:testHttpPort)

        # Clear the log file
        'Beginning integration tests' > $script:logFile
    }

    AfterAll {
        # Remove the test MSI if it is still installed
        if (Test-PackageInstalledById -ProductId $script:packageId)
        {
            $null = Start-Process -FilePath 'msiexec.exe' -ArgumentList @("/x$script:packageId", '/passive') -Wait
            $null = Start-Sleep -Seconds 1
        }

        if (Test-PackageInstalledById -ProductId $script:packageId)
        {
            throw 'Test package could not be uninstalled after running all tests. It may cause errors in subsequent test runs.'
        }

        Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
    }

    Context 'Uninstall package that is already Absent' {
        $configurationName = 'RemoveAbsentMsiPackage'

        $msiPackageParameters = @{
            ProductId = $script:packageId
            Path = $script:msiLocation
            Ensure = 'Absent'
        }

        It 'Should return True from Test-TargetResource with the same parameters before configuration' {
            $testTargetResourceInitialResult = MSFT_MsiPackage\Test-TargetResource @msiPackageParameters
            $testTargetResourceInitialResult | Should -BeTrue

            if ($testTargetResourceInitialResult -ne $true)
            {
                <#
                    Not throwing an error here since the tests should still run correctly after this,
                    we just want to notify the user that the tests aren't necessarily testing what
                    they should be
                #>
                Write-Error -Message $script:environmentInIncorrectStateErrorMessage
            }
        }

        It 'Package should not exist on the machine before configuration is run' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
        }

        It 'Should compile and run configuration' {
            {
                . $script:configurationFilePathNoOptionalParameters -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @msiPackageParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Not -Throw
        }

        It 'Should return True from Test-TargetResource with the same parameters after configuration' {
            MSFT_MsiPackage\Test-TargetResource @msiPackageParameters | Should -BeTrue
        }

        It 'Package should not exist on the machine' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
        }
    }

    Context 'Install package that is not installed yet' {
        $configurationName = 'InstallMsiPackage'

        $msiPackageParameters = @{
            ProductId = $script:packageId
            Path = $script:msiLocation
            Ensure = 'Present'
        }

        It 'Should return False from Test-TargetResource with the same parameters before configuration' {
            $testTargetResourceInitialResult = MSFT_MsiPackage\Test-TargetResource @msiPackageParameters
            $testTargetResourceInitialResult | Should -BeFalse

            if ($testTargetResourceInitialResult -ne $false)
            {
                <#
                    Not throwing an error here since the tests should still run correctly after this,
                    we just want to notify the user that the tests aren't necessarily testing what
                    they should be
                #>
                Write-Error -Message $script:environmentInIncorrectStateErrorMessage
            }
        }

        It 'Package should not exist on the machine before configuration is run' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
        }

        It 'Should compile and run configuration' {
            {
                . $script:configurationFilePathNoOptionalParameters -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @msiPackageParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Not -Throw
        }

        It 'Should return True from Test-TargetResource with the same parameters after configuration' {
            MSFT_MsiPackage\Test-TargetResource @msiPackageParameters | Should -BeTrue
        }

        It 'Package should exist on the machine' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue
        }
    }

    Context 'Install package that is already installed' {
        $configurationName = 'InstallExistingMsiPackage'

        $msiPackageParameters = @{
            ProductId = $script:packageId
            Path = $script:msiLocation
            Ensure = 'Present'
        }

        It 'Should return True from Test-TargetResource with the same parameters before configuration' {
            $testTargetResourceInitialResult = MSFT_MsiPackage\Test-TargetResource @msiPackageParameters
            $testTargetResourceInitialResult | Should -BeTrue

            if ($testTargetResourceInitialResult -ne $true)
            {
                <#
                    Not throwing an error here since the tests should still run correctly after this,
                    we just want to notify the user that the tests aren't necessarily testing what
                    they should be
                #>
                Write-Error -Message $script:environmentInIncorrectStateErrorMessage
            }
        }

        It 'Package should exist on the machine before configuration is run' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue
        }

        It 'Should compile and run configuration' {
            {
                . $script:configurationFilePathNoOptionalParameters -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @msiPackageParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Not -Throw
        }

        It 'Should return True from Test-TargetResource with the same parameters after configuration' {
            MSFT_MsiPackage\Test-TargetResource @msiPackageParameters | Should -BeTrue
        }

        It 'Package should exist on the machine' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue
        }
    }

    Context 'Uninstall package that is installed' {
        $configurationName = 'UninstallExistingMsiPackage'

        $msiPackageParameters = @{
            ProductId = $script:packageId
            Path = $script:msiLocation
            Ensure = 'Absent'
        }

        It 'Should return False from Test-TargetResource with the same parameters before configuration' {
            $testTargetResourceInitialResult = MSFT_MsiPackage\Test-TargetResource @msiPackageParameters
            $testTargetResourceInitialResult | Should -BeFalse

            if ($testTargetResourceInitialResult -ne $false)
            {
                <#
                    Not throwing an error here since the tests should still run correctly after this,
                    we just want to notify the user that the tests aren't necessarily testing what
                    they should be
                #>
                Write-Error -Message $script:environmentInIncorrectStateErrorMessage
            }
        }

        It 'Package should exist on the machine before configuration is run' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue
        }

        It 'Should compile and run configuration' {
            {
                . $script:configurationFilePathNoOptionalParameters -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @msiPackageParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Not -Throw
        }

        It 'Should return True from Test-TargetResource with the same parameters after configuration' {
            MSFT_MsiPackage\Test-TargetResource @msiPackageParameters | Should -BeTrue
        }

        It 'Package should not exist on the machine' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
        }
    }

    Context 'Install package that is not installed and write to specified log file' {
        $configurationName = 'InstallWithLogFile'

        $logPath = Join-Path -Path $TestDrive -ChildPath 'TestMsiLog.txt'

        if (Test-Path -Path $logPath)
        {
            Remove-Item -Path $logPath -Force
        }

        $msiPackageParameters = @{
            ProductId = $script:packageId
            Path = $script:msiLocation
            Ensure = 'Present'
            LogPath = $logPath
        }

        It 'Should return False from Test-TargetResource with the same parameters before configuration' {
            $testTargetResourceInitialResult = MSFT_MsiPackage\Test-TargetResource @msiPackageParameters
            $testTargetResourceInitialResult | Should -BeFalse

            if ($testTargetResourceInitialResult -ne $false)
            {
                <#
                    Not throwing an error here since the tests should still run correctly after this,
                    we just want to notify the user that the tests aren't necessarily testing what
                    they should be
                #>
                Write-Error -Message $script:environmentInIncorrectStateErrorMessage
            }
        }

        It 'Package should not exist on the machine before configuration is run' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
        }

        It 'Should compile and run configuration' {
            {
                . $script:configurationFilePathLogPath -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @msiPackageParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Not -Throw
        }

        It 'Should return True from Test-TargetResource with the same parameters after configuration' {
            MSFT_MsiPackage\Test-TargetResource @msiPackageParameters | Should -BeTrue
        }

        It 'Should have created the log file' {
            Test-Path -Path $logPath | Should -BeTrue
        }

        It 'Package should exist on the machine' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue
        }
    }

    Context 'Uninstall package that is installed and write to specified log file' {
        $configurationName = 'InstallWithLogFile'

        $logPath = Join-Path -Path $TestDrive -ChildPath 'TestMsiLog.txt'

        if (Test-Path -Path $logPath)
        {
            Remove-Item -Path $logPath -Force
        }

        $msiPackageParameters = @{
            ProductId = $script:packageId
            Path = $script:msiLocation
            Ensure = 'Absent'
            LogPath = $logPath
        }

        It 'Should return False from Test-TargetResource with the same parameters before configuration' {
            $testTargetResourceInitialResult = MSFT_MsiPackage\Test-TargetResource @msiPackageParameters
            $testTargetResourceInitialResult | Should -BeFalse

            if ($testTargetResourceInitialResult -ne $false)
            {
                <#
                    Not throwing an error here since the tests should still run correctly after this,
                    we just want to notify the user that the tests aren't necessarily testing what
                    they should be
                #>
                Write-Error -Message $script:environmentInIncorrectStateErrorMessage
            }
        }

        It 'Package should exist on the machine before configuration is run' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue
        }

        It 'Should compile and run configuration' {
            {
                . $script:configurationFilePathLogPath -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @msiPackageParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Not -Throw
        }

        It 'Should return True from Test-TargetResource with the same parameters after configuration' {
            MSFT_MsiPackage\Test-TargetResource @msiPackageParameters | Should -BeTrue
        }

        It 'Should have created the log file' {
            Test-Path -Path $logPath | Should -BeTrue
        }

        It 'Package should not exist on the machine' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
        }
    }

    Context 'Install package from HTTP Url' {
        $configurationName = 'UninstallExistingMsiPackageFromHttp'

        $uriBuilder = [System.UriBuilder]::new('http', 'localhost', $script:testHttpPort)
        $uriBuilder.Path = 'package.msi'
        $msiUrl = $uriBuilder.Uri.AbsoluteUri

        $fileServerStarted = $null
        $job = $null

        $msiPackageParameters = @{
            ProductId = $script:packageId
            Path = $msiUrl
            Ensure = 'Present'
        }

        It 'Should return False from Test-TargetResource with the same parameters before configuration' {
            $testTargetResourceInitialResult = MSFT_MsiPackage\Test-TargetResource @msiPackageParameters
            $testTargetResourceInitialResult | Should -BeFalse

            if ($testTargetResourceInitialResult -ne $false)
            {
                <#
                    Not throwing an error here since the tests should still run correctly after this,
                    we just want to notify the user that the tests aren't necessarily testing what
                    they should be
                #>
                Write-Error -Message $script:environmentInIncorrectStateErrorMessage
            }
        }

        It 'Package should not exist on the machine before configuration is run' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
        }

        try
        {
            # Make sure no existing HTTP(S) test servers are running
            Stop-EveryTestServerInstance

            $serverResult = Start-Server -FilePath $script:msiLocation -LogPath $script:logFile -Https $false -HttpPort $script:testHttpPort -HttpsPort $script:testHttpsPort
            $fileServerStarted = $serverResult.FileServerStarted
            $job = $serverResult.Job

            $fileServerStarted.WaitOne(30000)

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePathNoOptionalParameters -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @msiPackageParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }
        }
        finally
        {
            <#
                This must be called after Start-Server to ensure the listening port is closed,
                otherwise subsequent tests may fail until the machine is rebooted.
            #>
            Stop-Server -FileServerStarted $fileServerStarted -Job $job
        }

        It 'Should return True from Test-TargetResource with the same parameters after configuration' {
            MSFT_MsiPackage\Test-TargetResource @msiPackageParameters | Should -BeTrue
        }

        It 'Package should exist on the machine' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue
        }
    }

    Context 'Uninstall Msi package from HTTP Url' {
        $configurationName = 'InstallMsiPackageFromHttp'

        $uriBuilder = [System.UriBuilder]::new('http', 'localhost', $script:testHttpPort)
        $uriBuilder.Path = 'package.msi'
        $msiUrl = $uriBuilder.Uri.AbsoluteUri

        $fileServerStarted = $null
        $job = $null

        $msiPackageParameters = @{
            ProductId = $script:packageId
            Path = $msiUrl
            Ensure = 'Absent'
        }

        It 'Should return False from Test-TargetResource with the same parameters before configuration' {
            $testTargetResourceInitialResult = MSFT_MsiPackage\Test-TargetResource @msiPackageParameters
            $testTargetResourceInitialResult | Should -BeFalse

            if ($testTargetResourceInitialResult -ne $false)
            {
                <#
                    Not throwing an error here since the tests should still run correctly after this,
                    we just want to notify the user that the tests aren't necessarily testing what
                    they should be
                #>
                Write-Error -Message $script:environmentInIncorrectStateErrorMessage
            }
        }

        It 'Package should exist on the machine before configuration is run' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue
        }

        try
        {
            # Make sure no existing HTTP(S) test servers are running
            Stop-EveryTestServerInstance

            $serverResult = Start-Server -FilePath $script:msiLocation -LogPath $script:logFile -Https $false -HttpPort $script:testHttpPort -HttpsPort $script:testHttpsPort
            $fileServerStarted = $serverResult.FileServerStarted
            $job = $serverResult.Job

            $fileServerStarted.WaitOne(30000)

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePathNoOptionalParameters -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @msiPackageParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }
        }
        finally
        {
            <#
                This must be called after Start-Server to ensure the listening port is closed,
                otherwise subsequent tests may fail until the machine is rebooted.
            #>
            Stop-Server -FileServerStarted $fileServerStarted -Job $job
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_MsiPackage\Test-TargetResource @msiPackageParameters | Should -BeTrue
        }

        It 'Package should not exist on the machine' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
        }
    }

    Context 'Install Msi package from HTTPS Url' {
        $configurationName = 'InstallMsiPackageFromHttpS'

        $uriBuilder = [System.UriBuilder]::new('https', 'localhost', $script:testHttpsPort)
        $uriBuilder.Path = 'package.msi'
        $msiUrl = $uriBuilder.Uri.AbsoluteUri

        $fileServerStarted = $null
        $job = $null

        $msiPackageParameters = @{
            ProductId = $script:packageId
            Path = $msiUrl
            Ensure = 'Present'
        }

        It 'Should return False from Test-TargetResource with the same parameters before configuration' {
            $testTargetResourceInitialResult = MSFT_MsiPackage\Test-TargetResource @msiPackageParameters
            $testTargetResourceInitialResult | Should -BeFalse

            if ($testTargetResourceInitialResult -ne $false)
            {
                <#
                    Not throwing an error here since the tests should still run correctly after this,
                    we just want to notify the user that the tests aren't necessarily testing what
                    they should be
                #>
                Write-Error -Message $script:environmentInIncorrectStateErrorMessage
            }
        }

        It 'Package should not exist on the machine before configuration is run' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
        }

        try
        {
            # Make sure no existing HTTP(S) test servers are running
            Stop-EveryTestServerInstance

            $serverResult = Start-Server -FilePath $script:msiLocation -LogPath $script:logFile -Https $true -HttpPort $script:testHttpPort -HttpsPort $script:testHttpsPort
            $fileServerStarted = $serverResult.FileServerStarted
            $job = $serverResult.Job

            $fileServerStarted.WaitOne(30000)

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePathNoOptionalParameters -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @msiPackageParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }
        }
        finally
        {
            <#
                This must be called after Start-Server to ensure the listening port is closed,
                otherwise subsequent tests may fail until the machine is rebooted.
            #>
            Stop-Server -FileServerStarted $fileServerStarted -Job $job
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_MsiPackage\Test-TargetResource @msiPackageParameters | Should -BeTrue
        }

        It 'Package should exist on the machine' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue
        }
    }

    Context 'Uninstall Msi package from HTTPS Url' {
        $configurationName = 'UninstallMsiPackageFromHttps'

        $uriBuilder = [System.UriBuilder]::new('https', 'localhost', $script:testHttpsPort)
        $uriBuilder.Path = 'package.msi'
        $msiUrl = $uriBuilder.Uri.AbsoluteUri

        $fileServerStarted = $null
        $job = $null

        $msiPackageParameters = @{
            ProductId = $script:packageId
            Path = $msiUrl
            Ensure = 'Absent'
        }

        It 'Should return False from Test-TargetResource with the same parameters before configuration' {
            $testTargetResourceInitialResult = MSFT_MsiPackage\Test-TargetResource @msiPackageParameters
            $testTargetResourceInitialResult | Should -BeFalse

            if ($testTargetResourceInitialResult -ne $false)
            {
                <#
                    Not throwing an error here since the tests should still run correctly after this,
                    we just want to notify the user that the tests aren't necessarily testing what
                    they should be
                #>
                Write-Error -Message $script:environmentInIncorrectStateErrorMessage
            }
        }

        It 'Package should exist on the machine before configuration is run' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeTrue
        }

        try
        {
            # Make sure no existing HTTP(S) test servers are running
            Stop-EveryTestServerInstance

            $serverResult = Start-Server -FilePath $script:msiLocation -LogPath $script:logFile -Https $true -HttpPort $script:testHttpPort -HttpsPort $script:testHttpsPort
            $fileServerStarted = $serverResult.FileServerStarted
            $job = $serverResult.Job

            $fileServerStarted.WaitOne(30000)

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePathNoOptionalParameters -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @msiPackageParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }
        }
        finally
        {
            <#
                This must be called after Start-Server to ensure the listening port is closed,
                otherwise subsequent tests may fail until the machine is rebooted.
            #>
            Stop-Server -FileServerStarted $fileServerStarted -Job $job
        }

        It 'Should return true from Test-TargetResource with the same parameters after configuration' {
            MSFT_MsiPackage\Test-TargetResource @msiPackageParameters | Should -BeTrue
        }

        It 'Package should not exist on the machine' {
            Test-PackageInstalledById -ProductId $script:packageId | Should -BeFalse
        }
    }
}
