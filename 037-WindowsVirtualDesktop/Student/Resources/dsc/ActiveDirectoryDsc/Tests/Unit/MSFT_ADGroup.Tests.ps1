Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TestHelpers\ActiveDirectoryDsc.TestHelper.psm1')

if (-not (Test-RunForCITestCategory -Type 'Unit' -Category 'Tests'))
{
    return
}

$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADGroup'

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

        $testPresentParams = @{
            GroupName = 'TestGroup'
            GroupScope = 'Global'
            Category = 'Security'
            Path = 'OU=Fake,DC=contoso,DC=com'
            Description = 'Test AD group description'
            DisplayName = 'Test display name'
            Ensure = 'Present'
            Notes = 'This is a test AD group'
            ManagedBy = 'CN=User 1,CN=Users,DC=contoso,DC=com'
        }

        $testAbsentParams = $testPresentParams.Clone()
        $testAbsentParams['Ensure'] = 'Absent'
        $testPresentParamsMultiDomain = $testPresentParams.Clone()
        $testPresentParamsMultiDomain.MembershipAttribute = 'DistinguishedName'

        $fakeADGroup = @{
            Name = $testPresentParams.GroupName
            Identity = $testPresentParams.GroupName
            GroupScope = $testPresentParams.GroupScope
            GroupCategory = $testPresentParams.Category
            DistinguishedName = "CN=$($testPresentParams.GroupName),$($testPresentParams.Path)"
            Description = $testPresentParams.Description
            DisplayName = $testPresentParams.DisplayName
            ManagedBy = $testPresentParams.ManagedBy
            Info = $testPresentParams.Notes
        }

        $fakeADUser1 = [PSCustomObject] @{
            DistinguishedName = 'CN=User 1,CN=Users,DC=contoso,DC=com'
            ObjectGUID = 'a97cc867-0c9e-4928-8387-0dba0c883b8e'
            SamAccountName = 'USER1'
            SID = 'S-1-5-21-1131554080-2861379300-292325817-1106'
        }
        $fakeADUser2 = [PSCustomObject] @{
            DistinguishedName = 'CN=User 2,CN=Users,DC=contoso,DC=com'
            ObjectGUID = 'a97cc867-0c9e-4928-8387-0dba0c883b8f'
            SamAccountName = 'USER2'
            SID = 'S-1-5-21-1131554080-2861379300-292325817-1107'
        }
        $fakeADUser3 = [PSCustomObject] @{
            DistinguishedName = 'CN=User 3,CN=Users,DC=contoso,DC=com'
            ObjectGUID = 'a97cc867-0c9e-4928-8387-0dba0c883b90'
            SamAccountName = 'USER3'
            SID = 'S-1-5-21-1131554080-2861379300-292325817-1108'
        }
        $fakeADUser4 = [PSCustomObject] @{
            DistinguishedName = 'CN=User 4,CN=Users,DC=sub,DC=contoso,DC=com'
            ObjectGUID = 'ebafa34e-b020-40cd-8652-ee7286419869'
            SamAccountName = 'USER4'
            SID = 'S-1-5-21-1131554080-2861379300-292325817-1109'
        }

        $testDomainController = 'TESTDC'

        $testCredentials = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @(
            'DummyUser',
            (ConvertTo-SecureString -String 'DummyPassword' -AsPlainText -Force)
        )

        #region Function Get-TargetResource
        Describe 'ADGroup\Get-TargetResource' {
            Mock -CommandName Assert-Module -ParameterFilter {
                $ModuleName -eq 'ActiveDirectory'
            }

            It 'Calls "Assert-Module" to check AD module is installed' {
                Mock -CommandName Get-ADGroup -MockWith {
                    return $fakeADGroup
                }

                Mock -CommandName Get-ADGroupMember -MockWith {
                    return @(
                        $fakeADUser1,
                        $fakeADUser2
                    )
                }

                $null = Get-TargetResource @testPresentParams

                Assert-MockCalled -CommandName Assert-Module -ParameterFilter {
                    $ModuleName -eq 'ActiveDirectory'
                } -Scope It
            }

            It 'Returns the correct values when group exists' {
                Mock -CommandName Get-ADGroup -MockWith {
                    return $fakeADGroup
                }

                Mock -CommandName Get-ADGroupMember -MockWith {
                    return @(
                        $fakeADUser1,
                        $fakeADUser2
                    )
                }

                $result = Get-TargetResource @testPresentParams
                $result.Ensure | Should -Be 'Present'
                $result.GroupName | Should -Be $fakeADGroup.Name
                $result.GroupScope | Should -Be $fakeADGroup.GroupScope
                $result.Category | Should -Be $fakeADGroup.GroupCategory
                $result.Path | Should -Be 'OU=Fake,DC=contoso,DC=com'
                $result.Description | Should -Be $fakeADGroup.Description
                $result.DisplayName | Should -Be $fakeADGroup.DisplayName
                $result.Members | Should -HaveCount 2
                $result.Members | Should -Contain $fakeADUser1.SamAccountName
                $result.Members | Should -Contain $fakeADUser2.SamAccountName
                $result.MembersToInclude | Should -BeNullOrEmpty
                $result.MembersToExclude | Should -BeNullOrEmpty
                $result.MembershipAttribute | Should -Be 'SamAccountName'
                $result.ManagedBy | Should -Be $fakeADGroup.ManagedBy
                $result.Notes | Should -Be $fakeADGroup.Info
                $result.DistinguishedName | Should -Be $fakeADGroup.DistinguishedName
            }

            It 'Returns the correct values when group does not exist' {
                Mock -CommandName Get-ADGroup -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                $result = Get-TargetResource @testPresentParams
                $result.Ensure | Should -Be 'Absent'
                $result.GroupName | Should -Be $testPresentParams.GroupName
                $result.GroupScope | Should -BeNullOrEmpty
                $result.Category | Should -BeNullOrEmpty
                $result.Path | Should -BeNullOrEmpty
                $result.Description | Should -BeNullOrEmpty
                $result.DisplayName | Should -BeNullOrEmpty
                $result.Members | Should -BeNullOrEmpty
                $result.MembersToInclude | Should -BeNullOrEmpty
                $result.MembersToExclude | Should -BeNullOrEmpty
                $result.MembershipAttribute | Should -Be 'SamAccountName'
                $result.ManagedBy | Should -BeNullOrEmpty
                $result.Notes | Should -BeNullOrEmpty
                $result.DistinguishedName | Should -BeNullOrEmpty
            }


            It "Calls 'Get-ADGroup' with 'Server' parameter when 'DomainController' specified" {
                Mock -CommandName Get-ADGroup -ParameterFilter {
                    $Server -eq $testDomainController
                } -MockWith {
                    return $fakeADGroup
                }

                Mock -CommandName Get-ADGroupMember -MockWith {
                    return @(
                        $fakeADUser1,
                        $fakeADUser2
                    )
                }

                Get-TargetResource @testPresentParams -DomainController $testDomainController

                Assert-MockCalled -CommandName Get-ADGroup -ParameterFilter {
                    $Server -eq $testDomainController
                } -Scope It
            }

            It "Calls 'Get-ADGroup' with 'Credential' parameter when specified" {
                Mock -CommandName Get-ADGroup -ParameterFilter {
                    $Credential -eq $testCredentials
                } -MockWith {
                    return $fakeADGroup
                }

                Mock -CommandName Get-ADGroupMember -MockWith {
                    return @(
                        $fakeADUser1,
                        $fakeADUser2
                    )
                }

                Get-TargetResource @testPresentParams -Credential $testCredentials

                Assert-MockCalled -CommandName Get-ADGroup -ParameterFilter {
                    $Credential -eq $testCredentials
                } -Scope It
            }

            It "Calls 'Get-ADGroupMember' with 'Server' parameter when 'DomainController' specified" {
                Mock -CommandName Get-ADGroup -MockWith {
                    return $fakeADGroup
                }

                Mock -CommandName Get-ADGroupMember -ParameterFilter {
                    $Server -eq $testDomainController
                } -MockWith {
                    return @(
                        $fakeADUser1,
                        $fakeADUser2
                    )
                }

                Get-TargetResource @testPresentParams -DomainController $testDomainController

                Assert-MockCalled -CommandName Get-ADGroupMember -ParameterFilter {
                    $Server -eq $testDomainController
                } -Scope It
            }

            It "Calls 'Get-ADGroupMember' with 'Credential' parameter when specified" {
                Mock -CommandName Get-ADGroup -MockWith {
                    return $fakeADGroup
                }

                Mock -CommandName Get-ADGroupMember -ParameterFilter {
                    $Credential -eq $testCredentials
                } -MockWith {
                    return @(
                        $fakeADUser1,
                        $fakeADUser2
                    )
                }

                Get-TargetResource @testPresentParams -Credential $testCredentials

                Assert-MockCalled -CommandName Get-ADGroupMember -ParameterFilter {
                    $Credential -eq $testCredentials
                } -Scope It
            }

        }
        #end region

        #region Function Test-TargetResource
        Describe 'ADGroup\Test-TargetResource' {
            Mock -CommandName Assert-Module -ParameterFilter {
                $ModuleName -eq 'ActiveDirectory'
            }

            foreach ($attribute in @('SamAccountName','DistinguishedName','ObjectGUID','SID'))
            {
                It "Passes when group 'Members' match using '$attribute'" {
                    Mock -CommandName Get-ADGroup -MockWith {
                        return $fakeADGroup
                    }

                    Mock -CommandName Get-ADGroupMember -MockWith {
                        return @(
                            $fakeADUser1,
                            $fakeADUser2
                        )
                    }

                    $targetResource = Test-TargetResource @testPresentParams -Members $fakeADUser1.$attribute, $fakeADUser2.$attribute -MembershipAttribute $attribute

                    $targetResource | Should -BeTrue
                }

                It "Fails when group membership counts do not match using '$attribute'" {
                    Mock -CommandName Get-ADGroup -MockWith {
                        return $fakeADGroup
                    }

                    Mock -CommandName Get-ADGroupMember -MockWith {
                        return @(
                            $fakeADUser1
                        )
                    }

                    $targetResource = Test-TargetResource @testPresentParams -Members $fakeADUser2.$attribute, $fakeADUser3.$attribute -MembershipAttribute $attribute

                    $targetResource | Should -BeFalse
                }

                It "Fails when group 'Members' do not match using '$attribute'" {
                    Mock -CommandName Get-ADGroup -MockWith {
                        return $fakeADGroup
                    }

                    Mock -CommandName Get-ADGroupMember -MockWith {
                        return @(
                            $fakeADUser1,
                            $fakeADUser2
                        )
                    }

                    $targetResource = Test-TargetResource @testPresentParams -Members $fakeADUser2.$attribute, $fakeADUser3.$attribute -MembershipAttribute $attribute

                    $targetResource | Should -BeFalse
                }

                It "Passes when specified 'MembersToInclude' match using '$attribute'" {
                    Mock -CommandName Get-ADGroup -MockWith {
                        return $fakeADGroup
                    }

                    Mock -CommandName Get-ADGroupMember -MockWith {
                        return @(
                            $fakeADUser1,
                            $fakeADUser2
                        )
                    }

                    $targetResource = Test-TargetResource @testPresentParams -MembersToInclude $fakeADUser2.$attribute -MembershipAttribute $attribute

                    $targetResource | Should -BeTrue
                }

                It "Fails when specified 'MembersToInclude' are missing using '$attribute'" {
                    Mock -CommandName Get-ADGroup -MockWith {
                        return $fakeADGroup
                    }

                    Mock -CommandName Get-ADGroupMember -MockWith {
                        return @(
                            $fakeADUser1,
                            $fakeADUser2
                        )
                    }

                    $targetResource = Test-TargetResource @testPresentParams -MembersToInclude $fakeADUser3.$attribute -MembershipAttribute $attribute

                    $targetResource | Should -BeFalse
                }

                It "Passes when specified 'MembersToExclude' are missing using '$attribute'" {
                    Mock -CommandName Get-ADGroup -MockWith {
                        return $fakeADGroup
                    }

                    Mock -CommandName Get-ADGroupMember -MockWith {
                        return @(
                            $fakeADUser1,
                            $fakeADUser2
                        )
                    }

                    $targetResource = Test-TargetResource @testPresentParams -MembersToExclude $fakeADUser3.$attribute -MembershipAttribute $attribute

                    $targetResource | Should -BeTrue
                }

                It "Fails when when specified 'MembersToExclude' match using '$attribute'" {
                    Mock -CommandName Get-ADGroup -MockWith {
                        return $fakeADGroup
                    }

                    Mock -CommandName Get-ADGroupMember -MockWith {
                        return @(
                            $fakeADUser1,
                            $fakeADUser2
                        )
                    }

                    $targetResource = Test-TargetResource @testPresentParams -MembersToExclude $fakeADUser2.$attribute -MembershipAttribute $attribute

                    $targetResource | Should -BeFalse
                }

            } #end foreach attribute

            It "Fails when group does not exist and 'Ensure' is 'Present'" {
                Mock -CommandName Get-TargetResource -MockWith {
                    return $testAbsentParams
                }

                Test-TargetResource @testPresentParams | Should -BeFalse
            }

            It "Fails when group exists, 'Ensure' is 'Present' but 'Scope' is wrong" {
                Mock -CommandName Get-TargetResource -MockWith {
                    $duffADGroup = $testPresentParams.Clone()
                    $duffADGroup['GroupScope'] = 'Universal'

                    return $duffADGroup
                }

                Test-TargetResource @testPresentParams | Should -BeFalse
            }

            It "Fails when group exists, 'Ensure' is 'Present' but 'Category' is wrong" {
                Mock -CommandName Get-TargetResource -MockWith {
                    $duffADGroup = $testPresentParams.Clone()
                    $duffADGroup['Category'] = 'Distribution'

                    return $duffADGroup
                }

                Test-TargetResource @testPresentParams | Should -BeFalse
            }

            It "Fails when group exists, 'Ensure' is 'Present' but 'Path' is wrong" {
                Mock -CommandName Get-TargetResource -MockWith {
                    $duffADGroup = $testPresentParams.Clone()
                    $duffADGroup['Path'] = 'OU=WrongPath,DC=contoso,DC=com'

                    return $duffADGroup
                }

                Test-TargetResource @testPresentParams | Should -BeFalse
            }

            It "Fails when group exists, 'Ensure' is 'Present' but 'Description' is wrong" {
                Mock -CommandName Get-TargetResource -MockWith {
                    $duffADGroup = $testPresentParams.Clone()
                    $duffADGroup['Description'] = 'Test AD group description is wrong'

                    return $duffADGroup
                }

                Test-TargetResource @testPresentParams | Should -BeFalse
            }

            It "Fails when group exists, 'Ensure' is 'Present' but 'DisplayName' is wrong" {
                Mock -CommandName Get-TargetResource -MockWith {
                    $duffADGroup = $testPresentParams.Clone()
                    $duffADGroup['DisplayName'] = 'Wrong display name'

                    return $duffADGroup
                }

                Test-TargetResource @testPresentParams | Should -BeFalse
            }

            It "Fails when group exists, 'Ensure' is 'Present' but 'ManagedBy' is wrong" {
                Mock -CommandName Get-TargetResource -MockWith {
                    $duffADGroup = $testPresentParams.Clone()
                    $duffADGroup['ManagedBy'] = $fakeADUser3.DistinguishedName

                    return $duffADGroup
                }

                Test-TargetResource @testPresentParams | Should -BeFalse
            }

            It "Fails when group exists, 'Ensure' is 'Present' but 'Notes' is wrong" {
                Mock -CommandName Get-TargetResource -MockWith {
                    $duffADGroup = $testPresentParams.Clone()
                    $duffADGroup['Notes'] = 'These notes are clearly wrong'

                    return $duffADGroup
                }

                Test-TargetResource @testPresentParams | Should -BeFalse
            }

            It "Fails when group exists and 'Ensure' is 'Absent'" {
                Mock -CommandName Get-TargetResource -MockWith {
                    return $testPresentParams
                }

                Test-TargetResource @testAbsentParams | Should -BeFalse
            }

            It "Passes when group exists, target matches and 'Ensure' is 'Present'" {
                Mock -CommandName Get-TargetResource -MockWith {
                    return $testPresentParams
                }

                Test-TargetResource @testPresentParams | Should -BeTrue
            }

            It "Passes when group does not exist and 'Ensure' is 'Absent'" {
                Mock -CommandName Get-TargetResource -MockWith {
                    return $testAbsentParams
                }

                Test-TargetResource @testAbsentParams | Should -BeTrue
            }

        }
        #end region

        #region Function Set-TargetResource
        Describe 'ADGroup\Set-TargetResource' {
            Mock -CommandName Assert-Module -ParameterFilter {
                $ModuleName -eq 'ActiveDirectory'
            }

            Mock -CommandName Assert-MemberParameters

            It "Calls 'New-ADGroup' when 'Ensure' is 'Present' and the group does not exist" {
                Mock -CommandName Get-ADGroup -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName New-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Set-TargetResource @testPresentParams

                Assert-MockCalled -CommandName New-ADGroup -Scope It
            }

            $testProperties = @{
                Description = 'Test AD Group description is wrong'
                ManagedBy = $fakeADUser3.DistinguishedName
                DisplayName = 'Test DisplayName'
            }

            foreach ($property in $testProperties.Keys)
            {
                It "Calls 'Set-ADGroup' when 'Ensure' is 'Present' and '$property' is specified" {
                    Mock -CommandName Set-ADGroup
                    Mock -CommandName Get-ADGroupMember
                    Mock -CommandName Get-ADGroup -MockWith {
                        $duffADGroup = $fakeADGroup.Clone()
                        $duffADGroup[$property] = $testProperties.$property

                        return $duffADGroup
                    }

                    Set-TargetResource @testPresentParams

                    Assert-MockCalled -CommandName Set-ADGroup -Scope It -Exactly 1
                }
            }

            It "Calls 'Set-ADGroup' when 'Ensure' is 'Present' and 'Category' is specified" {
                Mock -CommandName Set-ADGroup -ParameterFilter {
                    $GroupCategory -eq $testPresentParams.Category
                }

                Mock -CommandName Get-ADGroupMember
                Mock -CommandName Get-ADGroup -MockWith {
                    $duffADGroup = $fakeADGroup.Clone()
                    $duffADGroup['GroupCategory'] = 'Distribution'

                    return $duffADGroup
                }

                Set-TargetResource @testPresentParams

                Assert-MockCalled -CommandName Set-ADGroup -ParameterFilter { $GroupCategory -eq $testPresentParams.Category } -Scope It -Exactly 1
            }

            It "Calls 'Set-ADGroup' when 'Ensure' is 'Present' and 'Notes' is specified" {
                Mock -CommandName Set-ADGroup -ParameterFilter {
                    $Replace -ne $null
                }

                Mock -CommandName Get-ADGroupMember
                Mock -CommandName Get-ADGroup {
                    $duffADGroup = $fakeADGroup.Clone()
                    $duffADGroup['Info'] = 'My test note..'

                    return $duffADGroup
                }

                Set-TargetResource @testPresentParams

                Assert-MockCalled -CommandName Set-ADGroup -ParameterFilter { $Replace -ne $null } -Scope It -Exactly 1
            }

            It "Calls 'Set-ADGroup' twice when 'Ensure' is 'Present', the group exists but the 'Scope' has changed" {
                Mock -CommandName Set-ADGroup
                Mock -CommandName Get-ADGroupMember
                Mock -CommandName Get-ADGroup -MockWith {
                    $duffADGroup = $fakeADGroup.Clone()
                    $duffADGroup['GroupScope'] = 'DomainLocal'

                    return $duffADGroup
                }

                Set-TargetResource @testPresentParams

                Assert-MockCalled -CommandName Set-ADGroup -Scope It -Exactly 2
            }

            It "Adds group members when 'Ensure' is 'Present', the group exists and 'Members' are specified" {
                Mock -CommandName Get-ADGroup -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName Add-ADCommonGroupMember
                Mock -CommandName New-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Set-TargetResource @testPresentParams -Members @($fakeADUser1.SamAccountName, $fakeADUser2.SamAccountName)

                Assert-MockCalled -CommandName Add-ADCommonGroupMember -Scope It
            }

            It "Tries to resolve the domain names for all groups in the same domain when the 'MembershipAttribute' property is set to distinguishedName" {
                Mock -CommandName Get-ADGroup -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName Add-ADCommonGroupMember
                Mock -CommandName New-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Mock -CommandName Get-DomainName -MockWith {
                    return 'contoso.com'
                }

                Mock -CommandName Get-ADDomainNameFromDistinguishedName -MockWith {
                    return 'contoso.com'
                }

                Mock -CommandName Write-Verbose -ParameterFilter {
                    $Message -and $Message -match 'Group membership objects are in .* different AD Domains.'
                }

                Set-TargetResource @testPresentParamsMultiDomain -Members @($fakeADUser1.distinguishedName, $fakeADUser2.distinguishedName)

                Assert-MockCalled -CommandName Get-ADDomainNameFromDistinguishedName
                Assert-MockCalled -CommandName Add-ADCommonGroupMember -Scope It
                Assert-MockCalled -CommandName Write-Verbose -ParameterFilter {
                    $Message -and $Message -match 'Group membership objects are in .* different AD Domains.'
                } -Exactly -Times 0
            }

            It "Tries to resolve the domain names for all groups in different domains when the 'MembershipAttribute' property is set to distinguishedName" {
                Mock -CommandName Get-ADGroup -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName Add-ADCommonGroupMember
                Mock -CommandName New-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Mock -CommandName Get-DomainName -MockWith {
                    return 'contoso.com'
                }

                Mock -CommandName Get-ADDomainNameFromDistinguishedName -MockWith {
                    param
                    (
                        [Parameter()]
                        [System.String]
                        $DistinguishedName
                    )

                    if ($DistinguishedName -match 'DC=sub')
                    {
                        return 'sub.contoso.com'
                    }
                    else
                    {
                        return 'contoso.com'
                    }
                }

                Mock -CommandName Write-Verbose -ParameterFilter {
                    $Message -and $Message -match 'Group membership objects are in .* different AD Domains.'
                }

                Set-TargetResource @testPresentParamsMultiDomain -Members @($fakeADUser1.distinguishedName, $fakeADUser4.distinguishedName)

                Assert-MockCalled -CommandName Get-ADDomainNameFromDistinguishedName
                Assert-MockCalled -CommandName Add-ADCommonGroupMember -Scope It
                Assert-MockCalled -CommandName Write-Verbose -ParameterFilter {
                    $Message -and $Message -match 'Group membership objects are in .* different AD Domains.'
                }
            }

            It "Adds group members when 'Ensure' is 'Present', the group exists and 'MembersToInclude' are specified" {
                Mock -CommandName Get-ADGroup -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName Add-ADCommonGroupMember
                Mock -CommandName New-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Set-TargetResource @testPresentParams -MembersToInclude @($fakeADUser1.SamAccountName, $fakeADUser2.SamAccountName)

                Assert-MockCalled -CommandName Add-ADCommonGroupMember -Scope It
            }

            It "Moves group when 'Ensure' is 'Present', the group exists but the 'Path' has changed" {
                Mock -CommandName Set-ADGroup
                Mock -CommandName Get-ADGroupMember
                Mock -CommandName Move-ADObject
                Mock -CommandName Get-ADGroup -MockWith {
                    $duffADGroup = $fakeADGroup.Clone()
                    $duffADGroup['DistinguishedName'] = "CN=$($testPresentParams.GroupName),OU=WrongPath,DC=contoso,DC=com"

                    return $duffADGroup
                }

                Set-TargetResource @testPresentParams

                Assert-MockCalled -CommandName Move-ADObject -Scope It
            }

            It "Resets group membership when 'Ensure' is 'Present' and 'Members' is incorrect" {
                Mock -CommandName Get-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName Get-ADGroupMember -MockWith {
                    return @(
                        $fakeADUser1,
                        $fakeADUser2
                    )
                }

                Mock -CommandName Add-ADCommonGroupMember
                Mock -CommandName Remove-ADGroupMember

                Set-TargetResource @testPresentParams -Members $fakeADUser1.SamAccountName

                Assert-MockCalled -CommandName Remove-ADGroupMember -Scope It -Exactly 1
                Assert-MockCalled -CommandName Add-ADCommonGroupMember -Scope It -Exactly 1
            }

            It "Does not reset group membership when 'Ensure' is 'Present' and existing group is empty" {
                Mock -CommandName Get-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName Get-ADGroupMember
                Mock -CommandName Remove-ADGroupMember

                Set-TargetResource @testPresentParams -MembersToExclude $fakeADUser1.SamAccountName

                Assert-MockCalled -CommandName Remove-ADGroupMember -Scope It -Exactly 0
            }

            It "Removes members when 'Ensure' is 'Present' and 'MembersToExclude' is incorrect" {
                Mock -CommandName Get-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName Get-ADGroupMember -MockWith {
                    return @(
                        $fakeADUser1,
                        $fakeADUser2
                    )
                }

                Mock -CommandName Remove-ADGroupMember

                Set-TargetResource @testPresentParams -MembersToExclude $fakeADUser1.SamAccountName

                Assert-MockCalled -CommandName Remove-ADGroupMember -Scope It -Exactly 1
            }

            It "Adds members when 'Ensure' is 'Present' and 'MembersToInclude' is incorrect" {
                Mock -CommandName Get-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName Get-ADGroupMember -MockWith {
                    return @(
                        $fakeADUser1,
                        $fakeADUser2
                    )
                }

                Mock -CommandName Add-ADCommonGroupMember

                Set-TargetResource @testPresentParams -MembersToInclude $fakeADUser3.SamAccountName

                Assert-MockCalled -CommandName Add-ADCommonGroupMember -Scope It -Exactly 1
            }

            It "Removes group when 'Ensure' is 'Absent' and group exists" {
                Mock -CommandName Get-ADGroup -MockWith {
                    return $fakeADGroup
                }

                Mock -CommandName Remove-ADGroup

                Set-TargetResource @testAbsentParams

                Assert-MockCalled -CommandName Remove-ADGroup -Scope It
            }

            It "Calls 'Set-ADGroup' with credentials when 'Ensure' is 'Present' and the group exists (#106)" {
                Mock -CommandName Get-ADGroup -MockWith {
                    return $fakeADGroup
                }

                Mock -CommandName New-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Mock -CommandName Get-ADGroupMember
                Mock -CommandName Set-ADGroup -ParameterFilter {
                    $Credential -eq $testCredentials
                }

                Set-TargetResource @testPresentParams -Credential $testCredentials

                Assert-MockCalled -CommandName Set-ADGroup -ParameterFilter {
                    $Credential -eq $testCredentials
                } -Scope It
            }

            It "Calls 'Set-ADGroup' with credentials when 'Ensure' is 'Present' and the group does not exist  (#106)" {
                Mock -CommandName Get-ADGroup -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                Mock -CommandName Set-ADGroup -ParameterFilter {
                    $Credential -eq $testCredentials
                }

                Mock -CommandName New-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Set-TargetResource @testPresentParams -Credential $testCredentials

                Assert-MockCalled -CommandName Set-ADGroup -ParameterFilter {
                    $Credential -eq $testCredentials
                } -Scope It
            }

            It "Calls 'Move-ADObject' with credentials when specified (#106)" {
                Mock -CommandName Set-ADGroup
                Mock -CommandName Get-ADGroupMember
                Mock -CommandName Move-ADObject -ParameterFilter {
                    $Credential -eq $testCredentials
                }

                Mock -CommandName Get-ADGroup -MockWith {
                    $duffADGroup = $fakeADGroup.Clone()
                    $duffADGroup['DistinguishedName'] = "CN=$($testPresentParams.GroupName),OU=WrongPath,DC=contoso,DC=com"

                    return $duffADGroup
                }

                Set-TargetResource @testPresentParams -Credential $testCredentials

                Assert-MockCalled -CommandName Move-ADObject -ParameterFilter { $Credential -eq $testCredentials } -Scope It
            }


            # tests for issue 183
            It "Doesn't reset to 'Global' when not specifying a 'Scope' and updating group membership" {
                $testUniversalPresentParams = $testPresentParams.Clone()
                $testUniversalPresentParams['GroupScope'] = 'Universal'
                $fakeADUniversalGroup = $fakeADGroup.Clone()
                $fakeADUniversalGroup['GroupScope'] = 'Universal'

                Mock -CommandName Get-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADUniversalGroup
                }

                Mock -CommandName Set-ADGroup -ParameterFilter {
                    $Identity -eq $fakeADUniversalGroup.Identity -and -not $PSBoundParameters.ContainsKey('GroupScope')
                }

                Mock -CommandName Add-ADCommonGroupMember

                Set-TargetResource -GroupName $testUniversalPresentParams.GroupName -Members @($fakeADUser1.SamAccountName, $fakeADUser2.SamAccountName)

                Assert-MockCalled -CommandName Set-ADGroup -Times 1 -Scope It
            }

            # tests for issue 183
            It "Doesn't reset to 'Security' when not specifying a 'Category' and updating group membership" {
                $testUniversalPresentParams = $testPresentParams.Clone()
                $testUniversalPresentParams['Category'] = 'Distribution'
                $fakeADUniversalGroup = $fakeADGroup.Clone()
                $fakeADUniversalGroup['GroupCategory'] = 'Distribution'

                Mock -CommandName Get-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADUniversalGroup
                }

                Mock -CommandName Set-ADGroup -ParameterFilter {
                    $Identity -eq $fakeADUniversalGroup.Identity -and -not $PSBoundParameters.ContainsKey('GroupCategory')
                }

                Mock -CommandName Add-ADCommonGroupMember

                Set-TargetResource -GroupName $testUniversalPresentParams.GroupName -Members @($fakeADUser1.SamAccountName, $fakeADUser2.SamAccountName)

                Assert-MockCalled -CommandName Set-ADGroup -Times 1 -Scope It
            }

            # tests for issue 183
            It "Doesn't reset to 'Global' when not specifying a 'Scope' and testing display name" {
                $testUniversalPresentParams = $testPresentParams.Clone()
                $testUniversalPresentParams['GroupScope'] = 'Universal'
                $fakeADUniversalGroup = $fakeADGroup.Clone()
                $fakeADUniversalGroup['GroupScope'] = 'Universal'

                Mock -CommandName Get-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADUniversalGroup
                }

                Mock -CommandName Set-ADGroup -ParameterFilter {
                    $Identity -eq $fakeADUniversalGroup.Identity -and -not $PSBoundParameters.ContainsKey('GroupScope')
                }

                Mock -CommandName Add-ADCommonGroupMember

                $universalGroupInCompliance = Test-TargetResource -GroupName $testUniversalPresentParams.GroupName -DisplayName $testUniversalPresentParams.DisplayName
                $universalGroupInCompliance | Should -BeTrue
            }

            # tests for issue 183
            It "Doesn't reset to 'Security' when not specifying a 'Category' and testing display name" {
                $testUniversalPresentParams = $testPresentParams.Clone()
                $testUniversalPresentParams['Category'] = 'Distribution'
                $fakeADUniversalGroup = $fakeADGroup.Clone()
                $fakeADUniversalGroup['GroupCategory'] = 'Distribution'

                Mock -CommandName Get-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADUniversalGroup
                }

                Mock -CommandName Set-ADGroup -ParameterFilter {
                    $Identity -eq $fakeADUniversalGroup.Identity -and -not $PSBoundParameters.ContainsKey('GroupScope')
                }

                Mock -CommandName Add-ADCommonGroupMember

                $universalGroupInCompliance = Test-TargetResource -GroupName $testUniversalPresentParams.GroupName -DisplayName $testUniversalPresentParams.DisplayName
                $universalGroupInCompliance | Should -BeTrue
            }

            It "Calls Restore-AdCommonObject when RestoreFromRecycleBin is used" {
                $restoreParam = $testPresentParams.Clone()
                $restoreParam.RestoreFromRecycleBin = $true
                Mock -CommandName Get-ADGroup -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName New-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Mock -CommandName Restore-ADCommonObject -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Set-TargetResource @restoreParam

                Assert-MockCalled -CommandName Restore-AdCommonObject -Scope It
                Assert-MockCalled -CommandName New-ADGroup -Scope It -Exactly -Times 0
                Assert-MockCalled -CommandName Set-ADGroup -Scope It
            }

            It "Calls New-ADGroup when RestoreFromRecycleBin is used and if no object was found in the recycle bin" {
                $restoreParam = $testPresentParams.Clone()
                $restoreParam.RestoreFromRecycleBin = $true
                Mock -CommandName Get-ADGroup -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName New-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Mock -CommandName Restore-ADCommonObject

                Set-TargetResource @restoreParam

                Assert-MockCalled -CommandName Restore-AdCommonObject -Scope It
                Assert-MockCalled -CommandName New-ADGroup -Scope It
            }

            It "Throws if the object cannot be restored" {
                $restoreParam = $testPresentParams.Clone()
                $restoreParam.RestoreFromRecycleBin = $true
                Mock -CommandName Get-ADGroup -MockWith {
                    throw New-Object Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException
                }

                Mock -CommandName Set-ADGroup
                Mock -CommandName New-ADGroup -MockWith {
                    return [PSCustomObject] $fakeADGroup
                }

                Mock -CommandName Restore-ADCommonObject -MockWith {
                    throw (New-Object -TypeName System.InvalidOperationException)
                }

                {Set-TargetResource @restoreParam} | Should -Throw

                Assert-MockCalled -CommandName Restore-AdCommonObject -Scope It
                Assert-MockCalled -CommandName New-ADGroup -Scope It -Exactly -Times 0
                Assert-MockCalled -CommandName Set-ADGroup -Scope It -Exactly -Times 0
            }
        }
        #end region

    }
    #end region
}
finally
{
    Invoke-TestCleanup
}
