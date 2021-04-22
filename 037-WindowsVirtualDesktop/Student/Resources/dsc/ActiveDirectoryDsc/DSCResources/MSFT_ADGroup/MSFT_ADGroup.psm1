$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'ActiveDirectoryDsc.Common'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'ActiveDirectoryDsc.Common.psm1')

$script:localizedData = Get-LocalizedData -ResourceName 'MSFT_ADGroup'

<#
    .SYNOPSIS
        Returns the current state of the Active Directory group.

    .PARAMETER GroupName
         Name of the Active Directory group.

    .PARAMETER GroupScope
        Active Directory group scope. Default value is 'Global'.

    .PARAMETER Category
        Active Directory group category. Default value is 'Security'.

    .PARAMETER Path
        Location of the group within Active Directory expressed as a Distinguished Name.

    .PARAMETER Ensure
        Specifies if this Active Directory group should be present or absent.
        Default value is 'Present'.

    .PARAMETER Description
        Description of the Active Directory group.

    .PARAMETER DisplayName
        Display name of the Active Directory group.

    .PARAMETER Credential
        Credentials used to enact the change upon.

    .PARAMETER DomainController
        Active Directory domain controller to enact the change upon.

    .PARAMETER Members
        Active Directory group membership should match membership exactly.

    .PARAMETER MembersToInclude
        Active Directory group should include these members.

    .PARAMETER MembersToExclude
        Active Directory group should NOT include these members.

    .PARAMETER MembershipAttribute
        Active Directory attribute used to perform membership operations.
        Default value is 'SamAccountName'.

    .PARAMETER ManagedBy
        Active Directory managed by attribute specified as a DistinguishedName.

    .PARAMETER Notes
        Active Directory group notes field.

    .PARAMETER RestoreFromRecycleBin
        Try to restore the group from the recycle bin before creating a new one.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $GroupName,

        [Parameter()]
        [ValidateSet('DomainLocal', 'Global', 'Universal')]
        [System.String]
        $GroupScope = 'Global',

        [Parameter()]
        [ValidateSet('Security', 'Distribution')]
        [System.String]
        $Category = 'Security',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $MembersToInclude,

        [Parameter()]
        [System.String[]]
        $MembersToExclude,

        [Parameter()]
        [ValidateSet('SamAccountName', 'DistinguishedName', 'SID', 'ObjectGUID')]
        [System.String]
        $MembershipAttribute = 'SamAccountName',

        # This must be the user's DN
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ManagedBy,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Notes,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $RestoreFromRecycleBin
    )

    Assert-Module -ModuleName 'ActiveDirectory'

    $getTargetResourceReturnValue = @{
        Ensure              = 'Absent'
        GroupName           = $GroupName
        GroupScope          = $null
        Category            = $null
        Path                = $null
        Description         = $null
        DisplayName         = $null
        Members             = @()
        MembersToInclude    = $MembersToInclude
        MembersToExclude    = $MembersToExclude
        MembershipAttribute = $MembershipAttribute
        ManagedBy           = $null
        Notes               = $null
        DistinguishedName   = $null
    }

    $commonParameters = Get-ADCommonParameters @PSBoundParameters

    try
    {
        $adGroup = Get-ADGroup @commonParameters -Properties @(
            'Name',
            'GroupScope',
            'GroupCategory',
            'DistinguishedName',
            'Description',
            'DisplayName',
            'ManagedBy',
            'Info'
        )

        Write-Verbose -Message ($script:localizedData.RetrievingGroupMembers -f $MembershipAttribute)

        if ($adGroup)
        {
            # Retrieve the current list of members, returning the specified membership attribute
            [System.Array] $adGroupMembers = (Get-ADGroupMember @commonParameters).$MembershipAttribute

            $getTargetResourceReturnValue['Ensure'] = 'Present'
            $getTargetResourceReturnValue['GroupName'] = $adGroup.Name
            $getTargetResourceReturnValue['GroupScope'] = $adGroup.GroupScope
            $getTargetResourceReturnValue['Category'] = $adGroup.GroupCategory
            $getTargetResourceReturnValue['DistinguishedName'] = $adGroup.DistinguishedName
            $getTargetResourceReturnValue['Path'] = Get-ADObjectParentDN -DN $adGroup.DistinguishedName
            $getTargetResourceReturnValue['Description'] = $adGroup.Description
            $getTargetResourceReturnValue['DisplayName'] = $adGroup.DisplayName
            $getTargetResourceReturnValue['Members'] = $adGroupMembers
            $getTargetResourceReturnValue['ManagedBy'] = $adGroup.ManagedBy
            $getTargetResourceReturnValue['Notes'] = $adGroup.Info
        }
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {
        Write-Verbose -Message ($script:localizedData.GroupNotFound -f $GroupName)
    }

    return $getTargetResourceReturnValue
} #end function Get-TargetResource

