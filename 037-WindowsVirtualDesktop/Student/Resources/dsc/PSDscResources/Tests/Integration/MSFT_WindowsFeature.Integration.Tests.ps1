<#
    Integration tests for installing/uninstalling a Windows Feature. Currently Telnet-Client is
    set as the feature to test since it's fairly small and doesn't require a restart. ADRMS
    is set as the feature to test installing/uninstalling a feature with subfeatures,
    but this takes a good chunk of time, so by default these tests are set to be skipped.
    If there's any major changes to the resource, then set the skipLongTests variable to $false
    and run those tests at least once to test the new functionality more completely.
#>

# Suppressing this rule since we need to create a plaintext password to test this resource
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
param ()

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
    -DscResourceName 'MSFT_WindowsFeature' `
    -TestType 'Integration'

$script:installStateOfTestFeature = $false
$script:installStateOfTestWithSubFeatures = $false

<#
    If this is set to $true then the tests for installing/uninstalling a feature with
    its subfeatures will not run.
#>
$script:skipLongTests = $false

try
{
    Describe 'WindowsFeature Integration Tests' {
        BeforeAll {
            $script:testFeatureName = 'Telnet-Client'
            $script:testFeatureWithSubFeaturesName = 'RSAT-File-Services'

            # Saving the state so we can clean up afterwards
            $testFeature = Get-WindowsFeature -Name $script:testFeatureName
            $script:installStateOfTestFeature = $testFeature.Installed

            $testFeatureWithSubFeatures = Get-WindowsFeature -Name $script:testFeatureWithSubFeaturesName
            $script:installStateOfTestWithSubFeatures = $testFeatureWithSubFeatures.Installed

            $configFile = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_WindowsFeature.config.ps1'
        }

        AfterAll {
            # Ensure that features used for testing are re-installed/uninstalled
            $feature = Get-WindowsFeature -Name $script:testFeatureName

            if ($script:installStateOfTestFeature -and -not $feature.Installed)
            {
                Add-WindowsFeature -Name $script:testFeatureName
            }
            elseif ( -not $script:installStateOfTestFeature -and $feature.Installed)
            {
                Remove-WindowsFeature -Name $script:testFeatureName
            }

            if (-not $script:skipLongTests)
            {
                $feature = Get-WindowsFeature -Name $script:testFeatureWithSubFeaturesName

                if ($script:installStateOfTestWithSubFeatures -and -not $feature.Installed)
                {
                    Add-WindowsFeature -Name $script:testFeatureWithSubFeaturesName -IncludeAllSubFeature
                }
                elseif ( -not $script:installStateOfTestWithSubFeatures -and $feature.Installed)
                {
                    Remove-WindowsFeature -Name $script:testFeatureWithSubFeaturesName
                }
            }
        }

        Context "Should Install the Windows Feature: $script:testFeatureName" {
            $configurationName = 'MSFT_WindowsFeature_InstallFeature'
            $configurationPath = Join-Path -Path $TestDrive -ChildPath $configurationName

            $logPath = Join-Path -Path $TestDrive -ChildPath 'InstallFeatureTest.log'

            try
            {
                # Ensure the feature is not already on the machine
                Remove-WindowsFeature -Name $script:testFeatureName

                It 'Should compile without throwing' {
                    {
                        . $configFile -ConfigurationName $configurationName
                        & $configurationName -Name $script:testFeatureName `
                                             -IncludeAllSubFeature $false `
                                             -Ensure 'Present' `
                                             -OutputPath $configurationPath `
                                             -ErrorAction 'Stop'
                        Start-DscConfiguration -Path $configurationPath -ErrorAction 'Stop' -Wait -Force
                    } | Should -Not -Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing' {
                    { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
                }

                It 'Should return the correct configuration' {
                   $currentConfig = Get-DscConfiguration -ErrorAction 'Stop'
                   $currentConfig.Name | Should -Be $script:testFeatureName
                   $currentConfig.IncludeAllSubFeature | Should -BeFalse
                   $currentConfig.Ensure | Should -Be 'Present'
                }

                It 'Should be Installed' {
                    $feature = Get-WindowsFeature -Name $script:testFeatureName
                    $feature.Installed | Should -BeTrue
                }
            }
            finally
            {
                if (Test-Path -Path $logPath) {
                    Remove-Item -Path $logPath -Recurse -Force
                }

                if (Test-Path -Path $configurationPath)
                {
                    Remove-Item -Path $configurationPath -Recurse -Force
                }
            }
        }

        Context "Should Uninstall the Windows Feature: $script:testFeatureName" {
            $configurationName = 'MSFT_WindowsFeature_UninstallFeature'
            $configurationPath = Join-Path -Path $TestDrive -ChildPath $configurationName

            $logPath = Join-Path -Path $TestDrive -ChildPath 'UninstallFeatureTest.log'

            try
            {
                It 'Should compile without throwing' {
                    {
                        . $configFile -ConfigurationName $configurationName
                        & $configurationName -Name $script:testFeatureName `
                                             -IncludeAllSubFeature $false `
                                             -Ensure 'Absent' `
                                             -OutputPath $configurationPath `
                                             -ErrorAction 'Stop'
                        Start-DscConfiguration -Path $configurationPath -ErrorAction 'Stop' -Wait -Force
                    } | Should -Not -Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing' {
                    { Get-DscConfiguration -ErrorAction 'Stop' } | Should -Not -Throw
                }

                It 'Should return the correct configuration' {
                   $currentConfig = Get-DscConfiguration -ErrorAction 'Stop'
                   $currentConfig.Name | Should -Be $script:testFeatureName
                   $currentConfig.IncludeAllSubFeature | Should -BeFalse
                   $currentConfig.Ensure | Should -Be 'Absent'
                }

                It 'Should not be installed' {
                    $feature = Get-WindowsFeature -Name $script:testFeatureName
                    $feature.Installed | Should -BeFalse
                }
            }
            finally
            {
                if (Test-Path -Path $logPath) {
                    Remove-Item -Path $logPath -Recurse -Force
                }

                if (Test-Path -Path $configurationPath)
                {
                    Remove-Item -Path $configurationPath -Recurse -Force
                }
            }
        }

        <#
            This test triggers a pending reboot on the machine which crashes the WindowsFeatureSet
            and WindowsOptionalFeatureSet tests on AppVeyor.

            If anyone knows of a Windows Feature that exists on Server 2012 R2, does not require a
            reboot, and has subfeatures, please update $script:testFeatureWithSubFeaturesName with
            the name of that feature and turn these tests back on in AppVeyor
        #>
        if (-not $env:appveyor)
        {
            Context "Should Install the Windows Feature: $script:testFeatureWithSubFeaturesName" {
                $configurationName = 'MSFT_WindowsFeature_InstallFeatureWithSubFeatures'
                $configurationPath = Join-Path -Path $TestDrive -ChildPath $configurationName

                $logPath = Join-Path -Path $TestDrive -ChildPath 'InstallSubFeatureTest.log'

                if (-not $script:skipLongTests)
                {
                    # Ensure that the feature is not already installed
                    Remove-WindowsFeature -Name $script:testFeatureWithSubFeaturesName
                }

                It 'Should compile without throwing' -Skip:$script:skipLongTests {
                    {
                        . $configFile -ConfigurationName $configurationName
                        & $configurationName -Name $script:testFeatureWithSubFeaturesName `
                                                -IncludeAllSubFeature $true `
                                                -Ensure 'Present' `
                                                -OutputPath $configurationPath `
                                                -ErrorAction 'Stop'
                        Start-DscConfiguration -Path $configurationPath -ErrorAction 'Stop' -Wait -Force
                    } | Should Not Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing' -Skip:$script:skipLongTests {
                    { Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
                }

                It 'Should return the correct configuration' -Skip:$script:skipLongTests {
                    $currentConfig = Get-DscConfiguration -ErrorAction 'Stop'
                    $currentConfig.Name | Should Be $script:testFeatureWithSubFeaturesName
                    $currentConfig.IncludeAllSubFeature | Should -BeTrue
                    $currentConfig.Ensure | Should Be 'Present'
                }

                It 'Should be Installed (includes check for subFeatures)' -Skip:$script:skipLongTests {
                    $feature = Get-WindowsFeature -Name $script:testFeatureWithSubFeaturesName
                    $feature.Installed | Should -BeTrue

                    foreach ($subFeatureName in $feature.SubFeatures)
                    {
                        $subFeature = Get-WindowsFeature -Name $subFeatureName
                        $subFeature.Installed | Should -BeTrue
                    }
                }
            }

            Context "Should Uninstall the Windows Feature: $script:testFeatureWithSubFeaturesName" {
                $configurationName = 'MSFT_WindowsFeature_UninstallFeatureWithSubFeatures'
                $configurationPath = Join-Path -Path $TestDrive -ChildPath $configurationName

                $logPath = Join-Path -Path $TestDrive -ChildPath 'UninstallSubFeatureTest.log'

                It 'Should compile without throwing' -Skip:$script:skipLongTests {
                    {
                        . $configFile -ConfigurationName $configurationName
                        & $configurationName -Name $script:testFeatureWithSubFeaturesName `
                                                -IncludeAllSubFeature $true `
                                                -Ensure 'Absent' `
                                                -OutputPath $configurationPath `
                                                -ErrorAction 'Stop'
                        Start-DscConfiguration -Path $configurationPath -ErrorAction 'Stop' -Wait -Force
                    } | Should Not Throw
                }

                It 'Should be able to call Get-DscConfiguration without throwing' -Skip:$script:skipLongTests {
                    { Get-DscConfiguration -ErrorAction 'Stop' } | Should Not Throw
                }

                It 'Should return the correct configuration' -Skip:$script:skipLongTests  {
                    $currentConfig = Get-DscConfiguration -ErrorAction 'Stop'
                    $currentConfig.Name | Should Be $script:testFeatureWithSubFeaturesName
                    $currentConfig.IncludeAllSubFeature | Should -BeFalse
                    $currentConfig.Ensure | Should Be 'Absent'
                }

                It 'Should not be installed (includes check for subFeatures)' -Skip:$script:skipLongTests {
                    $feature = Get-WindowsFeature -Name $script:testFeatureWithSubFeaturesName
                    $feature.Installed | Should -BeFalse

                    foreach ($subFeatureName in $feature.SubFeatures)
                    {
                        $subFeature = Get-WindowsFeature -Name $subFeatureName
                        $subFeature.Installed | Should -BeFalse
                    }
                }
            }
        }
    }
}
finally
{
    Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
}
