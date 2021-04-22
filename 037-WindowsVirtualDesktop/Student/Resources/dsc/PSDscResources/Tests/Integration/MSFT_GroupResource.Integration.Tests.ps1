[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
param ()

$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

if ($PSVersionTable.PSVersion -lt [Version] '5.1')
{
    Write-Warning -Message 'Cannot run PSDscResources integration tests on PowerShell versions lower than 5.1'
    return
}

$script:testFolderPath = Split-Path -Path $PSScriptRoot -Parent
$script:testHelpersPath = Join-Path -Path $script:testFolderPath -ChildPath 'TestHelpers'
Import-Module -Name (Join-Path -Path $script:testHelpersPath -ChildPath 'CommonTestHelper.psm1')

$script:testEnvironment = Enter-DscResourceTestEnvironment `
    -DscResourceModuleName 'PSDscResources' `
    -DscResourceName 'MSFT_GroupResource' `
    -TestType 'Integration'

try
{
    Describe 'Group Integration Tests'  {
        BeforeAll {
            Import-Module -Name (Join-Path -Path $script:testHelpersPath `
                                           -ChildPath 'MSFT_GroupResource.TestHelper.psm1')

            $script:confgurationNoMembersFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_GroupResource_NoMembers.config.ps1'
            $script:confgurationWithMembersFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_GroupResource_Members.config.ps1'
            $script:confgurationWithMembersToIncludeExcludeFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'MSFT_GroupResource_MembersToIncludeExclude.config.ps1'

            # Fake users for testing
            $testUsername1 = 'TestUser1'
            $testUsername2 = 'TestUser2'

            $testUsernames = @( $testUsername1, $testUsername2 )

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

        It 'Should use Group from PSDscResources' {
            $groupResource = Get-DscResource -Name 'Group'

            $groupResource | Should -Not -Be $null

            if ($groupResource.Count -gt 1)
            {
                $sortedGroupResrources = $groupResource | Sort-Object -Property 'Version' -Descending
                $groupResource = $sortedGroupResrources | Select-Object -First 1
            }

            $groupResource.ModuleName | Should -Be 'PSDscResources'
        }

        It 'Should create an empty group' {
            $configurationName = 'CreateEmptyGroup'
            $testGroupName = 'TestEmptyGroup1'

            $resourceParameters = @{
                Ensure = 'Present'
                GroupName = $testGroupName
            }

            Test-GroupExists -GroupName $testGroupName | Should -BeFalse

            try
            {
                {
                    . $script:confgurationWithMembersFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @resourceParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                Test-GroupExists -GroupName $testGroupName -Members @() | Should -BeTrue
            }
            finally
            {
                if (Test-GroupExists -GroupName $testGroupName)
                {
                    Remove-Group -GroupName $testGroupName
                }
            }
        }

        It 'Should not change the state of the present built-in Users group when no Members specified' {
            $configurationName = 'BuiltInGroup'
            $testGroupName = 'Users'

            $resourceParameters = @{
                Ensure = 'Present'
                GroupName = $testGroupName
            }

            Test-GroupExists -GroupName $testGroupName | Should -BeTrue

            {
                . $script:confgurationNoMembersFilePath -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @resourceParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Not -Throw

            Test-GroupExists -GroupName $testGroupName | Should -BeTrue
        }

        It 'Should add a member to the built-in Users group with MembersToInclude' {
            $configurationName = 'BuiltInGroup'
            $testGroupName = 'Users'

            $resourceParameters = @{
                Ensure = 'Present'
                GroupName = $testGroupName
                MembersToInclude = $testUsername1
            }

            Test-GroupExists -GroupName $testGroupName | Should -BeTrue

            {
                . $script:confgurationWithMembersToIncludeExcludeFilePath -ConfigurationName $configurationName
                & $configurationName -OutputPath $TestDrive @resourceParameters
                Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
            } | Should -Not -Throw

            Test-GroupExists -GroupName $testGroupName -MembersToInclude $testUsername1 | Should -BeTrue
        }

        It 'Should create a group with two test users using Members' {
            $configurationName = 'CreateGroupWithTwoMembers'
            $testGroupName = 'TestGroupWithMembers2'

            $groupMembers = $testUsernames

            $resourceParameters = @{
                Ensure = 'Present'
                GroupName = $testGroupName
                Members = $groupMembers
            }

            Test-GroupExists -GroupName $testGroupName | Should -BeFalse

            try
            {
                {
                    . $script:confgurationWithMembersFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @resourceParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                Test-GroupExists -GroupName $testGroupName -Members $groupMembers | Should -BeTrue
            }
            finally
            {
                if (Test-GroupExists -GroupName $testGroupName)
                {
                    Remove-Group -GroupName $testGroupName
                }
            }
        }

        It 'Should add a member to a group with MembersToInclude' {
            $configurationName = 'CreateGroupWithTwoMembers'
            $testGroupName = 'TestGroupWithMembersToInclude3'

            $groupMembers = @( $testUsername1 )

            $resourceParameters = @{
                Ensure = 'Present'
                GroupName = $testGroupName
                MembersToInclude = $groupMembers
            }

            Test-GroupExists -GroupName $testGroupName | Should -BeFalse

            New-Group -GroupName $testGroupName

            Test-GroupExists -GroupName $testGroupName | Should -BeTrue

            try
            {
                {
                    . $script:confgurationWithMembersToIncludeExcludeFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @resourceParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                Test-GroupExists -GroupName $testGroupName -MembersToInclude $groupMembers | Should -BeTrue
            }
            finally
            {
                if (Test-GroupExists -GroupName $testGroupName)
                {
                    Remove-Group -GroupName $testGroupName
                }
            }
        }

        It 'Should remove a member from a group with MembersToExclude' {
            $configurationName = 'CreateGroupWithTwoMembers'
            $testGroupName = 'TestGroupWithMembersToInclude3'

            $groupMembersToExclude = @( $testUsername1 )

            $resourceParameters = @{
                Ensure = 'Present'
                GroupName = $testGroupName
                MembersToExclude = $groupMembersToExclude
            }

            Test-GroupExists -GroupName $testGroupName | Should -BeFalse

            New-Group -GroupName $testGroupName -Members $groupMembersToExclude

            Test-GroupExists -GroupName $testGroupName | Should -BeTrue

            try
            {
                {
                    . $script:confgurationWithMembersToIncludeExcludeFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @resourceParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                Test-GroupExists -GroupName $testGroupName -MembersToExclude $groupMembersToExclude | Should -BeTrue
            }
            finally
            {
                if (Test-GroupExists -GroupName $testGroupName)
                {
                    Remove-Group -GroupName $testGroupName
                }
            }
        }

        It 'Should remove a group' {
            $configurationName = 'RemoveGroup'
            $testGroupName = 'TestRemoveGroup1'

            $resourceParameters = @{
                Ensure = 'Absent'
                GroupName = $testGroupName
            }

            Test-GroupExists -GroupName $testGroupName | Should -BeFalse

            New-Group -GroupName $testGroupName

            Test-GroupExists -GroupName $testGroupName | Should -BeTrue

            try
            {
                {
                    . $script:confgurationWithMembersFilePath -ConfigurationName $configurationName
                    & $configurationName -OutputPath $TestDrive @resourceParameters
                    Start-DscConfiguration -Path $TestDrive -ErrorAction 'Stop' -Wait -Force
                } | Should -Not -Throw

                Test-GroupExists -GroupName $testGroupName | Should -BeFalse
            }
            finally
            {
                if (Test-GroupExists -GroupName $testGroupName)
                {
                    Remove-Group -GroupName $testGroupName
                }
            }
        }
    }
}
finally
{
    Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
}
