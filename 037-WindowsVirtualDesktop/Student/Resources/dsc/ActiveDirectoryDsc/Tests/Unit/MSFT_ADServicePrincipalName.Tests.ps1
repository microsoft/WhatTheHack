Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADServicePrincipalName'

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

        #region Function Get-TargetResource
        Describe 'ADServicePrincipalName\Get-TargetResource' {
            $testDefaultParameters = @{
                ServicePrincipalName = 'HOST/demo'
            }

            Context 'No SPN set' {
                Mock -CommandName Get-ADObject

                It 'Should return absent' {
                    $result = Get-TargetResource @testDefaultParameters

                    $result.Ensure               | Should -Be 'Absent'
                    $result.ServicePrincipalName | Should -Be 'HOST/demo'
                    $result.Account              | Should -Be ''
                }
            }

            Context 'One SPN set' {
                Mock -CommandName Get-ADObject -MockWith {
                    return [PSCustomObject] @{
                        SamAccountName = 'User'
                    }
                }

                It 'Should return present with the correct account' {
                    $result = Get-TargetResource @testDefaultParameters

                    $result.Ensure               | Should -Be 'Present'
                    $result.ServicePrincipalName | Should -Be 'HOST/demo'
                    $result.Account              | Should -Be 'User'
                }
            }

            Context 'Multiple SPN set' {
                Mock -CommandName Get-ADObject -MockWith {
                    return @(
                        [PSCustomObject] @{
                            SamAccountName = 'User'
                        },
                        [PSCustomObject] @{
                            SamAccountName = 'Computer'
                        }
                    )
                }

                It 'Should return present with the multiple accounts' {
                    $result = Get-TargetResource @testDefaultParameters

                    $result.Ensure               | Should -Be 'Present'
                    $result.ServicePrincipalName | Should -Be 'HOST/demo'
                    $result.Account              | Should -Be 'User;Computer'
                }
            }
        }
        #endregion

        #region Function Test-TargetResource
        Describe 'ADServicePrincipalName\Test-TargetResource' {
            $testDefaultParameters = @{
                ServicePrincipalName = 'HOST/demo'
                Account              = 'User'
            }

            Context 'No SPN set' {
                Mock -CommandName Get-ADObject

                It 'Should return false for present' {
                    $result = Test-TargetResource -Ensure 'Present' @testDefaultParameters
                    $result | Should -BeFalse
                }

                It 'Should return true for absent' {
                    $result = Test-TargetResource -Ensure 'Absent' @testDefaultParameters
                    $result | Should -BeTrue
                }
            }

            Context 'Correct SPN set' {
                Mock -CommandName Get-ADObject -MockWith {
                    return [PSCustomObject] @{
                        SamAccountName = 'User'
                    }
                }

                It 'Should return true for present' {
                    $result = Test-TargetResource -Ensure 'Present' @testDefaultParameters
                    $result | Should -BeTrue
                }

                It 'Should return false for absent' {
                    $result = Test-TargetResource -Ensure 'Absent' @testDefaultParameters
                    $result | Should -BeFalse
                }
            }

            Context 'Wrong SPN set' {
                Mock -CommandName Get-ADObject -MockWith {
                    return [PSCustomObject] @{
                        SamAccountName = 'Computer'
                    }
                }

                It 'Should return false for present' {
                    $result = Test-TargetResource -Ensure 'Present' @testDefaultParameters
                    $result | Should -BeFalse
                }

                It 'Should return false for absent' {
                    $result = Test-TargetResource -Ensure 'Absent' @testDefaultParameters
                    $result | Should -BeFalse
                }
            }

            Context 'Multiple SPN set' {
                Mock -CommandName Get-ADObject -MockWith {
                    return @(
                        [PSCustomObject] @{
                            SamAccountName = 'User'
                        },
                        [PSCustomObject] @{
                            SamAccountName = 'Computer'
                        }
                    )
                }

                It 'Should return false for present' {
                    $result = Test-TargetResource -Ensure 'Present' @testDefaultParameters
                    $result | Should -BeFalse
                }

                It 'Should return false for absent' {
                    $result = Test-TargetResource -Ensure 'Absent' @testDefaultParameters
                    $result | Should -BeFalse
                }
            }

        }
        #endregion

        #region Function Set-TargetResource
        Describe 'ADServicePrincipalName\Set-TargetResource' {
            $testPresentParams = @{
                Ensure               = 'Present'
                ServicePrincipalName = 'HOST/demo'
                Account              = 'User'
            }

            $testAbsentParams = @{
                Ensure               = 'Absent'
                ServicePrincipalName = 'HOST/demo'
            }

            Context 'AD Object not existing' {
                Mock -CommandName Get-ADObject

                It 'Should throw the correct exception' {
                    { Set-TargetResource @testPresentParams } | Should -Throw ($script:localizedData.AccountNotFound -f $testPresentParams.Account)
                }
            }

            Context 'No SPN set' {
                Mock -CommandName Set-ADObject
                Mock -CommandName Get-ADObject -ParameterFilter {
                    $Filter -eq ([ScriptBlock]::Create(' ServicePrincipalName -eq $ServicePrincipalName '))
                }

                Mock -CommandName Get-ADObject -MockWith {
                    return 'User'
                }

                It 'Should call the Set-ADObject' {
                    $result = Set-TargetResource @testPresentParams

                    Assert-MockCalled -CommandName Set-ADObject -ParameterFilter {
                        $Identity -eq 'User'
                    } -Scope It -Times 1 -Exactly
                }
            }

            Context 'Wrong SPN set' {
                Mock -CommandName Get-ADObject -ParameterFilter { $Filter -eq ([ScriptBlock]::Create(' ServicePrincipalName -eq $ServicePrincipalName ')) } -MockWith {
                    return [PSCustomObject] @{
                        SamAccountName = 'Computer'
                        DistinguishedName = 'CN=Computer,OU=Corp,DC=contoso,DC=com'
                    }
                }

                Mock -CommandName Get-ADObject -MockWith {
                    return [PSCustomObject] @{
                        SamAccountName = 'User'
                    }
                }

                Mock -CommandName Set-ADObject -ParameterFilter { $null -ne $Add }
                Mock -CommandName Set-ADObject -ParameterFilter { $null -ne $Remove }

                It 'Should call the Set-ADObject twice' {
                    $result = Set-TargetResource @testPresentParams

                    Assert-MockCalled -CommandName Set-ADObject -Scope It -Times 1 -Exactly -ParameterFilter { $null -ne $Add }
                    Assert-MockCalled -CommandName Set-ADObject -Scope It -Times 1 -Exactly -ParameterFilter { $null -ne $Remove }
                }
            }

            Context 'Remove all SPNs' {
                Mock -CommandName Set-ADObject
                Mock -CommandName Get-ADObject -ParameterFilter {
                    $Filter -eq ([ScriptBlock]::Create(' ServicePrincipalName -eq $ServicePrincipalName '))
                } -MockWith {
                    [PSCustomObject] @{
                        SamAccountName = 'User'
                        DistinguishedName = 'CN=User,OU=Corp,DC=contoso,DC=com'
                    }
                }

                It 'Should call the Set-ADObject' {
                    { Set-TargetResource @testAbsentParams } | Should -Not -Throw

                    Assert-MockCalled -CommandName Set-ADObject -Scope It -Times 1 -Exactly
                }
            }
        }
        #endregion
    }
}
finally
{
    Invoke-TestCleanup
}
