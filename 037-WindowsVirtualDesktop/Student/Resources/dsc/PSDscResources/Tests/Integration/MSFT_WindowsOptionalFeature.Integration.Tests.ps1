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
    -DscResourceName 'MSFT_WindowsOptionalFeature' `
    -TestType 'Integration'

try
{
    Describe 'WindowsOptionalFeature Integration Tests' {
        BeforeAll {
            $script:enabledStates = @( 'Enabled', 'EnablePending' )
            $script:disabledStates = @( 'Disabled', 'DisablePending' )

            $script:confgurationFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_WindowsOptionalFeature.config.ps1'
        }

        It 'Should enable a valid Windows optional feature' {
            $configurationName = 'EnableWindowsOptionalFeature'

            $resourceParameters = @{
                Name = 'TelnetClient'
                Ensure = 'Present'
                LogPath = Join-Path -Path $TestDrive -ChildPath 'EnableOptionalFeature.log'
                NoWindowsUpdateCheck = $true
            }

            $originalFeature = Dism\Get-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online

            try
            {
                if ($originalFeature.State -in $script:enabledStates)
                {
                    Dism\Disable-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online -NoRestart
                }

                {
                    . $script:confgurationFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @resourceParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                $windowsOptionalFeature = Dism\Get-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online

                $windowsOptionalFeature | Should -Not -Be $null
                $windowsOptionalFeature.State -in $script:enabledStates | Should -BeTrue
            }
            finally
            {
                if ($originalFeature.State -in $script:disabledStates)
                {
                    Dism\Disable-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online -NoRestart
                }
                elseif ($originalFeature.State -in $script:enabledStates)
                {
                    Dism\Enable-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online -NoRestart
                }

                if (Test-Path -Path $resourceParameters.LogPath)
                {
                    Remove-Item -Path $resourceParameters.LogPath -Recurse -Force
                }
            }
        }

        It 'Should disable a valid Windows optional feature' {
            $configurationName = 'DisableWindowsOptionalFeature'

            $resourceParameters = @{
                Name = 'TelnetClient'
                Ensure = 'Absent'
                LogPath = Join-Path -Path $TestDrive -ChildPath 'DisableOptionalFeature.log'
                NoWindowsUpdateCheck = $true
                RemoveFilesOnDisable = $false
            }

            $originalFeature = Dism\Get-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online

            try
            {
                if ($originalFeature.State -in $script:disabledStates)
                {
                    Dism\Enable-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online -NoRestart
                }

                {
                    . $script:confgurationFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @resourceParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                $windowsOptionalFeature = Dism\Get-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online

                $windowsOptionalFeature | Should -Not -Be $null
                $windowsOptionalFeature.State -in $script:disabledStates | Should -BeTrue
            }
            finally
            {
                if ($originalFeature.State -in $script:disabledStates)
                {
                    Dism\Disable-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online -NoRestart
                }
                elseif ($originalFeature.State -in $script:enabledStates)
                {
                    Dism\Enable-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online -NoRestart
                }

                if (Test-Path -Path $resourceParameters.LogPath)
                {
                    Remove-Item -Path $resourceParameters.LogPath -Recurse -Force
                }
            }
        }

        It 'Should not enable an incorrect Windows optional feature' {
            $configurationName = 'EnableIncorrectWindowsOptionalFeature'

            $resourceParameters = @{
                Name = 'NonExistentWindowsOptionalFeature'
                Ensure = 'Present'
                LogPath = Join-Path -Path $TestDrive -ChildPath 'EnableIncorrectWindowsFeature.log'
                NoWindowsUpdateCheck = $true
            }

            Dism\Get-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online | Should -Be $null

            try
            {
                {
                    . $script:confgurationFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @resourceParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Throw "Feature name $($resourceParameters.Name) is unknown."

                Test-Path -Path $resourceParameters.LogPath | Should -BeTrue

                Dism\Get-WindowsOptionalFeature -FeatureName $resourceParameters.Name -Online | Should -Be $null
            }
            finally
            {
                if (Test-Path -Path $resourceParameters.LogPath)
                {
                    Remove-Item -Path $resourceParameters.LogPath -Recurse -Force
                }
            }
        }
    }
}
finally
{
    Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
}
