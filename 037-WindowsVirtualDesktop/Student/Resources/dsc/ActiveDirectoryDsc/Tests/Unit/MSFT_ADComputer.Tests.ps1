Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADComputer'

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

        $mockComputerNamePresent = 'TEST01'
        $mockDomain = 'contoso.com'
        $mockComputerNameAbsent = 'MISSING01'
        $mockLocation = 'Test location'
        $mockDnsHostName = '{0}.{1}' -f $mockComputerNamePresent, $mockDomain
        $mockServicePrincipalNames_DefaultValues = @(
            ('TERMSRV/{0}' -f $mockComputerNamePresent),
            ('TERMSRV/{0}.{1}' -f $mockComputerNamePresent, $mockDomain)
        )
        $mockServicePrincipalNames = @('spn/a', 'spn/b')
        $mockUserPrincipalName = '{0}@contoso.com' -f $mockComputerNamePresent
        $mockDisplayName = $mockComputerNamePresent
        $mockDescription = 'Test description'
        $mockEnabled = $true
        $mockManagedBy = 'CN=Manager,CN=Users,DC=contoso,DC=com'
        $mockDistinguishedName = 'CN={0},CN=Computers,DC=contoso,DC=com' -f $mockComputerNamePresent
        $mockSamAccountName = '{0}$' -f $mockComputerNamePresent
        $mockSID = 'S-1-5-21-1409167834-891301383-2860967316-1143'
        $mockObjectClass = 'Computer'
        $mockParentContainer = 'CN=Computers,DC=contoso,DC=com'

        $mockCredentialUserName = 'COMPANY\User'
        $mockCredentialPassword = 'dummyPassw0rd' | ConvertTo-SecureString -AsPlainText -Force
        $mockCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
            $mockCredentialUserName, $mockCredentialPassword
        )

        Describe 'MSFT_ADComputer\Get-TargetResource' -Tag 'Get' {
            BeforeAll {
                Mock -CommandName Assert-Module

                $mockGetADComputer = {
                    return @{
                        CN                    = $mockComputerNamePresent
                        Location              = $mockLocation
                        DnsHostName           = $mockDnsHostName
                        ServicePrincipalNames = $mockServicePrincipalNames + $mockServicePrincipalNames_DefaultValues
                        UserPrincipalName     = $mockUserPrincipalName
                        DisplayName           = $mockDisplayName
                        Description           = $mockDescription
                        Enabled               = $mockEnabled
                        ManagedBy             = $mockManagedBy
                        DistinguishedName     = $mockDistinguishedName
                        SamAccountName        = $mockSamAccountName
                        SID                   = $mockSID
                        ObjectClass           = $mockObjectClass
                    }
                }
            }

            Context 'When the Get-ADComputer throws an unhandled error' {
                BeforeAll {
                    $errorMessage = 'Mocked error'
                    Mock -CommandName Get-ADComputer -MockWith {
                        throw $errorMessage
                    }

                    $getTargetResourceParameters = @{
                        ComputerName = $mockComputerNamePresent
                    }
                }

                It 'Should return the state as absent' {
                    { Get-TargetResource @getTargetResourceParameters } | Should -Throw $errorMessage

                    Assert-MockCalled -CommandName Get-ADComputer -Exactly -Times 1 -Scope It
                }
            }

            Context 'When the system is in the desired state' {
                Context 'When the computer account is absent in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-ADComputer -MockWith {
                            throw New-Object -TypeName 'Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException'
                        }

                        $getTargetResourceParameters = @{
                            ComputerName          = $mockComputerNamePresent
                            DomainController      = 'DC01'
                            Credential            = $mockCredential
                            RequestFile           = 'TestDrive:\ODJ.txt'
                            RestoreFromRecycleBin = $false
                            EnabledOnCreation     = $false
                            Verbose               = $true
                        }
                    }

                    It 'Should return the state as absent' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.Ensure | Should -Be 'Absent'

                        Assert-MockCalled -CommandName Get-ADComputer -Exactly -Times 1 -Scope It
                    }

                    It 'Should return the same values as passed as parameters' {
                        $result = Get-TargetResource @getTargetResourceParameters
                        $result.DomainController | Should -Be $getTargetResourceParameters.DomainController
                        $result.Credential.UserName | Should -Be $getTargetResourceParameters.Credential.UserName
                        $result.RequestFile | Should -Be $getTargetResourceParameters.RequestFile
                        $result.RestoreFromRecycleBin | Should -Be $getTargetResourceParameters.RestoreFromRecycleBin
                        $result.EnabledOnCreation | Should -Be $getTargetResourceParameters.EnabledOnCreation
                    }

                    It 'Should return $null for the rest of the properties' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.ComputerName | Should -BeNullOrEmpty
                        $getTargetResourceResult.Location | Should -BeNullOrEmpty
                        $getTargetResourceResult.DnsHostName | Should -BeNullOrEmpty
                        $getTargetResourceResult.ServicePrincipalNames | Should -BeNullOrEmpty
                        $getTargetResourceResult.UserPrincipalName | Should -BeNullOrEmpty
                        $getTargetResourceResult.DisplayName | Should -BeNullOrEmpty
                        $getTargetResourceResult.Path | Should -BeNullOrEmpty
                        $getTargetResourceResult.Description | Should -BeNullOrEmpty
                        $getTargetResourceResult.Enabled | Should -BeFalse
                        $getTargetResourceResult.Manager | Should -BeFalse
                        $getTargetResourceResult.DistinguishedName | Should -BeNullOrEmpty
                        $getTargetResourceResult.SID | Should -BeNullOrEmpty
                        $getTargetResourceResult.SamAccountName | Should -BeNullOrEmpty
                    }
                }

                Context 'When the computer account is present in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-ADComputer -MockWith $mockGetADComputer

                        $getTargetResourceParameters = @{
                            ComputerName          = $mockComputerNamePresent
                            DomainController      = 'DC01'
                            Credential            = $mockCredential
                            RequestFile           = 'TestDrive:\ODJ.txt'
                            RestoreFromRecycleBin = $false
                            EnabledOnCreation     = $false
                            Verbose               = $true
                        }
                    }

                    It 'Should return the state as present' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.Ensure | Should -Be 'Present'

                        Assert-MockCalled -CommandName Get-ADComputer -Exactly -Times 1 -Scope It
                    }

                    It 'Should return the same values as passed as parameters' {
                        $result = Get-TargetResource @getTargetResourceParameters
                        $result.DomainController | Should -Be $getTargetResourceParameters.DomainController
                        $result.Credential.UserName | Should -Be $getTargetResourceParameters.Credential.UserName
                        $result.RequestFile | Should -Be $getTargetResourceParameters.RequestFile
                        $result.RestoreFromRecycleBin | Should -Be $getTargetResourceParameters.RestoreFromRecycleBin
                        $result.EnabledOnCreation | Should -Be $getTargetResourceParameters.EnabledOnCreation
                    }

                    It 'Should return correct values for the rest of the properties' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.ComputerName | Should -Be $mockComputerNamePresent
                        $getTargetResourceResult.Location | Should -Be $mockLocation
                        $getTargetResourceResult.DnsHostName | Should -Be $mockDnsHostName
                        $getTargetResourceResult.ServicePrincipalNames | Should -Be ($mockServicePrincipalNames + $mockServicePrincipalNames_DefaultValues)
                        $getTargetResourceResult.UserPrincipalName | Should -Be $mockUserPrincipalName
                        $getTargetResourceResult.DisplayName | Should -Be $mockDisplayName
                        $getTargetResourceResult.Path | Should -Be $mockParentContainer
                        $getTargetResourceResult.Description | Should -Be $mockDescription
                        $getTargetResourceResult.Enabled | Should -BeTrue
                        $getTargetResourceResult.Manager | Should -Be $mockManagedBy
                        $getTargetResourceResult.DistinguishedName | Should -Be $mockDistinguishedName
                        $getTargetResourceResult.SID | Should -Be $mockSID
                        $getTargetResourceResult.SamAccountName | Should -Be $mockSamAccountName
                    }
                }

                Context 'When Get-TargetResource is called with only mandatory parameters' {
                    BeforeAll {
                        Mock -CommandName Get-ADComputer -MockWith $mockGetADComputer

                        $getTargetResourceParameters = @{
                            ComputerName = $mockComputerNamePresent
                            Verbose      = $true
                        }
                    }

                    It 'Should only call Get-ADComputer with only Identity parameter' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.Ensure | Should -Be 'Present'

                        Assert-MockCalled -CommandName Get-ADComputer -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Identity') `
                                -and -not $PSBoundParameters.ContainsKey('Server') `
                                -and -not $PSBoundParameters.ContainsKey('Credential')
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When Get-TargetResource is called with DomainController parameter' {
                    BeforeAll {
                        Mock -CommandName Get-ADComputer -MockWith $mockGetADComputer

                        $getTargetResourceParameters = @{
                            ComputerName     = $mockComputerNamePresent
                            DomainController = 'DC01'
                            Verbose          = $true
                        }
                    }

                    It 'Should only call Get-ADComputer with Identity and Server parameter' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.Ensure | Should -Be 'Present'

                        Assert-MockCalled -CommandName Get-ADComputer -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Identity') `
                                -and $PSBoundParameters.ContainsKey('Server') `
                                -and -not $PSBoundParameters.ContainsKey('Credential')
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When Get-TargetResource is called with Credential parameter' {
                    BeforeAll {
                        Mock -CommandName Get-ADComputer -MockWith $mockGetADComputer

                        $getTargetResourceParameters = @{
                            ComputerName = $mockComputerNamePresent
                            Credential   = $mockCredential
                            Verbose      = $true
                        }
                    }

                    It 'Should only call Get-ADComputer with Identity and Credential parameter' {
                        $getTargetResourceResult = Get-TargetResource @getTargetResourceParameters
                        $getTargetResourceResult.Ensure | Should -Be 'Present'

                        Assert-MockCalled -CommandName Get-ADComputer -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Identity') `
                                -and -not $PSBoundParameters.ContainsKey('Server') `
                                -and $PSBoundParameters.ContainsKey('Credential')
                        } -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

        Describe 'MSFT_ADComputer\Test-TargetResource' -Tag 'Test' {
            BeforeAll {
                Mock -CommandName Assert-Module

                $mockGetTargetResource_Absent = {
                    return @{
                        Ensure                = 'Absent'
                        ComputerName          = $null
                        Location              = $null
                        DnsHostName           = $null
                        ServicePrincipalNames = $null
                        UserPrincipalName     = $null
                        DisplayName           = $null
                        Path                  = $null
                        Description           = $null
                        Enabled               = $false
                        Manager               = $null
                        DomainController      = $null
                        Credential            = $null
                        RequestFile           = $null
                        RestoreFromRecycleBin = $false
                        EnabledOnCreation     = $false
                        DistinguishedName     = $null
                        SID                   = $null
                        SamAccountName        = $null
                    }
                }

                $mockGetTargetResource_Present = {
                    return @{
                        Ensure                = 'Present'
                        ComputerName          = $mockComputerNamePresent
                        Location              = $mockLocation
                        DnsHostName           = $mockDnsHostName
                        ServicePrincipalNames = $mockServicePrincipalNames
                        UserPrincipalName     = $mockUserPrincipalName
                        DisplayName           = $mockDisplayName
                        Path                  = $mockParentContainer
                        Description           = $mockDescription
                        Enabled               = $true
                        Manager               = $mockManagedBy
                        DomainController      = 'DC01'
                        Credential            = $mockCredential
                        RequestFile           = 'TestDrive:\ODJ.txt'
                        RestoreFromRecycleBin = $false
                        EnabledOnCreation     = $false
                        DistinguishedName     = $mockDistinguishedName
                        SID                   = $mockSID
                        SamAccountName        = $mockSamAccountName
                    }
                }
            }

            Context 'When the system is in the desired state' {
                Context 'When the computer account is absent in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource $mockGetTargetResource_Absent

                        $testTargetResourceParameters = @{
                            Ensure       = 'Absent'
                            ComputerName = $mockComputerNamePresent
                            Verbose      = $true
                        }
                    }

                    It 'Should return $true' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the computer account is present in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present

                        $testTargetResourceParameters = @{
                            ComputerName          = $mockComputerNamePresent
                            DomainController      = 'DC01'
                            Credential            = $mockCredential
                            RequestFile           = 'TestDrive:\ODJ.txt'
                            RestoreFromRecycleBin = $false
                            EnabledOnCreation     = $false
                            Verbose               = $true
                        }
                    }

                    It 'Should return $true' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When service principal names are in desired state' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present

                        $testTargetResourceParameters = @{
                            ComputerName          = $mockComputerNamePresent
                            ServicePrincipalNames = $mockServicePrincipalNames
                            Verbose               = $true
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
                Context 'When the computer account is absent in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Absent

                        $testTargetResourceParameters = @{
                            Ensure       = 'Present'
                            ComputerName = $mockComputerNamePresent
                            Verbose      = $true
                        }
                    }

                    It 'Should return $false' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the computer account is present in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present

                        $testTargetResourceParameters = @{
                            Ensure       = 'Absent'
                            ComputerName = $mockComputerNamePresent
                            Verbose      = $true
                        }
                    }

                    It 'Should return $false' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When a property is not in desired state' {
                    BeforeAll {
                        # Mock a specific desired state.
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present
                    }

                    Context 'When a property should be set to a new non-empty value' {
                        BeforeAll {
                            # One test case per property with a value that differs from the desired state.
                            $testCases_Properties = @(
                                @{
                                    ParameterName = 'Location'
                                    Value         = 'NewLocation'
                                },
                                @{
                                    ParameterName = 'DnsHostName'
                                    Value         = 'New@contoso.com'
                                },
                                @{
                                    ParameterName = 'ServicePrincipalNames'
                                    Value         = @('spn/new')
                                },
                                @{
                                    ParameterName = 'UserPrincipalName'
                                    Value         = 'New@contoso.com'
                                },
                                @{
                                    ParameterName = 'DisplayName'
                                    Value         = 'New'
                                },
                                @{
                                    ParameterName = 'Path'
                                    Value         = 'OU=New,CN=Computers,DC=contoso,DC=com'
                                },
                                @{
                                    ParameterName = 'Description'
                                    Value         = 'New description'
                                },
                                @{
                                    ParameterName = 'Manager'
                                    Value         = 'CN=NewManager,CN=Users,DC=contoso,DC=com'
                                }
                            )
                        }

                        It 'Should return $false when non-empty property <ParameterName> is not in desired state' -TestCases $testCases_Properties {
                            param
                            (
                                [Parameter()]
                                $ParameterName,

                                [Parameter()]
                                $Value
                            )

                            $testTargetResourceParameters = @{
                                ComputerName   = $mockComputerNamePresent
                                $ParameterName = $Value
                            }

                            $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                            $testTargetResourceResult | Should -BeFalse

                            Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                        }

                    }

                    Context 'When a property should be set to an empty value' {
                        BeforeAll {
                            $testCases_Properties = @(
                                @{
                                    ParameterName = 'Location'
                                    Value         = ''
                                },
                                @{
                                    ParameterName = 'DnsHostName'
                                    Value         = ''
                                },
                                @{
                                    ParameterName = 'ServicePrincipalNames'
                                    Value         = ''
                                },
                                @{
                                    ParameterName = 'ServicePrincipalNames'
                                    Value         = @()
                                },
                                @{
                                    ParameterName = 'UserPrincipalName'
                                    Value         = ''
                                },
                                @{
                                    ParameterName = 'DisplayName'
                                    Value         = ''
                                },
                                @{
                                    ParameterName = 'Path'
                                    Value         = ''
                                },
                                @{
                                    ParameterName = 'Description'
                                    Value         = ''
                                },
                                @{
                                    ParameterName = 'Manager'
                                    Value         = ''
                                }
                            )
                        }

                        It 'Should return $false when empty property <ParameterName> is not in desired state' -TestCases $testCases_Properties {
                            param
                            (
                                [Parameter()]
                                $ParameterName,

                                [Parameter()]
                                $Value
                            )

                            $testTargetResourceParameters = @{
                                ComputerName   = $mockComputerNamePresent
                                $ParameterName = $Value
                                Verbose        = $true
                            }

                            $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                            $testTargetResourceResult | Should -BeFalse

                            Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                        }
                    }
                }
            }
        }

        Describe 'MSFT_ADComputer\Set-TargetResource' -Tag 'Set' {
            BeforeAll {
                Mock -CommandName Assert-Module

                $mockGetTargetResource_Absent = {
                    return @{
                        Ensure                = 'Absent'
                        ComputerName          = $null
                        Location              = $null
                        DnsHostName           = $null
                        ServicePrincipalNames = $null
                        UserPrincipalName     = $null
                        DisplayName           = $null
                        Path                  = $null
                        Description           = $null
                        Enabled               = $false
                        Manager               = $null
                        DomainController      = $null
                        Credential            = $null
                        RequestFile           = $null
                        RestoreFromRecycleBin = $false
                        EnabledOnCreation     = $false
                        DistinguishedName     = $null
                        SID                   = $null
                        SamAccountName        = $null
                    }
                }

                $mockGetTargetResource_Present = {
                    return @{
                        Ensure                = 'Present'
                        ComputerName          = $mockComputerNamePresent
                        Location              = $mockLocation
                        DnsHostName           = $mockDnsHostName
                        ServicePrincipalNames = $mockServicePrincipalNames_DefaultValues
                        UserPrincipalName     = $mockUserPrincipalName
                        DisplayName           = $mockDisplayName
                        Path                  = $mockParentContainer
                        Description           = $mockDescription
                        Enabled               = $true
                        Manager               = $mockManagedBy
                        DomainController      = 'DC01'
                        Credential            = $mockCredential
                        RequestFile           = 'TestDrive:\ODJ.txt'
                        RestoreFromRecycleBin = $false
                        EnabledOnCreation     = $false
                        DistinguishedName     = $mockDistinguishedName
                        SID                   = $mockSID
                        SamAccountName        = $mockSamAccountName
                    }
                }
            }

            Context 'When the system is in the desired state' {
                BeforeAll {
                    Mock -CommandName Remove-ADComputer
                    Mock -CommandName Set-DscADComputer
                    Mock -CommandName New-ADComputer
                    Mock -CommandName Move-ADObject
                }

                Context 'When the computer account is absent in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Absent

                        $setTargetResourceParameters = @{
                            Ensure       = 'Absent'
                            ComputerName = $mockComputerNamePresent
                            Verbose      = $true
                        }
                    }

                    It 'Should not call any mocks that changes state' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When the computer account is present in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present

                        $setTargetResourceParameters = @{
                            ComputerName          = $mockComputerNamePresent
                            DomainController      = 'DC01'
                            Credential            = $mockCredential
                            RequestFile           = 'TestDrive:\ODJ.txt'
                            RestoreFromRecycleBin = $false
                            EnabledOnCreation     = $false
                            Verbose               = $true
                        }
                    }

                    It 'Should not call any mocks that changes state' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When service principal names are in desired state' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present

                        $setTargetResourceParameters = @{
                            ComputerName          = $mockComputerNamePresent
                            ServicePrincipalNames = $mockServicePrincipalNames_DefaultValues
                            Verbose               = $true
                        }
                    }

                    It 'Should not call any mocks that changes state' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                BeforeAll {
                    Mock -CommandName Remove-ADComputer
                    Mock -CommandName Set-DscADComputer
                    Mock -CommandName Move-ADObject
                    Mock -CommandName New-ADComputer -MockWith {
                        $script:mockNewADComputerWasCalled = $true
                    }

                }

                Context 'When the computer account is absent from Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            if (-not $script:mockNewADComputerWasCalled)
                            {
                                # First call.
                                $mockGetTargetResourceResult = & $mockGetTargetResource_Absent
                            }
                            else
                            {
                                # Second call - After New-ADComputer has been called.
                                $mockGetTargetResourceResult = & $mockGetTargetResource_Present
                            }

                            return $mockGetTargetResourceResult
                        }
                    }

                    BeforeEach {
                        $script:mockNewADComputerWasCalled = $false
                    }

                    Context 'When the computer account is created on the default path' {
                        BeforeAll {
                            $setTargetResourceParameters = @{
                                Ensure       = 'Present'
                                ComputerName = $mockComputerNamePresent
                                Verbose      = $true
                            }
                        }

                        It 'Should call the correct mocks' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                        }
                    }

                    Context 'When the computer account is created on the specified path' {
                        BeforeAll {
                            $setTargetResourceParameters = @{
                                Ensure       = 'Present'
                                ComputerName = $mockComputerNamePresent
                                Path         = $mockParentContainer
                                Verbose      = $true
                            }
                        }

                        It 'Should call the correct mocks' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                        }
                    }
                }

                Context 'When the computer account is present in Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present

                        $setTargetResourceParameters = @{
                            Ensure       = 'Absent'
                            ComputerName = $mockComputerNamePresent
                            Verbose      = $true
                        }
                    }

                    It 'Should call the correct mocks' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When the computer account should be force to be created enabled' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Absent

                        $setTargetResourceParameters = @{
                            ComputerName      = $mockComputerNamePresent
                            EnabledOnCreation = $true
                            Verbose           = $true
                        }
                    }

                    It 'Should call the correct mocks' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName New-ADComputer -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Enabled') -and $Enabled -eq $true
                        } -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When the computer account should be force to be created disabled' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Absent

                        $setTargetResourceParameters = @{
                            ComputerName      = $mockComputerNamePresent
                            EnabledOnCreation = $false
                            Verbose           = $true
                        }
                    }

                    It 'Should call the correct mocks' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName New-ADComputer -ParameterFilter {
                            $PSBoundParameters.ContainsKey('Enabled') -and $Enabled -eq $false
                        } -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When the computer account should be created using offline domain join (ODJ) request file' {
                    BeforeAll {
                        Mock -CommandName Wait-Process
                        Mock -CommandName Get-TargetResource -MockWith {
                            if (-not $script:mockSuccessDomainJoin)
                            {
                                # First call.
                                $mockGetTargetResourceResult = & $mockGetTargetResource_Absent
                            }
                            else
                            {
                                <#
                                    Second call - After Offline Domain Join request file has been
                                    created and the computer account has been provisioned.
                                #>
                                $mockGetTargetResourceResult = & $mockGetTargetResource_Present
                            }

                            return $mockGetTargetResourceResult
                        }

                        Mock -CommandName Get-DomainName -MockWith {
                            return $mockDomain
                        }

                        Mock -CommandName Start-ProcessWithTimeout -MockWith {
                            $script:mockSuccessDomainJoin = $true

                            return 0
                        }

                        $setTargetResourceParameters = @{
                            ComputerName     = $mockComputerNamePresent
                            Path             = $mockParentContainer
                            DomainController = 'dc01.contoso.com'
                            RequestFile      = 'c:\ODJTest.txt'
                            Verbose          = $true
                        }
                    }

                    BeforeEach {
                        $script:mockSuccessDomainJoin = $false
                    }

                    It 'Should call the correct mocks' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw


                        Assert-MockCalled -CommandName Start-ProcessWithTimeout -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When an offline domain join (ODJ) request file fails to be created' {
                    BeforeAll {
                        Mock -CommandName Wait-Process
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Absent
                        Mock -CommandName Get-DomainName -MockWith {
                            return $mockDomain
                        }

                        # ExitCode for 'The parameter is incorrect.'.
                        $mockExitCode = 87

                        Mock -CommandName Start-ProcessWithTimeout -MockWith {
                            return $mockExitCode
                        }

                        $setTargetResourceParameters = @{
                            ComputerName = $mockComputerNamePresent
                            RequestFile  = 'c:\ODJTest.txt'
                            Verbose      = $true
                        }
                    }

                    It 'Should throw the correct error' {
                        { Set-TargetResource @setTargetResourceParameters } | Should -Throw ($script:localizedData.FailedToCreateOfflineDomainJoinRequest -f $mockComputerNamePresent, $mockExitCode)

                        Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When a property is not in desired state' {
                    BeforeAll {
                        # Mock a specific desired state.
                        Mock -CommandName Get-TargetResource -MockWith $mockGetTargetResource_Present
                    }

                    Context 'When a property should be replaced' {
                        BeforeAll {
                            # One test case per property with a value that differs from the desired state.
                            $testCases_Properties = @(
                                @{
                                    PropertyName = 'Location'
                                    Value        = 'NewLocation'
                                },
                                @{
                                    PropertyName = 'DnsHostName'
                                    Value        = 'New@contoso.com'
                                },
                                @{
                                    ParameterName = 'ServicePrincipalNames'
                                    PropertyName  = 'ServicePrincipalName'
                                    Value         = @('spn/new')
                                },
                                @{
                                    PropertyName = 'UserPrincipalName'
                                    Value        = 'New@contoso.com'
                                },
                                @{
                                    PropertyName = 'DisplayName'
                                    Value        = 'New'
                                },
                                @{
                                    PropertyName = 'Description'
                                    Value        = 'New description'
                                },
                                @{
                                    ParameterName = 'Manager'
                                    PropertyName  = 'ManagedBy'
                                    Value         = 'CN=NewManager,CN=Users,DC=contoso,DC=com'
                                }
                            )
                        }

                        It 'Should set the correct property when property <PropertyName> is not in desired state' -TestCases $testCases_Properties {
                            param
                            (
                                [Parameter()]
                                $PropertyName,

                                [Parameter()]
                                $ParameterName = $PropertyName,

                                [Parameter()]
                                $Value
                            )

                            $setTargetResourceParameters = @{
                                ComputerName   = $mockComputerNamePresent
                                $ParameterName = $Value
                                Verbose        = $true
                            }

                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName Set-DscADComputer -ParameterFilter {
                                $Parameters.Replace.ContainsKey($PropertyName) -eq $true
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When a property should be removed' {
                        BeforeAll {
                            # One test case per property with a value that differs from the desired state.
                            $testCases_Properties = @(
                                @{
                                    PropertyName = 'Location'
                                    Value        = $null
                                },
                                @{
                                    PropertyName = 'DnsHostName'
                                    Value        = $null
                                },
                                @{
                                    ParameterName = 'ServicePrincipalNames'
                                    PropertyName  = 'ServicePrincipalName'
                                    Value         = @()
                                },
                                @{
                                    PropertyName = 'UserPrincipalName'
                                    Value        = $null
                                },
                                @{
                                    PropertyName = 'DisplayName'
                                    Value        = $null
                                },
                                @{
                                    PropertyName = 'Description'
                                    Value        = $null
                                },
                                @{
                                    ParameterName = 'Manager'
                                    PropertyName  = 'ManagedBy'
                                    Value         = $null
                                }
                            )
                        }

                        It 'Should set the correct property when property <PropertyName> is not in desired state' -TestCases $testCases_Properties {
                            param
                            (
                                [Parameter()]
                                $PropertyName,

                                [Parameter()]
                                $ParameterName = $PropertyName,

                                [Parameter()]
                                $Value
                            )

                            $setTargetResourceParameters = @{
                                ComputerName   = $mockComputerNamePresent
                                $ParameterName = $Value
                                Verbose        = $true
                            }

                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName Set-DscADComputer -ParameterFilter {
                                $Parameters.Remove.ContainsKey($PropertyName) -eq $true
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When the computer account should be moved' {
                        BeforeAll {
                            $setTargetResourceParameters = @{
                                ComputerName = $mockComputerNamePresent
                                Path         = 'OU=New,CN=Computers,DC=contoso,DC=com'
                                Verbose      = $true
                            }
                        }

                        It 'Should call the correct mock to move the computer account' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            Assert-MockCalled -CommandName Remove-ADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                            Assert-MockCalled -CommandName Move-ADObject -Exactly -Times 1 -Scope It
                        }
                    }
                }

                Context 'When RestoreFromRecycleBin is used' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            if (-not $script:mockRestoreADCommonObjectSuccessfullyRestoredObject)
                            {
                                # First call.
                                $mockGetTargetResourceResult = & $mockGetTargetResource_Absent
                            }
                            else
                            {
                                # Second call - After Restore-ADCommonObject has been called.
                                $mockGetTargetResourceResult = & $mockGetTargetResource_Present
                            }

                            return $mockGetTargetResourceResult
                        }

                        $setTargetResourceParameters = @{
                            ComputerName          = $mockComputerNamePresent
                            RestoreFromRecycleBin = $true
                            Verbose               = $true
                        }
                    }

                    BeforeEach {
                        $script:mockRestoreADCommonObjectSuccessfullyRestoredObject = $false
                    }

                    Context 'When the computer object exist in the recycle bin' {
                        BeforeAll {
                            Mock -CommandName Restore-ADCommonObject -MockWith {
                                return @{
                                    ObjectClass = 'computer'
                                }

                                $script:mockRestoreADCommonObjectSuccessfullyRestoredObject = $true
                            }
                        }

                        It 'Should call Restore-ADCommonObject and successfully restore the computer account' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            Assert-MockCalled -CommandName Restore-ADCommonObject -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName New-ADComputer -Times 0 -Exactly -Scope It
                            Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                        }
                    }

                    Context 'When the computer object does not exist in the recycle bin' {
                        BeforeAll {
                            Mock -CommandName Restore-ADCommonObject
                        }

                        It 'Should create a new computer account' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            Assert-MockCalled -CommandName Restore-ADCommonObject -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName New-ADComputer -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Set-DscADComputer -Exactly -Times 0 -Scope It
                        }
                    }

                    Context 'When the cmdlet Restore-ADCommonObject throws an error' {
                        BeforeAll {
                            $errorMessage = 'Mocked error'

                            Mock -CommandName Restore-ADCommonObject -MockWith {
                                throw $errorMessage
                            }
                        }

                        It 'Should throw the correct error' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Throw $errorMessage

                            Assert-MockCalled -CommandName Restore-ADCommonObject -Scope It -Exactly -Times 1
                            Assert-MockCalled -CommandName New-ADComputer -Scope It -Exactly -Times 0
                            Assert-MockCalled -CommandName Set-DscADComputer -Scope It -Exactly -Times 0
                        }
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
