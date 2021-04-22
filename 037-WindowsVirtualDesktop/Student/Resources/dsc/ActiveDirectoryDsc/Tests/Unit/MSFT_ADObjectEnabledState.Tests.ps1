Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADObjectEnabledState'

#region HEADER

# Unit Test Template Version: 1.2.4
$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git', (Join-Path -Path $script:moduleRoot -ChildPath 'DscResource.Tests'))
}

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force

# TODO: Insert the correct <ModuleName> and <ResourceName> for your resource
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

        $mockComputerNamePresent = 'TEST01'
        $mockDomain = 'contoso.com'
        $mockEnabled = $true
        $mockDisabled = $false
        $mockObjectClass_Computer = 'Computer'
        $mockDomainController = 'DC01'

        $mockCredentialUserName = 'COMPANY\User'
        $mockCredentialPassword = 'dummyPassw0rd' | ConvertTo-SecureString -AsPlainText -Force
        $mockCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
            $mockCredentialUserName, $mockCredentialPassword
        )

        Describe 'MSFT_ADObjectEnabledState\Get-TargetResource' -Tag 'Get' {
            BeforeAll {
                Mock -CommandName Assert-Module
            }

            Context 'When the system is not in the desired state' {
                Context 'When the Get-ADComputer throws an unknown error' {
                    BeforeAll {
                        $errorMessage = 'Mocked error'
                        Mock -CommandName Get-ADComputer -MockWith {
                            throw $errorMessage
                        }

                        $getTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $false
                            Verbose     = $true
                        }
                    }

                    It 'Should throw the correct error' {
                        { Get-TargetResource @getTargetResourceParameters } | Should -Throw $errorMessage

                        Assert-MockCalled -CommandName Get-ADComputer -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the computer account is absent in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-ADComputer -MockWith {
                            throw New-Object -TypeName 'Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException'
                        }

                        $getTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $false
                            Verbose     = $true
                        }
                    }

                    It 'Should throw the correct error' {
                        { Get-TargetResource @getTargetResourceParameters } | Should -Throw ($script:localizedData.FailedToRetrieveComputerAccount -f $mockComputerNamePresent)

                        Assert-MockCalled -CommandName Get-ADComputer -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is in the desired state' {
                BeforeEach {
                    Mock -CommandName Get-ADComputer -MockWith {
                        return @{
                            CN          = $mockComputerNamePresent
                            Enabled     = $mockDynamicEnabledProperty
                            ObjectClass = $mockObjectClass
                        }
                    }
                }

                Context 'When the computer account is present in Active Directory' {
                    Context 'When the computer account is enabled' {
                        BeforeAll {
                            $mockDynamicEnabledProperty = $mockEnabled

                            $getTargetResourceParameters = @{
                                Identity         = $mockComputerNamePresent
                                ObjectClass      = $mockObjectClass_Computer
                                DomainController = $mockDomainController
                                Credential       = $mockCredential
                                Enabled          = $false
                                Verbose          = $true
                            }
                        }

                        It 'Should return the same values as passed as parameters' {
                            $result = Get-TargetResource @getTargetResourceParameters
                            $result.Identity | Should -Be $getTargetResourceParameters.Identity
                            $result.ObjectClass | Should -Be $getTargetResourceParameters.ObjectClass
                            $result.DomainController | Should -Be $getTargetResourceParameters.DomainController
                            $result.Credential.UserName | Should -Be $getTargetResourceParameters.Credential.UserName

                            Assert-MockCalled -CommandName Get-ADComputer -Exactly -Times 1 -Scope It
                        }

                        It 'Should return correct values for the rest of the properties' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                            $getTargetResourceResult.Enabled | Should -BeTrue
                        }
                    }

                    Context 'When the computer account is disabled' {
                        BeforeAll {
                            $mockDynamicEnabledProperty = $mockDisabled

                            $getTargetResourceParameters = @{
                                Identity         = $mockComputerNamePresent
                                ObjectClass      = $mockObjectClass_Computer
                                DomainController = $mockDomainController
                                Credential       = $mockCredential
                                Enabled          = $true
                                Verbose          = $true
                            }
                        }

                        It 'Should return the same values as passed as parameters' {
                            $result = Get-TargetResource @getTargetResourceParameters
                            $result.Identity | Should -Be $getTargetResourceParameters.Identity
                            $result.ObjectClass | Should -Be $getTargetResourceParameters.ObjectClass
                            $result.DomainController | Should -Be $getTargetResourceParameters.DomainController
                            $result.Credential.UserName | Should -Be $getTargetResourceParameters.Credential.UserName

                            Assert-MockCalled -CommandName Get-ADComputer -Exactly -Times 1 -Scope It
                        }

                        It 'Should return correct values for the rest of the properties' {
                            $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                            $getTargetResourceResult.Enabled | Should -BeFalse
                        }
                    }
                }

                Context 'When Get-TargetResource is called with only mandatory parameters' {
                    BeforeAll {
                        $mockDynamicEnabledProperty = $mockEnabled

                        $getTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $false
                            Verbose     = $true
                        }
                    }

                    It 'Should only call Get-ADComputer with only Identity parameter' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                        Assert-MockCalled -CommandName Get-ADComputer -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Identity') `
                                -and -not $PSBoundParameters.ContainsKey('Server') `
                                -and -not $PSBoundParameters.ContainsKey('Credential')
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When Get-TargetResource is called with DomainController parameter' {
                    BeforeAll {
                        $mockDynamicEnabledProperty = $mockEnabled

                        $getTargetResourceParameters = @{
                            Identity         = $mockComputerNamePresent
                            ObjectClass      = $mockObjectClass_Computer
                            Enabled          = $false
                            DomainController = $mockDomainController
                            Verbose          = $true
                        }
                    }

                    It 'Should only call Get-ADComputer with Identity and Server parameter' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                        Assert-MockCalled -CommandName Get-ADComputer -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Identity') `
                                -and $PSBoundParameters.ContainsKey('Server') `
                                -and -not $PSBoundParameters.ContainsKey('Credential')
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When Get-TargetResource is called with Credential parameter' {
                    BeforeAll {
                        $mockDynamicEnabledProperty = $mockEnabled

                        $getTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $false
                            Credential  = $mockCredential
                            Verbose     = $true
                        }
                    }

                    It 'Should only call Get-ADComputer with Identity and Credential parameter' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters

                        Assert-MockCalled -CommandName Get-ADComputer -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Identity') `
                                -and -not $PSBoundParameters.ContainsKey('Server') `
                                -and $PSBoundParameters.ContainsKey('Credential')
                        } -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

        Describe 'MSFT_ADObjectEnabledState\Test-TargetResource' -Tag 'Test' {
            BeforeAll {
                Mock -CommandName Assert-Module

                $mockGetTargetResource_Enabled = {
                    return @{
                        Identity         = $null
                        ObjectClass      = $mockObjectClass_Computer
                        Enabled          = $true
                        DomainController = $mockDomainController
                        Credential       = $mockCredential
                    }
                }

                $mockGetTargetResource_Disabled = {
                    return @{
                        Identity         = $null
                        ObjectClass      = $mockObjectClass_Computer
                        Enabled          = $false
                        DomainController = $mockDomainController
                        Credential       = $mockCredential
                    }
                }
            }

            Context 'When the system is in the desired state' {
                Context 'When the computer account is disabled in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource $mockGetTargetResource_Disabled

                        $testTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $false
                            Verbose     = $true
                        }
                    }

                    It 'Should return $true' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the computer account is enabled in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Enabled

                        $testTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $true
                            Verbose     = $true
                        }
                    }

                    It 'Should return $true' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the computer account should be enabled in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource $mockGetTargetResource_Disabled

                        $testTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $true
                            Verbose     = $true
                        }
                    }

                    It 'Should return $false' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the computer account should be disabled in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Enabled

                        $testTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $false
                            Verbose     = $true
                        }
                    }

                    It 'Should return $false' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

        Describe 'MSFT_ADObjectEnabledState\Set-TargetResource' -Tag 'Set' {
            BeforeAll {
                Mock -CommandName Assert-Module
                Mock -CommandName Set-DscADComputer

                $mockGetTargetResource_Enabled = {
                    return @{
                        Identity         = $null
                        ObjectClass      = $mockObjectClass_Computer
                        Enabled          = $true
                        DomainController = $mockDomainController
                        Credential       = $mockCredential
                    }
                }

                $mockGetTargetResource_Disabled = {
                    return @{
                        Identity         = $null
                        ObjectClass      = $mockObjectClass_Computer
                        Enabled          = $false
                        DomainController = $mockDomainController
                        Credential       = $mockCredential
                    }
                }
            }

            Context 'When the system is in the desired state' {
                Context 'When the computer account is enabled in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Enabled

                        $setTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $true
                            Verbose     = $true
                        }
                    }

                    It 'Should not call any mocks that changes state' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When the computer account is disabled in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Disabled

                        $setTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $false
                            Verbose     = $true
                        }
                    }

                    It 'Should not call any mocks that changes state' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the computer account should be enabled in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Disabled

                        $setTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $true
                            Verbose     = $true
                        }
                    }

                    It 'Should call the correct mocks' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Set-DscADComputer -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Enabled') -and $Enabled -eq $true
                        } -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When the computer account should be disabled in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Enabled

                        $setTargetResourceParameters = @{
                            Identity    = $mockComputerNamePresent
                            ObjectClass = $mockObjectClass_Computer
                            Enabled     = $false
                            Verbose     = $true
                        }
                    }

                    It 'Should call the correct mocks' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Set-DscADComputer -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Enabled') -and $Enabled -eq $false
                        } -Exactly -Times 0 -Scope It
                    }
                }
            }
        }
    }
}
finally
{
    Invoke-TestCleanup
}
