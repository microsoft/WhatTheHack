[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
param ()

$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

Describe 'GroupResource Unit Tests' {
    BeforeAll {
        # Import CommonTestHelper
        $testsFolderFilePath = Split-Path $PSScriptRoot -Parent
        $testHelperFolderFilePath = Join-Path -Path $testsFolderFilePath -ChildPath 'TestHelpers'
        $commonTestHelperFilePath = Join-Path -Path $testHelperFolderFilePath -ChildPath 'CommonTestHelper.psm1'
        Import-Module -Name $commonTestHelperFilePath

        $script:testEnvironment = Enter-DscResourceTestEnvironment `
            -DscResourceModuleName 'PSDscResources' `
            -DscResourceName 'MSFT_GroupResource' `
            -TestType 'Unit'

        InModuleScope 'MSFT_GroupResource' {
            <#
                Create test group object to be used in tests.
                It must be created within module scope for objects to be
                accessible to tests running in module scope.
            #>
            $script:disposableObjects = @()

            $script:testGroupName = 'TestGroup'
            $script:testGroupDescription = 'A group for testing'

            $script:localDomain = $env:computerName

            $script:onNanoServer = Test-IsNanoServer

            $script:testMemberName1 = 'User1'
            $script:testMemberName2 = 'User2'
            $script:testMemberName3 = 'User3'

            $testUserName = 'TestUserName'
            $testPassword = 'TestPassword'
            $secureTestPassword = ConvertTo-SecureString -String $testPassword -AsPlainText -Force

            $script:testCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @( $testUsername, $secureTestPassword )

            $script:testErrorMessage = 'Test error message'

            if ($script:onNanoServer)
            {
                $script:testLocalGroup = New-Object -TypeName 'Microsoft.PowerShell.Commands.LocalGroup' -ArgumentList @( $script:testGroupName )
            }
            else
            {
                $script:testPrincipalContext = New-Object -TypeName 'System.DirectoryServices.AccountManagement.PrincipalContext' -ArgumentList @( [System.DirectoryServices.AccountManagement.ContextType]::Machine )

                $script:testGroup = New-Object -TypeName 'System.DirectoryServices.AccountManagement.GroupPrincipal' -ArgumentList @( $script:testPrincipalContext )
                $script:disposableObjects += $testGroup

                $script:testUserPrincipal1 = New-Object -TypeName 'System.DirectoryServices.AccountManagement.UserPrincipal' -ArgumentList @( $testPrincipalContext )
                $script:testuserPrincipal1.Name = $script:testMemberName1
                $script:testuserPrincipal1.SamAccountName = 'SamAccountName1'
                $script:disposableObjects += $script:testuserPrincipal1

                $script:testUserPrincipal2 = New-Object -TypeName 'System.DirectoryServices.AccountManagement.UserPrincipal' -ArgumentList @( $testPrincipalContext )
                $script:testuserPrincipal2.Name = $script:testMemberName2
                $script:testuserPrincipal2.SamAccountName = 'SamAccountName2'
                $script:disposableObjects += $script:testuserPrincipal2

                $script:testUserPrincipal3 = New-Object -TypeName 'System.DirectoryServices.AccountManagement.UserPrincipal' -ArgumentList @( $testPrincipalContext )
                $script:testuserPrincipal3.Name = $script:testMemberName3
                $script:testuserPrincipal3.SamAccountName = 'SamAccountName3'
                $script:disposableObjects += $script:testuserPrincipal3
            }
        }
    }

    AfterAll {
        InModuleScope 'MSFT_GroupResource' {
            # Dispose of module scoped test group objects
            foreach ($disposableObject in $script:disposableObjects)
            {
                $disposableObject.Dispose()
            }
        }

        Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
    }

    InModuleScope 'MSFT_GroupResource' {
        <#
            .SYNOPSIS
                Reset a test group object prior to running each test.

            .DESCRIPTION
                Resets the test group prior to executing tests to ensure
                it is in a known state.
        #>
        function Reset-TestGroup {
            [CmdletBinding()]
            param
            (
            )

            if (-not ($script:onNanoServer))
            {
                $script:testGroup.Name = $script:testGroupName
                $script:testGroup.Description = ''

                if ($script:testGroup.Members.Count -gt 0)
                {
                    $script:testGroup.Members.Clear()
                }
            }
            else
            {
                # Reset the local group
                $script:testLocalGroup.Name = $script:testGroupName
                $script:testLocalGroup.Description = ''
            }
        }

        <#
            Get-Group, Add-GroupMember, Remove-GroupMember, Clear-GroupMember, Save-Group,
            Remove-Group, Find-Principal, and Remove-DisposableObject cannot be unit tested
            because they are wrapper functions for .NET class function calls.
        #>
        Describe 'GroupResource\Get-TargetResource' -Tag 'Get' {
            BeforeEach {
                Mock -CommandName 'Assert-GroupNameValid' -MockWith { }
                Mock -CommandName 'Test-IsNanoServer' -MockWith { return $false }
                Mock -CommandName 'Get-TargetResourceOnFullSKU' -MockWith { return @{ TestResult = 'OnFullSKU' } }
                Mock -CommandName 'Get-TargetResourceOnNanoServer' -MockWith { return @{ TestResult = 'OnNanoServer' } }
            }

            Context 'When called with the given group name' {
                It 'Should call Assert-GroupNameValid' {
                    $null = Get-TargetResource -GroupName $script:testGroupName

                    Assert-MockCalled -CommandName 'Assert-GroupNameValid' -ParameterFilter { $GroupName -eq $script:testGroupName }
                }
            }

            Context 'When called with all parameters when not on Nano Server' {
                It 'Should return output from Get-TargetResourceOnFullSKU' {
                    $getTargetResourceResult = Get-TargetResource -GroupName $script:testGroupName -Credential $script:testCredential

                    Assert-MockCalled -CommandName 'Test-IsNanoServer'
                    Assert-MockCalled -CommandName 'Get-TargetResourceOnFullSKU' -ParameterFilter { $GroupName -eq $script:testGroupName -and $Credential -eq $script:testCredential }
                    $getTargetResourceResult.TestResult | Should -Be 'OnFullSKU'
                }
            }

            Context 'When called with all parameters when on Nano Server' {
                It 'Should return output from Get-TargetResourceOnNanoServer' {
                    Mock -CommandName 'Test-IsNanoServer' -MockWith { return $true }

                    $getTargetResourceResult = Get-TargetResource -GroupName $script:testGroupName -Credential $script:testCredential

                    Assert-MockCalled -CommandName 'Test-IsNanoServer'
                    Assert-MockCalled -CommandName 'Get-TargetResourceOnNanoServer' -ParameterFilter { $GroupName -eq $script:testGroupName -and $Credential -eq $script:testCredential }
                    $getTargetResourceResult.TestResult | Should -Be 'OnNanoServer'
                }
            }
        }

        Describe 'GroupResource\Set-TargetResource' -Tag 'Set' {
            BeforeEach {
                Mock -CommandName 'Assert-GroupNameValid' -MockWith { }
                Mock -CommandName 'Test-IsNanoServer' -MockWith { return $false }
                Mock -CommandName 'Set-TargetResourceOnFullSKU' -MockWith { }
                Mock -CommandName 'Set-TargetResourceOnNanoServer' -MockWith { }
            }

            Context 'When called with the given group name' {
                It 'Should call Assert-GroupNameValid' {
                    $null = Set-TargetResource -GroupName $script:testGroupName
                    Assert-MockCalled -CommandName 'Assert-GroupNameValid' -ParameterFilter { $GroupName -eq $script:testGroupName }
                }
            }

            Context 'When called with all parameters when not on Nano Server' {
                It 'Should call Set-TargetResourceOnFullSKU' {
                    Set-TargetResource -GroupName $script:testGroupName -Credential $script:testCredential

                    Assert-MockCalled -CommandName 'Test-IsNanoServer'
                    Assert-MockCalled -CommandName 'Set-TargetResourceOnFullSKU' -ParameterFilter { $GroupName -eq $script:testGroupName -and $Credential -eq $script:testCredential }
                }
            }

            Context 'When called with all parameters when on Nano Server' {
                It 'Should call Set-TargetResourceOnNanoServer' {
                    Mock -CommandName 'Test-IsNanoServer' -MockWith { return $true }

                    Set-TargetResource -GroupName $script:testGroupName -Credential $script:testCredential

                    Assert-MockCalled -CommandName 'Test-IsNanoServer'
                    Assert-MockCalled -CommandName 'Set-TargetResourceOnNanoServer' -ParameterFilter { $GroupName -eq $script:testGroupName -and $Credential -eq $script:testCredential }
                }
            }
        }

        Describe 'GroupResource\Test-TargetResource' -Tag 'Test' {
            BeforeEach {
                Mock -CommandName 'Assert-GroupNameValid' -MockWith { }
                Mock -CommandName 'Test-IsNanoServer' -MockWith { return $false }
                Mock -CommandName 'Test-TargetResourceOnFullSKU' -MockWith { }
                Mock -CommandName 'Test-TargetResourceOnNanoServer' -MockWith { }
            }

            Context 'When called with the given group name' {
                It 'Should call Assert-GroupNameValid' {
                    $null = Test-TargetResource -GroupName $script:testGroupName
                    Assert-MockCalled -CommandName 'Assert-GroupNameValid' -ParameterFilter { $GroupName -eq $script:testGroupName }
                }
            }

            Context 'When called with all parameters when not on Nano Server' {
                It 'Should call Test-TargetResourceOnFullSKU' {
                    $null = Test-TargetResource -GroupName $script:testGroupName -Credential $script:testCredential

                    Assert-MockCalled -CommandName 'Test-IsNanoServer'
                    Assert-MockCalled -CommandName 'Test-TargetResourceOnFullSKU' -ParameterFilter { $GroupName -eq $script:testGroupName -and $Credential -eq $script:testCredential }
                }
            }

            Context 'When called with all parameters when on Nano Server' {
                It 'Should call Test-TargetResourceOnNanoServer' {
                    Mock -CommandName 'Test-IsNanoServer' -MockWith { return $true }

                    $null = Test-TargetResource -GroupName $script:testGroupName -Credential $script:testCredential

                    Assert-MockCalled -CommandName 'Test-IsNanoServer'
                    Assert-MockCalled -CommandName 'Test-TargetResourceOnNanoServer' -ParameterFilter { $GroupName -eq $script:testGroupName -and $Credential -eq $script:testCredential }
                }
            }
        }

        Describe 'GroupResource\Assert-GroupNameValid' -Tag 'Helper' {
            Context 'When called with an invalid group name' {
                $invalidCharacters = @( '\', '/', '"', '[', ']', ':', '|', '<', '>', '+', '=', ';', ',', '?', '*', '@' ) |
                    ForEach-Object { @{ InvalidCharacter = $_ } }

                It 'Should throw error if name contains invalid character "<InvalidCharacter>"' -TestCases $invalidCharacters {
                    param
                    (
                        [Parameter(Mandatory = $true)]
                        [System.String]
                        $InvalidCharacter
                    )

                    $invalidGroupName = ('Invalid' + $invalidCharacter + 'Group')
                    { Assert-GroupNameValid -GroupName $invalidGroupName } | Should -Throw ($script:localizedData.InvalidGroupName -f $invalidGroupName, '')
                }

                $invalidGroups = @(
                    @{
                        InvalidGroupName = '    '
                        InvalidGroupDescription = 'only whitespace'
                    },
                    @{
                        InvalidGroupName = '....'
                        InvalidGroupDescription = 'only dots'
                    },
                    @{
                        InvalidGroupName = '..    ..'
                        InvalidGroupDescription = 'only whitespace and dots'
                    }
                )

                It 'Should throw if name contains <InvalidGroupDescription>' -TestCases $invalidGroups {
                    param
                    (
                        [Parameter(Mandatory = $true)]
                        [System.String]
                        $InvalidGroupDescription,

                        [Parameter(Mandatory = $true)]
                        [System.String]
                        $InvalidGroupName
                    )

                    { Assert-GroupNameValid -GroupName $invalidGroupName } | Should -Throw ($script:localizedData.InvalidGroupName -f $invalidGroupName, '')
                }
            }

            Context 'When called with a valid group name' {
                It 'Should not throw if name contains whitespace and dots' {
                    $invalidGroupName = '..  MyGroup  ..'
                    { Assert-GroupNameValid -GroupName $invalidGroupName } | Should -Not -Throw
                }
            }
        }

        Describe 'GroupResource\Test-IsLocalMachine' -Tag 'Helper' {
            BeforeEach {
                Mock -CommandName 'Get-CimInstance' -MockWith { }
            }

            Context 'When called with a scope name that resolves to the local machine' {
                $localMachineScopes = @(
                    @{ localMachineScope = '.' }
                    @{ localMachineScope = $ENV:COMPUTERNAME }
                    @{ localMachineScope = 'localhost' }
                    @{ localMachineScope = '127.0.0.1' }
                )

                It 'Should return true for local machine scope "<LocalMachineScope>"' -TestCases $localMachineScopes {
                    param
                    (
                        [Parameter(Mandatory = $true)]
                        [System.String]
                        $LocalMachineScope
                    )

                    Test-IsLocalMachine -Scope $LocalMachineScope | Should -BeTrue
                }

                $customLocalIPAddress = '123.4.5.6'

                It 'Should return true if custom local IP address provided and Get-CimInstance contains matching IP address' {
                    Mock -CommandName 'Get-CimInstance' -MockWith { return @{ IPAddress = @($customLocalIPAddress, '789.1.2.3')} }

                    Test-IsLocalMachine -Scope $customLocalIPAddress | Should -BeTrue
                }
            }

            Context 'When called with a scope name that does not resolve to the local machine' {
                $customLocalIPAddress = '123.4.5.6'

                It 'Should return false if custom local IP address provided and Get-CimInstance returns null' {
                    Test-IsLocalMachine -Scope $customLocalIPAddress | Should -BeFalse
                }

                It 'Should return false if custom local IP address provided and Get-CimInstance do not contain matching IP addresses' {
                    Mock -CommandName 'Get-CimInstance' -MockWith { return @{ IPAddress = @('789.1.2.3')} }

                    Test-IsLocalMachine -Scope $customLocalIPAddress | Should -BeFalse
                }
            }
        }

        Describe 'GroupResource\Split-MemberName' -Tag 'Helper' {
            Context 'When called with the MemberName in the domain\username format with the local scope' {
                It 'Should return the local scope and the username' {
                    Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $true }

                    $testMemberName = 'domain\username'
                    $splitMemberNameResult = Split-MemberName -MemberName $testMemberName

                    Assert-MockCalled -CommandName 'Test-IsLocalMachine'

                    $splitMemberNameResult | Should -Be @( $script:localDomain, 'username' )
                }
            }

            Context 'When called with a MemberName in the domain\username format with the domain scope' {
                It 'Should return the specified domain and the username' {
                    Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }

                    $testMemberName = 'domain\username'
                    $splitMemberNameResult = Split-MemberName -MemberName $testMemberName

                    Assert-MockCalled -CommandName 'Test-IsLocalMachine'

                    $splitMemberNameResult | Should -Be @( 'domain', 'username' )
                }
            }

            Context 'When called with a MemberName in the username@domain format with the domain scope' {
                It 'Should return the specified domain and the username' {
                    Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }

                    $testMemberName = 'username@domain'
                    $splitMemberNameResult = Split-MemberName -MemberName $testMemberName

                    $splitMemberNameResult | Should -Be @( 'domain', 'username' )
                }
            }

            Context 'When called with a MemberName in the CN=username,DC=domain format with local scope' {
                It 'Should return the local scope and the username' {
                    Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }

                    $testMemberName = 'CN=username,DC=domain'
                    $splitMemberNameResult = Split-MemberName -MemberName $testMemberName

                    $splitMemberNameResult | Should -Be @( $script:localDomain, $testMemberName )
                }
            }

            Context 'When called with a MemberName in the CN=username,DC=domain format with domain scope' {
                It 'Should return the specified domain and the username' {
                    Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }

                    $testMemberName = 'CN=username,DC=domain,DC=com'
                    $splitMemberNameResult = Split-MemberName -MemberName $testMemberName

                    $splitMemberNameResult | Should -Be @( 'domain', $testMemberName )
                }
            }

            Context 'When called with a MemberName in the without a scope specified' {
                It 'Should return the local scope and the username' {
                    Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }

                    $testMemberName = 'username'
                    $splitMemberNameResult = Split-MemberName -MemberName $testMemberName

                    $splitMemberNameResult | Should -Be @( $script:localDomain, 'username' )
                }
            }
        }

        if ($script:onNanoServer)
        {
            Describe 'GroupResource\Get-TargetResourceOnNanoServer' -Tag 'Helper' {
                $testMembers = @('User1', 'User2')

                BeforeEach {
                    Reset-TestGroup

                    Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @() }
                }

                Context 'When Get-LocalGroup throws a GroupNotFound exception' {
                    It 'Should return Ensure as Absent' {
                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message 'Test error message' -CategoryReason 'GroupNotFoundException' }

                        $getTargetResourceResult = Get-TargetResourceOnNanoServer -GroupName $script:testGroupName

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }

                        $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                        $getTargetResourceResult.Keys.Count | Should -Be 2
                        $getTargetResourceResult.GroupName | Should -Be $script:testGroupName
                        $getTargetResourceResult.Ensure | Should -Be 'Absent'
                    }
                }

                Context 'When Get-LocalGroup throws an exception other than GroupNotFound' {
                    It 'Should throw expected exception' {
                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message $script:testErrorMessage -CategoryReason 'OtherException' }

                        { $null = Get-TargetResourceOnNanoServer -GroupName $script:testGroupName } | Should -Throw -ExpectedMessage $script:testErrorMessage

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                    }
                }

                Context 'When Get-LocalGroup returns a valid, existing group without members' {
                    It 'Should return expected values and call expected mocks' {
                        $script:testLocalGroup.Description = $script:testGroupDescription

                        Mock -CommandName 'Get-LocalGroup' -MockWith { return $script:testLocalGroup }

                        $getTargetResourceResult = Get-TargetResourceOnNanoServer -GroupName $script:testGroupName

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group -eq $script:testLocalGroup }

                        $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                        $getTargetResourceResult.Keys.Count | Should -Be 4
                        $getTargetResourceResult.GroupName | Should -Be $script:testGroupName
                        $getTargetResourceResult.Ensure | Should -Be 'Present'
                        $getTargetResourceResult.Description | Should -Be $script:testGroupDescription
                        $getTargetResourceResult.Members | Should -Be $null
                    }
                }

                Context 'When Get-LocalGroup returns a valid, existing group with members' {
                    It 'Should return expected values and call expected mocks' {
                        $script:testLocalGroup.Description = $script:testGroupDescription

                        Mock -CommandName 'Get-LocalGroup' -MockWith { return $script:testLocalGroup }
                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return $testMembers }

                        $getTargetResourceResult = Get-TargetResourceOnNanoServer -GroupName $script:testGroupName

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group -eq $script:testLocalGroup }

                        $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                        $getTargetResourceResult.Keys.Count | Should -Be 4
                        $getTargetResourceResult.GroupName | Should -Be $script:testGroupName
                        $getTargetResourceResult.Ensure | Should -Be 'Present'
                        $getTargetResourceResult.Description | Should -Be $script:testGroupDescription
                        $getTargetResourceResult.Members | Should -Be $testMembers
                    }
                }
            }

            Describe 'GroupResource\Set-TargetResourceOnNanoServer' -Tag 'Helper' {
                <#
                    .SYNOPSIS
                        Assert that Group Members have not changed on Nano Server.

                    .DESCRIPTION
                        This helper asserts that none of the calls to update a group
                        have been made.
                #>
                function Assert-GroupMembersNotChangedOnNanoServer
                {
                    [CmdletBinding()]
                    param
                    (
                    )

                    Assert-MockCalled -CommandName 'Set-LocalGroup' -Times 0 -Scope 'It'
                    Assert-MockCalled -CommandName 'Add-LocalGroupMember' -Times 0 -Scope 'It'
                    Assert-MockCalled -CommandName 'Remove-LocalGroupMember' -Times 0 -Scope 'It'
                }

                BeforeEach {
                    Reset-TestGroup

                    Mock -CommandName 'Get-LocalGroup' -MockWith { return $script:testLocalGroup }
                    Mock -CommandName 'New-LocalGroup' -MockWith { return $script:testLocalGroup }
                    Mock -CommandName 'Set-LocalGroup' -MockWith { }
                    Mock -CommandName 'Remove-LocalGroup' -MockWith { }
                    Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { }
                    Mock -CommandName 'Add-LocalGroupMember' -MockWith { }
                    Mock -CommandName 'Remove-LocalGroupMember' -MockWith { }
                }

                Context 'When Ensure is absent and the group does not exist' {
                    It 'Should not attempt to remove an absent group' {
                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message 'Test error message' -CategoryReason 'GroupNotFoundException' }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Ensure 'Absent'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-LocalGroup' -Times 0 -Scope 'It'
                    }
                }

                Context 'When Ensure is absent and the group exists' {
                    It 'Should remove an existing group' {
                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Ensure 'Absent'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName } -Scope 'It'
                    }
                }

                Context 'When Ensure is present and the group does not exist' {
                    It 'Should create an empty group' {
                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message 'Test error message' -CategoryReason 'GroupNotFoundException' }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group does not exist and Description is passed' {
                    It 'Should create an empty group with a description' {
                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message 'Test error message' -CategoryReason 'GroupNotFoundException' }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Description $script:testGroupDescription -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Set-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName -and $Description -eq $script:testGroupDescription }
                    }
                }

                Context 'When Ensure is present and the group does not exist and Members is passed with one local member' {
                    It 'Should create a group with one local member' {
                        $testMembers = @( $script:testMemberName1 )

                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message 'Test error message' -CategoryReason 'GroupNotFoundException' }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName1 }
                    }
                }

                Context 'When Ensure is present and the group does not exist and Members is passed with two local members' {
                    It 'Should create a group with two local members' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName2 )

                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message 'Test error message' -CategoryReason 'GroupNotFoundException' }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName1 }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName2 }
                    }
                }

                Context 'When Ensure is present and the group does not exist and MembersToInclude is passed with one local member' {
                    It 'Should create a group with one local member' {
                        $testMembers = @( $script:testMemberName1 )

                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message 'Test error message' -CategoryReason 'GroupNotFoundException' }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName1 }
                    }
                }

                Context 'When Ensure is present and the group does not exist and MembersToInclude is passed with two local members' {
                    It 'Should create a group with two local members using MembersToInclude' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName2 )

                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message 'Test error message' -CategoryReason 'GroupNotFoundException' }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName1 }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName2 }
                    }
                }

                Context 'When Get-LocalGroup throws an exception other than GroupNotFound' {
                    It 'Should throw expected exception' {
                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message $script:testErrorMessage -CategoryReason 'OtherException' }

                        { Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Ensure 'Present' } | Should -Throw $script:testErrorMessage
                    }
                }

                Context 'When Ensure is present and the group exists with no members and Members is passed with one member' {
                    It 'Should add a member to an existing group' {
                        $testMembers = @( $script:testMemberName1 )

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName1 }
                    }
                }

                Context 'When Ensure is present and the group exists with two members missing from Members list passed' {
                    It 'Should add two members to an existing group' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName2 )

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName1 }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName2 }
                    }
                }

                Context 'When Ensure is present and the group exists with no members and MembersToInclude is passed with one member' {
                    It 'Should add a member to an existing group' {
                        $testMembers = @( $script:testMemberName1 )

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName1 }
                    }
                }

                Context 'When Ensure is present and the group exists with two members missing from MembersToInclude list passed' {
                    It 'Should add two members to an existing group' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName2 )

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName1 }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName2 }
                    }
                }

                Context 'When Ensure is present and the group exists with one member not in the Members list passed' {
                    It 'Should remove a member from an existing group' {
                        $testMembers = @( $script:testMemberName1 )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName2 }
                    }
                }

                Context 'When Ensure is present and the group exists with containing members and an empty Members list passed' {
                    It 'Should clear all members from an existing group' {
                        $testMembers = @( )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName1 }
                        Assert-MockCalled -CommandName 'Remove-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName2 }
                    }
                }

                Context 'When Ensure is present and the group exists with a member contained in the MembersToExclude list passed' {
                    It 'Should remove a member from an existing group' {
                        $testMembers = @( $script:testMemberName2 )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToExclude $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName2 }
                    }
                }

                Context 'When Ensure is present and the group exists with Members passed that require one member to be added and one removed' {
                    It 'Should add a user and remove a user' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName3 )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName3 }
                        Assert-MockCalled -CommandName 'Remove-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName2 }
                    }
                }

                Context 'When Ensure is present and the group exists with MembersToInclude and MembersToExclude passed that require one member to be added and one removed' {
                    It 'Should add a user and remove a user' {
                        $testMembersToInclude = @( $script:testMemberName3 )
                        $testMembersToExclude = @( $script:testMemberName2 )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMemberstoInclude -MembersToExclude $testMemberstoExclude -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Add-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName3 }
                        Assert-MockCalled -CommandName 'Remove-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Member.Name -eq $script:testMemberName2 }
                    }
                }

                Context 'When Members and MembersToInclude are both specified' {
                    It 'Should throw expected exception' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName2 )
                        $testMembersToInclude = @( $script:testMemberName3 )

                        $errorMessage = $script:localizedData.MembersAndIncludeExcludeConflict -f 'Members', 'MembersToInclude'

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        { Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -MembersToInclude $testMembersToInclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }

                Context 'When Members and MembersToExclude are both specified' {
                    It 'Should throw expected exception' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName2 )
                        $testMembersToExclude = @( $script:testMemberName3 )

                        $errorMessage = $script:localizedData.MembersAndIncludeExcludeConflict -f 'Members', 'MembersToExclude'

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        { Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -MembersToExclude $testMembersToExclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }

                Context 'When MembersToInclude and MembersToExclude both contain the same member' {
                    It 'Should throw expected exception' {
                        $testMembersToInclude = @( $script:testMemberName1 )
                        $testMembersToExclude = @( $script:testMemberName1 )

                        $errorMessage = $script:localizedData.IncludeAndExcludeConflict -f $script:testMemberName1, 'MembersToInclude', 'MembersToExclude'

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        { Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembersToInclude -MembersToExclude $testMembersToExclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }

                Context 'When Ensure is present and the group exists with members already containing all principals in the MembersToInclude' {
                    It 'Should not modify the group' {
                        $testMembers = @( $script:testMemberName1 )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnNanoServer
                    }
                }

                Context 'When Ensure is present and the group exists with members not containing any of the principals in the MembersToExclude' {
                    It 'Should not modify the group' {
                        $testMembers = @( $script:testMemberName3 )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToExclude $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnNanoServer
                    }
                }

                Context 'When Ensure is present and the group exists with members that match the Members' {
                    It 'Should not modify the group' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName2 )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnNanoServer
                    }
                }

                Context 'When Ensure is present and the group exists with no members and the MembersToInclude is specified but Empty' {
                    It 'Should not modify the group' {
                        $testMembers = @( )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnNanoServer
                    }
                }

                Context 'When Ensure is present and the group exists with no members and the MembersToExclude is specified but Empty' {
                    It 'Should not modify the group' {
                        $testMembers = @( )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToExclude $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnNanoServer
                    }
                }

                Context 'When Ensure is present and the group exists with no members and both MembersToInclude and MembersToExclude are empty' {
                    It 'Should not modify the group' {
                        $testMembers = @( )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembers -MembersToExclude $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnNanoServer
                    }
                }

                Context 'When Ensure is present and the group exists with no members and empty Members passed' {
                    It 'Should not modify the group' {
                        $testMembers = @( )

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnNanoServer
                    }
                }

                Context 'When Ensure is present and the group exists and no changes are made to the group' {
                    It 'Should not save group' {
                        Mock -CommandName 'Get-LocalGroup' -MockWith { return $script:testLocalGroup }
                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { return @( $script:testMemberName1, $script:testMemberName2 ) }

                        Set-TargetResourceOnNanoServer -GroupName $script:testGroupName -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnNanoServer
                    }
                }
            }

            Describe 'GroupResource\Test-TargetResourceOnNanoServer' -Tag 'Helper' {
                BeforeEach {
                    Reset-TestGroup

                    Mock -CommandName 'Get-LocalGroup' -MockWith { return $script:testLocalGroup }
                    Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { }
                }

                Context 'When Ensure is absent and the group does not exist' {
                    It 'Should return true and expected mocks are called' {
                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message 'Test error message' -CategoryReason 'GroupNotFoundException' }

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Ensure 'Absent' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is absent and the group exists' {
                    It 'Should return false and expected mocks are called' {
                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Ensure 'Absent' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group does not exist' {
                    It 'Should return false and expected mocks are called' {
                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message 'Test error message' -CategoryReason 'GroupNotFoundException' }

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                    }
                }

                Context 'When Get-LocalGroup throws an exception other than GroupNotFound' {
                    It 'Should throw expected exception' {
                        Mock -CommandName 'Get-LocalGroup' -MockWith { Write-Error -Message $script:testErrorMessage -CategoryReason 'OtherException' }

                        { Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Ensure 'Present' } | Should -Throw -ExpectedMessage $script:testErrorMessage
                    }
                }

                Context 'When Ensure is present and the group exists' {
                    It 'Should return true and expected mocks are called' {
                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group exists and Description matches' {
                    It 'Should return true and expected mocks are called' {
                        $script:testLocalGroup.Description = $script:testGroupDescription

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Description $script:testGroupDescription -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group exists and Description does not match' {
                    It 'Should return false and expected mocks are called' {
                        $script:testLocalGroup.Description = $script:testGroupDescription

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Description 'Wrong description' -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group exists and with no members and Members should be empty' {
                    It 'Should return true and expected mocks are called' {
                        $testMembers = @( )

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group exists mismatching number of members when passing Members' {
                    It 'Should return false and expected mocks are called' {
                        $testMembers = @( $script:testMemberName1 )

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group exists with missing member when passing MembersToInclude' {
                    It 'Should return false and expected mocks are called' {
                        $testMembers = @( $script:testMemberName1 )

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group exists with missing member when passing MembersToExclude' {
                    It 'Should return true and expected mocks are called' {
                        $testMembers = @( $script:testMemberName1 )

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToExclude $testMembers -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group exists containing member specified by MembersToExclude' {
                    It 'Should return false and expected mocks are called' {
                        $testMembers = @( $script:testMemberName1 )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { @( $script:testMemberName1, $script:testMemberName2 ) }

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToExclude $testMembers -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group exists containing member specified by MembersToInclude' {
                    It 'Should return true and expected mocks are called' {
                        $testMembers = @( $script:testMemberName1 )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { @( $script:testMemberName1, $script:testMemberName2 ) }

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group exists and current members matches Members' {
                    It 'Should return true and expected mocks are called' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName2 )

                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { @( $script:testMemberName1, $script:testMemberName2 ) }

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When Ensure is present and the group exists and current members do not match Members' {
                    It 'Should return false and expected mocks are called' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName3 )

                        Mock -CommandName 'Get-LocalGroup' -MockWith { return $script:testLocalGroup }
                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { @( $script:testMemberName1, $script:testMemberName2 ) }

                        Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-LocalGroup' -ParameterFilter { $Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnNanoServer' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When Members and MembersToInclude are both specified' {
                    It 'Should throw expected exception' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName2 )
                        $testMembersToInclude = @( $script:testMemberName3 )

                        $errorMessage = $script:localizedData.MembersAndIncludeExcludeConflict -f 'Members', 'MembersToInclude'

                        Mock -CommandName 'Get-LocalGroup' -MockWith { return $script:testLocalGroup }
                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { @( $script:testMemberName1, $script:testMemberName2 ) }

                        { Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -MembersToInclude $testMembersToInclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }

                Context 'When Members and MembersToExclude are both specified' {
                    It 'Should throw expected exception' {
                        $testMembers = @( $script:testMemberName1, $script:testMemberName2 )
                        $testMembersToExclude = @( $script:testMemberName3 )

                        $errorMessage = $script:localizedData.MembersAndIncludeExcludeConflict -f 'Members', 'MembersToExclude'

                        Mock -CommandName 'Get-LocalGroup' -MockWith { return $script:testLocalGroup }
                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { @( $script:testMemberName1, $script:testMemberName2 ) }

                        { Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -Members $testMembers -MembersToExclude $testMembersToExclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }

                Context 'When MembersToInclude and MembersToExclude both contain the same member' {
                    It 'Should throw expected exception' {
                        $testMembersToInclude = @( $script:testMemberName1 )
                        $testMembersToExclude = @( $script:testMemberName1 )

                        $errorMessage = $script:localizedData.IncludeAndExcludeConflict -f $script:testMemberName1, 'MembersToInclude', 'MembersToExclude'

                        Mock -CommandName 'Get-LocalGroup' -MockWith { return $script:testLocalGroup }
                        Mock -CommandName 'Get-MembersOnNanoServer' -MockWith { @( $script:testMemberName1, $script:testMemberName2 ) }

                        { Test-TargetResourceOnNanoServer -GroupName $script:testGroupName -MembersToInclude $testMembersToInclude -MembersToExclude $testMembersToExclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }
            }

            Describe 'GroupResource\Get-MembersOnNanoServer' -Tag 'Helper' {
                Context 'When called with a group that does not have any members' {
                    It 'Should return nothing' {
                        Mock -CommandName 'Get-LocalGroupMember' -MockWith { }

                        Get-MembersOnNanoServer -Group $script:testLocalGroup | Should -Be $null

                        Assert-MockCalled -CommandName 'Get-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When called with a group that has local and domain members' {
                    It 'Should return all local members without domain prefix and domain members with domain prefix' {
                        $testGroupMember1 = @{
                            Name = 'Domain\TestDomainUser1'
                            PrincipalSource = 'NotLocal'
                            ExpectedName = 'Domain\TestDomainUser1'
                        }

                        $testGroupMember2 = @{
                            Name = 'LocalMachine\TestLocalUser2'
                            PrincipalSource = 'Local'
                            ExpectedName = 'TestLocalUser2'
                        }

                        Mock -CommandName 'Get-LocalGroupMember' -MockWith { return @( $testGroupMember1, $testGroupMember2 ) }

                        Get-MembersOnNanoServer -Group $script:testLocalGroup | Should -Be @( $testGroupMember1.ExpectedName, $testGroupMember2.ExpectedName )

                        Assert-MockCalled -CommandName 'Get-LocalGroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }
            }
        }
        else
        {
            Describe 'GroupResource\Get-TargetResourceOnFullSKU' -Tag 'Helper' {
                BeforeEach {
                    Reset-TestGroup

                    $testMembers = @($script:testuserPrincipal1.Name, $script:testuserPrincipal2.Name)

                    Mock -CommandName 'Get-MembersOnFullSKU' -MockWith { return @() }
                    Mock -CommandName 'Remove-DisposableObject' -MockWith { }
                }

                Context 'When called with a Group that does not exist' {
                    It 'Should return expected values and call expected mocks' {
                        Mock -CommandName 'Get-Group' -MockWith { }

                        $getTargetResourceResult = Get-TargetResourceOnFullSKU -GroupName $script:testGroupName

                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'

                        $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                        $getTargetResourceResult.Keys.Count | Should -Be 2
                        $getTargetResourceResult.GroupName | Should -Be $script:testGroupName
                        $getTargetResourceResult.Ensure | Should -Be 'Absent'
                    }
                }

                Context 'When called with a valid, existing Group containing no members' {
                    It 'Should return expected values and call expected mocks' {
                        $script:testGroup.Description = $script:testGroupDescription

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        $getTargetResourceResult = Get-TargetResourceOnFullSKU -GroupName $script:testGroupName

                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnFullSKU' -ParameterFilter { $Group -eq $script:testGroup }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'

                        $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                        $getTargetResourceResult.Keys.Count | Should -Be 4
                        $getTargetResourceResult.GroupName | Should -Be $script:testGroupName
                        $getTargetResourceResult.Ensure | Should -Be 'Present'
                        $getTargetResourceResult.Description | Should -Be $script:testGroupDescription
                        $getTargetResourceResult.Members | Should -Be $null
                    }
                }

                Context 'When called with a valid, existing Group with containing members' {
                    It 'Should return expected values and call expected mocks' {
                        $testGroup.Description = $script:testGroupDescription

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }
                        Mock -CommandName 'Get-MembersOnFullSKU' -MockWith { return $testMembers }

                        $getTargetResourceResult = Get-TargetResourceOnFullSKU -GroupName $script:testGroupName

                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersOnFullSKU' -ParameterFilter { $Group -eq $script:testGroup }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'

                        $getTargetResourceResult -is [System.Collections.Hashtable] | Should -BeTrue
                        $getTargetResourceResult.Keys.Count | Should -Be 4
                        $getTargetResourceResult.GroupName | Should -Be $script:testGroupName
                        $getTargetResourceResult.Ensure | Should -Be 'Present'
                        $getTargetResourceResult.Description | Should -Be $script:testGroupDescription
                        $getTargetResourceResult.Members | Should -Be $testMembers
                    }
                }
            }

            Describe 'GroupResource\Set-TargetResourceOnFullSKU' -Tag 'Helper' {
                <#
                    .SYNOPSIS
                        Assert that Group Members have not changed on Full SKU.

                    .DESCRIPTION
                        This helper asserts that none of the calls to update a group
                        have been made.
                #>
                function Assert-GroupMembersNotChangedOnFullSKU
                {
                    [CmdletBinding()]
                    param
                    (
                    )

                    Assert-MockCalled -CommandName 'Clear-GroupMember' -Times 0 -Scope 'It'
                    Assert-MockCalled -CommandName 'Add-GroupMember' -Times 0 -Scope 'It'
                    Assert-MockCalled -CommandName 'Remove-GroupMember' -Times 0 -Scope 'It'
                    Assert-MockCalled -CommandName 'Save-Group' -Times 0 -Scope 'It'
                    Assert-MockCalled -CommandName 'Remove-Group' -Times 0 -Scope 'It'
                }

                BeforeEach {
                    Reset-TestGroup

                    Mock -CommandName 'Get-Group' -MockWith { }
                    Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { }
                    Mock -CommandName 'ConvertTo-UniquePrincipalsList' -MockWith {
                        $memberPrincipals = @()

                        if ($MemberNames -contains $script:testUserPrincipal1.Name)
                        {
                            $memberPrincipals += @( $script:testUserPrincipal1` )
                        }

                        if ($MemberNames -contains $script:testUserPrincipal2.Name)
                        {
                            $memberPrincipals += @( $script:testUserPrincipal2 )
                        }

                        if ($MemberNames -contains $script:testUserPrincipal3.Name)
                        {
                            $memberPrincipals += @( $script:testUserPrincipal3 )
                        }

                        return $memberPrincipals
                    }

                    Mock -CommandName 'Clear-GroupMember' -MockWith { }
                    Mock -CommandName 'Add-GroupMember' -MockWith { }
                    Mock -CommandName 'Remove-GroupMember' -MockWith { }
                    Mock -CommandName 'Remove-Group' -MockWith { }
                    Mock -CommandName 'Save-Group' -MockWith { }
                    Mock -CommandName 'Remove-DisposableObject' -MockWith { }
                    Mock -CommandName 'Get-PrincipalContext' -MockWith { return $script:testPrincipalContext }
                    Mock -CommandName 'Get-Group' -MockWith { }
                }

                Context 'When Ensure is absent and the group does not exist' {
                    It 'Should not attempt to remove an absent group' {
                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Ensure 'Absent'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -Scope 'It'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName } -Scope 'It'
                        Assert-MockCalled -CommandName 'Remove-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName } -Times 0 -Scope 'It'
                        Assert-MockCalled -CommandName 'Remove-DisposableObject' -Scope 'It'
                    }
                }

                Context 'When Ensure is absent and the group exists' {
                    It 'Should remove an existing group' {
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Ensure 'Absent'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -Scope 'It'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName } -Scope 'It'
                        Assert-MockCalled -CommandName 'Remove-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName } -Scope 'It'
                        Assert-MockCalled -CommandName 'Remove-DisposableObject' -Scope 'It'
                    }
                }

                Context 'When Ensure is present and the group does not exist' {
                    It 'Should create an empty group' {
                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group does not exist and Description is passed' {
                    It 'Should create an empty group with a description' {
                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Description $script:testGroupDescription -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $Group.Description -eq $script:testGroupDescription }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group does not exist and Members is passed with one local member' {
                    It 'Should create a group with one local member' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Mock -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.GroupPrincipal' } -MockWith { return $testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.GroupPrincipal' }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { $MemberNames -eq $testMembers }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal1 }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group does not exist and Members is passed with two local members' {
                    It 'Should create a group with two local members' {
                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )

                        Mock -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.GroupPrincipal' } -MockWith { return $testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.GroupPrincipal' }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembers -DifferenceObject $MemberNames) -eq $null  }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal1 }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal2 }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group does not exist and MembersToInclude is passed with one local member' {
                    It 'Should create a group with one local member' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Mock -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.GroupPrincipal' } -MockWith { return $testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.GroupPrincipal' }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { $MemberNames -eq $testMembers }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal1 }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group does not exist and MembersToInclude is passed with two local members' {
                    It 'Should create a group with two local members' {
                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )

                        Mock -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.GroupPrincipal' } -MockWith { return $testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.GroupPrincipal' }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembers -DifferenceObject $MemberNames)  -eq $null  }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal1 }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal2 }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with no members and Members is passed with one member' {
                    It 'Should add a member to an existing group' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembers -DifferenceObject $MemberNames) -eq $null }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal1 }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with one member missing from Members list passed' {
                    It 'Should add a member to an existing group' {
                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1 ) }
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembers -DifferenceObject $MemberNames) -eq $null }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal2 }
                        Assert-MockCalled -CommandName 'Remove-GroupMember' -Times 0
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with no members and MembersToInclude is passed with one member' {
                    It 'Should add a member to an existing group' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembers -DifferenceObject $MemberNames) -eq $null }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal1 }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with one member missing from Members list passed' {
                    It 'Should add a member to an existing group' {
                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1 ) }
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembers -DifferenceObject $MemberNames) -eq $null }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal2 }
                        Assert-MockCalled -CommandName 'Remove-GroupMember' -Times 0
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with one member not in the Members list passed' {
                    It 'Should remove a member from an existing group' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembers -DifferenceObject $MemberNames) -eq $null }
                        Assert-MockCalled -CommandName 'Remove-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal2 }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with containing members and an empty Members list passed' {
                    It 'Should clear all members from an existing group' {
                        $testMembers = @( )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Clear-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with a member contained in the MembersToExclude list passed' {
                    It 'Should remove a member from an existing group' {
                        $testMembers = @( $script:testUserPrincipal2.Name )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToExclude $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembers -DifferenceObject $MemberNames) -eq $null }
                        Assert-MockCalled -CommandName 'Remove-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal2 }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with Members passed that require one member to be added and one removed' {
                    It 'Should add a user and remove a user' {
                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal3.Name )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembers -DifferenceObject $MemberNames) -eq $null }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal3 }
                        Assert-MockCalled -CommandName 'Remove-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal2 }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with MembersToInclude and MembersToExclude passed that require one member to be added and one removed' {
                    It 'Should add a user and remove a user' {
                        $testMembersToInclude = @( $script:testUserPrincipal3.Name )
                        $testMembersToExclude = @( $script:testUserPrincipal2.Name )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembersToInclude -MembersToExclude $testMembersToExclude -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembersToInclude -DifferenceObject $MemberNames) -eq $null }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { (Compare-Object -ReferenceObject $testMembersToExclude -DifferenceObject $MemberNames) -eq $null }
                        Assert-MockCalled -CommandName 'Add-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal3 }
                        Assert-MockCalled -CommandName 'Remove-GroupMember' -ParameterFilter { $Group.Name -eq $script:testGroupName -and $MemberAsPrincipal -eq $script:testUserPrincipal2 }
                        Assert-MockCalled -CommandName 'Save-Group' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Members and MembersToInclude are both specified' {
                    It 'Should throw expected exception' {
                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )
                        $testMembersToInclude = @( $script:testUserPrincipal3.Name )

                        $errorMessage = $script:localizedData.MembersAndIncludeExcludeConflict -f 'Members', 'MembersToInclude'

                        { Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -MembersToInclude $testMembersToInclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }

                Context 'When Members and MembersToExclude are both specified' {
                    It 'Should throw expected exception' {
                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )
                        $testMembersToExclude = @( $script:testUserPrincipal3.Name )

                        $errorMessage = $script:localizedData.MembersAndIncludeExcludeConflict -f 'Members', 'MembersToExclude'

                        { Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -MembersToExclude $testMembersToExclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }

                Context 'When MembersToInclude and MembersToExclude both contain the same member' {
                    It 'Should throw expected exception' {
                        $testMembersToInclude = @( $script:testUserPrincipal1.Name )
                        $testMembersToExclude = @( $script:testUserPrincipal1.Name )

                        $errorMessage = $script:localizedData.IncludeAndExcludeConflict -f $script:testUserPrincipal1.Name, 'MembersToInclude', 'MembersToExclude'

                        { Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembersToInclude -MembersToExclude $testMembersToExclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }

                Context 'When Ensure is present and the group exists with members already containing all principals in the MembersToInclude' {
                    It 'Should not modify the group' {
                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnFullSKU
                    }
                }

                Context 'When Ensure is present and the group exists with members not containing any of the principals in the MembersToExclude' {
                    It 'Should not modify the group' {
                        $testMembers = @( $script:testUserPrincipal3.Name )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToExclude $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnFullSKU
                    }
                }

                Context 'When Ensure is present and the group exists with members that match the Members' {
                    It 'Should not modify the group' {
                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnFullSKU
                    }
                }

                Context 'When Ensure is present and the group exists with no members and the MembersToInclude is specified but Empty' {
                    It 'Should not modify the group' {
                        $testMembers = @( )

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnFullSKU
                    }
                }

                Context 'When Ensure is present and the group exists with no members and the MembersToExclude is specified but Empty' {
                    It 'Should not modify the group' {
                        $testMembers = @( )

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToExclude $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnFullSKU
                    }
                }

                Context 'When Ensure is present and the group exists with no members and both MembersToInclude and MembersToExclude are empty' {
                    It 'Should not modify the group' {
                        $testMembers = @( )

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -MembersToExclude $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnFullSKU
                    }
                }

                Context 'When Ensure is present and the group exists with no members and empty Members passed' {
                    It 'Should not modify the group' {
                        $testMembers = @( )

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present'

                        Assert-GroupMembersNotChangedOnFullSKU
                    }
                }

                Context 'When Ensure is present and the group exists and no changes are made to the group' {
                    It 'Should not save group' {
                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -Scope 'It'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName } -Scope 'It'
                        Assert-MockCalled -CommandName 'Save-Group' -Times 0 -Scope 'It'
                        Assert-MockCalled -CommandName 'Remove-DisposableObject' -Scope 'It'
                    }
                }

                Context 'When Ensure is present and the group exists and Credential is passed when using Members' {
                    It 'Should pass Credential to all appropriate functions' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Credential $script:testCredential -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential }
                    }
                }

                Context 'When Ensure is present and the group exists and Credential is passed when using MembersToInclude' {
                    It 'Should pass Credential to all appropriate functions' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -Credential $script:testCredential -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential }
                    }
                }

                Context 'When Ensure is present and the group exists and Credential is passed when using MembersToExclude' {
                    It 'Should pass Credential to all appropriate functions' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }

                        Set-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToExclude $testMembers -Credential $script:testCredential -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential }
                    }
                }
            }

            Describe 'GroupResource\Test-TargetResourceOnFullSKU' -Tag 'Helper' {
                BeforeEach {
                    Reset-TestGroup

                    Mock -CommandName 'Get-Group' -MockWith { return $script:testGroup }
                    Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { }
                    Mock -CommandName 'ConvertTo-UniquePrincipalsList' -MockWith {
                        $memberPrincipals = @()

                        if ($MemberNames -contains $script:testUserPrincipal1.Name)
                        {
                            $memberPrincipals += @( $script:testUserPrincipal1` )
                        }

                        if ($MemberNames -contains $script:testUserPrincipal2.Name)
                        {
                            $memberPrincipals += @( $script:testUserPrincipal2 )
                        }

                        if ($MemberNames -contains $script:testUserPrincipal3.Name)
                        {
                            $memberPrincipals += @( $script:testUserPrincipal3 )
                        }

                        return $memberPrincipals
                    }

                    Mock -CommandName 'Remove-DisposableObject' -MockWith { }
                    Mock -CommandName 'Get-PrincipalContext' -MockWith { return $script:testPrincipalContext }
                }

                Context 'When Ensure is absent and the group does not exist' {
                    It 'Should return true and expected mocks are called' {
                        Mock -CommandName 'Get-Group' -MockWith { }

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Ensure 'Absent' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -Scope 'It'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName } -Scope 'It'
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is absent and the group exists' {
                    It 'Should return false and expected mocks are called' {
                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Ensure 'Absent' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -Scope 'It'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName } -Scope 'It'
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group does not exist' {
                    It 'Should return false and expected mocks are called' {
                        Mock -CommandName 'Get-Group' -MockWith { }

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists' {
                    It 'Should return true and expected mocks are called' {
                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists and Description matches' {
                    It 'Should return true and expected mocks are called' {
                        $script:testGroup.Description = $script:testGroupDescription

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Description $script:testGroupDescription -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists and Description does not match' {
                    It 'Should return false and expected mocks are called' {
                        $script:testGroup.Description = $script:testGroupDescription

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Description 'Wrong description' -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists and with no members and Members should be empty' {
                    It 'Should return true and expected mocks are called' {
                        $testMembers = @( )

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists mismatching number of members when passing Members' {
                    It 'Should return false and expected mocks are called' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with missing member when passing MembersToInclude' {
                    It 'Should return false and expected mocks are called' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists with missing member when passing MembersToExclude' {
                    It 'Should return true and expected mocks are called' {
                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToExclude $testMembers -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists containing member specified by MembersToExclude' {
                    It 'Should return false and expected mocks are called' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToExclude $testMembers -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists containing member specified by MembersToInclude' {
                    It 'Should return true and expected mocks are called' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        $testMembers = @( $script:testUserPrincipal1.Name )

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists and current members matches Members' {
                    It 'Should return true and expected mocks are called' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        $testMembers = @( $script:testUserPrincipal1, $script:testUserPrincipal2 )

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present' | Should -BeTrue

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Ensure is present and the group exists and current members do not match Members' {
                    It 'Should return false and expected mocks are called' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        $testMembers = @( $script:testUserPrincipal1, $script:testUserPrincipal3 )

                        Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Ensure 'Present' | Should -BeFalse

                        Assert-MockCalled -CommandName 'Get-PrincipalContext'
                        Assert-MockCalled -CommandName 'Get-Group' -ParameterFilter { $GroupName -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'Remove-DisposableObject'
                    }
                }

                Context 'When Credential is passed with Members' {
                    It 'Should pass Credential to all appropriate functions' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        $testMembers = @( $script:testUserPrincipal1.Name )

                        $null = Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -Credential $script:testCredential -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential  }
                    }
                }

                Context 'When Credential is passed with MembersToInclude' {
                    It 'Should pass Credential to all appropriate functions' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        $testMembers = @( $script:testUserPrincipal1.Name )

                        $null = Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembers -Credential $script:testCredential -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential  }
                    }
                }

                Context 'When Credential is passed with MembersToExclude' {
                    It 'Should pass Credential to all appropriate functions' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        $testMembers = @( $script:testUserPrincipal1.Name )

                        $null = Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToExclude $testMembers -Credential $script:testCredential -Ensure 'Present'

                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential }
                        Assert-MockCalled -CommandName 'ConvertTo-UniquePrincipalsList' -ParameterFilter { $Credential -eq $script:testCredential  }
                    }
                }

                Context 'When Members and MembersToInclude are both specified' {
                    It 'Should throw expected exception' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )
                        $testMembersToInclude = @( $script:testUserPrincipal3.Name )

                        $errorMessage = $script:localizedData.MembersAndIncludeExcludeConflict -f 'Members', 'MembersToInclude'

                        { Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -MembersToInclude $testMembersToInclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }

                Context 'When Members and MembersToExclude are both specified' {
                    It 'Should throw expected exception' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        $testMembers = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )
                        $testMembersToExclude = @( $script:testUserPrincipal3.Name )

                        $errorMessage = $script:localizedData.MembersAndIncludeExcludeConflict -f 'Members', 'MembersToExclude'

                        { Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -Members $testMembers -MembersToExclude $testMembersToExclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }

                Context 'When MembersToInclude and MembersToExclude both contain the same member' {
                    It 'Should throw expected exception' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        $testMembersToInclude = @( $script:testUserPrincipal1.Name )
                        $testMembersToExclude = @( $script:testUserPrincipal1.Name )

                        $errorMessage = $script:localizedData.IncludeAndExcludeConflict -f $script:testUserPrincipal1.Name, 'MembersToInclude', 'MembersToExclude'

                        { Test-TargetResourceOnFullSKU -GroupName $script:testGroupName -MembersToInclude $testMembersToInclude -MembersToExclude $testMembersToExclude -Ensure 'Present' } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }
            }

            Describe 'GroupResource\Get-MembersOnFullSKU' -Tag 'Helper' {
                BeforeEach {
                    $principalContextCache = @{}
                    $disposables = New-Object -TypeName 'System.Collections.ArrayList'
                }

                Context 'When called with a group that does not have any members' {
                    It 'Should return nothing' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { }

                        Get-MembersOnFullSKU -Group $script:testGroup -PrincipalContextCache $principalContextCache -Disposables $disposables | Should -Be $null

                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When called with a group that has only local memebers' {
                    It 'Should return principal names' {
                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $script:testUserPrincipal1, $script:testUserPrincipal2 ) }

                        Get-MembersOnFullSKU -Group $script:testGroup -PrincipalContextCache $principalContextCache -Disposables $disposables | Should -Be @( $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )

                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When called with group that has domain members' {
                    It 'Should return exepcted principal names with domains' {
                        $testDomainUser1 = @{
                            Name = 'TestDomainUser1'
                            SamAccountName = 'TestSamAccountName1'
                            ContextType = [System.DirectoryServices.AccountManagement.ContextType]::Domain
                            Context = @{
                                Name = 'TestDomain1'
                            }
                            StructuralObjectClass = 'Domain'
                        }

                        $domainName2 = 'TestDomain2'

                        $testDomainUser2 = @{
                            Name = 'TestDomainUser2'
                            SamAccountName = 'TestSamAccountName2'
                            ContextType = [System.DirectoryServices.AccountManagement.ContextType]::Domain
                            Context = @{
                                Name = "$domainName2.WithDot"
                            }
                            StructuralObjectClass = 'Computer'
                        }

                        $expectedName1 = "$($testDomainUser1.Context.Name)\$($testDomainUser1.SamAccountName)"
                        $expectedName2 = "$($domainName2)\$($testDomainUser2.Name)"
                        $expectedGetMembersResult = @( $expectedName1, $expectedName2 )

                        Mock -CommandName 'Get-MembersAsPrincipalsList' -MockWith { return @( $testDomainUser1, $testDomainUser2 ) }

                        $getMembersResult = Get-MembersOnFullSKU -Group $script:testGroup -PrincipalContextCache $principalContextCache -Disposables $disposables

                        (Compare-Object -ReferenceObject $expectedGetMembersResult -DifferenceObject $getMembersResult) | Should -Be $null

                        Assert-MockCalled -CommandName 'Get-MembersAsPrincipalsList' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }
            }

            Describe 'GroupResource\Get-MembersAsPrincipalsList' -Tag 'Helper' {
                BeforeEach {
                    $principalContextCache = @{}
                    $disposables = New-Object -TypeName 'System.Collections.ArrayList'
                    $memberDirectoryEntry1 = @{
                        Path = 'WinNT://domainname/accountname'
                        Properties = @{
                            ObjectSid = @{
                                Value = 'SidValue1'
                            }
                        }
                    }

                    $memberDirectoryEntry2 = @{
                        Path = 'WinNT://domainname/machinename/accountname'
                        Properties = @{
                            ObjectSid = @{
                                Value = 'SidValue2'
                            }
                        }
                    }

                    $memberDirectoryEntry3 = @{
                        Path ='accountname'
                    }

                    Mock -CommandName 'Get-GroupMembersFromDirectoryEntry' -MockWith { }

                    Mock -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.DirectoryEntry' } -MockWith {
                        return $ArgumentList[0]
                    }

                    Mock -CommandName 'Get-PrincipalContext' -MockWith { return $script:testPrincipalContext }
                    Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $true }

                    Mock -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.Security.Principal.SecurityIdentifier' } -MockWith {
                        return 'S-1-0-0'
                    }

                    Mock -CommandName 'Resolve-SidToPrincipal' -MockWith { return 'FakeSidValue' }
                }

                Context 'When called with Group that contains no group members' {
                    It 'Should return null and call expected mocks' {
                        Get-MembersAsPrincipalsList -Group $script:testGroup -PrincipalContextCache $principalContextCache -Disposables $disposables | Should -Be $null
                        Assert-MockCalled -CommandName 'Get-GroupMembersFromDirectoryEntry' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                    }
                }

                Context 'When called with Group that contains only stale group members' {
                    It 'Should return null and call expected mocks' {
                        Mock -CommandName 'Get-GroupMembersFromDirectoryEntry' -MockWith { return @( $memberDirectoryEntry3 ) }

                        $getMembersResult = Get-MembersAsPrincipalsList -Group $script:testGroup -PrincipalContextCache $principalContextCache -Disposables $disposables -WarningAction 'SilentlyContinue'
                        $getMembersResult | Should -Be $null

                        Assert-MockCalled -CommandName 'Get-GroupMembersFromDirectoryEntry' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.DirectoryEntry' }
                    }
                }

                Context 'When called with Group that contains two non-stale local members' {
                    It 'Should return a list of two members and call expected mocks' {
                        Mock -CommandName 'Get-GroupMembersFromDirectoryEntry' -MockWith { return @( $memberDirectoryEntry1, $memberDirectoryEntry2 ) }

                        $getMembersResult = Get-MembersAsPrincipalsList -Group $script:testGroup -PrincipalContextCache $principalContextCache -Disposables $disposables
                        $getMembersResult.Count | Should -Be 2

                        Assert-MockCalled -CommandName 'Get-GroupMembersFromDirectoryEntry' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.DirectoryEntry' } -Times 2 -Scope 'It'
                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -ParameterFilter { $Scope -eq 'domainname' }
                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -ParameterFilter { $Scope -eq 'machinename' }
                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq 'domainname' }
                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq 'machinename' }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.Security.Principal.SecurityIdentifier' -and $ArgumentList[0] -eq 'SidValue1' }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.Security.Principal.SecurityIdentifier' -and $ArgumentList[0] -eq 'SidValue2' }
                        Assert-MockCalled -CommandName 'Resolve-SidToPrincipal' -ParameterFilter { $Sid -eq 'S-1-0-0' -and $Scope -eq 'domainname' }
                        Assert-MockCalled -CommandName 'Resolve-SidToPrincipal' -ParameterFilter { $Sid -eq 'S-1-0-0' -and $Scope -eq 'machinename' }
                    }
                }

                Context 'When called with Group that contains two non-stale domain members' {
                    It 'Should return a list of two members and call expected mocks' {
                        Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }
                        Mock -CommandName 'Get-GroupMembersFromDirectoryEntry' -MockWith { return @( $memberDirectoryEntry1, $memberDirectoryEntry2 ) }

                        $getMembersResult = Get-MembersAsPrincipalsList -Group $script:testGroup -PrincipalContextCache $principalContextCache -Disposables $disposables
                        $getMembersResult.Count | Should -Be 2

                        Assert-MockCalled -CommandName 'Get-GroupMembersFromDirectoryEntry' -ParameterFilter { $Group.Name -eq $script:testGroupName }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.DirectoryEntry' } -Times 2 -Scope 'It'
                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -ParameterFilter { $Scope -eq 'domainname' }
                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -ParameterFilter { $Scope -eq 'machinename' }
                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq 'domainname' }
                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq 'machinename' }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.Security.Principal.SecurityIdentifier' -and $ArgumentList[0] -eq 'SidValue1' }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.Security.Principal.SecurityIdentifier' -and $ArgumentList[0] -eq 'SidValue2' }
                        Assert-MockCalled -CommandName 'Resolve-SidToPrincipal' -ParameterFilter { $Sid -eq 'S-1-0-0' -and $Scope -eq 'domainname' }
                        Assert-MockCalled -CommandName 'Resolve-SidToPrincipal' -ParameterFilter { $Sid -eq 'S-1-0-0' -and $Scope -eq 'machinename' }
                    }
                }

                Context 'When called with Credential' {
                    It 'Should pass Credential to appropriate functions' {
                        Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }
                        Mock -CommandName 'Get-GroupMembersFromDirectoryEntry' -MockWith { return @( $memberDirectoryEntry1, $memberDirectoryEntry2 ) }

                        $null = Get-MembersAsPrincipalsList -Group $script:testGroup -Credential $script:testCredential -PrincipalContextCache $principalContextCache -Disposables $disposables

                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -ParameterFilter { $Credential -eq $script:testCredential }
                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -ParameterFilter { $Credential -eq $script:testCredential}
                    }
                }

                Context 'When called with a group that contains a principal that can not be found in the domain' {
                    It 'Should throw expected exception' {
                        Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }
                        Mock -CommandName 'Get-GroupMembersFromDirectoryEntry' -MockWith { return @( $memberDirectoryEntry1, $memberDirectoryEntry2 ) }
                        Mock -CommandName 'Get-PrincipalContext' -MockWith { }

                        $errorMessage = ($script:localizedData.DomainCredentialsRequired -f 'accountname')

                        { Get-MembersAsPrincipalsList -Group $script:testGroup -PrincipalContextCache $principalContextCache -Disposables $disposables } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }
            }

            Describe 'GroupResource\ConvertTo-UniquePrincipalsList' -Tag 'Helper' {
                BeforeEach {
                    $principalContextCache = @{}
                    $disposables = New-Object -TypeName 'System.Collections.ArrayList'

                    $testDomainUser1 = @{
                        Name = 'TestDomainUser1'
                        SamAccountName = 'TestSamAccountName1'
                        ContextType = [System.DirectoryServices.AccountManagement.ContextType]::Domain
                        Context = @{
                            Name = 'TestDomain1'
                        }
                        StructuralObjectClass = 'Domain'
                        DistinguishedName = 'TestDomainUser1'
                    }

                    Mock -CommandName 'ConvertTo-Principal' -MockWith {
                        switch ($MemberName)
                        {
                            $script:testUserPrincipal1.Name { return $script:testUserPrincipal1 }
                            $script:testUserPrincipal2.Name { return $script:testUserPrincipal2 }
                            $script:testUserPrincipal3.Name { return $script:testUserPrincipal3 }
                            $testDomainUser1.Name { return $testDomainUser1 }
                        }
                    }
                }

                Context 'When called with a list of local principals that contains duplicates' {
                    It 'Should not return duplicate local prinicpals' {
                        $memberNames = @( $script:testUserPrincipal1.Name, $script:testUserPrincipal1.Name, $script:testUserPrincipal2.Name )

                        $uniquePrincipalsList = ConvertTo-UniquePrincipalsList -MemberNames $memberNames -PrincipalContextCache $principalContextCache -Disposables $disposables
                        $uniquePrincipalsList | Should -Be @( $script:testUserPrincipal1, $script:testUserPrincipal2 )

                        foreach ($passedInMemberName in $memberNames)
                        {
                            Assert-MockCalled -CommandName 'ConvertTo-Principal' -ParameterFilter { $MemberName -eq $passedInMemberName }
                        }
                    }
                }

                Context 'When called with a list of domain principals that contains duplicates' {
                    It 'Should not return duplicate domain prinicpals' {
                        $memberNames = @( $testDomainUser1.Name, $testDomainUser1.Name )

                        $uniquePrincipalsList = ConvertTo-UniquePrincipalsList -MemberNames $memberNames -PrincipalContextCache $principalContextCache -Disposables $disposables
                        $uniquePrincipalsList | Should -Be @( $testDomainUser1 )

                        foreach ($passedInMemberName in $memberNames)
                        {
                            Assert-MockCalled -CommandName 'ConvertTo-Principal' -ParameterFilter { $MemberName -eq $passedInMemberName }
                        }
                    }
                }

                Context 'When called with a list of domain principals that does not contain duplicates and a credential is passed' {
                    It 'Should pass Credential to appropriate functions' {
                        ConvertTo-UniquePrincipalsList -MemberNames @( $script:testUserPrincipal1 ) -Credential $script:testCredential -PrincipalContextCache $principalContextCache -Disposables $disposables

                        Assert-MockCalled -CommandName 'ConvertTo-Principal' -ParameterFilter { $Credential -eq $script:testCredential }
                    }
                }
            }

            Describe 'GroupResource\ConvertTo-Principal' -Tag 'Helper' {
                BeforeEach {
                    $principalContextCache = @{}
                    $disposables = New-Object -TypeName 'System.Collections.ArrayList'

                    Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }
                    Mock -CommandName 'Split-MemberName' -MockWith { return $script:localDomain, $MemberName }
                    Mock -CommandName 'Get-PrincipalContext' -MockWith { return $script:testPrincipalContext }
                    Mock -CommandName 'Find-Principal' -MockWith {
                        switch ($IdentityValue)
                        {
                            $script:testUserPrincipal1.Name { return $script:testUserPrincipal1 }
                            $script:testUserPrincipal2.Name { return $script:testUserPrincipal2 }
                            $script:testUserPrincipal3.Name { return $script:testUserPrincipal3 }
                        }
                    }
                }

                Context 'When called with a local machine member that is not in the principal context cache' {
                    It 'Should return principal with local member name' {
                        Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $true }

                        $convertToPrincipalResult = ConvertTo-Principal `
                            -MemberName $script:testUserPrincipal1.Name `
                            -PrincipalContextCache $principalContextCache `
                            -Disposables $disposables

                        $convertToPrincipalResult | Should -Be $script:testUserPrincipal1

                        Assert-MockCalled -CommandName 'Split-MemberName' -ParameterFilter { $MemberName -eq $script:testUserPrincipal1.Name }
                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq $script:localDomain }
                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -ParameterFilter { $Scope -eq $script:localDomain }
                        Assert-MockCalled -CommandName 'Find-Principal' -ParameterFilter { $IdentityValue -eq $script:testUserPrincipal1.Name }
                    }
                }

                Context 'When called with a domain member that is not in the principal context cache' {
                    It 'Should attempt to resolve domain member with domain trust' {
                        $convertToPrincipalResult = ConvertTo-Principal `
                            -MemberName $script:testUserPrincipal1.Name `
                            -PrincipalContextCache $principalContextCache `
                            -Disposables $disposables

                        $convertToPrincipalResult | Should -Be $script:testUserPrincipal1

                        Assert-MockCalled -CommandName 'Split-MemberName' -ParameterFilter { $MemberName -eq $script:testUserPrincipal1.Name }
                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq $script:localDomain }
                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -ParameterFilter { $Scope -eq $script:localDomain }
                        Assert-MockCalled -CommandName 'Find-Principal' -ParameterFilter { $IdentityValue -eq $script:testUserPrincipal1.Name }
                    }
                }

                Context 'When called with a domain member that is not in the principal context cache and a credential is passed' {
                    It 'Should pass Credential to appropriate functions' {
                        $null = ConvertTo-Principal -MemberName $script:testUserPrincipal1.Name -Credential $script:testCredential -PrincipalContextCache $principalContextCache -Disposables $disposables

                        Assert-MockCalled -CommandName 'Get-PrincipalContext' -ParameterFilter { $Credential -eq $script:testCredential }
                    }
                }

                Context 'When called with a domain member that is not in the principal context cache and could not be found' {
                    It 'Should throw if principal cannot be found' {
                        Mock -CommandName 'Find-Principal' -MockWith { }

                        $errorMessage = ($script:localizedData.CouldNotFindPrincipal -f $script:testUserPrincipal1.Name)

                        { $null = ConvertTo-Principal `
                            -MemberName $script:testUserPrincipal1.Name `
                            -PrincipalContextCache $principalContextCache `
                            -Disposables $disposables } | Should -Throw -ExpectedMessage $errorMessage
                    }
                }
            }

            Describe 'GroupResource\Resolve-SidToPrincipal' -Tag 'Helper' {
                BeforeEach {
                    $testSidValue = 'S-1-0-0'
                    $testSid = New-Object -TypeName 'System.Security.Principal.SecurityIdentifier' -ArgumentList @( $testSidValue )
                    $fakePrincipal = 'FakePrincipal'
                    $sidIdentityType = [System.DirectoryServices.AccountManagement.IdentityType]::Sid

                    Mock -CommandName 'Find-Principal' -MockWith { }
                    Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }
                }

                Context 'When called with a local principal that does not esxist' {
                    It 'Should throw when principal not found' {
                        Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $true }

                        { Resolve-SidToPrincipal -Sid $testSid -PrincipalContext $script:testPrincipalContext -Scope $script:localDomain } | Should -Throw ($script:localizedData.CouldNotFindPrincipal -f $testSidValue)

                        Assert-MockCalled -CommandName 'Find-Principal' -ParameterFilter { $PrincipalContext -eq $script:testPrincipalContext -and $IdentityType -eq $sidIdentityType -and $IdentityValue -eq $testSidValue }
                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq $script:localDomain }
                    }
                }

                Context 'When called with a domain principal that does not exist' {
                    It 'Should throw when principal not found' {
                        $customDomain = 'CustomDomain'

                        { Resolve-SidToPrincipal -Sid $testSid -PrincipalContext $script:testPrincipalContext -Scope $customDomain } | Should -Throw ($script:localizedData.CouldNotFindPrincipal -f $testSidValue)

                        Assert-MockCalled -CommandName 'Find-Principal' -ParameterFilter { $PrincipalContext -eq $script:testPrincipalContext -and $IdentityType -eq $sidIdentityType -and $IdentityValue -eq $testSidValue }
                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq $customDomain }
                    }
                }

                Context 'When called with a local principal that exists' {
                    It 'Should return found principal' {
                        Mock -CommandName 'Find-Principal' -MockWith { return $fakePrincipal }

                        Resolve-SidToPrincipal -Sid $testSid -PrincipalContext $script:testPrincipalContext -Scope $script:localDomain | Should -Be $fakePrincipal
                        Assert-MockCalled -CommandName 'Find-Principal' -ParameterFilter { $PrincipalContext -eq $script:testPrincipalContext -and $IdentityType -eq $sidIdentityType -and $IdentityValue -eq $testSidValue }
                    }
                }
            }

            Describe 'GroupResource\Get-PrincipalContext' -Tag 'Helper' {
                BeforeEach {
                    $fakePrincipalContext = 'FakePrincipalContext'
                    $localMachineContext = [System.DirectoryServices.AccountManagement.ContextType]::Machine
                    $customDomainContext = [System.DirectoryServices.AccountManagement.ContextType]::Domain

                    Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $false }
                    Mock -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.PrincipalContext' } -MockWith { $fakePrincipalContext }
                }

                Context 'When called with a local principal that does not exist in the principal context cache' {
                    It 'Should create a new local principal context' {
                        Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $true }

                        $principalContextCache = @{}
                        $disposables = New-Object -TypeName 'System.Collections.ArrayList'

                        $localScope = 'localhost'

                        Get-PrincipalContext -Scope $localScope -PrincipalContextCache $principalContextCache -Disposables $disposables

                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq $localScope }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.PrincipalContext' -and $ArgumentList.Contains($localMachineContext) }

                        $principalContextCache.ContainsKey($localScope) | Should -BeFalse
                        $principalContextCache.$script:localDomain | Should -Be $fakePrincipalContext
                        $disposables.Contains($fakePrincipalContext) | Should -BeTrue
                    }
                }

                Context 'When called with a domain principal that does exist in the principal context cache' {
                    It 'Should return the local principal context from the cache' {
                        Mock -CommandName 'Test-IsLocalMachine' -MockWith { return $true }

                        $principalContextCache = @{ $script:localDomain = $script:testPrincipalContext }
                        $disposables = New-Object -TypeName 'System.Collections.ArrayList'

                        Get-PrincipalContext -Scope $script:localDomain -PrincipalContextCache $principalContextCache -Disposables $disposables

                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq $script:localDomain }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.PrincipalContext' } -Times 0 -Scope 'It'

                        $principalContextCache.$script:localDomain | Should -Not -Be $fakePrincipalContext
                        $disposables.Contains($fakePrincipalContext) | Should -BeFalse
                    }
                }

                Context 'When called with a domain principal that does not exist in the principal cache and without a Credential' {
                    It 'Should create a new domain principal context without a Credential' {
                        $principalContextCache = @{}
                        $disposables = New-Object -TypeName 'System.Collections.ArrayList'

                        $customDomain = 'CustomDomain'

                        Get-PrincipalContext -Scope $customDomain -PrincipalContextCache $principalContextCache -Disposables $disposables

                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq $customDomain }

                        $principalContextArgumentList = @($customDomainContext, $customDomain)

                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.PrincipalContext' -and
                            (Compare-Object -ReferenceObject $principalContextArgumentList -DifferenceObject $ArgumentList) -eq $null }

                        $principalContextCache.$customDomain | Should -Be $fakePrincipalContext
                        $disposables.Contains($fakePrincipalContext) | Should -BeTrue
                    }
                }

                Context 'When called with a domain principal that does not exist in the principal cache and with a Credential without a domain' {
                    It 'Should create a new domain principal context with a credential without a domain' {
                        $principalContextCache = @{}
                        $disposables = New-Object -TypeName 'System.Collections.ArrayList'

                        $customDomain = 'CustomDomain'

                        Get-PrincipalContext -Scope $customDomain -Credential $script:testCredential -PrincipalContextCache $principalContextCache -Disposables $disposables

                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq $customDomain }

                        $principalContextArgumentList = @( $customDomainContext, $customDomain, $script:testCredential.GetNetworkCredential().UserName, $script:testCredential.GetNetworkCredential().Password )

                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.PrincipalContext' -and
                            (Compare-Object -ReferenceObject $principalContextArgumentList -DifferenceObject $ArgumentList) -eq $null }

                        $principalContextCache.$customDomain | Should -Be $fakePrincipalContext
                        $disposables.Contains($fakePrincipalContext) | Should -BeTrue
                    }
                }

                Context 'When called with a domain principal that does not exist in the principal cache and with a Credential with a domain' {
                    It 'Should create a new custom principal context with a Credential with a domain' {
                        $principalContextCache = @{}
                        $disposables = New-Object -TypeName 'System.Collections.ArrayList'

                        $customDomain = 'CustomDomain'

                        $userNameWithDomain = 'CustomDomain\username'
                        $testPassword = 'TestPassword'
                        $secureTestPassword = ConvertTo-SecureString -String $testPassword -AsPlainText -Force

                        $credentialWithDomain = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @( $userNameWithDomain, $secureTestPassword )

                        Get-PrincipalContext -Scope $customDomain -Credential $credentialWithDomain -PrincipalContextCache $principalContextCache -Disposables $disposables

                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq $customDomain }

                        $principalContextArgumentList = @( $customDomainContext, $customDomain, $userNameWithDomain, $credentialWithDomain.GetNetworkCredential().Password  )

                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.PrincipalContext' -and
                            (Compare-Object -ReferenceObject $principalContextArgumentList -DifferenceObject $ArgumentList) -eq $null }

                        $principalContextCache.$customDomain | Should -Be $fakePrincipalContext
                        $disposables.Contains($fakePrincipalContext) | Should -BeTrue
                    }
                }

                Context 'When called with a domain principal that exists in the principal context cache' {
                    It 'Should return a domain principal context from the cache' {
                        $customDomain = 'CustomDomain'

                        $principalContextCache = @{ $customDomain = $script:testPrincipalContext }
                        $disposables = New-Object -TypeName 'System.Collections.ArrayList'

                        Get-PrincipalContext -Scope $customDomain -PrincipalContextCache $principalContextCache -Disposables $disposables

                        Assert-MockCalled -CommandName 'Test-IsLocalMachine' -ParameterFilter { $Scope -eq $customDomain }
                        Assert-MockCalled -CommandName 'New-Object' -ParameterFilter { $TypeName -eq 'System.DirectoryServices.AccountManagement.PrincipalContext' } -Times 0 -Scope 'It'

                        $principalContextCache.$customDomain | Should -Not -Be $fakePrincipalContext
                        $disposables.Contains($fakePrincipalContext) | Should -BeFalse
                    }
                }
            }
        }
    }
}
