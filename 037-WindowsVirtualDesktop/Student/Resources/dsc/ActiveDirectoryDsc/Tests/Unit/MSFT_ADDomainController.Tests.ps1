[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '')]
param ()

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

#region HEADER
$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADDomainController'

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
        Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'Stubs\ADDSDeployment_2019.psm1') -Force

        #region Pester Test Variable Initialization
        $correctDomainName = 'present.com'
        $testAdminCredential = [System.Management.Automation.PSCredential]::Empty
        $correctDatabasePath = 'C:\Windows\NTDS'
        $correctLogPath = 'C:\Windows\NTDS'
        $correctSysvolPath = 'C:\Windows\SYSVOL'
        $correctSiteName = 'PresentSite'
        $incorrectSiteName = 'IncorrectSite'
        $correctInstallationMediaPath = 'TestDrive:\IFM'
        $mockNtdsSettingsObjectDn = 'CN=NTDS Settings,CN=ServerName,CN=Servers,CN=PresentSite,CN=Sites,CN=Configuration,DC=present,DC=com'
        $allowedAccount = 'allowedAccount'
        $deniedAccount = 'deniedAccount'

        $testDefaultParams = @{
            Credential = $testAdminCredential
            SafeModeAdministratorPassword = $testAdminCredential
            Verbose                       = $true
        }

        $testDefaultParamsRODC = @{
            Credential = $testAdminCredential
            SafeModeAdministratorPassword = $testAdminCredential
            Verbose                       = $true
            ReadOnlyReplica               = $true
            SiteName                      = $correctSiteName
        }
        #endregion Pester Test Variable Initialization

        #region Function Get-TargetResource
        Describe 'ADDomainController\Get-TargetResource' -Tag 'Get' {
            BeforeAll {
                Mock -CommandName Assert-Module
            }

            Context 'When the domain name is not available' {
                BeforeAll {
                    Mock -CommandName Get-ADDomain -MockWith {
                        throw New-Object -TypeName 'Microsoft.ActiveDirectory.Management.ADServerDownException'
                    }
                }

                It 'Should throw the correct error' {
                    { Get-TargetResource @testDefaultParams -DomainName $correctDomainName } | Should -Throw ($script:localizedData.MissingDomain -f $correctDomainName)
                }
            }

            Context 'When the system is in the desired state' {
                Context 'When the node is a Domain Controller' {
                    BeforeAll {
                        Mock -CommandName Get-ADDomain -MockWith { return $true }
                        Mock -CommandName Get-DomainControllerObject {
                            $domainControllerObject = New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController
                            $domainControllerObject.Site = $correctSiteName
                            $domainControllerObject.Domain = $correctDomainName
                            $domainControllerObject.IsGlobalCatalog = $true
                            $domainControllerObject.IsReadOnly = $false
                            $domainControllerObject.OperationMasterRoles = @('DomainNamingMaster','RIDMaster')
                            return $domainControllerObject
                        }

                        Mock -CommandName Get-ItemProperty -ParameterFilter { $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters' } -MockWith {
                            return @{
                                'Database log files path' = 'C:\Windows\NTDS'
                                'DSA Working Directory'   = 'C:\Windows\NTDS'
                            }
                        }

                        Mock -CommandName Get-ItemProperty -ParameterFilter { $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters' } -MockWith {
                            return @{
                                'SysVol' = 'C:\Windows\SYSVOL\sysvol'
                            }
                        }

                        Mock -CommandName Get-ADDomainControllerPasswordReplicationPolicy -ParameterFilter { $Allowed.IsPresent } -MockWith {
                            return $null
                        }

                        Mock -CommandName Get-ADDomainControllerPasswordReplicationPolicy -ParameterFilter { $Denied.IsPresent } -MockWith {
                            return $null
                        }

                        New-Item -Path 'TestDrive:\' -ItemType Directory -Name 'IFM'
                    }

                    It 'Should returns current Domain Controller properties' {
                        $result = Get-TargetResource @testDefaultParams -DomainName $correctDomainName

                        $result.DomainName | Should -Be $correctDomainName
                        $result.DatabasePath | Should -Be $correctDatabasePath
                        $result.LogPath | Should -Be $correctLogPath
                        $result.SysvolPath | Should -Be $correctSysvolPath
                        $result.SiteName | Should -Be $correctSiteName
                        $result.Ensure | Should -BeTrue
                        $result.IsGlobalCatalog | Should -BeTrue
                        $result.ReadOnlyReplica | Should -BeFalse
                        $result.AllowPasswordReplicationAccountName | Should -BeNullOrEmpty
                        $result.DenyPasswordReplicationAccountName | Should -BeNullOrEmpty
                        $result.FlexibleSingleMasterOperationRole | Should -Contain 'DomainNamingMaster'
                        $result.FlexibleSingleMasterOperationRole | Should -Contain 'RIDMaster'
                        $result.InstallDns | Should -BeFalse
                    }
                }

                Context 'When the node is a Read-Only Domain Controller' {
                    BeforeAll {
                        Mock -CommandName Get-ADDomain -MockWith { return $true }
                        Mock -CommandName Get-DomainControllerObject {
                            $domainControllerObject = New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController
                            $domainControllerObject.Site = $correctSiteName
                            $domainControllerObject.Domain = $correctDomainName
                            $domainControllerObject.IsGlobalCatalog = $true
                            $domainControllerObject.IsReadOnly = $true
                            return $domainControllerObject
                        }

                        Mock -CommandName Get-ItemProperty -ParameterFilter { $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters' } -MockWith {
                            return @{
                                'Database log files path' = 'C:\Windows\NTDS'
                                'DSA Working Directory'   = 'C:\Windows\NTDS'
                            }
                        }

                        Mock -CommandName Get-ItemProperty -ParameterFilter { $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters' } -MockWith {
                            return @{
                                'SysVol' = 'C:\Windows\SYSVOL\sysvol'
                            }
                        }

                        Mock -CommandName Get-ADDomainControllerPasswordReplicationPolicy -ParameterFilter { $Allowed.IsPresent } -MockWith {
                            return [PSCustomObject]@{
                                SamAccountName = $allowedAccount
                            }
                        }

                        Mock -CommandName Get-ADDomainControllerPasswordReplicationPolicy -ParameterFilter { $Denied.IsPresent } -MockWith {
                            return [PSCustomObject]@{
                                SamAccountName = $deniedAccount
                            }
                        }

                        New-Item -Path 'TestDrive:\' -ItemType Directory -Name 'IFM'
                    }

                    It 'Returns current Domain Controller properties' {
                        $result = Get-TargetResource @testDefaultParams -DomainName $correctDomainName

                        $result.DomainName | Should -Be $correctDomainName
                        $result.DatabasePath | Should -Be $correctDatabasePath
                        $result.LogPath | Should -Be $correctLogPath
                        $result.SysvolPath | Should -Be $correctSysvolPath
                        $result.SiteName | Should -Be $correctSiteName
                        $result.Ensure | Should -BeTrue
                        $result.IsGlobalCatalog | Should -BeTrue
                        $result.ReadOnlyReplica | Should -BeTrue
                        $result.AllowPasswordReplicationAccountName | Should -HaveCount 1
                        $result.AllowPasswordReplicationAccountName | Should -Be $allowedAccount
                        $result.DenyPasswordReplicationAccountName | Should -Be $deniedAccount
                        $result.InstallDns | Should -BeFalse
                    }
                }

                Context 'When the node is a Domain Controller with DNS installed' {
                    BeforeAll {
                        Mock -CommandName Get-ADDomain -MockWith { return $true }
                        Mock -CommandName Get-DomainControllerObject {
                            $domainControllerObject = New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController
                            $domainControllerObject.Site = $correctSiteName
                            $domainControllerObject.Domain = $correctDomainName
                            $domainControllerObject.IsGlobalCatalog = $true
                            $domainControllerObject.IsReadOnly = $false
                            return $domainControllerObject
                        }

                        Mock -CommandName Get-ItemProperty -ParameterFilter { $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters' } -MockWith {
                            return @{
                                'Database log files path' = 'C:\Windows\NTDS'
                                'DSA Working Directory'   = 'C:\Windows\NTDS'
                            }
                        }

                        Mock -CommandName Get-ItemProperty -ParameterFilter { $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters' } -MockWith {
                            return @{
                                'SysVol' = 'C:\Windows\SYSVOL\sysvol'
                            }
                        }

                        Mock -CommandName Get-ADDomainControllerPasswordReplicationPolicy
                        Mock -CommandName Get-ADDomainControllerPasswordReplicationPolicy

                        New-Item -Path 'TestDrive:\' -ItemType Directory -Name 'IFM'
                    }

                    It 'Returns current Domain Controller properties' {
                        $result = Get-TargetResource @testDefaultParams -DomainName $correctDomainName -InstallDns $true

                        $result.DomainName | Should -Be $correctDomainName
                        $result.InstallDns | Should -BeTrue
                    }
                }

                Context 'When the node is a Domain Controller and no DNS should be installed' {
                    BeforeAll {
                        Mock -CommandName Get-ADDomain -MockWith { return $true }
                        Mock -CommandName Get-DomainControllerObject {
                            $domainControllerObject = New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController
                            $domainControllerObject.Site = $correctSiteName
                            $domainControllerObject.Domain = $correctDomainName
                            $domainControllerObject.IsGlobalCatalog = $true
                            $domainControllerObject.IsReadOnly = $false
                            return $domainControllerObject
                        }

                        Mock -CommandName Get-ItemProperty -ParameterFilter { $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters' } -MockWith {
                            return @{
                                'Database log files path' = 'C:\Windows\NTDS'
                                'DSA Working Directory'   = 'C:\Windows\NTDS'
                            }
                        }

                        Mock -CommandName Get-ItemProperty -ParameterFilter { $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters' } -MockWith {
                            return @{
                                'SysVol' = 'C:\Windows\SYSVOL\sysvol'
                            }
                        }

                        Mock -CommandName Get-ADDomainControllerPasswordReplicationPolicy
                        Mock -CommandName Get-ADDomainControllerPasswordReplicationPolicy

                        New-Item -Path 'TestDrive:\' -ItemType Directory -Name 'IFM'
                    }

                    It 'Returns current Domain Controller properties' {
                        $result = Get-TargetResource @testDefaultParams -DomainName $correctDomainName -InstallDns $false

                        $result.DomainName | Should -Be $correctDomainName
                        $result.InstallDns | Should -BeFalse
                    }
                }

                Context 'When the node should not be a Domain Controller' {
                    BeforeAll {
                        Mock -CommandName Get-ADDomain -MockWith { return $true }
                        Mock -CommandName Get-DomainControllerObject -MockWith {
                            return $null
                        }
                    }

                    It 'Returns Ensure = False' {
                        $result = Get-TargetResource @testDefaultParams -DomainName $correctDomainName

                        $result.DomainName | Should -Be $correctDomainName
                        $result.DatabasePath | Should -BeNullOrEmpty
                        $result.LogPath | Should -BeNullOrEmpty
                        $result.SysvolPath | Should -BeNullOrEmpty
                        $result.SiteName | Should -BeNullOrEmpty
                        $result.Ensure | Should -BeFalse
                        $result.IsGlobalCatalog | Should -BeFalse
                        $result.NtdsSettingsObjectDn | Should -BeNullOrEmpty
                        $result.ReadOnlyReplica | Should -BeFalse
                        $result.AllowPasswordReplicationAccountName | Should -BeNullOrEmpty
                        $result.DenyPasswordReplicationAccountName | Should -BeNullOrEmpty
                        $result.FlexibleSingleMasterOperationRole | Should -BeNullOrEmpty
                        $result.InstallDns | Should -BeFalse
                    }
                }
            }
        }
        #endregion

        #region Function Test-TargetResource
        Describe 'ADDomainController\Test-TargetResource' -Tag 'Test' {
            BeforeAll {
                Mock -CommandName Get-ADDomainControllerPasswordReplicationPolicy -ParameterFilter { $Allowed.IsPresent } -MockWith {
                    return [PSCustomObject]@{
                        SamAccountName = $allowedAccount
                    }
                }

                Mock -CommandName Get-ADDomainControllerPasswordReplicationPolicy -ParameterFilter { $Denied.IsPresent } -MockWith {
                    return [PSCustomObject]@{
                        SamAccountName = $deniedAccount
                    }
                }
            }

            Context 'When the system is in the desired state' {
                BeforeAll {
                    Mock -CommandName Get-TargetResource -MockWith {
                        return @{
                            DomainName                          = $correctDomainName
                            SiteName                            = $correctSiteName
                            IsGlobalCatalog                     = $true
                            AllowPasswordReplicationAccountName = @($allowedAccount)
                            DenyPasswordReplicationAccountName  = @($deniedAccount)
                            FlexibleSingleMasterOperationRole   = @('DomainNamingMaster','RIDMaster')
                            Ensure                              = $true
                        }
                    }

                    Mock -CommandName Test-ADReplicationSite -MockWith {
                        return $true
                    }
                }

                Context 'When creating a domain controller with only mandatory parameters' {
                    It 'Should return $true' {
                        $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName
                        $result | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When property SiteName is in desired state' {
                    It 'Should return $true' {
                        $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -SiteName $correctSiteName
                        $result | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When property IsGlobalCatalog is in desired state' {
                    It 'Should return $true' {
                        $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -IsGlobalCatalog $true
                        $result | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When property AllowPasswordReplicationAccountName is in desired state' {
                    It 'Should return $true' {
                        $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -AllowPasswordReplicationAccountName @($allowedAccount)
                        $result | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When property DenyPasswordReplicationAccountName is in desired state' {
                    It 'Should return $true' {
                        $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -DenyPasswordReplicationAccountName @($deniedAccount)
                        $result | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When property FlexibleSingleMasterOperationRole is in desired state' {
                    It 'Should return $true' {
                        $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -FlexibleSingleMasterOperationRole @('RIDMaster')
                        $result | Should -Be $true

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                BeforeAll {
                    Mock -CommandName Test-ADReplicationSite -MockWith {
                        return $true
                    }
                }

                Context 'When creating a domain controller with only mandatory parameters' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                DomainName                          = 'WrongDomainName'
                                Ensure                              = $false
                            }
                        }
                    }

                    It 'Should return $false' {
                        $result = Test-TargetResource @testDefaultParams -DomainName 'WrongDomainName'
                        $result | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When properties are not in desired state' {
                    Context 'When property SiteName is not in desired state' {
                        BeforeAll {
                            Mock -CommandName Get-TargetResource -MockWith {
                                return @{
                                    DomainName                          = $correctDomainName
                                    SiteName                            = $correctSiteName
                                    Ensure                              = $true
                                }
                            }
                        }

                        It 'Should return $false' {
                            $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -SiteName 'NewSiteName'
                            $result | Should -BeFalse

                            Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When property IsGlobalCatalog is not in desired state' {
                        Context 'When Domain Controller should be a Global Catalog' {
                            BeforeAll {
                                Mock -CommandName Get-TargetResource -MockWith {
                                    return @{
                                        DomainName                          = $correctDomainName
                                        IsGlobalCatalog                     = $false
                                        Ensure                              = $true
                                    }
                                }
                            }

                            It 'Should return $false' {
                                $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -IsGlobalCatalog $true
                                $result | Should -BeFalse

                                Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                                Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                            }
                        }

                        Context 'When Domain Controller should not be a Global Catalog' {
                            BeforeAll {
                                Mock -CommandName Get-TargetResource -MockWith {
                                    return @{
                                        DomainName                          = $correctDomainName
                                        IsGlobalCatalog                     = $true
                                        Ensure                              = $true
                                    }
                                }
                            }

                            It 'Should return $false' {
                                $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -IsGlobalCatalog $false
                                $result | Should -BeFalse

                                Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                                Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                            }
                        }
                    }

                    Context 'When property AllowPasswordReplicationAccountName is not in desired state' {
                        BeforeAll {
                            Mock -CommandName Get-TargetResource -MockWith {
                                return @{
                                    DomainName                          = $correctDomainName
                                    AllowPasswordReplicationAccountName = @($allowedAccount,'Member2')
                                    Ensure                              = $true
                                }
                            }
                        }

                        Context 'When there are different members than the desired state' {
                            It 'Should return $false' {
                                $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -AllowPasswordReplicationAccountName @('NewMember1','NewMember2')
                                $result | Should -BeFalse

                                Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                                Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                            }
                        }

                        Context 'When there exist less members than the desired state' {
                            It 'Should return $false' {
                                $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -AllowPasswordReplicationAccountName @($allowedAccount,'Member2','NewMember')
                                $result | Should -BeFalse

                                Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                                Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                            }
                        }

                        Context 'When there exist more members that the desired state' {
                            It 'Should return $false' {
                                $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -AllowPasswordReplicationAccountName @($allowedAccount)
                                $result | Should -BeFalse

                                Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                                Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                            }
                        }
                    }

                    Context 'When property DenyPasswordReplicationAccountName is not in desired state' {
                        BeforeAll {
                            Mock -CommandName Get-TargetResource -MockWith {
                                return @{
                                    DomainName                          = $correctDomainName
                                    DenyPasswordReplicationAccountName  = @($deniedAccount,'Member2')
                                    Ensure                              = $true
                                }
                            }
                        }

                        Context 'When there are different members than the desired state' {
                            It 'Should return $false' {
                                $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -DenyPasswordReplicationAccountName @('NewMember1','NewMember2')
                                $result | Should -BeFalse

                                Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                                Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                            }
                        }

                        Context 'When there exist less members than the desired state' {
                            It 'Should return $false' {
                                $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -DenyPasswordReplicationAccountName @($allowedAccount,'Member2','NewMember')
                                $result | Should -BeFalse

                                Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                                Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                            }
                        }

                        Context 'When there exist more members that the desired state' {
                            It 'Should return $false' {
                                $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -DenyPasswordReplicationAccountName @($allowedAccount)
                                $result | Should -BeFalse

                                Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                                Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 0 -Scope It
                            }
                        }
                    }

                    Context 'When property FlexibleSingleMasterOperationRole is not in desired state' {
                        BeforeAll {
                            Mock -CommandName Get-TargetResource -MockWith {
                                return @{
                                    DomainName                          = $correctDomainName
                                    DenyPasswordReplicationAccountName  = @($deniedAccount,'Member2')
                                    Ensure                              = $true
                                    FlexibleSingleMasterOperationRole   = @('DomainNamingMaster')
                                }
                            }
                        }

                        It 'Should return $false' {
                            $result = Test-TargetResource @testDefaultParams -DomainName $correctDomainName -FlexibleSingleMasterOperationRole @('RIDMaster')
                            $result | Should -Be $false

                            Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                        }
                    }
                }

                Context 'When a specified site does not exist in the Active Directory' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                DomainName                          = $correctDomainName
                                SiteName                            = $correctSiteName
                                Ensure                              = $true
                            }
                        }

                        Mock -CommandName Test-ADReplicationSite -MockWith {
                            return $false
                        }
                    }

                    It 'Should throw the correct error' {
                        {
                            Test-TargetResource @testDefaultParams -DomainName $correctDomainName -SiteName $correctSiteName
                        } | Should -Throw ($script:localizedData.FailedToFindSite -f $correctSiteName, $correctDomainName)

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Test-ADReplicationSite -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When providing parameter ReadOnlyReplica with a value of $true, but do not specify parameter SiteName' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                DomainName                          = $correctDomainName
                                SiteName                            = $null
                                ReadOnlyReplica                     = $false
                                Ensure                              = $false
                            }
                        }
                    }

                    It 'Should throw the correct error' {
                        {
                            Test-TargetResource @testDefaultParams -DomainName $correctDomainName -ReadOnlyReplica $true
                        } | Should -Throw $script:localizedData.RODCMissingSite

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When providing parameter ReadOnlyReplica with a value of $true, but the node is already a writeable Domain Controller' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                DomainName                          = $correctDomainName
                                ReadOnlyReplica                     = $false
                                Ensure                              = $true
                            }
                        }
                    }

                    It 'Should throw the correct error' {
                        {
                            Test-TargetResource @testDefaultParams -DomainName $correctDomainName -SiteName $correctSiteName -ReadOnlyReplica $true
                        } | Should -Throw $script:localizedData.CannotConvertToRODC

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }
        }
        #endregion

        #region Function Set-TargetResource
        Describe 'ADDomainController\Set-TargetResource' -Tag 'Set' {
            Context 'When the system is not in the desired state' {
                BeforeAll {
                    Mock -CommandName Install-ADDSDomainController
                    Mock -CommandName Remove-ADDomainControllerPasswordReplicationPolicy
                    Mock -CommandName Add-ADDomainControllerPasswordReplicationPolicy
                    Mock -CommandName Get-ADDomain -MockWith {
                        return $true
                    }

                    Mock -CommandName Get-TargetResource -MockWith {
                        return @{
                            Ensure = $false
                        }
                    }
                }

                Context 'When adding a domain controller to a specific site' {
                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -SiteName $correctSiteName } | Should -Not -Throw

                        Assert-MockCalled -CommandName Install-ADDSDomainController -ParameterFilter {
                            $SiteName -eq $correctSiteName
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When adding a domain controller to a specific database path' {
                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -DatabasePath $correctDatabasePath } | Should -Not -Throw

                        Assert-MockCalled -CommandName Install-ADDSDomainController -ParameterFilter {
                            $DatabasePath -eq $correctDatabasePath
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When adding a domain controller to a specific SysVol path' {
                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -SysVolPath $correctSysvolPath } | Should -Not -Throw

                        Assert-MockCalled -CommandName Install-ADDSDomainController -ParameterFilter {
                            $SysVolPath -eq $correctSysvolPath
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When adding a domain controller to a specific log path' {
                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -LogPath $correctLogPath } | Should -Not -Throw

                        Assert-MockCalled -CommandName Install-ADDSDomainController -ParameterFilter {
                            $LogPath -eq $correctLogPath
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When adding a domain controller that should not be a Global Catalog' {
                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -IsGlobalCatalog $false } | Should -Not -Throw

                        Assert-MockCalled -CommandName Install-ADDSDomainController -ParameterFilter {
                            $NoGlobalCatalog -eq $true
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When adding a domain controller using IFM' {
                    BeforeAll {
                        New-Item -Path $correctInstallationMediaPath -ItemType 'Directory' -Force
                    }

                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -InstallationMediaPath $correctInstallationMediaPath } | Should -Not -Throw

                        Assert-MockCalled -CommandName Install-ADDSDomainController -ParameterFilter {
                            $InstallationMediaPath -eq $correctInstallationMediaPath
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'Throws if "ReadOnlyReplica" is specified without Site' {
                    It 'Throws the correct exception' {
                        {
                            Set-TargetResource @testDefaultParams -DomainName $correctDomainName -ReadOnlyReplica $true
                        } | Should -Throw $script:localizedData.RODCMissingSite
                    }
                }

                Context 'When adding a domain controller with AllowPasswordReplicationAccountName' {
                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParamsRODC -DomainName $correctDomainName -AllowPasswordReplicationAccountName $allowedAccount } | Should -Not -Throw

                        Assert-MockCalled -CommandName Install-ADDSDomainController -ParameterFilter {
                            $AllowPasswordReplicationAccountName -eq $allowedAccount
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When adding a domain controller with DenyPasswordReplicationAccountName' {
                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParamsRODC -DomainName $correctDomainName -DenyPasswordReplicationAccountName $deniedAccount } | Should -Not -Throw

                        Assert-MockCalled -CommandName Install-ADDSDomainController -ParameterFilter {
                            $DenyPasswordReplicationAccountName -eq $deniedAccount
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the domain controller should have a DNS installed' {
                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParamsRODC -DomainName $correctDomainName -InstallDns $true } | Should -Not -Throw

                        Assert-MockCalled -CommandName Install-ADDSDomainController -ParameterFilter {
                            $InstallDns -eq $true
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When the domain controller should not have a DNS installed' {
                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParamsRODC -DomainName $correctDomainName -InstallDns $false } | Should -Not -Throw

                        Assert-MockCalled -CommandName Install-ADDSDomainController -ParameterFilter {
                            $InstallDns -eq $false
                        } -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When a domain controller is in the wrong site' {
                    BeforeAll {
                        Mock -CommandName Move-ADDirectoryServer
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                Ensure   = $true
                                SiteName = 'IncorrectSite'
                            }
                        }

                        <#
                            Without this line the local tests are crashing powershell.exe (both 5 and 6).
                            See test 'Should call the correct mocks to move the domain controller to the correct site'.
                        #>
                        Mock -CommandName Get-DomainControllerObject -MockWith {
                            return (New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController)
                        }
                    }

                    It 'Should call the correct mocks to move the domain controller to the correct site' {
                        { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -SiteName $correctSiteName } | Should -Not -Throw

                        Assert-MockCalled -CommandName Move-ADDirectoryServer -ParameterFilter {
                            $Site.ToString() -eq $correctSiteName
                        } -Exactly -Times 1 -Scope It
                    }

                    Context 'When the domain controller is in the wrong site, but SiteName is not specified' {
                        It 'Should not move the domain controller' {
                            { Set-TargetResource @testDefaultParams -DomainName $correctDomainName } | Should -Not -Throw

                            Assert-MockCalled -CommandName Move-ADDirectoryServer  -Exactly -Times 0 -Scope It
                        }
                    }
                }

                Context 'When specifying the IsGlobalCatalog parameter' {
                    BeforeAll {
                        Mock -CommandName Set-ADObject
                        Mock -CommandName Get-DomainControllerObject {
                            return @{
                                NTDSSettingsObjectDN = $mockNtdsSettingsObjectDn
                            }
                        }
                    }

                    Context 'When the domain controller should be a Global Catalog' {
                        BeforeAll {
                            Mock -CommandName Get-TargetResource -MockWith {
                                return $stubTargetResource = @{
                                    Ensure          = $true
                                    SiteName        = 'PresentSite'
                                    IsGlobalCatalog = $false
                                }
                            }
                        }

                        It 'Should call the correct mocks' {
                            { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -IsGlobalCatalog $true } | Should -Not -Throw

                            Assert-MockCalled -CommandName Set-ADObject -ParameterFilter {
                                $Replace['options'] -eq 1
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When the domain controller should not be a Global Catalog' {
                        BeforeAll {
                            Mock -CommandName Get-TargetResource -MockWith {
                                return $stubTargetResource = @{
                                    Ensure          = $true
                                    SiteName        = 'PresentSite'
                                    IsGlobalCatalog = $true
                                }
                            }
                        }

                        It 'Should call the correct mocks' {
                            { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -IsGlobalCatalog $false } | Should -Not -Throw

                            Assert-MockCalled -CommandName Set-ADObject -ParameterFilter {
                                $Replace['options'] -eq 0
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When the domain controller should change state of Global Catalog, but fail to return a domain controller object' {
                        BeforeAll {
                            Mock -CommandName Get-TargetResource -MockWith {
                                return $stubTargetResource = @{
                                    Ensure          = $true
                                    SiteName        = 'PresentSite'
                                    IsGlobalCatalog = $true
                                }
                            }

                            Mock -CommandName Get-DomainControllerObject
                        }

                        It 'Should call the correct mocks' {
                            { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -IsGlobalCatalog $false } | Should -Throw $script:localizedData.ExpectedDomainController

                            Assert-MockCalled -CommandName Set-ADObject -Exactly -Times 0 -Scope It
                        }
                    }
                }

                Context 'When AllowPasswordReplicationAccountName is not compliant' {
                    Mock -CommandName Get-TargetResource -MockWith {
                        return @{
                            Ensure                              = $true
                            AllowPasswordReplicationAccountName = 'allowedAccount2'
                            SiteName                            = $correctSiteName
                        }
                    }

                    Mock -CommandName Get-DomainControllerObject -MockWith {
                        $stubDomainController = New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController
                        $stubDomainController.Site = $correctSiteName

                        return $stubDomainController
                    }

                    It "Should call the correct mock to set AllowPasswordReplicationAccountName Attribute" {
                        { Set-TargetResource @testDefaultParamsRODC -DomainName $correctDomainName -AllowPasswordReplicationAccountName $allowedAccount } | Should -Not -Throw

                        Assert-MockCalled -CommandName Remove-ADDomainControllerPasswordReplicationPolicy -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Add-ADDomainControllerPasswordReplicationPolicy  -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When DenyPasswordReplicationAccountName is not compliant' {
                    Mock -CommandName Get-TargetResource -MockWith {
                        return @{
                            Ensure                             = $true
                            DenyPasswordReplicationAccountName = 'deniedAccount2'
                            SiteName                           = $correctSiteName
                        }
                    }

                    Mock -CommandName Get-DomainControllerObject -MockWith {
                        $stubDomainController = New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController
                        $stubDomainController.Site = $correctSiteName
                        return $stubDomainController
                    }

                    It "Should call the correct mock to set DenyPasswordReplicationAccountName Attribute" {
                        { Set-TargetResource @testDefaultParamsRODC  -DomainName $correctDomainName -DenyPasswordReplicationAccountName $deniedAccount } | Should -Not -Throw

                        Assert-MockCalled -CommandName Remove-ADDomainControllerPasswordReplicationPolicy -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Add-ADDomainControllerPasswordReplicationPolicy -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When adding a domain controller and the FlexibleSingleMasterOperationRole is set to ''RIDMaster''' {
                    BeforeAll {
                        Mock -CommandName Move-ADDirectoryServerOperationMasterRole
                        Mock -CommandName Get-ADForest
                        Mock -CommandName Get-ADDomain -MockWith {
                            return @{
                                RIDMaster = 'dc.contoso.com'
                            }
                        }

                        Mock -CommandName Get-DomainControllerObject {
                            $domainControllerObject = New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController
                            $domainControllerObject.OperationMasterRoles = @('DomainNamingMaster')
                            return $domainControllerObject
                        }

                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                Ensure = $true
                                FlexibleSingleMasterOperationRole = @('DomainNamingMaster')
                            }
                        }
                    }

                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -FlexibleSingleMasterOperationRole @('RIDMaster') } | Should -Not -Throw

                        Assert-MockCalled -CommandName Get-ADDomain -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Get-ADForest -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Move-ADDirectoryServerOperationMasterRole -Exactly -Times 1 -Scope It
                    }
                }

                Context 'When adding a domain controller and the FlexibleSingleMasterOperationRole is set to ''SchemaMaster''' {
                    BeforeAll {
                        Mock -CommandName Move-ADDirectoryServerOperationMasterRole
                        Mock -CommandName Get-ADDomain
                        Mock -CommandName Get-ADForest -MockWith {
                            return @{
                                SchemaMaster = 'dc.contoso.com'
                            }
                        }

                        Mock -CommandName Get-DomainControllerObject {
                            $domainControllerObject = New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController
                            $domainControllerObject.OperationMasterRoles = @('DomainNamingMaster')
                            return $domainControllerObject
                        }

                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                Ensure = $true
                                FlexibleSingleMasterOperationRole = @('DomainNamingMaster')
                            }
                        }
                    }

                    It 'It should call the correct mocks' {
                        { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -FlexibleSingleMasterOperationRole @('SchemaMaster') } | Should -Not -Throw

                        Assert-MockCalled -CommandName Get-ADDomain -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Get-ADForest -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Move-ADDirectoryServerOperationMasterRole -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is in the desired state' {
                BeforeAll {
                    Mock -CommandName Remove-ADDomainControllerPasswordReplicationPolicy
                    Mock -CommandName Add-ADDomainControllerPasswordReplicationPolicy
                }

                Context 'When a domain controller is in the correct site' {
                    BeforeAll {
                        Mock -CommandName Move-ADDirectoryServer
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                Ensure   = $true
                                SiteName = 'PresentSite'
                            }
                        }
                        Mock -CommandName Get-DomainControllerObject {
                            return (New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController)
                        }
                    }

                    It 'Should not move the domain controller' {
                        { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -SiteName $correctSiteName } | Should -Not -Throw

                        Assert-MockCalled -CommandName Move-ADDirectoryServer -Exactly -Times 0 -Scope It
                    }
                }

                Context 'When specifying the IsGlobalCatalog parameter' {
                    BeforeAll {
                        Mock -CommandName Set-ADObject
                        Mock -CommandName Get-DomainControllerObject {
                            return @{
                                NTDSSettingsObjectDN = $mockNtdsSettingsObjectDn
                            }
                        }
                    }

                    Context 'When the domain controller should be a Global Catalog' {
                        BeforeAll {
                            Mock -CommandName Get-TargetResource -MockWith {
                                return $stubTargetResource = @{
                                    Ensure          = $true
                                    SiteName        = 'PresentSite'
                                    IsGlobalCatalog = $false
                                }
                            }
                        }

                        It 'Should call the correct mocks' {
                            { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -IsGlobalCatalog $true } | Should -Not -Throw

                            Assert-MockCalled -CommandName Set-ADObject -ParameterFilter {
                                $Replace['options'] -eq 1
                            } -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When the domain controller already is a Global Catalog' {
                        BeforeAll {
                            Mock -CommandName Get-TargetResource -MockWith {
                                return $stubTargetResource = @{
                                    Ensure          = $true
                                    SiteName        = 'PresentSite'
                                    IsGlobalCatalog = $true
                                }
                            }
                        }

                        It 'Should not call the mock Set-ADObject' {
                            { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -IsGlobalCatalog $true } | Should -Not -Throw

                            Assert-MockCalled -CommandName Set-ADObject -Exactly -Times 0 -Scope It
                        }
                    }

                    Context 'When the domain controller already are not a Global Catalog' {
                        BeforeAll {
                            Mock -CommandName Get-TargetResource -MockWith {
                                return $stubTargetResource = @{
                                    Ensure          = $true
                                    SiteName        = 'PresentSite'
                                    IsGlobalCatalog = $false
                                }
                            }
                        }

                        It 'Should not call the mock Set-ADObject' {
                            { Set-TargetResource @testDefaultParams -DomainName $correctDomainName -IsGlobalCatalog $false } | Should -Not -Throw

                            Assert-MockCalled -CommandName Set-ADObject -Exactly -Times 0 -Scope It
                        }
                    }
                }

                Context 'When Read-OnlyDomainController(RODC) Sync Accounts are compliant' {
                    BeforeAll {
                        Mock -CommandName Get-DomainControllerObject -MockWith {
                            $stubDomainController = New-Object -TypeName Microsoft.ActiveDirectory.Management.ADDomainController
                            $stubDomainController.Site = $correctSiteName

                            return $stubDomainController
                        }
                    }

                    It 'AllowPasswordReplicationAccountName is correct' {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                Ensure                              = $true
                                AllowPasswordReplicationAccountName = $allowedAccount
                                SiteName                            = $correctSiteName
                            }
                        }
                        { Set-TargetResource @testDefaultParamsRODC -DomainName $correctDomainName -AllowPasswordReplicationAccountName $allowedAccount } | Should -Not -Throw

                        Assert-MockCalled -CommandName Remove-ADDomainControllerPasswordReplicationPolicy -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Add-ADDomainControllerPasswordReplicationPolicy -Exactly -Times 0 -Scope It
                    }

                    It 'DenyPasswordReplicationAccountName is correct' {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                Ensure                             = $true
                                DenyPasswordReplicationAccountName = $deniedAccount
                                SiteName                           = $correctSiteName
                            }
                        }

                        { Set-TargetResource @testDefaultParamsRODC -DomainName $correctDomainName -DenyPasswordReplicationAccountName $deniedAccount } | Should -Not -Throw

                        Assert-MockCalled -CommandName Remove-ADDomainControllerPasswordReplicationPolicy -Exactly -Times 0 -Scope It
                        Assert-MockCalled -CommandName Add-ADDomainControllerPasswordReplicationPolicy -Exactly -Times 0 -Scope It
                    }
                }
            }
        }
        #endregion

        Describe 'ADDomainController\Get-MembersToAddAndRemove' -Tag 'Helper' {
            Context 'When there is one desired member' {
                Context 'When there are no current members' {
                    Context 'When proving a $null value for CurrentMembers' {
                        It 'Should return the correct values' {
                            $result = Get-MembersToAddAndRemove -DesiredMembers 'Member1' -CurrentMembers $null
                            $result.MembersToAdd | Should -HaveCount 1
                            $result.MembersToAdd[0].ToString() | Should -Be 'Member1'
                            $result.MembersToRemove | Should -BeNullOrEmpty
                        }
                    }

                    Context 'When proving an empty collection for CurrentMembers' {
                        It 'Should return the correct values' {
                            $result = Get-MembersToAddAndRemove -DesiredMembers 'Member1' -CurrentMembers @()
                            $result.MembersToAdd | Should -HaveCount 1
                            $result.MembersToAdd[0].ToString() | Should -Be 'Member1'
                            $result.MembersToRemove | Should -BeNullOrEmpty
                        }
                    }
                }

                Context 'When there are one current member' {
                    It 'Should return the correct values' {
                        Context 'When proving a collection for CurrentMembers' {
                            $result = Get-MembersToAddAndRemove -DesiredMembers 'Member1' -CurrentMembers @('OldMember')
                            $result.MembersToAdd | Should -HaveCount 1
                            $result.MembersToAdd[0].ToString() | Should -Be 'Member1'
                            $result.MembersToRemove | Should -HaveCount 1
                            $result.MembersToRemove[0].ToString() | Should -Be 'OldMember'
                        }

                        Context 'When proving a string value for CurrentMembers' {
                            $result = Get-MembersToAddAndRemove -DesiredMembers 'Member1' -CurrentMembers 'OldMember'
                            $result.MembersToAdd | Should -HaveCount 1
                            $result.MembersToAdd[0].ToString() | Should -Be 'Member1'
                            $result.MembersToRemove | Should -HaveCount 1
                            $result.MembersToRemove[0].ToString() | Should -Be 'OldMember'
                        }
                    }
                }

                Context 'When there more than one current member' {
                    It 'Should return the correct values' {
                        $result = Get-MembersToAddAndRemove -DesiredMembers 'Member1' -CurrentMembers @('OldMember1','OldMember2')
                        $result.MembersToAdd | Should -HaveCount 1
                        $result.MembersToAdd[0].ToString() | Should -Be 'Member1'
                        $result.MembersToRemove | Should -HaveCount 2
                        $result.MembersToRemove[0].ToString() | Should -Be 'OldMember1'
                        $result.MembersToRemove[1].ToString() | Should -Be 'OldMember2'
                    }
                }
            }

            Context 'When there is no desired members' {
                Context 'When there are no current members' {
                    Context 'When proving a $null value for DesiredMembers and CurrentMembers' {
                        It 'Should return the correct values' {
                            $result = Get-MembersToAddAndRemove -DesiredMembers $null -CurrentMembers $null
                            $result.MembersToAdd | Should -BeNullOrEmpty
                            $result.MembersToRemove | Should -BeNullOrEmpty
                        }
                    }

                    Context 'When proving an empty collection for DesiredMembers and CurrentMembers' {
                        It 'Should return the correct values' {
                            $result = Get-MembersToAddAndRemove -DesiredMembers @() -CurrentMembers @()
                            $result.MembersToAdd | Should -BeNullOrEmpty
                            $result.MembersToRemove | Should -BeNullOrEmpty
                        }
                    }
                }

                Context 'When there are one current member' {
                    It 'Should return the correct values' {
                        Context 'When proving a collection for CurrentMembers' {
                            $result = Get-MembersToAddAndRemove -DesiredMembers $null -CurrentMembers @('OldMember')
                            $result.MembersToAdd | Should -BeNullOrEmpty
                            $result.MembersToRemove | Should -HaveCount 1
                            $result.MembersToRemove[0].ToString() | Should -Be 'OldMember'
                        }

                        Context 'When proving a string value for CurrentMembers' {
                            $result = Get-MembersToAddAndRemove -DesiredMembers $null -CurrentMembers 'OldMember'
                            $result.MembersToAdd | Should -BeNullOrEmpty
                            $result.MembersToRemove | Should -HaveCount 1
                            $result.MembersToRemove[0].ToString() | Should -Be 'OldMember'
                        }
                    }
                }

                Context 'When there more than one current member' {
                    It 'Should return the correct values' {
                        $result = Get-MembersToAddAndRemove -DesiredMembers $null -CurrentMembers @('OldMember1','OldMember2')
                        $result.MembersToAdd | Should -BeNullOrEmpty
                        $result.MembersToRemove | Should -HaveCount 2
                        $result.MembersToRemove[0].ToString() | Should -Be 'OldMember1'
                        $result.MembersToRemove[1].ToString() | Should -Be 'OldMember2'
                    }
                }
            }

            Context 'When the same members are present in desired members and current members' {
                Context 'When proving a collection for CurrentMembers' {
                    $result = Get-MembersToAddAndRemove -DesiredMembers @('Member1') -CurrentMembers @('Member1')
                    $result.MembersToAdd | Should -BeNullOrEmpty
                    $result.MembersToRemove | Should -BeNullOrEmpty
                }

                Context 'When proving a string value for CurrentMembers' {
                    $result = Get-MembersToAddAndRemove -DesiredMembers 'Member1' -CurrentMembers 'Member1'
                    $result.MembersToAdd | Should -BeNullOrEmpty
                    $result.MembersToRemove | Should -BeNullOrEmpty
                }
            }

            Context 'When the there are more desired members than current members' {
                Context 'When proving a collection for CurrentMembers' {
                    $result = Get-MembersToAddAndRemove -DesiredMembers @('Member1','Member2') -CurrentMembers @('Member1')
                    $result.MembersToAdd | Should -HaveCount 1
                    $result.MembersToAdd[0].ToString() | Should -Be 'Member2'
                    $result.MembersToRemove | Should -BeNullOrEmpty
                }
            }

            Context 'When the there are fewer desired members than current members' {
                Context 'When proving a string value for CurrentMembers' {
                    $result = Get-MembersToAddAndRemove -DesiredMembers 'Member1' -CurrentMembers @('Member1','Member2')
                    $result.MembersToAdd | Should -BeNullOrEmpty
                    $result.MembersToRemove | Should -HaveCount 1
                    $result.MembersToRemove[0].ToString() | Should -Be 'Member2'
                }
            }
        }
    }
}
finally
{
    Invoke-TestCleanup
}
