<#
    WARNING: DO NOT RUN THESE TESTS ON A VALUABLE MACHINE!
    Running on a disposable VM or AppVeyor is strongly recommended.
    If these tests go awry, your machine's registry could be corrupted which will brick your machine!
    If this happens to you, it is fixable, but the fix is difficult and time-consuming.
#>

if ($PSVersionTable.PSVersion -lt [Version] '5.1')
{
    Write-Warning -Message 'Cannot run PSDscResources integration tests on PowerShell versions lower than 5.1'
    return
}

$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

# Import CommonTestHelper for Enter-DscResourceTestEnvironment, Exit-DscResourceTestEnvironment
$script:testFolderPath = Split-Path -Path $PSScriptRoot -Parent
$script:testHelpersPath = Join-Path -Path $script:testFolderPath -ChildPath 'TestHelpers'
Import-Module -Name (Join-Path -Path $script:testHelpersPath -ChildPath 'CommonTestHelper.psm1')

$script:testEnvironment = Enter-DscResourceTestEnvironment `
    -DscResourceModuleName 'PSDscResources' `
    -DscResourceName 'MSFT_RegistryResource' `
    -TestType 'Integration'

try
{
    Describe 'Registry End to End Tests' {
        BeforeAll {
            # Import Registry resource module for Get-TargetResource, Test-TargetResource, Set-TargetResource
            $moduleRootFilePath = Split-Path -Path $script:testFolderPath -Parent
            $dscResourcesFolderFilePath = Join-Path -Path $moduleRootFilePath -ChildPath 'DscResources'
            $registryResourceFolderFilePath = Join-Path -Path $dscResourcesFolderFilePath -ChildPath 'MSFT_RegistryResource'
            $registryResourceModuleFilePath = Join-Path -Path $registryResourceFolderFilePath -ChildPath 'MSFT_RegistryResource.psm1'
            Import-Module -Name $registryResourceModuleFilePath -Force

            $script:registryKeyValueTypes = @( 'String', 'Binary', 'DWord', 'QWord', 'MultiString', 'ExpandString' )
            $script:testRegistryKeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\TestKey2'
            $script:testRegistryKeyWithDrivePath = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\TestKey2\C:/Program Files (x86)/'

            # Force is specified as true for both of these configurations
            $script:confgurationFilePathKeyAndNameOnly = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_RegistryResource_KeyAndNameOnly.config.ps1'
            $script:confgurationFilePathWithDataAndType = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_RegistryResource_WithDataAndType.config.ps1'
        }

        Context 'Create a new registry key' {
            $configurationName = 'CreateRegistryKey'

            $registryParameters = @{
                Key = $script:testRegistryKeyPath
                Ensure = 'Present'
                ValueName = ''
            }

            It 'Should compile and run configuration' {
                {
                    . $script:confgurationFilePathKeyAndNameOnly -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @registryParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
            }

            $registryKey = Get-Item -Path $registryParameters.Key -ErrorAction 'SilentlyContinue'

            It 'Should have created the registry key' {
                $registryKey | Should -Not -Be $null
            }

            It 'Should return true from Test-TargetResource with the same parameters' {
                MSFT_RegistryResource\Test-TargetResource @registryParameters | Should -BeTrue
            }
        }

        Context 'Create a registry key value with no data or type' {
            $configurationName = 'CreateRegistryKeyValueNoDataOrType'

            $registryParameters = @{
                Key = $script:testRegistryKeyPath
                Ensure = 'Present'
                ValueName = 'TestValue'
            }

            It 'Should compile and run configuration' {
                {
                    . $script:confgurationFilePathKeyAndNameOnly -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @registryParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
            }

            $registryKeyValue = Get-ItemProperty -Path $registryParameters.Key -Name $registryParameters.ValueName -ErrorAction 'SilentlyContinue'

            It 'Should have created the registry key value' {
                $registryKeyValue | Should -Not -Be $null
            }

            It 'Should not have set the registry key value' {
                $registryKeyValue.($registryParameters.ValueName) | Should -Be ''
            }

            It 'Should return true from Test-TargetResource with the same parameters' {
                MSFT_RegistryResource\Test-TargetResource @registryParameters | Should -BeTrue
            }
        }

        Context 'Set registry key value with data and String type' {
            $configurationName = 'SetRegistryKeyValueString'

            $registryParameters = @{
                Key = $script:testRegistryKeyPath
                Ensure = 'Present'
                ValueName = 'TestValue'
                ValueType = 'String'
                ValueData = 'TestString1'
            }

            It 'Should compile and run configuration' {
                {
                    . $script:confgurationFilePathWithDataAndType -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @registryParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
            }

            $registryKeyValue = Get-ItemProperty -Path $registryParameters.Key -Name $registryParameters.ValueName -ErrorAction 'SilentlyContinue'

            It 'Should have created the registry key value' {
                $registryKeyValue | Should -Not -Be $null
            }

            It 'Should have set the registry key value to the specified String value' {
                $registryKeyValue.($registryParameters.ValueName) | Should -Be $registryParameters.ValueData
            }

            It 'Should return true from Test-TargetResource with the same parameters' {
                MSFT_RegistryResource\Test-TargetResource @registryParameters | Should -BeTrue
            }
        }

        foreach ($registryKeyValueType in $script:registryKeyValueTypes)
        {
            $registryKeyValueData = switch ($registryKeyValueType)
            {
                'String' { 'TestString2'; break }
                'Binary' { '0xCAC1111'; break }
                'DWord' { [System.Int32]::MaxValue.ToString(); break }
                'QWord' { [System.Int64]::MaxValue.ToString(); break }
                'MultiString' { @('MultiString1', 'MultiString2'); break }
                'ExpandString' { '%WINDIR%'; break }
            }

            $expectedRegistryKeyValue = switch ($registryKeyValueType)
            {
                'String' { 'TestString2'; break }
                'Binary' { [System.Byte[]] @( 12, 172, 17, 17 ); break }
                'DWord' { [System.Int32]::MaxValue; break }
                'QWord' { [System.Int64]::MaxValue; break }
                'MultiString' { [System.String[]] @('MultiString1', 'MultiString2'); break }
                'ExpandString' { 'C:\windows'; break }
            }

            Context "Overwrite a registry key value with a $registryKeyValueType value" {
                $configurationName = "OverwriteRegistryKeyValue$registryKeyValueType"

                $registryParameters = @{
                    Key = $script:testRegistryKeyPath
                    Ensure = 'Present'
                    ValueName = 'TestValue'
                    ValueType = $registryKeyValueType
                    ValueData = $registryKeyValueData
                }

                It 'Should compile and run configuration' {
                    {
                        . $script:confgurationFilePathWithDataAndType -ConfigurationName $configurationName
                        & $configurationName -OutputPath $TestDrive @registryParameters
                        Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                    } | Should -Not -Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing' {
                    { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
                }

                $registryKeyValue = Get-ItemProperty -Path $registryParameters.Key -Name $registryParameters.ValueName -ErrorAction 'SilentlyContinue'

                It 'Should be able to retrieve the registry key value' {
                    $registryKeyValue | Should -Not -Be $null
                }

                It 'Should have set the registry key value to the specified value' {
                    Compare-Object -ReferenceObject $expectedRegistryKeyValue -DifferenceObject $registryKeyValue.($registryParameters.ValueName) | Should -Be $null
                }

                It 'Should return true from Test-TargetResource with the same parameters' {
                    MSFT_RegistryResource\Test-TargetResource @registryParameters | Should -BeTrue
                }
            }
        }

        Context 'Set the registry key default value to a Binary value of 0' {
            $configurationName = 'SetDefaultRegistryKeyValueBinary0'

            $registryParameters = @{
                Key = $script:testRegistryKeyPath
                Ensure = 'Present'
                ValueName = ''
                ValueType = 'Binary'
                ValueData = '0x00'
            }

            $expectedRegistryKeyValue = [System.Byte[]] @(0)

            It 'Should compile and run configuration' {
                {
                    . $script:confgurationFilePathWithDataAndType -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @registryParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
            }

            $registryKeyValue = Get-ItemProperty -Path $registryParameters.Key -Name $registryParameters.ValueName -ErrorAction 'SilentlyContinue'

            It 'Should be able to retrieve the registry key value' {
                $registryKeyValue | Should -Not -Be $null
            }

            It 'Should have set the registry key value to the specified Binary value' {
                Compare-Object -ReferenceObject $expectedRegistryKeyValue -DifferenceObject $registryKeyValue.'(default)' | Should -Be $null
            }

            It 'Should return true from Test-TargetResource with the same parameters' {
                MSFT_RegistryResource\Test-TargetResource @registryParameters | Should -BeTrue
            }
        }

        Context 'Set a registry key value with a drive in the key name' {
            $configurationName = 'SetRegistryKeyValueString'

            $registryParameters = @{
                Key = $script:testRegistryKeyWithDrivePath
                Ensure = 'Present'
                ValueName = 'TestValue'
                ValueType = 'String'
                ValueData = '0'
            }

            It 'Should compile and run configuration' {
                {
                    . $script:confgurationFilePathWithDataAndType -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @registryParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
            }

            $parentRegistryKey = Get-Item -Path 'HKLM:'
            $registryKey = $parentRegistryKey.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment\TestKey2\C:/Program Files (x86)/', $false)

            It 'Should have created the registry key value' {
                $registryKey | Should Not Be $null
            }

            It 'Should have set the registry key value to the specified value' {
                $registryKey.GetValue($registryParameters.ValueName) | Should Be $registryParameters.ValueData
            }

            It 'Should return true from Test-TargetResource with the same parameters' {
                MSFT_RegistryResource\Test-TargetResource @registryParameters | Should -BeTrue
            }
        }

        Context 'Remove a registry key value' {
            $configurationName = 'RemoveRegistryKeyValue'

            $registryParameters = @{
                Key = $script:testRegistryKeyPath
                Ensure = 'Absent'
                ValueName = 'TestValue'
            }

            It 'Should compile and run configuration' {
                {
                    . $script:confgurationFilePathKeyAndNameOnly -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @registryParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
            }

            $registryKeyValue = Get-ItemProperty -Path $registryParameters.Key -Name $registryParameters.ValueName -ErrorAction 'SilentlyContinue'

            It 'Should have removed the registry key value' {
                $registryKeyValue | Should -Be $null
            }

            It 'Should return true from Test-TargetResource with the same parameters' {
                MSFT_RegistryResource\Test-TargetResource @registryParameters | Should -BeTrue
            }
        }

        Context 'Remove a default registry key value' {
            $configurationName = 'RemoveDefaultRegistryKeyValue'

            $registryParameters = @{
                Key = $script:testRegistryKeyPath
                Ensure = 'Absent'
                ValueName = ''
                ValueType = 'Binary'
                ValueData = '0'
            }

            It 'Should compile and run configuration' {
                {
                    . $script:confgurationFilePathWithDataAndType -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @registryParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
            }

            $registryKeyValue = Get-ItemProperty -Path $registryParameters.Key -Name $registryParameters.ValueName -ErrorAction 'SilentlyContinue'

            It 'Should have removed the registry key value' {
                $registryKeyValue | Should -Be $null
            }

            It 'Should return true from Test-TargetResource with the same parameters' {
                MSFT_RegistryResource\Test-TargetResource @registryParameters | Should -BeTrue
            }
        }

        Context 'Remove a registry key' {
            $configurationName = 'RemoveRegistryKey'

            $registryParameters = @{
                Key = $script:testRegistryKeyPath
                Ensure = 'Absent'
                ValueName = ''
            }

            It 'Should compile and run configuration' {
                {
                    . $script:confgurationFilePathKeyAndNameOnly -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @registryParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
            }

            $registryKey = Get-Item -Path $registryParameters.Key -ErrorAction 'SilentlyContinue'

            It 'Should have removed the registry key value' {
                $registryKey | Should -Be $null
            }

            It 'Should return true from Test-TargetResource with the same parameters' {
                MSFT_RegistryResource\Test-TargetResource @registryParameters | Should -BeTrue
            }
        }
    }
}
finally
{
    Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
}

