Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADObjectPermissionEntry'

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

        #region Pester Test Initialization
        $testDefaultParameters = @{
            Path                               = 'CN=PC01,CN=Computers,DC=contoso,DC=com'
            IdentityReference                  = 'CONTOSO\User'
            AccessControlType                  = 'Allow'
            ObjectType                         = '00000000-0000-0000-0000-000000000000'
            ActiveDirectorySecurityInheritance = 'None'
            InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
        }

        $testPresentParameters = @{
            Ensure                             = 'Present'
            ActiveDirectoryRights              = 'GenericAll'
        }

        $testAbsentParameters = @{
            Ensure                             = 'Absent'
            ActiveDirectoryRights              = 'GenericAll'
        }

        $mockGetAclPresent = {
            $mock = [PSCustomObject] @{
                Path   = 'AD:CN=PC01,CN=Computers,DC=contoso,DC=com'
                Owner  = 'BUILTIN\Administrators'
                Access = @(
                    [PSCustomObject] @{
                        ActiveDirectoryRights = 'GenericAll'
                        InheritanceType       = 'None'
                        ObjectType            = [System.Guid] '00000000-0000-0000-0000-000000000000'
                        InheritedObjectType   = [System.Guid] '00000000-0000-0000-0000-000000000000'
                        ObjectFlags           = 'None'
                        AccessControlType     = 'Allow'
                        IdentityReference     = [PSCustomObject] @{
                            Value = 'CONTOSO\User'
                        }
                        IsInherited           = $false
                        InheritanceFlags      = 'None'
                        PropagationFlags      = 'None'
                    }
                )
            }
            $mock | Add-Member -MemberType 'ScriptMethod' -Name 'AddAccessRule' -Value {}
            $mock | Add-Member -MemberType 'ScriptMethod' -Name 'RemoveAccessRule' -Value {}
            return $mock
        }

        $mockGetAclAbsent = {
            $mock = [PSCustomObject] @{
                Path   = 'AD:CN=PC,CN=Computers,DC=lab,DC=local'
                Owner  = 'BUILTIN\Administrators'
                Access = @()
            }
            $mock | Add-Member -MemberType 'ScriptMethod' -Name 'AddAccessRule' -Value {}
            $mock | Add-Member -MemberType 'ScriptMethod' -Name 'RemoveAccessRule' -Value {}
            return $mock
        }
        #endregion

        #region Function Get-TargetResource
        Describe 'ADObjectPermissionEntry\Get-TargetResource' {
            Mock -CommandName 'Assert-ADPSDrive'

            Context 'When the desired ace is present' {

                Mock -CommandName 'Get-Acl' -MockWith $mockGetAclPresent

                It 'Should call "Assert-ADPSDrive" to check AD PS Drive is created' {
                    $targetResource = Get-TargetResource @testDefaultParameters -Verbose
                    Assert-MockCalled -CommandName Assert-ADPSDrive -Scope It -Exactly -Times 1
                }

                It 'Should return a "System.Collections.Hashtable" object type' {
                    # Act
                    $targetResource = Get-TargetResource @testDefaultParameters -Verbose

                    # Assert
                    $targetResource | Should -BeOfType [System.Collections.Hashtable]
                }

                It 'Should return a valid result if the ace is present' {
                    # Act
                    $targetResource = Get-TargetResource @testDefaultParameters -Verbose

                    # Assert
                    $targetResource.Ensure                             | Should -Be 'Present'
                    $targetResource.Path                               | Should -Be $testDefaultParameters.Path
                    $targetResource.IdentityReference                  | Should -Be $testDefaultParameters.IdentityReference
                    $targetResource.ActiveDirectoryRights              | Should -Be 'GenericAll'
                    $targetResource.AccessControlType                  | Should -Be $testDefaultParameters.AccessControlType
                    $targetResource.ObjectType                         | Should -Be $testDefaultParameters.ObjectType
                    $targetResource.ActiveDirectorySecurityInheritance | Should -Be $testDefaultParameters.ActiveDirectorySecurityInheritance
                    $targetResource.InheritedObjectType                | Should -Be $testDefaultParameters.InheritedObjectType
                }
            }

            Context 'When the desired ace is absent' {

                Mock -CommandName 'Get-Acl' -MockWith $mockGetAclAbsent

                It 'Should call "Assert-ADPSDrive" to check AD PS Drive is created' {
                    $targetResource = Get-TargetResource @testDefaultParameters -Verbose
                    Assert-MockCalled -CommandName Assert-ADPSDrive -Scope It -Exactly -Times 1
                }

                It 'Should return a valid result if the ace is absent' {
                    # Act
                    $targetResource = Get-TargetResource @testDefaultParameters -Verbose

                    # Assert
                    $targetResource.Ensure                             | Should -Be 'Absent'
                    $targetResource.Path                               | Should -Be $testDefaultParameters.Path
                    $targetResource.IdentityReference                  | Should -Be $testDefaultParameters.IdentityReference
                    $targetResource.ActiveDirectoryRights              | Should -Be ''
                    $targetResource.AccessControlType                  | Should -Be $testDefaultParameters.AccessControlType
                    $targetResource.ObjectType                         | Should -Be $testDefaultParameters.ObjectType
                    $targetResource.ActiveDirectorySecurityInheritance | Should -Be $testDefaultParameters.ActiveDirectorySecurityInheritance
                    $targetResource.InheritedObjectType                | Should -Be $testDefaultParameters.InheritedObjectType
                }
            }
        }
        #endregion

        #region Function Test-TargetResource
        Describe 'ADObjectPermissionEntry\Test-TargetResource' {
            Mock -CommandName 'Assert-ADPSDrive' { }

            Context 'When the desired ace is present' {

                Mock -CommandName 'Get-Acl' -MockWith $mockGetAclPresent

                It 'Should return a "System.Boolean" object type' {
                    # Act
                    $targetResource = Test-TargetResource @testDefaultParameters @testPresentParameters

                    # Assert
                    $targetResource | Should -BeOfType [System.Boolean]
                }

                It 'Should return $true if the ace desired state is present' {
                    # Act
                    $targetResource = Test-TargetResource @testDefaultParameters @testPresentParameters -Verbose

                    # Assert
                    $targetResource | Should -BeTrue
                }

                It 'Should return $false if the ace desired state is absent' {
                    # Act
                    $targetResource = Test-TargetResource @testDefaultParameters @testAbsentParameters

                    # Assert
                    $targetResource | Should -BeFalse
                }
            }

            Context 'When the desired ace is absent' {

                Mock -CommandName 'Get-Acl' -MockWith $mockGetAclAbsent

                It 'Should return $false if the ace desired state is present' {
                    # Act
                    $targetResource = Test-TargetResource @testDefaultParameters @testPresentParameters

                    # Assert
                    $targetResource | Should -BeFalse
                }

                It 'Should return $true if the ace desired state is absent' {
                    # Act
                    $targetResource = Test-TargetResource @testDefaultParameters @testAbsentParameters

                    # Assert
                    $targetResource | Should -BeTrue
                }
            }
        }
        #endregion

        #region Function Set-TargetResource
        Describe 'ADObjectPermissionEntry\Set-TargetResource' {
            Mock -CommandName 'Assert-ADPSDrive'

            Context 'When the desired ace is present' {

                Mock -CommandName 'Get-Acl' -MockWith $mockGetAclPresent
                Mock -CommandName 'Set-Acl' -Verifiable

                It 'Should call "Assert-ADPSDrive" to check AD PS Drive is created' {
                    $targetResource = Get-TargetResource @testDefaultParameters -Verbose
                    Assert-MockCalled -CommandName Assert-ADPSDrive -Scope It -Exactly -Times 1
                }

                It 'Should remove the ace from the existing acl' {
                    # Act
                    Set-TargetResource @testDefaultParameters @testAbsentParameters

                    # Assert
                    Assert-MockCalled -CommandName 'Set-Acl' -Scope It -Times 1 -Exactly
                }
            }

            Context 'When the desired ace is absent' {

                Mock -CommandName 'Get-Acl' -MockWith $mockGetAclAbsent
                Mock -CommandName 'Set-Acl' -Verifiable

                It 'Should call "Assert-ADPSDrive" to check AD PS Drive is created' {
                    $targetResource = Get-TargetResource @testDefaultParameters -Verbose
                    Assert-MockCalled -CommandName Assert-ADPSDrive -Scope It -Exactly -Times 1
                }

                It 'Should add the ace to the existing acl' {
                    # Act
                    Set-TargetResource @testDefaultParameters @testPresentParameters

                    # Assert
                    Assert-MockCalled -CommandName 'Set-Acl' -Scope It -Times 1 -Exactly
                }
            }
        }
    }
}
finally
{
    Invoke-TestCleanup
}
