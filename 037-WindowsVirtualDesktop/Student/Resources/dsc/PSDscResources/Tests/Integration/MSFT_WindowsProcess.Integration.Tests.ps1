$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

if ($PSVersionTable.PSVersion -lt [Version] '5.1')
{
    Write-Warning -Message 'Cannot run PSDscResources integration tests on PowerShell versions lower than 5.1'
    return
}

Describe 'WindowsProcess Integration Tests' {
    BeforeAll {
        $script:testFolderPath = Split-Path -Path $PSScriptRoot -Parent
        $script:testHelpersPath = Join-Path -Path $script:testFolderPath -ChildPath 'TestHelpers'
        Import-Module -Name (Join-Path -Path $script:testHelpersPath -ChildPath 'CommonTestHelper.psm1')

        $script:testEnvironment = Enter-DscResourceTestEnvironment `
            -DscResourceModuleName 'PSDscResources' `
            -DscResourceName 'MSFT_WindowsProcess' `
            -TestType 'Integration'

        $script:testProcessPath = Join-Path -Path $script:testHelpersPath -ChildPath 'WindowsProcessTestProcess.exe'
        $script:testProcessName = 'WindowsProcessTestProcess'

        $script:logFilePath = Join-Path -Path $TestDrive -ChildPath 'ProcessTestLog.txt'

        $script:configurationFilePathNoCredential = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_WindowsProcess_NoCredential.config.ps1'
        $script:configurationFilePathWithCredential = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_WindowsProcess_WithCredential.config.ps1'

        $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'
    }

    AfterAll {
        $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'
        $null = Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
    }

    Describe 'No credential provided' {
        Context 'Stop a process that is already stopped or does not exist' {
            $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            $configurationName = 'StopStoppedProcess'

            $processParameters = @{
                Path = $testProcessPath
                Ensure = 'Absent'
                Arguments = $logFilePath
            }

            It 'Should not be able to retrieve the process before configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Throw
            }

            It 'Should not be able to find the log file before configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeFalse
            }

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePathNoCredential -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @processParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should Not Throw
            }

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            It 'Should not be able to retrieve the process after configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
            }

            It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                $currentConfig = Get-DscConfiguration
                $currentConfig.Path | Should Be $processParameters.Path
                $currentConfig.Arguments | Should Be $processParameters.Arguments
                $currentConfig.Ensure | Should Be $processParameters.Ensure
            }

            It 'Should not be able to find the log file after configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeFalse
            }
        }

        Context 'Start a new running process' {
            $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            $configurationName = 'StartNewProcess'

            $processParameters = @{
                Path = $testProcessPath
                Ensure = 'Present'
                Arguments = $logFilePath
            }

            It 'Should not be able to retrieve the process before configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Throw
            }

            It 'Should not be able to find the log file before configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeFalse
            }

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePathNoCredential -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @processParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should Not Throw
            }

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            It 'Should be able to retrieve the process after configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
            }

            It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                $currentConfig = Get-DscConfiguration
                $currentConfig.Path | Should Be $processParameters.Path
                $currentConfig.Arguments | Should Be $processParameters.Arguments
                $currentConfig.Ensure | Should Be $processParameters.Ensure
                $currentConfig.ProcessCount | Should Be 1
            }

            It 'Should be able to find the log file after configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeTrue
            }
        }

        Context 'Start a process that is already running' {
            $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            $configurationName = 'StartRunningProcess'

            $processParameters = @{
                Path = $testProcessPath
                Ensure = 'Present'
                Arguments = $logFilePath
            }

            $null = Start-Process -FilePath $processParameters.Path -ArgumentList $processParameters.Arguments -ErrorAction 'SilentlyContinue'

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            It 'Should be able to retrieve the process before configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
            }

            It 'Should be able to find the log file before configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeTrue
            }

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePathNoCredential -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @processParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should Not Throw
            }

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            It 'Should be able to retrieve the process after configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
            }

            It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                $currentConfig = Get-DscConfiguration
                $currentConfig.Path | Should Be $processParameters.Path
                $currentConfig.Arguments | Should Be $processParameters.Arguments
                $currentConfig.Ensure | Should Be $processParameters.Ensure
                $currentConfig.ProcessCount | Should Be 1
            }

            It 'Should be able to find the log file after configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeTrue
            }
        }

        Context 'Stop a running process' {
            $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            $configurationName = 'StopRunningProcess'

            $processParameters = @{
                Path = $testProcessPath
                Ensure = 'Absent'
                Arguments = $logFilePath
            }

            $null = Start-Process -FilePath $processParameters.Path -ArgumentList $processParameters.Arguments -ErrorAction 'SilentlyContinue'

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            It 'Should be able to retrieve the process before configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
            }

            It 'Should be able to find the log file before configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeTrue
            }

            # Remove the created log file so that we can check that the configuration did not re-create it
            $null = Remove-Item -Path $script:logFilePath -Force -ErrorAction 'SilentlyContinue'

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePathNoCredential -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @processParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should Not Throw
            }

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            It 'Should not be able to retrieve the process after configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
            }

            It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                $currentConfig = Get-DscConfiguration
                $currentConfig.Path | Should Be $processParameters.Path
                $currentConfig.Arguments | Should Be $processParameters.Arguments
                $currentConfig.Ensure | Should Be $processParameters.Ensure
            }

            It 'Should not be able to find the log file after configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeFalse
            }
        }

        Context 'Get correct number of processes from Get-DscConfiguration when two of the same process are running' {
            $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            $configurationName = 'GetMultipleProcesses'

            $processParameters = @{
                Path = $testProcessPath
                Ensure = 'Present'
                Arguments = $logFilePath
            }

            It 'Should not be able to retrieve the process before configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Throw
            }

            It 'Should not be able to find the log file before configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeFalse
            }

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePathNoCredential -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @processParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should Not Throw
            }

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            $null = Start-Process -FilePath $processParameters.Path -ArgumentList $processParameters.Arguments -ErrorAction 'SilentlyContinue'

            # Wait a moment for the second process to stop/start
            $null = Start-Sleep -Seconds 1

            It 'Should be able to retrieve the processes after configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
            }

            It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                $currentConfig = Get-DscConfiguration
                $currentConfig.Path | Should Be $processParameters.Path
                $currentConfig.Arguments | Should Be $processParameters.Arguments
                $currentConfig.Ensure | Should Be $processParameters.Ensure
                $currentConfig.ProcessCount | Should Be 2
            }

            It 'Should be able to find the log file after configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeTrue
            }
        }

        Context 'Stop multiple running processes' {
            $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            $configurationName = 'StopMultipleRunningProcesses'

            $processParameters = @{
                Path = $testProcessPath
                Ensure = 'Absent'
                Arguments = $logFilePath
            }

            $null = Start-Process -FilePath $processParameters.Path -ArgumentList $processParameters.Arguments -ErrorAction 'SilentlyContinue'

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            $null = Start-Process -FilePath $processParameters.Path -ArgumentList $processParameters.Arguments -ErrorAction 'SilentlyContinue'

            # Wait a moment for the second process to stop/start
            $null = Start-Sleep -Seconds 1

            It 'Should be able to retrieve the process before configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
            }

            It 'Should be able to find the log file before configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeTrue
            }

            # Remove the created log file so that we can check that the configuration did not re-create it
            $null = Remove-Item -Path $script:logFilePath -Force -ErrorAction 'SilentlyContinue'

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePathNoCredential -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @processParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should Not Throw
            }

            # Wait a moment for the process to stop/start
            $null = Start-Sleep -Seconds 1

            It 'Should not be able to retrieve the processes after configuration' {
                { $null = Get-Process -Name $script:testProcessName } | Should Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
            }

            It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                $currentConfig = Get-DscConfiguration
                $currentConfig.Path | Should Be $processParameters.Path
                $currentConfig.Arguments | Should Be $processParameters.Arguments
                $currentConfig.Ensure | Should Be $processParameters.Ensure
            }

            It 'Should not be able to find the log file after configuration' {
                $pathResult = Test-Path -Path $logFilePath
                $pathResult | Should -BeFalse
            }
        }
    }

    if ($env:AppVeyor) {
        Describe 'Credential provided - Only runs in AppVeyor' {
             $script:testCredential = Get-AppVeyorAdministratorCredential

            $script:credentialConfigurationData = @{
                AllNodes = @(
                    @{
                        NodeName = '*'
                        PSDscAllowPlainTextPassword = $true
                    }
                    @{
                        NodeName = 'localhost'
                    }
                )
            }

            Context 'Stop a process that is already stopped or does not exist' {
                $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                $configurationName = 'StopStoppedProcess'

                $processParameters = @{
                    Path = $testProcessPath
                    Ensure = 'Absent'
                    Arguments = $logFilePath
                    Credential = $script:testCredential
                }

                It 'Should not be able to retrieve the process before configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Throw
                }

                It 'Should not be able to find the log file before configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeFalse
                }

                It 'Should compile and run configuration' {
                    {
                        . $script:configurationFilePathWithCredential -ConfigurationName $configurationName
                        & $configurationName -OutputPath $TestDrive -ConfigurationData $script:credentialConfigurationData @processParameters
                        Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                    } | Should Not Throw
                }

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                It 'Should not be able to retrieve the process after configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                    { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
                }

                It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                    $currentConfig = Get-DscConfiguration
                    $currentConfig.Path | Should Be $processParameters.Path
                    $currentConfig.Arguments | Should Be $processParameters.Arguments
                    $currentConfig.Ensure | Should Be $processParameters.Ensure
                }

                It 'Should not be able to find the log file after configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeFalse
                }
            }

            Context 'Start a new running process' {
                $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                $configurationName = 'StartNewProcess'

                $processParameters = @{
                    Path = $testProcessPath
                    Ensure = 'Present'
                    Arguments = $logFilePath
                    Credential = $script:testCredential
                }

                It 'Should not be able to retrieve the process before configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Throw
                }

                It 'Should not be able to find the log file before configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeFalse
                }

                It 'Should compile and run configuration' {
                    {
                        . $script:configurationFilePathWithCredential -ConfigurationName $configurationName
                        & $configurationName -OutputPath $TestDrive -ConfigurationData $script:credentialConfigurationData @processParameters
                        Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                    } | Should Not Throw
                }

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                It 'Should be able to retrieve the process after configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                    { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
                }

                It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                    $currentConfig = Get-DscConfiguration
                    $currentConfig.Path | Should Be $processParameters.Path
                    $currentConfig.Arguments | Should Be $processParameters.Arguments
                    $currentConfig.Ensure | Should Be $processParameters.Ensure
                    $currentConfig.ProcessCount | Should Be 1
                }

                It 'Should be able to find the log file after configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeTrue
                }
            }

            Context 'Start a process that is already running' {
                $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                $configurationName = 'StartRunningProcess'

                $processParameters = @{
                    Path = $testProcessPath
                    Ensure = 'Present'
                    Arguments = $logFilePath
                    Credential = $script:testCredential
                }

                $null = Start-Process -FilePath $processParameters.Path -ArgumentList $processParameters.Arguments -ErrorAction 'SilentlyContinue'

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                It 'Should be able to retrieve the process before configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
                }

                It 'Should be able to find the log file before configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeTrue
                }

                It 'Should compile and run configuration' {
                    {
                        . $script:configurationFilePathWithCredential -ConfigurationName $configurationName
                        & $configurationName -OutputPath $TestDrive -ConfigurationData $script:credentialConfigurationData @processParameters
                        Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                    } | Should Not Throw
                }

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                It 'Should be able to retrieve the process after configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                    { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
                }

                It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                    $currentConfig = Get-DscConfiguration
                    $currentConfig.Path | Should Be $processParameters.Path
                    $currentConfig.Arguments | Should Be $processParameters.Arguments
                    $currentConfig.Ensure | Should Be $processParameters.Ensure
                    $currentConfig.ProcessCount | Should Be 1
                }

                It 'Should be able to find the log file after configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeTrue
                }
            }

            Context 'Stop a running process' {
                $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                $configurationName = 'StopRunningProcess'

                $processParameters = @{
                    Path = $testProcessPath
                    Ensure = 'Absent'
                    Arguments = $logFilePath
                    Credential = $script:testCredential
                }

                $null = Start-Process -FilePath $processParameters.Path -ArgumentList $processParameters.Arguments -ErrorAction 'SilentlyContinue'

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                It 'Should be able to retrieve the process before configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
                }

                It 'Should be able to find the log file before configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeTrue
                }

                # Remove the created log file so that we can check that the configuration did not re-create it
                $null = Remove-Item -Path $script:logFilePath -Force -ErrorAction 'SilentlyContinue'

                It 'Should compile and run configuration' {
                    {
                        . $script:configurationFilePathWithCredential -ConfigurationName $configurationName
                        & $configurationName -OutputPath $TestDrive -ConfigurationData $script:credentialConfigurationData @processParameters
                        Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                    } | Should Not Throw
                }

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                It 'Should not be able to retrieve the process after configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                    { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
                }

                It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                    $currentConfig = Get-DscConfiguration
                    $currentConfig.Path | Should Be $processParameters.Path
                    $currentConfig.Arguments | Should Be $processParameters.Arguments
                    $currentConfig.Ensure | Should Be $processParameters.Ensure
                }

                It 'Should not be able to find the log file after configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeFalse
                }
            }

            Context 'Get correct number of processes from Get-DscConfiguration when two of the same process are running' {
                $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                $configurationName = 'GetMultipleProcesses'

                $processParameters = @{
                    Path = $testProcessPath
                    Ensure = 'Present'
                    Arguments = $logFilePath
                    Credential = $script:testCredential
                }

                It 'Should not be able to retrieve the process before configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Throw
                }

                It 'Should not be able to find the log file before configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeFalse
                }

                It 'Should compile and run configuration' {
                    {
                        . $script:configurationFilePathWithCredential -ConfigurationName $configurationName
                        & $configurationName -OutputPath $TestDrive -ConfigurationData $script:credentialConfigurationData @processParameters
                        Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                    } | Should Not Throw
                }

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                $null = Start-Process -FilePath $processParameters.Path -ArgumentList $processParameters.Arguments -ErrorAction 'SilentlyContinue'

                # Wait a moment for the second process to stop/start
                $null = Start-Sleep -Seconds 1

                It 'Should be able to retrieve the processes after configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                    { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
                }

                It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                    $currentConfig = Get-DscConfiguration
                    $currentConfig.Path | Should Be $processParameters.Path
                    $currentConfig.Arguments | Should Be $processParameters.Arguments
                    $currentConfig.Ensure | Should Be $processParameters.Ensure
                    $currentConfig.ProcessCount | Should Be 2
                }

                It 'Should be able to find the log file after configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeTrue
                }
            }

            Context 'Stop multiple running processes' {
                $null = Stop-Process -Name $script:testProcessName -Force -ErrorAction 'SilentlyContinue'

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                $configurationName = 'StopMultipleRunningProcesses'

                $processParameters = @{
                    Path = $testProcessPath
                    Ensure = 'Absent'
                    Arguments = $logFilePath
                    Credential = $script:testCredential
                }

                $null = Start-Process -FilePath $processParameters.Path -ArgumentList $processParameters.Arguments -ErrorAction 'SilentlyContinue'

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                $null = Start-Process -FilePath $processParameters.Path -ArgumentList $processParameters.Arguments -ErrorAction 'SilentlyContinue'

                # Wait a moment for the second process to stop/start
                $null = Start-Sleep -Seconds 1

                It 'Should be able to retrieve the process before configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Not Throw
                }

                It 'Should be able to find the log file before configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeTrue
                }

                # Remove the created log file so that we can check that the configuration did not re-create it
                $null = Remove-Item -Path $script:logFilePath -Force -ErrorAction 'SilentlyContinue'

                It 'Should compile and run configuration' {
                    {
                        . $script:configurationFilePathWithCredential -ConfigurationName $configurationName
                        & $configurationName -OutputPath $TestDrive -ConfigurationData $script:credentialConfigurationData @processParameters
                        Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                    } | Should Not Throw
                }

                # Wait a moment for the process to stop/start
                $null = Start-Sleep -Seconds 1

                It 'Should not be able to retrieve the processes after configuration' {
                    { $null = Get-Process -Name $script:testProcessName } | Should Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing after configuration' {
                    { $null = Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
                }

                It 'Should return the correct configuration from Get-DscConfiguration after configuration' {
                    $currentConfig = Get-DscConfiguration
                    $currentConfig.Path | Should Be $processParameters.Path
                    $currentConfig.Arguments | Should Be $processParameters.Arguments
                    $currentConfig.Ensure | Should Be $processParameters.Ensure
                }

                It 'Should not be able to find the log file after configuration' {
                    $pathResult = Test-Path -Path $logFilePath
                    $pathResult | Should -BeFalse
                }
            }
        }
    }
}

