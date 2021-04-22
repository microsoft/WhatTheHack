if ($PSVersionTable.PSVersion -lt [Version] '5.1')
{
    Write-Warning -Message 'Cannot run PSDscResources integration tests on PowerShell versions lower than 5.1'
    return
}

$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

$script:testFolderPath = Split-Path -Path $PSScriptRoot -Parent
$script:testHelpersPath = Join-Path -Path $script:testFolderPath -ChildPath 'TestHelpers'
Import-Module -Name (Join-Path -Path $script:testHelpersPath -ChildPath 'CommonTestHelper.psm1')

$script:testEnvironment = Enter-DscResourceTestEnvironment `
    -DscResourceModuleName 'PSDscResources' `
    -DscResourceName 'WindowsFeatureSet' `
    -TestType 'Integration'

try
{
    Describe 'WindowsFeatureSet Integration Tests' {
        BeforeAll {
            $script:validFeatureNames = @( 'Telnet-Client', 'RSAT-File-Services' )

            $script:originalFeatures = @{}

            foreach ($validFeatureName in $script:validFeatureNames)
            {
                $script:originalFeatures[$validFeatureName] = Get-WindowsFeature -Name $validFeatureName
            }

            $script:configurationFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'WindowsFeatureSet.config.ps1'
        }

        AfterAll {
            foreach ($validFeatureaName in $script:originalFeatures.Keys)
            {
                $feature = Get-WindowsFeature -Name $validFeatureaName

                if ($script:originalFeatures[$validFeatureaName].Installed -and -not $feature.Installed)
                {
                    Add-WindowsFeature -Name $validFeatureaName
                }
                elseif (-not $script:originalFeatures[$validFeatureaName].Installed -and $feature.Installed)
                {
                    Remove-WindowsFeature -Name $validFeatureaName
                }
            }
        }

        Context 'Install two Windows Features' {
            $configurationName = 'InstallTwoFeatures'

            $windowsFeatureSetParameters = @{
                WindowsFeatureNames = $script:validFeatureNames
                Ensure = 'Present'
                LogPath = Join-Path -Path $TestDrive -ChildPath 'InstallFeatureSetTest.log'
            }

            foreach ($windowsFeatureName in $windowsFeatureSetParameters.WindowsFeatureNames)
            {
                $windowsFeature = Get-WindowsFeature -Name $windowsFeatureName

                It "Should be able to retrieve Windows feature $windowsFeatureName before the configuration" {
                    $windowsFeature | Should -Not -Be $null
                }

                if ($windowsFeature.Installed)
                {
                    $null = Remove-WindowsFeature -Name $windowsFeatureName
                    $windowsFeature = Get-WindowsFeature -Name $windowsFeatureName

                    # May need to wait a moment for the correct state to populate
                    $millisecondsElapsed = 0
                    $startTime = Get-Date
                    while ($windowsFeature.Installed -and $millisecondsElapsed -lt 3000)
                    {
                        $windowsFeature = Get-WindowsFeature -Name $windowsFeatureName
                        $millisecondsElapsed = ((Get-Date) - $startTime).TotalMilliseconds
                    }
                }

                It "Should have uninstalled Windows feature $windowsFeatureName before the configuration" {
                    $windowsFeature.Installed | Should -BeFalse
                }
            }

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @windowsFeatureSetParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }

            foreach ($windowsFeatureName in $windowsFeatureSetParameters.WindowsFeatureNames)
            {
                $windowsFeature = Get-WindowsFeature -Name $windowsFeatureName

                It "Should be able to retrieve Windows feature $windowsFeatureName after the configuration" {
                    $windowsFeature | Should -Not -Be $null
                }

                if (-not $windowsFeature.Installed)
                {
                    # May need to wait a moment for the correct state to populate
                    $millisecondsElapsed = 0
                    $startTime = Get-Date
                    while (-not $windowsFeature.Installed -and $millisecondsElapsed -lt 3000)
                    {
                        $windowsFeature = Get-WindowsFeature -Name $windowsFeatureName
                        $millisecondsElapsed = ((Get-Date) - $startTime).TotalMilliseconds
                    }
                }

                It "Should have installed Windows feature $windowsFeatureName after the configuration" {
                    $windowsFeature.Installed | Should -BeTrue
                }
            }

            It 'Should have created the log file' {
                Test-Path -Path $windowsFeatureSetParameters.LogPath | Should -BeTrue
            }

            It 'Should have created content in the log file' {
                Get-Content -Path $windowsFeatureSetParameters.LogPath -Raw | Should -Not -Be $null
            }
        }

        Context 'Uninstall two Windows features' {
            $configurationName = 'UninstallTwoFeatures'

            $windowsFeatureSetParameters = @{
                WindowsFeatureNames = $script:validFeatureNames
                Ensure = 'Absent'
                LogPath = Join-Path -Path $TestDrive -ChildPath 'UninstallFeatureSetTest.log'
            }

            foreach ($windowsFeatureName in $windowsFeatureSetParameters.WindowsFeatureNames)
            {
                $windowsFeature = Get-WindowsFeature -Name $windowsFeatureName

                It "Should be able to retrieve Windows feature $windowsFeatureName before the configuration" {
                    $windowsFeature | Should -Not -Be $null
                }

                if (-not $windowsFeature.Installed)
                {
                    $null = Add-WindowsFeature -Name $windowsFeatureName
                    $windowsFeature = Get-WindowsFeature -Name $windowsFeatureName

                    # May need to wait a moment for the correct state to populate
                    $millisecondsElapsed = 0
                    $startTime = Get-Date
                    while (-not $windowsFeature.Installed -and $millisecondsElapsed -lt 3000)
                    {
                        $windowsFeature = Get-WindowsFeature -Name $windowsFeatureName
                        $millisecondsElapsed = ((Get-Date) - $startTime).TotalMilliseconds
                    }
                }

                It "Should have installed Windows feature $windowsFeatureName before the configuration" {
                    $windowsFeature.Installed | Should -BeTrue
                }
            }

            It 'Should compile and run configuration' {
                {
                    . $script:configurationFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @windowsFeatureSetParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }

            foreach ($windowsFeatureName in $windowsFeatureSetParameters.WindowsFeatureNames)
            {
                $windowsFeature = Get-WindowsFeature -Name $windowsFeatureName

                It "Should be able to retrieve Windows feature $windowsFeatureName after the configuration" {
                    $windowsFeature | Should -Not -Be $null
                }

                if ($windowsFeature.Installed)
                {
                    # May need to wait a moment for the correct state to populate
                    $millisecondsElapsed = 0
                    $startTime = Get-Date
                    while ($windowsFeature.Installed -and $millisecondsElapsed -lt 3000)
                    {
                        $windowsFeature = Get-WindowsFeature -Name $windowsFeatureName
                        $millisecondsElapsed = ((Get-Date) - $startTime).TotalMilliseconds
                    }
                }

                It "Should have uninstalled Windows feature $windowsFeatureName after the configuration" {
                    $windowsFeature.Installed | Should -BeFalse
                }
            }

            It 'Should have created the log file' {
                Test-Path -Path $windowsFeatureSetParameters.LogPath | Should -BeTrue
            }

            It 'Should have created content in the log file' {
                Get-Content -Path $windowsFeatureSetParameters.LogPath -Raw | Should -Not -Be $null
            }
        }
    }
}
finally
{
    Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
}