<#
    .SYNOPSIS
        Determines if the Active Directory group is in the desired state.

    .PARAMETER GroupName
         Name of the Active Directory group.

    .PARAMETER GroupScope
        Active Directory group scope. Default value is 'Global'.

    .PARAMETER Category
        Active Directory group category. Default value is 'Security'.

    .PARAMETER Path
        Location of the group within Active Directory expressed as a Distinguished Name.

    .PARAMETER Ensure
        Specifies if this Active Directory group should be present or absent.
        Default value is 'Present'.

    .PARAMETER Description
        Description of the Active Directory group.

    .PARAMETER DisplayName
        Display name of the Active Directory group.

    .PARAMETER Credential
        Credentials used to enact the change upon.

    .PARAMETER DomainController
        Active Directory domain controller to enact the change upon.

    .PARAMETER Members
        Active Directory group membership should match membership exactly.

    .PARAMETER MembersToInclude
        Active Directory group should include these members.

    .PARAMETER MembersToExclude
        Active Directory group should NOT include these members.

    .PARAMETER MembershipAttribute
        Active Directory attribute used to perform membership operations.
        Default value is 'SamAccountName'.

    .PARAMETER ManagedBy
        Active Directory managed by attribute specified as a DistinguishedName.

    .PARAMETER Notes
        Active Directory group notes field.

    .PARAMETER RestoreFromRecycleBin
        Try to restore the group from the recycle bin before creating a new one.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $GroupName,

        [Parameter()]
        [ValidateSet('DomainLocal', 'Global', 'Universal')]
        [System.String]
        $GroupScope = 'Global',

        [Parameter()]
        [ValidateSet('Security', 'Distribution')]
        [System.String]
        $Category = 'Security',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $MembersToInclude,

        [Parameter()]
        [System.String[]]
        $MembersToExclude,

        [Parameter()]
        [ValidateSet('SamAccountName', 'DistinguishedName', 'SID', 'ObjectGUID')]
        [System.String]
        $MembershipAttribute = 'SamAccountName',

        # This must be the user's DN
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ManagedBy,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Notes,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $RestoreFromRecycleBin
    )

    # Validate parameters before we even attempt to retrieve anything
    $assertMemberParameters = @{}

    # Members parameter should always be tested to enforce an empty group (issue #189)
    if ($PSBoundParameters.ContainsKey('Members'))
    {
        $assertMemberParameters['Members'] = $Members
    }

    if ($PSBoundParameters.ContainsKey('MembersToInclude') -and -not [System.String]::IsNullOrEmpty($MembersToInclude))
    {
        $assertMemberParameters['MembersToInclude'] = $MembersToInclude
    }

    if ($PSBoundParameters.ContainsKey('MembersToExclude') -and -not [System.String]::IsNullOrEmpty($MembersToExclude))
    {
        $assertMemberParameters['MembersToExclude'] = $MembersToExclude
    }

    Assert-MemberParameters @assertMemberParameters

    $targetResource = Get-TargetResource @PSBoundParameters

    $targetResourceInCompliance = $true

    if ($PSBoundParameters.ContainsKey('GroupScope') -and $targetResource.GroupScope -ne $GroupScope)
    {
        Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f 'GroupScope', $GroupScope, $targetResource.GroupScope)
        $targetResourceInCompliance = $false
    }

    if ($PSBoundParameters.ContainsKey('Category') -and $targetResource.Category -ne $Category)
    {
        Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f 'Category', $Category, $targetResource.Category)
        $targetResourceInCompliance = $false
    }

    if ($Path -and ($targetResource.Path -ne $Path))
    {
        Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f 'Path', $Path, $targetResource.Path)
        $targetResourceInCompliance = $false
    }

    if ($Description -and ($targetResource.Description -ne $Description))
    {
        Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f 'Description', $Description, $targetResource.Description)
        $targetResourceInCompliance = $false
    }

    if ($DisplayName -and ($targetResource.DisplayName -ne $DisplayName))
    {
        Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f 'DisplayName', $DisplayName, $targetResource.DisplayName)
        $targetResourceInCompliance = $false
    }

    if ($ManagedBy -and ($targetResource.ManagedBy -ne $ManagedBy))
    {
        Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f 'ManagedBy', $ManagedBy, $targetResource.ManagedBy)
        $targetResourceInCompliance = $false
    }

    if ($Notes -and ($targetResource.Notes -ne $Notes))
    {
        Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f 'Notes', $Notes, $targetResource.Notes)
        $targetResourceInCompliance = $false
    }

    # Test group members match passed membership parameters
    if (-not (Test-Members @assertMemberParameters -ExistingMembers $targetResource.Members))
    {
        Write-Verbose -Message $script:localizedData.GroupMembershipNotDesiredState
        $targetResourceInCompliance = $false
    }

    if ($targetResource.Ensure -ne $Ensure)
    {
        Write-Verbose -Message ($script:localizedData.NotDesiredPropertyState -f 'Ensure', $Ensure, $targetResource.Ensure)
        $targetResourceInCompliance = $false
    }

    return $targetResourceInCompliance
} #end function Test-TargetResource

