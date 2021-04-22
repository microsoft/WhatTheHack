[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
param ()

if ($PSVersionTable.PSVersion -lt [Version] '5.1')
{
    Write-Warning -Message 'Cannot run PSDscResources integration tests on PowerShell versions lower than 5.1'
    return
}

$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

# Import CommonTestHelper for Enter-DscResourceTestEnvironment, Exit-DscResourceTestEnvironment
$script:testFolderPath = Split-Path -Path $PSScriptRoot -Parent
$script:testHelpersPath = Join-Path -Path $script:testFolderPath -ChildPath 'TestHelpers'
Import-Module -Name (Join-Path -Path $script:testHelpersPath -ChildPath 'CommonTestHelper.psm1')

$script:testEnvironment = Enter-DscResourceTestEnvironment `
    -DscResourceModuleName 'PSDscResources' `
    -DscResourceName 'GroupSet' `
    -TestType 'Integration'

try
{
    Describe 'GroupSet Integration Tests' {
        BeforeAll {
            # Import Group Test Helper for TestGroupExists, New-Group, Remove-Group, New-User, Remove-User
            $groupTestHelperFilePath = Join-Path -Path $script:testHelpersPath -ChildPath 'MSFT_GroupResource.TestHelper.psm1'
            Import-Module -Name $groupTestHelperFilePath

            $script:confgurationFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'GroupSet.config.ps1'

            # Fake users for testing
            $testUsername1 = 'TestUser1'
            $testUsername2 = 'TestUser2'
            $testUsername3 = 'TestUser3'

            $testUsernames = @( $testUsername1, $testUsername2, $testUsername3 )

            $testPassword = 'T3stPassw0rd#'
            $secureTestPassword = ConvertTo-SecureString -String $testPassword -AsPlainText -Force

            foreach ($username in $testUsernames)
            {
                $testUserCredential = New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList @( $username, $secureTestPassword )
                $null = New-User -Credential $testUserCredential
            }
        }

        AfterAll {
            foreach ($username in $testUsernames)
            {
                Remove-User -UserName $username
            }
        }

        It 'Should create a set of two empty groups' {
            $configurationName = 'CreateEmptyGroups'

            $testGroupName1 = 'TestEmptyGroup1'
            $testGroupName2 = 'TestEmptyGroup2'

            $groupSetParameters = @{
                GroupName = @( $testGroupName1, $testGroupName2 )
                Ensure = 'Present'
            }

            Test-GroupExists -GroupName $testGroupName1 | Should -BeFalse
            Test-GroupExists -GroupName $testGroupName2 | Should -BeFalse

            try
            {
                {
                    . $script:confgurationFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @groupSetParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                Test-GroupExists -GroupName $testGroupName1 -Members @() | Should -BeTrue
                Test-GroupExists -GroupName $testGroupName2 -Members @() | Should -BeTrue
            }
            finally
            {
                if (Test-GroupExists -GroupName $testGroupName1)
                {
                    Remove-Group -GroupName $testGroupName1
                }

                if (Test-GroupExists -GroupName $testGroupName2)
                {
                    Remove-Group -GroupName $testGroupName2
                }
            }
        }

        It 'Should create a set of one group with one member' {
            $configurationName = 'CreateOneGroup'

            $testGroupName1 = 'TestGroup1'
            $groupMembers = @( $testUsername1 )

            $groupSetParameters = @{
                GroupName = @( $testGroupName1 )
                Ensure = 'Present'
                MembersToInclude = $groupMembers
            }

            Test-GroupExists -GroupName $testGroupName1 | Should -BeFalse

            try
            {
                {
                    . $script:confgurationFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @groupSetParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                Test-GroupExists -GroupName $testGroupName1 -MembersToInclude $groupMembers | Should -BeTrue
            }
            finally
            {
                if (Test-GroupExists -GroupName $testGroupName1)
                {
                    Remove-Group -GroupName $testGroupName1
                }
            }
        }

        It 'Should create one group with one member and add the same member to the Administrators group' {
            $configurationName = 'CreateOneGroupAndModifyAdministrators'

            $testGroupName = 'TestGroupWithMember'
            $administratorsGroupName = 'Administrators'

            $groupMembers = @( $testUsername1 )

            $groupSetParameters = @{
                GroupName = @( $testGroupName, $administratorsGroupName )
                Ensure = 'Present'
                MembersToInclude = $groupMembers
            }

            Test-GroupExists -GroupName $testGroupName | Should -BeFalse
            Test-GroupExists -GroupName $administratorsGroupName | Should -BeTrue

            try
            {
                {
                    . $script:confgurationFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @groupSetParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                Test-GroupExists -GroupName $testGroupName -MembersToInclude $groupMembers | Should -BeTrue
                Test-GroupExists -GroupName $administratorsGroupName -MembersToInclude $groupMembers | Should -BeTrue
            }
            finally
            {
                if (Test-GroupExists -GroupName $testGroupName)
                {
                    Remove-Group -GroupName $testGroupName
                }
            }
        }

        It 'Should remove two members from a set of three groups' {
            $configurationName = 'RemoveTwoMembersFromThreeGroups'

            $testGroupNames = @('TestGroupWithMembersToExclude1', 'TestGroupWithMembersToExclude2', 'TestGroupWithMembersToExclude3')

            $groupMembersToExclude = @( $testUsername2, $testUsername3 )

            $groupSetParameters = @{
                GroupName = $testGroupNames
                Ensure = 'Present'
                MembersToExclude = $groupMembersToExclude
            }

            foreach ($testGroupName in $testGroupNames)
            {
                Test-GroupExists -GroupName $testGroupName | Should -BeFalse

                New-Group -GroupName $testGroupName -Members $testUsernames

                Test-GroupExists -GroupName $testGroupName | Should -BeTrue
            }

            try
            {
                {
                    . $script:confgurationFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @groupSetParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                foreach ($testGroupName in $testGroupNames)
                {
                    Test-GroupExists -GroupName $testGroupName -MembersToExclude $groupMembersToExclude | Should -BeTrue
                }
            }
            finally
            {
                foreach ($testGroupName in $testGroupNames)
                {
                    if (Test-GroupExists -GroupName $testGroupName)
                    {
                        Remove-Group -GroupName $testGroupName
                    }
                }
            }
        }

        It 'Should remove a set of groups' {
                $configurationName = 'RemoveThreeGroups'

            $testGroupNames = @('TestGroupRemove1', 'TestGroupRemove2', 'TestGroupRemove3')

            $groupSetParameters = @{
                GroupName = $testGroupNames
                Ensure = 'Absent'
            }

            foreach ($testGroupName in $testGroupNames)
            {
                Test-GroupExists -GroupName $testGroupName | Should -BeFalse

                New-Group -GroupName $testGroupName

                Test-GroupExists -GroupName $testGroupName | Should -BeTrue
            }

            try
            {
                {
                    . $script:confgurationFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @groupSetParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                foreach ($testGroupName in $testGroupNames)
                {
                    Test-GroupExists -GroupName $testGroupName | Should -BeFalse
                }
            }
            finally
            {
                foreach ($testGroupName in $testGroupNames)
                {
                    if (Test-GroupExists -GroupName $testGroupName)
                    {
                        Remove-Group -GroupName $testGroupName
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
