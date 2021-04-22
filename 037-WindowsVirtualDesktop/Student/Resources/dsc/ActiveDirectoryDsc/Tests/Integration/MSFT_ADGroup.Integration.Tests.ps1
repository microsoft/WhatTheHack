if ($env:APPVEYOR -eq $true)
{
    Write-Warning -Message 'Integration test is not supported in AppVeyor.'
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceFriendlyName = 'ADGroup'
$script:dscResourceName = "MSFT_$($script:dscResourceFriendlyName)"

#region HEADER
# Integration Test Template Version: 1.3.3
[System.String] $script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git', (Join-Path -Path $script:moduleRoot -ChildPath 'DscResource.Tests'))
}

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:dscModuleName `
    -DSCResourceName $script:dscResourceName `
    -TestType Integration
#endregion

try
{
    $configFile = Join-Path -Path $PSScriptRoot -ChildPath "$($script:dscResourceName).config.ps1"
    . $configFile

    Describe "$($script:dscResourceName)_Integration" {
        BeforeAll {
            $resourceId = "[$($script:dscResourceFriendlyName)]Integration_Test"
        }

        $configurationName = "$($script:dscResourceName)_CreateGroup1_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group1_Name
                $resourceCurrentState.GroupScope | Should -Be 'Global'
                $resourceCurrentState.Category | Should -Be 'Security'
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group1_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_CreateGroup2_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group2_Name
                $resourceCurrentState.GroupScope | Should -Be $ConfigurationData.AllNodes.Group2_Scope
                $resourceCurrentState.Category | Should -Be 'Security'
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group2_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_CreateGroup3_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group3_Name
                $resourceCurrentState.GroupScope | Should -Be $ConfigurationData.AllNodes.Group3_Scope
                $resourceCurrentState.Category | Should -Be 'Security'
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group3_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_ChangeCategoryGroup3_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group3_Name
                $resourceCurrentState.GroupScope | Should -Be $ConfigurationData.AllNodes.Group3_Scope
                $resourceCurrentState.Category | Should -Be 'Distribution'
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group3_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_CreateGroup4_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group4_Name
                $resourceCurrentState.GroupScope | Should -Be $ConfigurationData.AllNodes.Group4_Scope
                $resourceCurrentState.Category | Should -Be 'Security'
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group4_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_RemoveGroup4_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Absent'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group4_Name
                $resourceCurrentState.GroupScope | Should -BeNullOrEmpty
                $resourceCurrentState.Category | Should -BeNullOrEmpty
                $resourceCurrentState.Path | Should -BeNullOrEmpty
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -BeNullOrEmpty

            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_RestoreGroup4_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group4_Name
                $resourceCurrentState.GroupScope | Should -Be $ConfigurationData.AllNodes.Group4_Scope
                $resourceCurrentState.Category | Should -Be 'Security'
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group4_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_ChangeScopeGroup4_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group4_Name
                $resourceCurrentState.GroupScope | Should -Be 'Global'
                $resourceCurrentState.Category | Should -Be 'Security'
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group4_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_UpdateGroup1_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group1_Name
                $resourceCurrentState.GroupScope | Should -Be 'Global'
                $resourceCurrentState.Category | Should -Be 'Security'
                $resourceCurrentState.Path | Should -Be ('CN=Computers,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -Be 'A DSC description'
                $resourceCurrentState.DisplayName | Should -Be 'DSC Group 1'
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -HaveCount 2
                $resourceCurrentState.Members | Should -Contain 'Administrator'
                $resourceCurrentState.Members | Should -Contain 'Guest'
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -Be ('CN=Administrator,CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Notes | Should -Be 'Notes for this group'
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Computers,{1}' -f $ConfigurationData.AllNodes.Group1_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_CreateGroup5_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group5_Name
                $resourceCurrentState.GroupScope | Should -Be $ConfigurationData.AllNodes.Group5_Scope
                $resourceCurrentState.Category | Should -Be $ConfigurationData.AllNodes.Group5_Category
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -HaveCount 1
                $resourceCurrentState.Members | Should -Contain 'Administrator'
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group5_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_ModifyMembersGroup5_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group5_Name
                $resourceCurrentState.GroupScope | Should -Be $ConfigurationData.AllNodes.Group5_Scope
                $resourceCurrentState.Category | Should -Be $ConfigurationData.AllNodes.Group5_Category
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -HaveCount 1
                $resourceCurrentState.Members | Should -Contain 'Guest'
                $resourceCurrentState.MembersToInclude | Should -HaveCount 1
                $resourceCurrentState.MembersToInclude | Should -Contain 'Guest'
                $resourceCurrentState.MembersToExclude | Should -HaveCount 1
                $resourceCurrentState.MembersToExclude | Should -Contain 'Administrator'
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group5_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_EnforceMembersGroup5_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group5_Name
                $resourceCurrentState.GroupScope | Should -Be $ConfigurationData.AllNodes.Group5_Scope
                $resourceCurrentState.Category | Should -Be $ConfigurationData.AllNodes.Group5_Category
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -HaveCount 2
                $resourceCurrentState.Members | Should -Contain 'Administrator'
                $resourceCurrentState.Members | Should -Contain 'Guest'
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group5_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_ClearMembersGroup5_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }

            It 'Should be able to call Get-DscConfiguration without throwing' {
                {
                    $script:currentConfiguration = Get-DscConfiguration -Verbose -ErrorAction Stop
                } | Should -Not -Throw
            }

            It 'Should have set the resource and all the parameters should match' {
                $resourceCurrentState = $script:currentConfiguration | Where-Object -FilterScript {
                    $_.ConfigurationName -eq $configurationName `
                        -and $_.ResourceId -eq $resourceId
                }

                $resourceCurrentState.Ensure | Should -Be 'Present'
                $resourceCurrentState.GroupName | Should -Be $ConfigurationData.AllNodes.Group5_Name
                $resourceCurrentState.GroupScope | Should -Be $ConfigurationData.AllNodes.Group5_Scope
                $resourceCurrentState.Category | Should -Be $ConfigurationData.AllNodes.Group5_Category
                $resourceCurrentState.Path | Should -Be ('CN=Users,{0}' -f $ConfigurationData.AllNodes.DomainDistinguishedName)
                $resourceCurrentState.Description | Should -BeNullOrEmpty
                $resourceCurrentState.DisplayName | Should -BeNullOrEmpty
                $resourceCurrentState.Credential | Should -BeNullOrEmpty
                $resourceCurrentState.DomainController | Should -BeNullOrEmpty
                $resourceCurrentState.Members | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToInclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembersToExclude | Should -BeNullOrEmpty
                $resourceCurrentState.MembershipAttribute | Should -Be 'SamAccountName'
                $resourceCurrentState.ManagedBy | Should -BeNullOrEmpty
                $resourceCurrentState.Notes | Should -BeNullOrEmpty
                $resourceCurrentState.RestoreFromRecycleBin | Should -BeNullOrEmpty
                $resourceCurrentState.DistinguishedName | Should -Be ('CN={0},CN=Users,{1}' -f $ConfigurationData.AllNodes.Group5_Name, $ConfigurationData.AllNodes.DomainDistinguishedName)
            }

            It 'Should return $true when Test-DscConfiguration is run' {
                Test-DscConfiguration -Verbose | Should -Be 'True'
            }
        }

        $configurationName = "$($script:dscResourceName)_Cleanup_Config"

        Context ('When using configuration {0}' -f $configurationName) {
            It 'Should compile and apply the MOF without throwing' {
                {
                    $configurationParameters = @{
                        OutputPath        = $TestDrive
                        # The variable $ConfigurationData was dot-sourced above.
                        ConfigurationData = $ConfigurationData
                    }

                    & $configurationName @configurationParameters

                    $startDscConfigurationParameters = @{
                        Path         = $TestDrive
                        ComputerName = 'localhost'
                        Wait         = $true
                        Verbose      = $true
                        Force        = $true
                        ErrorAction  = 'Stop'
                    }

                    Start-DscConfiguration @startDscConfigurationParameters
                } | Should -Not -Throw
            }
        }
    }
}
finally
{
    #region FOOTER
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
    #endregion
}