<#
    .SYNOPSIS
        Creates, removes or modifies the Active Directory group.

    .PARAMETER GroupName
         Name of the Active Directory group.

    .PARAMETER GroupScope
        Active Directory group scope. Default value is 'Global'.

    .PARAMETER Category
        Active Directory group category. Default value is 'Security'.

    .PARAMETER Path
        Location of the group within Active Directory expressed as a Distinguished Name.

    .PARAMETER Ensure
        Specifies if this Active Directory group should be present or absent.
        Default value is 'Present'.

    .PARAMETER Description
        Description of the Active Directory group.

    .PARAMETER DisplayName
        Display name of the Active Directory group.

    .PARAMETER Credential
        Credentials used to enact the change upon.

    .PARAMETER DomainController
        Active Directory domain controller to enact the change upon.

    .PARAMETER Members
        Active Directory group membership should match membership exactly.

    .PARAMETER MembersToInclude
        Active Directory group should include these members.

    .PARAMETER MembersToExclude
        Active Directory group should NOT include these members.

    .PARAMETER MembershipAttribute
        Active Directory attribute used to perform membership operations.
        Default value is 'SamAccountName'.

    .PARAMETER ManagedBy
        Active Directory managed by attribute specified as a DistinguishedName.

    .PARAMETER Notes
        Active Directory group notes field.

    .PARAMETER RestoreFromRecycleBin
        Try to restore the group from the recycle bin before creating a new one.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $GroupName,

        [Parameter()]
        [ValidateSet('DomainLocal', 'Global', 'Universal')]
        [System.String]
        $GroupScope = 'Global',

        [Parameter()]
        [ValidateSet('Security', 'Distribution')]
        [System.String]
        $Category = 'Security',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainController,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $MembersToInclude,

        [Parameter()]
        [System.String[]]
        $MembersToExclude,

        [Parameter()]
        [ValidateSet('SamAccountName', 'DistinguishedName', 'SID', 'ObjectGUID')]
        [System.String]
        $MembershipAttribute = 'SamAccountName',

        # This must be the user's DN
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ManagedBy,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Notes,

        [Parameter()]
        [ValidateNotNull()]
        [System.Boolean]
        $RestoreFromRecycleBin

    )

    Assert-Module -ModuleName 'ActiveDirectory'

    $assertMemberParameters = @{}

    # Members parameter should always be added to enforce an empty group (issue #189)
    if ($PSBoundParameters.ContainsKey('Members'))
    {
        $assertMemberParameters['Members'] = $Members
    }

    if ($PSBoundParameters.ContainsKey('MembersToInclude') -and -not [System.String]::IsNullOrEmpty($MembersToInclude))
    {
        $assertMemberParameters['MembersToInclude'] = $MembersToInclude
    }

    if ($PSBoundParameters.ContainsKey('MembersToExclude') -and -not [System.String]::IsNullOrEmpty($MembersToExclude))
    {
        $assertMemberParameters['MembersToExclude'] = $MembersToExclude
    }

    Assert-MemberParameters @assertMemberParameters

    if ($MembershipAttribute -eq 'DistinguishedName')
    {
        $allMembers = $Members + $MembersToInclude + $MembersToExclude

        $groupMemberDomains = @()

        foreach ($member in $allMembers)
        {
            $groupMemberDomains += Get-ADDomainNameFromDistinguishedName -DistinguishedName $member
        }

        $uniqueGroupMemberDomainCount = $groupMemberDomains |
            Select-Object -Unique

        $GroupMemberDomainCount = $uniqueGroupMemberDomainCount.count

        if ($GroupMemberDomainCount -gt 1 -or ($groupMemberDomains -ine (Get-DomainName)).Count -gt 0)
        {
            Write-Verbose -Message ($script:localizedData.GroupMembershipMultipleDomains -f $GroupMemberDomainCount)
            $membersInMultipleDomains = $true
        }
    }

    $commonParameters = Get-ADCommonParameters @PSBoundParameters

    $getTargetResourceResult = Get-TargetResource @PSBoundParameters

    if ($getTargetResourceResult.Ensure -eq 'Present')
    {
        if ($Ensure -eq 'Present')
        {
            $setADGroupParams = $commonParameters.Clone()
            $setADGroupParams['Identity'] = $getTargetResourceResult.DistinguishedName

            # Update existing group properties
            if ($PSBoundParameters.ContainsKey('Category') -and $Category -ne $getTargetResourceResult.Category)
            {
                Write-Verbose -Message ($script:localizedData.UpdatingGroupProperty -f 'Category', $Category)

                $setADGroupParams['GroupCategory'] = $Category
            }

            if ($PSBoundParameters.ContainsKey('GroupScope') -and $GroupScope -ne $getTargetResourceResult.GroupScope)
            {
                # Cannot change DomainLocal to Global or vice versa directly. Need to change them to a Universal group first!
                Set-ADGroup -Identity $getTargetResourceResult.DistinguishedName -GroupScope 'Universal' -ErrorAction 'Stop'

                Write-Verbose -Message ($script:localizedData.UpdatingGroupProperty -f 'GroupScope', $GroupScope)

                $setADGroupParams['GroupScope'] = $GroupScope
            }

            if ($Description -and ($Description -ne $getTargetResourceResult.Description))
            {
                Write-Verbose -Message ($script:localizedData.UpdatingGroupProperty -f 'Description', $Description)

                $setADGroupParams['Description'] = $Description
            }

            if ($DisplayName -and ($DisplayName -ne $getTargetResourceResult.DisplayName))
            {
                Write-Verbose -Message ($script:localizedData.UpdatingGroupProperty -f 'DisplayName', $DisplayName)

                $setADGroupParams['DisplayName'] = $DisplayName
            }

            if ($ManagedBy -and ($ManagedBy -ne $getTargetResourceResult.ManagedBy))
            {
                Write-Verbose -Message ($script:localizedData.UpdatingGroupProperty -f 'ManagedBy', $ManagedBy)

                $setADGroupParams['ManagedBy'] = $ManagedBy
            }

            if ($Notes -and ($Notes -ne $getTargetResourceResult.Notes))
            {
                Write-Verbose -Message ($script:localizedData.UpdatingGroupProperty -f 'Notes', $Notes)

                $setADGroupParams['Replace'] = @{
                    Info = $Notes
                }
            }

            Write-Verbose -Message ($script:localizedData.UpdatingGroup -f $GroupName)

            Set-ADGroup @setADGroupParams -ErrorAction 'Stop'

            $groupParentDistinguishedName = Get-ADObjectParentDN -DN $getTargetResourceResult.DistinguishedName

            # Move group if the path is not correct
            if ($Path -and $Path -ne $groupParentDistinguishedName)
            {
                Write-Verbose -Message ($script:localizedData.MovingGroup -f $GroupName, $Path)

                $moveADObjectParams = $commonParameters.Clone()
                $moveADObjectParams['Identity'] = $getTargetResourceResult.DistinguishedName
                $moveADObjectParams['TargetPath'] = $Path
                $moveADObjectParams['ErrorAction'] = 'Stop'

                Move-ADObject @moveADObjectParams
            }

            if ($assertMemberParameters.Count -gt 0)
            {
                Write-Verbose -Message ($script:localizedData.RetrievingGroupMembers -f $MembershipAttribute)

                $adGroupMembers = (Get-ADGroupMember @commonParameters).$MembershipAttribute

                $assertMemberParameters['ExistingMembers'] = $adGroupMembers

                # Return $false if the members mismatch.
                if (-not (Test-Members @assertMemberParameters))
                {
                    # Members parameter should always be enforce if it is bound (issue #189)
                    if ($PSBoundParameters.ContainsKey('Members'))
                    {
                        # Remove all existing first and add explicit members
                        $Members = Remove-DuplicateMembers -Members $Members

                        # We can only remove members if there are members already in the group!
                        if ($adGroupMembers.Count -gt 0)
                        {
                            Write-Verbose -Message ($script:localizedData.RemovingGroupMembers -f $adGroupMembers.Count, $GroupName)

                            Remove-ADGroupMember @commonParameters -Members $adGroupMembers -Confirm:$false -ErrorAction 'Stop'
                        }

                        Write-Verbose -Message ($script:localizedData.AddingGroupMembers -f $Members.Count, $GroupName)

                        Add-ADCommonGroupMember -Parameters $commonParameters -Members $Members -MembersInMultipleDomains:$membersInMultipleDomains
                    }

                    if ($PSBoundParameters.ContainsKey('MembersToInclude') -and -not [System.String]::IsNullOrEmpty($MembersToInclude))
                    {
                        $MembersToInclude = Remove-DuplicateMembers -Members $MembersToInclude

                        Write-Verbose -Message ($script:localizedData.AddingGroupMembers -f $MembersToInclude.Count, $GroupName)

                        Add-ADCommonGroupMember -Parameters $commonParameters -Members $MembersToInclude -MembersInMultipleDomains:$membersInMultipleDomains
                    }

                    if ($PSBoundParameters.ContainsKey('MembersToExclude') -and -not [System.String]::IsNullOrEmpty($MembersToExclude))
                    {
                        $MembersToExclude = Remove-DuplicateMembers -Members $MembersToExclude

                        Write-Verbose -Message ($script:localizedData.RemovingGroupMembers -f $MembersToExclude.Count, $GroupName)

                        Remove-ADGroupMember @commonParameters -Members $MembersToExclude -Confirm:$false -ErrorAction 'Stop'
                    }
                }
            }
        }
        elseif ($Ensure -eq 'Absent')
        {
            # Remove existing group
            Write-Verbose -Message ($script:localizedData.RemovingGroup -f $GroupName)

            Remove-ADGroup @commonParameters -Confirm:$false -ErrorAction 'Stop'
        }
    }
    else
    {
        # The Active Directory group does not exist, check if it should.
        if ($Ensure -eq 'Present')
        {
            $commonParametersUsingName = Get-ADCommonParameters @PSBoundParameters -UseNameParameter

            $newAdGroupParameters = $commonParametersUsingName.Clone()
            $newAdGroupParameters['GroupCategory'] = $Category
            $newAdGroupParameters['GroupScope'] = $GroupScope

            if ($PSBoundParameters.ContainsKey('Description'))
            {
                $newAdGroupParameters['Description'] = $Description
            }

            if ($PSBoundParameters.ContainsKey('DisplayName'))
            {
                $newAdGroupParameters['DisplayName'] = $DisplayName
            }

            if ($PSBoundParameters.ContainsKey('ManagedBy'))
            {
                $newAdGroupParameters['ManagedBy'] = $ManagedBy
            }

            if ($PSBoundParameters.ContainsKey('Path'))
            {
                $newAdGroupParameters['Path'] = $Path
            }

            $adGroup = $null

            # Create group. Try to restore account first if it exists.
            if ($RestoreFromRecycleBin)
            {
                Write-Verbose -Message ($script:localizedData.RestoringGroup -f $GroupName)

                $restoreParams = Get-ADCommonParameters @PSBoundParameters

                $adGroup = Restore-ADCommonObject @restoreParams -ObjectClass 'Group'
            }

            <#
                Check if the Active Directory group was restored, if not create
                the group.
            #>
            if (-not $adGroup)
            {
                Write-Verbose -Message ($script:localizedData.AddingGroup -f $GroupName)

                $adGroup = New-ADGroup @newAdGroupParameters -PassThru -ErrorAction 'Stop'
            }

            <#
                Only the New-ADGroup cmdlet takes a -Name parameter. Refresh
                the parameters with the -Identity parameter rather than -Name.
            #>
            $commonParameters = Get-ADCommonParameters @PSBoundParameters

            if ($PSBoundParameters.ContainsKey('Notes'))
            {
                # Can't set the Notes field when creating the group
                Write-Verbose -Message ($script:localizedData.UpdatingGroupProperty -f 'Notes', $Notes)

                $setADGroupParams = $commonParameters.Clone()
                $setADGroupParams['Identity'] = $adGroup.DistinguishedName
                $setADGroupParams['ErrorAction'] = 'Stop'
                $setADGroupParams['Add'] = @{
                    Info = $Notes
                }

                Set-ADGroup @setADGroupParams
            }

            # Add the required members
            if ($PSBoundParameters.ContainsKey('Members') -and -not [System.String]::IsNullOrEmpty($Members))
            {
                $Members = Remove-DuplicateMembers -Members $Members

                Write-Verbose -Message ($script:localizedData.AddingGroupMembers -f $Members.Count, $GroupName)

                Add-ADCommonGroupMember -Parameters $commonParameters -Members $Members -MembersInMultipleDomains:$membersInMultipleDomains
            }
            elseif ($PSBoundParameters.ContainsKey('MembersToInclude') -and -not [System.String]::IsNullOrEmpty($MembersToInclude))
            {
                $MembersToInclude = Remove-DuplicateMembers -Members $MembersToInclude

                Write-Verbose -Message ($script:localizedData.AddingGroupMembers -f $MembersToInclude.Count, $GroupName)

                Add-ADCommonGroupMember -Parameters $commonParameters -Members $MembersToInclude -MembersInMultipleDomains:$membersInMultipleDomains
            }
        }
    } #end catch
} #end function Set-TargetResource

Export-ModuleMember -Function *-TargetResource
