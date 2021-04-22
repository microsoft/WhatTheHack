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
    -DscResourceName 'MSFT_WindowsPackageCab' `
    -TestType 'Integration'

try
{
    Describe 'WindowsPackageCab Integration Tests' {
        BeforeAll {
            Import-Module -Name 'Dism'

            $script:installedStates = @( 'Installed', 'InstallPending' )
            $script:confgurationFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_WindowsPackageCab.config.ps1'

            $script:testPackageName = ''
            $script:testSourcePath = Join-Path -Path $PSScriptRoot -ChildPath ''

            $script:cabPackageNotProvided = $script:testPackageName -eq [System.String]::Empty

            try
            {
                $originalPackage = Dism\Get-WindowsPackage -PackageName $script:testPackageName -Online
                if ($null -ne $originalPackage -and $originalPackage.PackageState -in $script:installedStates)
                {
                    $script:packageOriginallyInstalled = $true
                }
                else
                {
                    $script:packageOriginallyInstalled = $false
                }
            }
            catch
            {
                $script:packageOriginallyInstalled = $false
            }

            if ($script:packageOriginallyInstalled)
            {
                throw "Package $script:testPackageName is currently installed on this machine. These tests may destroy this package. Aborting."
            }
        }

        AfterEach {
            if (-not $script:packageOriginallyInstalled)
            {
                try
                {
                    $windowsPackage = Dism\Get-WindowsPackage -PackageName $script:testPackageName -Online
                    if ($null -ne $windowsPackage -and $windowsPackage.PackageState -in $script:installedStates)
                    {
                        Dism\Remove-WindowsPackage -PackageName $script:testPackageName.Name -Online -NoRestart
                    }
                }
                catch
                {
                    Write-Verbose -Message "No test cleanup needed. Package $script:testPackageName not found."
                }
            }
        }

        It 'Should install a Windows package through a cab file' -Skip:$script:cabPackageNotProvided {
            $configurationName = 'InstallWindowsPackageCab'

            $resourceParameters = @{
                Name = $script:testPackageName
                SourcePath = $script:testSourcePath
                Ensure = 'Present'
            }

            {
                . $script:confgurationFilePath -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @resourceParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Not -Throw

            { $null = Dism\Get-WindowsPackage -PackageName $resourceParameters.Name -Online } | Should -Not -Throw

            $windowsPackage = Dism\Get-WindowsPackage -PackageName $resourceParameters.Name -Online
            $windowsPackage | Should -Not -Be $null
            $windowsPackage.PackageState -in $script:installedStates | Should -BeTrue
        }

        It 'Should uninstall a Windows package through a cab file' -Skip:$script:cabPackageNotProvided {
            $configurationName = 'UninstallWindowsPackageCab'

            $resourceParameters = @{
                Name = $script:testPackageName
                SourcePath = $script:testSourcePath
                Ensure = 'Absent'
            }

            Dism\Add-WindowsPackage -PackagePath $resourceParameters.SourcePath -Online -NoRestart

            { $null = Dism\Get-WindowsPackage -PackageName $resourceParameters.Name -Online } | Should -Not -Throw

            {
                . $script:confgurationFilePath -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @resourceParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Not -Throw

            { $null = Dism\Get-WindowsPackage -PackageName $resourceParameters.Name -Online } | Should -Throw
        }

        It 'Should not install an invalid Windows package through a cab file' {
            $configurationName = 'InstallInvalidWindowsPackageCab'

            $resourceParameters = @{
                Name = 'NonExistentWindowsPackageCab'
                SourcePath = (Join-Path -Path $TestDrive -ChildPath 'FakePath.cab')
                Ensure = 'Present'
                LogPath = (Join-Path -Path $TestDrive -ChildPath 'InvalidWindowsPackageCab.log')
            }

            { Dism\Get-WindowsPackage -PackageName $resourceParameters.Name -Online } | Should -Throw

            {
                . $script:confgurationFilePath -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @resourceParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Throw

            Test-Path -Path $resourceParameters.LogPath | Should -BeTrue

            { Dism\Get-WindowsPackage -PackageName $resourceParameters.Name -Online } | Should -Throw
        }
    }
}
finally
{
    Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
}
