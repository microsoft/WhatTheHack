Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADForestProperties'

#region HEADER

# Unit Test Template Version: 1.2.4
$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git', (Join-Path -Path $script:moduleRoot -ChildPath 'DscResource.Tests'))
}

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force

$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:dscModuleName `
    -DSCResourceName $script:dscResourceName `
    -ResourceType 'Mof' `
    -TestType Unit

#endregion HEADER

function Invoke-TestSetup
{
}

function Invoke-TestCleanup
{
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
}

# Begin Testing
try
{
    Invoke-TestSetup

    InModuleScope $script:dscResourceName {
        # Load stub cmdlets and classes.
        Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'Stubs\ActiveDirectory_2019.psm1') -Force

        $forestName = 'contoso.com'
        $testCredential = [System.Management.Automation.PSCredential]::Empty

        $replaceParameters = @{
            ForestName                 = $forestName
            ServicePrincipalNameSuffix = 'test.net'
            UserPrincipalNameSuffix    = 'cloudapp.net', 'fabrikam.com'
            Credential                 = $testCredential
        }

        $addRemoveParameters = @{
            ForestName                         = $forestName
            ServicePrincipalNameSuffixToRemove = 'test.com'
            ServicePrincipalNameSuffixToAdd    = 'test.net'
            UserPrincipalNameSuffixToRemove    = 'pester.net'
            UserPrincipalNameSuffixToAdd       = 'cloudapp.net', 'fabrikam.com'
            Credential                         = $testCredential
        }

        $removeParameters = $addRemoveParameters.clone()
        $removeParameters['ServicePrincipalNameSuffixToAdd'] = $null
        $removeParameters['UserPrincipalNameSuffixToAdd'] = $null

        $invalidParameters = $addRemoveParameters.clone()
        $invalidParameters['UserPrincipalNameSuffix'] = 'test.com'

        $mockADForestDesiredState = @{
            Name        = $forestName
            SpnSuffixes = @('test.net')
            UpnSuffixes = @('cloudapp.net', 'fabrikam.com')
        }

        $mockADForestNonDesiredState = @{
            Name        = $forestName
            SpnSuffixes = @('test3.value')
            UpnSuffixes = @('test1.value', 'test2.value')
        }

        Mock -CommandName Assert-Module
        Mock -CommandName Import-Module

        Describe 'MSFT_ADForestProperties\Get-TargetResource' {
            Mock -CommandName Get-ADForest -MockWith { $mockADForestDesiredState }

            Context 'When used with add/remove parameters' {

                It 'Should return expected properties' {
                    $targetResource = Get-TargetResource @addRemoveParameters

                    $targetResource.ServicePrincipalNameSuffix         | Should -Be $mockADForestDesiredState.SpnSuffixes
                    $targetResource.ServicePrincipalNameSuffixToAdd    | Should -Be $addRemoveParameters.ServicePrincipalNameSuffixToAdd
                    $targetResource.ServicePrincipalNameSuffixToRemove | Should -Be $addRemoveParameters.ServicePrincipalNameSuffixToRemove
                    $targetResource.UserPrincipalNameSuffix            | Should -Be $mockADForestDesiredState.UpnSuffixes
                    $targetResource.UserPrincipalNameSuffixToAdd       | Should -Be $addRemoveParameters.UserPrincipalNameSuffixToAdd
                    $targetResource.UserPrincipalNameSuffixToRemove    | Should -Be $addRemoveParameters.UserPrincipalNameSuffixToRemove
                    $targetResource.Credential                         | Should -BeNullOrEmpty
                    $targetResource.ForestName                         | Should -Be $mockADForestDesiredState.Name
                }
            }

            Context 'When used with replace parameters' {

                It 'Should return expected properties' {
                    $targetResource = Get-TargetResource @replaceParameters

                    $targetResource.ServicePrincipalNameSuffix         | Should -Be $mockADForestDesiredState.SpnSuffixes
                    $targetResource.ServicePrincipalNameSuffixToAdd    | Should -BeNullOrEmpty
                    $targetResource.ServicePrincipalNameSuffixToRemove | Should -BeNullOrEmpty
                    $targetResource.UserPrincipalNameSuffix            | Should -Be $mockADForestDesiredState.UpnSuffixes
                    $targetResource.UserPrincipalNameSuffixToAdd       | Should -BeNullOrEmpty
                    $targetResource.UserPrincipalNameSuffixToRemove    | Should -BeNullOrEmpty
                    $targetResource.Credential                         | Should -BeNullOrEmpty
                    $targetResource.ForestName                         | Should -Be $mockADForestDesiredState.Name
                }
            }
        }

        Describe 'MSFT_ADForestProperties\Test-TargetResource' {
            Context 'When target resource in desired state' {
                Mock -CommandName Get-ADForest -MockWith { $mockADForestDesiredState }

                It 'Should return $true when using add/remove parameters' {
                    Test-TargetResource @addRemoveParameters | Should -BeTrue
                }

                It 'Should return $true when using replace parameters' {
                    Test-TargetResource @replaceParameters | Should -BeTrue
                }
            }

            Context 'When using Add and Remove parameters and target not in desired state' {
                Mock -CommandName Get-ADForest -MockWith { $mockADForestNonDesiredState }

                It 'Should return $false when using add/remove parameters' {
                    Test-TargetResource @addRemoveParameters | Should -BeFalse
                }

                It 'Should return $false when using replace parameters' {
                    Test-TargetResource @replaceParameters | Should -BeFalse
                }
            }

            Context 'When using invalid parameter combination' {
                Mock -CommandName Get-ADForest

                It 'Should throw when invalid parameter set is used' {
                    { Test-TargetResource @invalidParameters } | Should -Throw
                }
            }
        }

        Describe 'MSFT_ADForestProperties\Set-TargetResource' {
            Context 'When using replace parameters' {
                Mock -CommandName Set-ADForest -ParameterFilter {
                    ($SpnSuffixes.Replace -join ',') -eq ($replaceParameters.ServicePrincipalNameSuffix -join ',') -and
                    ($UpnSuffixes.Replace -join ',') -eq ($replaceParameters.UserPrincipalNameSuffix -join ',')
                }

                It 'Should call Set-ADForest with the replace action' {
                    Set-TargetResource @replaceParameters

                    Assert-MockCalled Set-ADForest -Scope It -Times 1 -Exactly
                }
            }

            Context 'When using add/remove parameters' {
                Mock -CommandName Set-ADForest -ParameterFilter {
                    ($SpnSuffixes.Add -join ',') -eq ($addRemoveParameters.ServicePrincipalNameSuffixToAdd -join ',') -and
                    ($SpnSuffixes.Remove -join ',') -eq ($addRemoveParameters.ServicePrincipalNameSuffixToRemove -join ',') -and
                    ($UpnSuffixes.Add -join ',') -eq ($addRemoveParameters.UserPrincipalNameSuffixToAdd -join ',') -and
                    ($UpnSuffixes.Remove -join ',') -eq ($addRemoveParameters.UserPrincipalNameSuffixToRemove -join ',')
                }

                It 'Should call Set-ADForest with the add and remove actions' {
                    Set-TargetResource @addRemoveParameters

                    Assert-MockCalled Set-ADForest -Scope It -Times 1 -Exactly
                }
            }

            Context 'When using only remove parameters' {
                Mock -CommandName Set-ADForest -ParameterFilter {
                    ($SpnSuffixes.Remove -join ',') -eq ($removeParameters.ServicePrincipalNameSuffixToRemove -join ',') -and
                    ($UpnSuffixes.Remove -join ',') -eq ($removeParameters.UserPrincipalNameSuffixToRemove -join ',')
                }

                It 'Should call Set-ADForest with the remove action' {
                    Set-TargetResource @removeParameters

                    Assert-MockCalled Set-ADForest -Scope It -Times 1 -Exactly
                }
            }
        }
    }
}
finally
{
    Invoke-TestCleanup
}
