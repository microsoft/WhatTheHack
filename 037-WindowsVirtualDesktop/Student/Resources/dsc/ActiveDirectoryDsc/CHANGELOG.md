# Change log for ActiveDirectoryDsc

## Unreleased

## 4.2.0.0

- Changes to ActiveDirectoryDsc
  - Resolved custom Script Analyzer rules that was added to the test framework.
  - Resolve style guideline violations for hashtables ([issue #516](https://github.com/PowerShell/ActiveDirectoryDsc/issues/516)).
- Changes to ADReplicationSite
  - Added 'Description' attribute parameter ([issue #500](https://github.com/PowerShell/ActiveDirectoryDsc/issues/500)).
  - Added Integration testing ([issue #355](https://github.com/PowerShell/ActiveDirectoryDsc/issues/355)).
  - Correct value returned for RenameDefaultFirstSiteName ([issue #502](https://github.com/PowerShell/ActiveDirectoryDsc/issues/502)).
- Changes to ADReplicationSubnet
  - Added 'Description' attribute parameter ([issue #503](https://github.com/PowerShell/ActiveDirectoryDsc/issues/500))
  - Added Integration testing ([issue #357](https://github.com/PowerShell/ActiveDirectoryDsc/issues/357))
- Changes to ADReplicationSiteLink
  - Added Integration testing ([issue #356](https://github.com/PowerShell/ActiveDirectoryDsc/issues/356)).
  - Added ability to set 'Options' such as Change Notification Replication ([issue #504](https://github.com/PowerShell/ActiveDirectoryDsc/issues/504)).
- Changes to ActiveDirectoryDsc.Common
  - Fix `Test-DscPropertyState` Failing when Comparing $Null and Arrays. ([issue #513](https://github.com/PowerShell/ActiveDirectoryDsc/issues/513))

## 4.1.0.0

- Changes to ActiveDirectoryDsc
  - New resource ADDomainControllerProperties ([issue #301](https://github.com/PowerShell/ActiveDirectoryDsc/issues/301)).
  - New resource ADForestFunctionalLevel ([issue #200](https://github.com/PowerShell/ActiveDirectoryDsc/issues/200)).
  - New resource ADDomainFunctionalLevel ([issue #200](https://github.com/PowerShell/ActiveDirectoryDsc/issues/200)).
  - Split the meta tests and the unit and integration tests in different
    AppVeyor jobs ([issue #437](https://github.com/PowerShell/ActiveDirectoryDsc/issues/437)).
  - Fixed all stub cmdlets and unit tests so the unit test can be run locally
    without having the ActiveDirectory module installed on the computer.
    This will also be reflected in the AppVeyor build worker where there
    will no longer be an ActiveDirectory module installed. This is
    to make sure that if the unit tests work locally they should also work
    in the CI pipeline.
  - Added new stubs for the cmdlets and classes to be used with unit tests.
    The new stubs are based on the modules ActiveDirectory and ADDSDeployment
    in Windows Server 2019. The stubs are generated using the PowerShell
    module *Indented.StubCommand*. Instructions how to generate stubs
    (for example for a new operating system) has been added to the README.md
    in the `Tests/Unit/Stubs` folder ([issue #245](https://github.com/PowerShell/ActiveDirectoryDsc/issues/245)).
  - Update all unit tests removing all local stub functions in favor of
    the new stub modules.
  - Enable PSScriptAnalyzer default rules ([issue #491](https://github.com/PowerShell/ActiveDirectoryDsc/issues/491)).
- Changes to ActiveDirectoryDsc.Common
  - Updated common helper function `Find-DomainController` with the
    optional parameter `WaitForValidCredentials` which will ignore
    authentication exceptions when the credentials cannot be authenticated.
  - Updated the function `Test-ADReplicationSite` to make the parameter
    `Credential` mandatory.
  - Update helper function `Add-ADCommonGroupMember` to reduce duplicated
    code, and add an evaluation if `Members` is empty.
  - Updated helper function `Restore-ADCommonObject` to write out a verbose
    message when no object was found in the recycle bin.
  - Updated helper function `Assert-MemberParameters` to not throw an error
    if the parameter `Members` is en empty array.
- Changes to WaitForADDomain
  - Correct grammar issues in example descriptions.
  - An optional parameter `WaitForValidCredentials` can be set to $true
    to tell the resource to ignore authentication errors ([issue #478](https://github.com/PowerShell/ActiveDirectoryDsc/issues/478)).
- Changes to ADDomain
  - The property `DomainName` will now always return the same value as
    was passed in as the parameter. For the fully qualified domain name
    (FQDN) of the domain see the new read-only property `DnsRoot`.
  - If the domain should exist, the resource correctly waits only 5 times
    when calling `Get-TargetResource` if the tracking file was previously
    created ([issue #181](https://github.com/PowerShell/ActiveDirectoryDsc/issues/181)).
  - The resource now throws if either one of the cmdlets `Install-ADDSForest`
    or `Install-ADDSDomain` fails, and will not create the tracking file
    ([issue #181](https://github.com/PowerShell/ActiveDirectoryDsc/issues/181)).
  - The resource now outputs the properties from `Get-TargetResource`
    when a domain cannot be found.
  - Minor casing corrections on the parameter and variable names.
  - Improved the parameter descriptions of the parameters `DomainName`
    and `Credential`.
  - If the tracking file is missing and the domain is found a warning
    message is now written asking the consumer to recreate the file.
  - Correctly outputs the time in seconds in the verbose message how long
    the resource waits between ech retry when looking for the domain
    (when a tracking file exist and the domain is not yet responding).
  - If the `Set-TargetResource` is called directly it will not try to
    create the domain if it already exist.
  - Added read-only property `DnsRoot` that will return the fully qualified
    domain name (FQDN) of the domain or child domain.
  - Added read-only property `Forest` that will return the fully qualified
    domain name (FQDN) of the forest that the domain belongs to.
  - Added read-only property `DomainExist` that will return `$true` if
    the domain was found, or `$false` if it was not.
- Changes to ADUser
  - Remove unused non-mandatory parameters from the Get-TargetResource ([issue #293](https://github.com/PowerShell/ActiveDirectoryDsc/issues/293)).
  - Added a note to the resource README.md that `RestoreFromRecycleBin`
    needs the feature Recycle Bin enabled.
- Changes to ADDomainController
  - Add InstallDns parameter to enable promotion without installing local
    DNS Server Service ([issue #87](https://github.com/PowerShell/xActiveDirectory/issues/87)).
- Changes to ADGroup
  - Now Get-TargetResource returns correct value when the group does not
    exist.
  - Added integration tests ([issue #350](https://github.com/PowerShell/ActiveDirectoryDsc/issues/350)).
  - Added a read-only property `DistinguishedName`.
  - Refactor the function `Set-TargetResource` to use the function
    `Get-TargetResource` so that `Set-TargetResource` can correctly throw
    an error when something goes wrong ([issue #151](https://github.com/PowerShell/ActiveDirectoryDsc/issues/151),
    [issue #166](https://github.com/PowerShell/ActiveDirectoryDsc/issues/166),
    [issue #493](https://github.com/PowerShell/ActiveDirectoryDsc/issues/493)).
  - It is now possible to enforce a group with no members by using
    `Members = @()` in a configuration ([issue #189](https://github.com/PowerShell/xActiveDirectory/issues/189)).
  - Added a note to the resource README.md that `RestoreFromRecycleBin`
    needs the feature Recycle Bin enabled ([issue #496](https://github.com/PowerShell/xActiveDirectory/issues/496)).
- Changes to ADOrganizationalUnit
  - Added a note to the resource README.md that `RestoreFromRecycleBin`
    needs the feature Recycle Bin enabled.
- Changes to ADComputer
  - Added a note to the resource README.md that `RestoreFromRecycleBin`
    needs the feature Recycle Bin enabled ([issue #498](https://github.com/PowerShell/xActiveDirectory/issues/498)).
  - Updated integration test to be able to catch when a computer account
    cannot be restored.

## 4.0.0.0

- Changes to ActiveDirectoryDsc
  - BREAKING CHANGE: ADRecycleBin is replaced by the new resource ADOptionalFeature
    ([issue #162](https://github.com/PowerShell/ActiveDirectoryDsc/issues/162)).
  - New resource ADOptionalFeature ([issue #162](https://github.com/PowerShell/ActiveDirectoryDsc/issues/162)).
  - BREAKING CHANGE: Renamed the xActiveDirectory to ActiveDirectoryDsc
    and removed the 'x' from all resource names ([issue #312](https://github.com/PowerShell/ActiveDirectoryDsc/issues/312)).
  - The helper function `Find-DomainController` is exported in the module
    manifest. When running `Import-Module -Name ActiveDirectoryDsc` the
    module will also import the nested module ActiveDirectoryDsc.Common.
    It is exported so that the resource WaitForADDomain can reuse code
    when running a background job to search for a domain controller.
  - Module manifest has been updated to optimize module auto-discovery
    according to the article [*PowerShell module authoring considerations*](https://docs.microsoft.com/en-us/windows-server/administration/performance-tuning/powershell/module-authoring-considerations)
    ([issue #463](https://github.com/PowerShell/ActiveDirectoryDsc/issues/463)).
  - Added a Requirements section to every DSC resource README with the
    bullet point stating "Target machine must be running Windows Server
    2008 R2 or later" ([issue #399](https://github.com/PowerShell/ActiveDirectoryDsc/issues/399)).
  - Added 'about_\<DSCResource\>.help.txt' file to all resources
    ([issue #404](https://github.com/PowerShell/ActiveDirectoryDsc/issues/404)).
  - Fixed an issue that the helper function `Add-ADCommonGroupMember` was
    not outputting the correct group name in a verbose message and in an
    error message.
  - Style guideline cleanup.
    - Cleaned up some minor style violations in the code.
    - All localized strings in the resources now has a string ID suffix
      ([issue #419](https://github.com/PowerShell/ActiveDirectoryDsc/issues/419)).
    - All schema properties description now ends with full stop (.)
      ([issue #420](https://github.com/PowerShell/ActiveDirectoryDsc/issues/420)).
    - Updated all types in the resources schema to use PascalCase.
  - Updated all resource read-only parameters to start the description
    with 'Returns...' so it is more clear that the property cannot be
    assigned a value.
  - The default value on resource parameters are now reflected in the parameter
    descriptions in the schema.mof (so that Wiki will be updated)
    ([issue #426](https://github.com/PowerShell/ActiveDirectoryDsc/issues/426)).
  - Removed unnecessary Script Analyzer rule overrides from tests.
  - Added new helper functions in ActiveDirectoryDsc.Common.
    - New-CimCredentialInstance
    - Add-TypeAssembly
    - New-ADDirectoryContext
  - Changes to ActiveDirectoryDsc.Common:
    - Removed unused parameter `ModuleName` from `Assert-MemberParameters`
      function.
    - Removed unused parameter `ModuleName` from `ConvertTo-DeploymentForestMode`
      function.
    - Removed unused parameter `ModuleName` from `ConvertTo-DeploymentDomainMode`
      function.
    - Added function help ([issue #321](https://github.com/PowerShell/ActiveDirectoryDsc/issues/321)).
    - Removed the helper function `ThrowInvalidOperationError` and
      `ThrowInvalidArgumentError` in favor of the
      [new helper functions for localization](https://github.com/PowerShell/DscResources/blob/master/StyleGuidelines.md#helper-functions-for-localization)
      ([issue #316](https://github.com/PowerShell/ActiveDirectoryDsc/issues/316),
      [issue #317](https://github.com/PowerShell/ActiveDirectoryDsc/issues/317)).
    - Removed the alias `DomainAdministratorCredential` from the parameter
      `Credential` in the function `Restore-ADCommonObject`
    - Removed the alias `DomainAdministratorCredential` from the parameter
      `Credential` in the function `Get-ADCommonParameters`
    - Added function `Find-DomainController`.
    - Added function `Get-CurrentUser` (moved from the resource ADKDSKey).
    - Refactor `Remove-DuplicateMembers` and added more unit tests
      ([issue #443](https://github.com/PowerShell/ActiveDirectoryDsc/issues/443)).
    - Minor cleanup in `Test-Members` because of the improved `Remove-DuplicateMembers`.
    - Minor cleanup in `Assert-MemberParameters` because of the improved `Remove-DuplicateMembers`.
  - Updated all the examples files to be prefixed with the resource
    name so they are more easily discovered in PowerShell Gallery and
    Azure Automation ([issue #416](https://github.com/PowerShell/ActiveDirectoryDsc/issues/416)).
  - Fix examples that had duplicate guid that would have prevented them
    to be published.
  - Integration tests are now correctly evaluates the value from `Test-DscConfiguration`
    ([issue #434](https://github.com/PowerShell/ActiveDirectoryDsc/issues/434)).
  - Update all tests to use `| Should -BeTrue` and `| Should -BeFalse'`.
- Changes to ADManagedServiceAccount
  - Added a requirement to README stating "Group Managed Service Accounts
    need at least one Windows Server 2012 Domain Controller"
    ([issue #399](https://github.com/PowerShell/ActiveDirectoryDsc/issues/399)).
  - Using `$PSBoundParameters.Remove()` returns a `[System.Boolean]` to
    indicate of the removal was done or not. That returned value has been
    suppressed ([issue #466](https://github.com/PowerShell/ActiveDirectoryDsc/issues/466)).
- Changes to ADComputer
  - BREAKING CHANGE: The previously made obsolete parameter `Enabled` has
    been removed and is now a read-only property. See resource documentation
    how to enforce the `Enabled` property.
  - BREAKING CHANGE: Renamed the parameter `DomainAdministratorCredential`
    to `Credential` to better indicate that it is possible to impersonate
    any credential with enough permission to perform the task ([issue #269](https://github.com/PowerShell/ActiveDirectoryDsc/issues/269)).
  - Fixed the GUID in Example 3-AddComputerAccountSpecificPath_Config
    ([issue #410](https://github.com/PowerShell/ActiveDirectoryDsc/issues/410)).
  - Add example showing how to create cluster computer account ([issue #401](https://github.com/PowerShell/ActiveDirectoryDsc/issues/401)).
- Changes to ADOrganizationalUnit
  - Catch exception when the path property specifies a non-existing path
    ([issue #408](https://github.com/PowerShell/ActiveDirectoryDsc/issues/408)).
  - The unit tests are using the stub classes so the tests can be run locally.
  - Added comment-based help ([issue #339](https://github.com/PowerShell/ActiveDirectoryDsc/issues/339)).
- Changes to ADUser
  - BREAKING CHANGE: Renamed the parameter `DomainAdministratorCredential`
    to `Credential` to better indicate that it is possible to impersonate
    any credential with enough permission to perform the task ([issue #269](https://github.com/PowerShell/ActiveDirectoryDsc/issues/269)).
  - Fixes exception when creating a user with an empty string property
    ([issue #407](https://github.com/PowerShell/ActiveDirectoryDsc/issues/407)).
  - Fixes exception when updating `CommonName` and `Path` concurrently
    ([issue #402](https://github.com/PowerShell/ActiveDirectoryDsc/issues/402)).
  - Fixes ChangePasswordAtLogon Property to be only set to `true` at User
    Creation ([issue #414](https://github.com/PowerShell/ActiveDirectoryDsc/issues/414)).
  - Added comment-based help ([issue #340](https://github.com/PowerShell/ActiveDirectoryDsc/issues/340)).
  - Now it correctly tests passwords when parameter DomainName is set to
   distinguished name and parameter Credential is used ([issue #451](https://github.com/PowerShell/ActiveDirectoryDsc/issues/451)).
  - Added integration tests ([issue #359](https://github.com/PowerShell/ActiveDirectoryDsc/issues/359)).
  - Update the logic for setting the default value for the parameter
    `CommonName`. This is due to an how LCM handles parameters when a
    default value is derived from another parameter ([issue #427](https://github.com/PowerShell/ActiveDirectoryDsc/issues/427)).
  - Now uses the helper function `Add-TypeAssembly` which have some benefit
    instead of directly using `Add-Type`, like verbose logging ([issue #431](https://github.com/PowerShell/ActiveDirectoryDsc/issues/431)).
  - Add new property `ThumbnailPhoto` and read-only property `ThumbnailPhotoHash`
    ([issue #44](https://github.com/PowerShell/ActiveDirectoryDsc/issues/44)).
- Changes to ADDomain
  - BREAKING CHANGE: Renamed the parameter `DomainAdministratorCredential`
    to `Credential` to better indicate that it is possible to impersonate
    any credential with enough permission to perform the task ([issue #269](https://github.com/PowerShell/ActiveDirectoryDsc/issues/269)).
  - Updated tests and replaced `Write-Error` with `throw`
    ([issue #332](https://github.com/PowerShell/ActiveDirectoryDsc/pull/332)).
  - Added comment-based help ([issue #335](https://github.com/PowerShell/ActiveDirectoryDsc/issues/335)).
  - Using `$PSBoundParameters.Remove()` returns a `[System.Boolean]` to
    indicate of the removal was done or not. That returned value has been
    suppressed ([issue #466](https://github.com/PowerShell/ActiveDirectoryDsc/issues/466)).
- Changes to ADServicePrincipalName
  - Minor change to the unit tests that did not correct assert the localized
    string when an account is not found.
- Changes to ADDomainTrust
  - BREAKING CHANGE: Renamed the parameter `TargetDomainAdministratorCredential`
    to `TargetCredential` to better indicate that it is possible to impersonate
    any credential with enough permission to perform the task ([issue #269](https://github.com/PowerShell/ActiveDirectoryDsc/issues/269)).
  - BREAKING CHANGE: A new parameter `AllowTrustRecreation` has been added
    that when set allows a trust to be recreated in scenarios where that
    is required. This way the user have to opt-in to such destructive
    action since since it can result in service interruption ([issue #421](https://github.com/PowerShell/ActiveDirectoryDsc/issues/421)).
  - Refactored the resource to enable unit tests, and at the same time changed
    it to use the same code pattern as the resource xADObjectEnabledState.
  - Added unit tests ([issue #324](https://github.com/PowerShell/ActiveDirectoryDsc/issues/324)).
  - Added comment-based help ([issue #337](https://github.com/PowerShell/ActiveDirectoryDsc/issues/337)).
  - Added integration tests ([issue #348](https://github.com/PowerShell/ActiveDirectoryDsc/issues/348)).
- Changes to WaitForADDomain
  - BREAKING CHANGE: Refactored the resource to handle timeout better and
    more correctly wait for a specific amount of time, and at the same time
    make the resource more intuitive to use. This change has replaced
    parameters in the resource ([issue #343](https://github.com/PowerShell/ActiveDirectoryDsc/issues/343)).
  - Now the resource can use built-in `PsDscRunAsCredential` instead of
    specifying the `Credential` parameter ([issue #367](https://github.com/PowerShell/ActiveDirectoryDsc/issues/367)).
  - New parameter `SiteName` can be used to wait for a domain controller
    in a specific site in the domain.
  - Added comment-based help ([issue #341](https://github.com/PowerShell/ActiveDirectoryDsc/issues/341)).
- Changes to ADDomainController
  - BREAKING CHANGE: Renamed the parameter `DomainAdministratorCredential`
    to `Credential` to better indicate that it is possible to impersonate
    any credential with enough permission to perform the task ([issue #269](https://github.com/PowerShell/ActiveDirectoryDsc/issues/269)).
  - Add support for creating Read-Only Domain Controller (RODC)
    ([issue #40](https://github.com/PowerShell/ActiveDirectoryDsc/issues/40)).
    [Svilen @SSvilen](https://github.com/SSvilen)
  - Refactored unit tests for Test-TargetResource.
  - Added new parameter `FlexibleSingleMasterOperationRole` to able to move
    Flexible Single Master Operation (FSMO) roles to the current node.
    It does not allow seizing of roles, only allows a move when both
    domain controllers are available ([issue #55](https://github.com/PowerShell/ActiveDirectoryDsc/issues/55)).
- Changes to ADObjectPermissionEntry
  - Remove remnants of the `SupportsShouldProcess` ([issue #329](https://github.com/PowerShell/ActiveDirectoryDsc/issues/329)).
- Changes to ADGroup
  - Added comment-based help ([issue #338](https://github.com/PowerShell/ActiveDirectoryDsc/issues/338)).
  - Update the documentation with the correct default value for the parameter
    GroupScope.
- Changes to ADDomainDefaultPasswordPolicy
  - Added comment-based help ([issue #336](https://github.com/PowerShell/ActiveDirectoryDsc/issues/336)).

## 3.0.0.0

- Changes to xActiveDirectory
  - Added new helper functions in xADCommon, see each functions comment-based
    help for more information.
    - Convert-PropertyMapToObjectProperties
    - Compare-ResourcePropertyState
    - Test-DscPropertyState
  - Move the examples in the README.md to Examples folder.
  - Fix Script Analyzer rule failures.
  - Opt-in to the following DSC Resource Common Meta Tests:
    - Common Tests - Custom Script Analyzer Rules
    - Common Tests - Required Script Analyzer Rules
    - Common Tests - Flagged Script Analyzer Rules
    - Common Tests - Validate Module Files ([issue #282](https://github.com/PowerShell/ActiveDirectoryDsc/issues/282))
    - Common Tests - Validate Script Files ([issue #283](https://github.com/PowerShell/ActiveDirectoryDsc/issues/283))
    - Common Tests - Relative Path Length ([issue #284](https://github.com/PowerShell/ActiveDirectoryDsc/issues/284))
    - Common Tests - Validate Markdown Links ([issue #280](https://github.com/PowerShell/ActiveDirectoryDsc/issues/280))
    - Common Tests - Validate Localization ([issue #281](https://github.com/PowerShell/ActiveDirectoryDsc/issues/281))
    - Common Tests - Validate Example Files ([issue #279](https://github.com/PowerShell/ActiveDirectoryDsc/issues/279))
    - Common Tests - Validate Example Files To Be Published ([issue #311](https://github.com/PowerShell/ActiveDirectoryDsc/issues/311))
  - Move resource descriptions to Wiki using auto-documentation ([issue #289](https://github.com/PowerShell/ActiveDirectoryDsc/issues/289))
  - Move helper functions from MSFT_xADCommon to the module
    xActiveDirectory.Common ([issue #288](https://github.com/PowerShell/ActiveDirectoryDsc/issues/288)).
    - Removed helper function `Test-ADDomain` since it was not used. The
      helper function had design flaws too.
    - Now the helper function `Test-Members` outputs all the members that
      are not in desired state when verbose output is enabled.
  - Update all unit tests to latest unit test template.
  - Deleted the obsolete xActiveDirectory_TechNetDocumentation.html file.
  - Added new resource xADObjectEnabledState. This resource should be
    used to enforce the `Enabled` property of computer accounts. This
    resource replaces the deprecated `Enabled` property in the resource
    xADComputer.
  - Cleanup of code
    - Removed semicolon throughout where it is not needed.
    - Migrate tests to Pester syntax v4.x ([issue #322](https://github.com/PowerShell/ActiveDirectoryDsc/issues/322)).
    - Removed `-MockWith {}` in unit tests.
    - Use fully qualified type names for parameters and variables
      ([issue #374](https://github.com/PowerShell/ActiveDirectoryDsc/issues/374)).
  - Removed unused legacy test files from the root of the repository.
  - Updated Example List README with missing resources.
  - Added missing examples for xADReplicationSubnet, xADServicePrincipalName
    and xWaitForADDomain ([issue #395](https://github.com/PowerShell/ActiveDirectoryDsc/issues/395)).
- Changes to xADComputer
  - Refactored the resource and the unit tests.
  - BREAKING CHANGE: The `Enabled` property is **DEPRECATED** and is no
    longer set or enforces with this resource. _If this parameter is_
    _used in a configuration a warning message will be outputted saying_
    _that the `Enabled` parameter has been deprecated_. The new resource
    [xADObjectEnabledState](https://github.com/PowerShell/xActiveDirectory#xadobjectenabledstate)
    can be used to enforce the `Enabled` property.
  - BREAKING CHANGE: The default value of the enabled property of the
    computer account will be set to the default value of the cmdlet
    `New-ADComputer`.
  - A new parameter was added called `EnabledOnCreation` that will control
    if the computer account is created enabled or disabled.
  - Moved examples from the README.md to separate example files in the
    Examples folder.
  - Fix the RestoreFromRecycleBin description.
  - Fix unnecessary cast in `Test-TargetResource` ([issue #295](https://github.com/PowerShell/ActiveDirectoryDsc/issues/295)).
  - Fix ServicePrincipalNames property empty string exception ([issue #382](https://github.com/PowerShell/ActiveDirectoryDsc/issues/382)).
- Changes to xADGroup
  - Change the description of the property RestoreFromRecycleBin.
  - Code cleanup.
- Changes to xADObjectPermissionEntry
  - Change the description of the property IdentityReference.
  - Fix failure when applied in the same configuration as xADDomain.
  - Localize and Improve verbose messaging.
  - Code cleanup.
- Changes to xADOrganizationalUnit
  - Change the description of the property RestoreFromRecycleBin.
  - Code cleanup.
  - Fix incorrect verbose message when this resource has Ensure set to
    Absent ([issue #276](https://github.com/PowerShell/ActiveDirectoryDsc/issues/276)).
- Changes to xADUser
  - Change the description of the property RestoreFromRecycleBin.
  - Added ServicePrincipalNames property ([issue #153](https://github.com/PowerShell/ActiveDirectoryDsc/issues/153)).
  - Added ChangePasswordAtLogon property ([issue #246](https://github.com/PowerShell/ActiveDirectoryDsc/issues/246)).
  - Code cleanup.
  - Added LogonWorkstations property
  - Added Organization property
  - Added OtherName property
  - Added AccountNotDelegated property
  - Added AllowReversiblePasswordEncryption property
  - Added CompoundIdentitySupported property
  - Added PasswordNotRequired property
  - Added SmartcardLogonRequired property
  - Added ProxyAddresses property ([Issue #254](https://github.com/PowerShell/ActiveDirectoryDsc/issues/254)).
  - Fix Password property being updated whenever another property is changed
    ([issue #384](https://github.com/PowerShell/ActiveDirectoryDsc/issues/384)).
  - Replace Write-Error with the correct helper function ([Issue #331](https://github.com/PowerShell/ActiveDirectoryDsc/issues/331)).
- Changes to xADDomainController
  - Change the `#Requires` statement in the Examples to require the correct
    module.
  - Suppressing the Script Analyzer rule `PSAvoidGlobalVars` since the
    resource is using the `$global:DSCMachineStatus` variable to trigger
    a reboot.
  - Code cleanup.
- Changes to xADDomain
  - Suppressing the Script Analyzer rule `PSAvoidGlobalVars` since the
    resource is using the `$global:DSCMachineStatus` variable to trigger
    a reboot.
  - Code cleanup.
- Changes to xADDomainTrust
  - Replaced New-TerminatingError with Standard Function.
  - Code cleanup.
- Changes to xWaitForADDomain
  - Suppressing the Script Analyzer rule `PSAvoidGlobalVars` since the
    resource is using the `$global:DSCMachineStatus` variable to trigger
    a reboot.
  - Added missing property schema descriptions ([issue #369](https://github.com/PowerShell/ActiveDirectoryDsc/issues/369)).
  - Code cleanup.
- Changes to xADRecycleBin
  - Remove unneeded example and resource designer files.
  - Added missing property schema descriptions ([issue #368](https://github.com/PowerShell/ActiveDirectoryDsc/issues/368)).
  - Code cleanup.
  - It now sets back the `$ErrorActionPreference` that was set prior to
    setting it to `'Stop'`.
  - Replace Write-Error with the correct helper function ([issue #327](https://github.com/PowerShell/ActiveDirectoryDsc/issues/327)).
- Changes to xADReplicationSiteLink
  - Fix ADIdentityNotFoundException when creating a new site link.
  - Code cleanup.
- Changes to xADReplicationSubnet
  - Remove `{ *Present* | Absent }` from the property schema descriptions
    which were causing corruption in the Wiki documentation.
- Changes to xADServicePrincipalNames
  - Remove `{ *Present* | Absent }` from the property schema descriptions
    which were causing corruption in the Wiki documentation.
- Changes to xADDomainDefaultPasswordPolicy
  - Code cleanup.
- Changes to xADForestProperties
  - Minor style cleanup.
- Changes to xADReplicationSubnet
  - Code cleanup.
- Changes to xADKDSKey
  - Code cleanup.
- Changes to xADManagedServiceAccount
  - Code cleanup.
- Changes to xADServicePrincipalName
  - Code cleanup.

## 2.26.0.0

- Changes to xActiveDirectory
  - Added localization module -DscResource.LocalizationHelper* containing
    the helper functions `Get-LocalizedData`, `New-InvalidArgumentException`,
    `New-InvalidOperationException`, `New-ObjectNotFoundException`, and
    `New-InvalidResultException` ([issue #257](https://github.com/PowerShell/ActiveDirectoryDsc/issues/257)).
    For more information around these helper functions and localization
    in resources, see [Localization section in the Style Guideline](https://github.com/PowerShell/DscResources/blob/master/StyleGuidelines.md#localization).
  - Added common module *DscResource.Common* containing the helper function
    `Test-DscParameterState`. The goal is that all resource common functions
    are moved to this module (functions that are or can be used by more
    than one resource) ([issue #257](https://github.com/PowerShell/ActiveDirectoryDsc/issues/257)).
  - Added xADManagedServiceAccount resource to manage Managed Service
    Accounts (MSAs). [Andrew Wickham (@awickham10)](https://github.com/awickham10)
    and [@kungfu71186](https://github.com/kungfu71186)
  - Removing the Misc Folder, as it is no longer required.
  - Added xADKDSKey resource to create KDS Root Keys for gMSAs. [@kungfu71186](https://github.com/kungfu71186)
  - Combined DscResource.LocalizationHelper and DscResource.Common Modules
    into xActiveDirectory.Common
- Changes to xADReplicationSiteLink
  - Make use of the new localization helper functions.
- Changes to xAdDomainController
  - Added new parameter to disable or enable the Global Catalog (GC)
    ([issue #75](https://github.com/PowerShell/ActiveDirectoryDsc/issues/75)).
    [Eric Foskett @Merto410](https://github.com/Merto410)
  - Fixed a bug with the parameter `InstallationMediaPath` that it would
    not be added if it was specified in a configuration. Now the parameter
    `InstallationMediaPath` is correctly passed to `Install-ADDSDomainController`.
  - Refactored the resource with major code cleanup and localization.
  - Updated unit tests to latest unit test template and refactored the
    tests for the function 'Set-TargetResource'.
  - Improved test code coverage.
- Changes to xADComputer
  - Restoring a computer account from the recycle bin no longer fails if
    there is more than one object with the same name in the recycle bin.
    Now it uses the object that was changed last using the property
    `whenChanged` ([issue #271](https://github.com/PowerShell/ActiveDirectoryDsc/issues/271)).
- Changes to xADGroup
  - Restoring a group from the recycle bin no longer fails if there is
    more than one object with the same name in the recycle bin. Now it
    uses the object that was changed last using the property `whenChanged`
    ([issue #271](https://github.com/PowerShell/ActiveDirectoryDsc/issues/271)).
- Changes to xADOrganizationalUnit
  - Restoring an organizational unit from the recycle bin no longer fails
    if there is more than one object with the same name in the recycle bin.
    Now it uses the object that was changed last using the property `whenChanged`
    ([issue #271](https://github.com/PowerShell/ActiveDirectoryDsc/issues/271)).
- Changes to xADUser
  - Restoring a user from the recycle bin no longer fails if there is
    more than one object with the same name in the recycle bin. Now it
    uses the object that was changed last using the property `whenChanged`
    ([issue #271](https://github.com/PowerShell/ActiveDirectoryDsc/issues/271)).

## 2.25.0.0

- Added xADReplicationSiteLink
  - New resource added to facilitate replication between AD sites
- Updated xADObjectPermissionEntry to use `AD:` which is more generic when using `Get-Acl` and `Set-Acl` than using `Microsoft.ActiveDirectory.Management\ActiveDirectory:://RootDSE/`
- Changes to xADComputer
  - Minor clean up of unit tests.
- Changes to xADUser
  - Added TrustedForDelegation parameter to xADUser to support enabling/disabling Kerberos delegation
  - Minor clean up of unit tests.
- Added Ensure Read property to xADDomainController to fix Get-TargetResource return bug ([issue #155](https://github.com/PowerShell/ActiveDirectoryDsc/issues/155)).
  - Updated readme and add release notes
- Updated xADGroup to support group membership from multiple domains ([issue #152](https://github.com/PowerShell/ActiveDirectoryDsc/issues/152)). [Robert Biddle (@robbiddle)](https://github.com/RobBiddle) and [Jan-Hendrik Peters (@nyanhp)](https://github.com/nyanhp)

## 2.24.0.0

- Added parameter to xADDomainController to support InstallationMediaPath ([issue #108](https://github.com/PowerShell/ActiveDirectoryDsc/issues/108)).
- Updated xADDomainController schema to be standard and provide Descriptions.

## 2.23.0.0

- Explicitly removed extra hidden files from release package

## 2.22.0.0

- Add PasswordNeverResets parameter to xADUser to facilitate user lifecycle management
- Update appveyor.yml to use the default template.
- Added default template files .gitattributes, and .gitignore, and
  .vscode folder.
- Added xADForestProperties: New resource to manage User and Principal Name Suffixes for a Forest.

## 2.21.0.0

- Added xADObjectPermissionEntry
  - New resource added to control the AD object permissions entries [Claudio Spizzi (@claudiospizzi)](https://github.com/claudiospizzi)
- Changes to xADCommon
  - Assert-Module has been extended with a parameter ImportModule to also import the module ([issue #218](https://github.com/PowerShell/ActiveDirectoryDsc/issues/218)). [Jan-Hendrik Peters (@nyanhp)](https://github.com/nyanhp)
- Changes to xADDomain
  - xADDomain makes use of new parameter ImportModule of Assert-Module in order to import the ADDSDeployment module ([issue #218](https://github.com/PowerShell/ActiveDirectoryDsc/issues/218)). [Jan-Hendrik Peters (@nyanhp)](https://github.com/nyanhp)
- xADComputer, xADGroup, xADOrganizationalUnit and xADUser now support restoring from AD recycle bin ([Issue #221](https://github.com/PowerShell/ActiveDirectoryDsc/issues/211)). [Jan-Hendrik Peters (@nyanhp)](https://github.com/nyanhp)

## 2.20.0.0

- Changes to xActiveDirectory
  - Changed MSFT_xADUser.schema.mof version to "1.0.0.0" to match other resources ([issue #190](https://github.com/PowerShell/ActiveDirectoryDsc/issues/190)). [thequietman44 (@thequietman44)](https://github.com/thequietman44)
  - Removed duplicated code from examples in README.md ([issue #198](https://github.com/PowerShell/ActiveDirectoryDsc/issues/198)). [thequietman44 (@thequietman44)](https://github.com/thequietman44)
  - xADDomain is now capable of setting the forest and domain functional level ([issue #187](https://github.com/PowerShell/ActiveDirectoryDsc/issues/187)). [Jan-Hendrik Peters (@nyanhp)](https://github.com/nyanhp)

## 2.19.0.0

- Changes to xActiveDirectory
  - Activated the GitHub App Stale on the GitHub repository.
  - The resources are now in alphabetical order in the README.md
    ([issue #194](https://github.com/PowerShell/ActiveDirectoryDsc/issues/194)).
  - Adding a Branches section to the README.md with Codecov badges for both
    master and dev branch ([issue #192](https://github.com/PowerShell/ActiveDirectoryDsc/issues/192)).
  - xADGroup no longer resets GroupScope and Category to default values ([issue #183](https://github.com/PowerShell/ActiveDirectoryDsc/issues/183)).
  - The helper function script file MSFT_xADCommon.ps1 was renamed to
    MSFT_xADCommon.psm1 to be a module script file instead. This makes it
    possible to report code coverage for the helper functions ([issue #201](https://github.com/PowerShell/ActiveDirectoryDsc/issues/201)).

## 2.18.0.0

- xADReplicationSite: Resource added.
- Added xADReplicationSubnet resource.
- Fixed bug with group members in xADGroup

## 2.17.0.0

- Converted AppVeyor.yml to use DSCResource.tests shared code.
- Opted-In to markdown rule validation.
- Readme.md modified resolve markdown rule violations.
- Added CodeCov.io support.
- Added xADServicePrincipalName resource.

## 2.16.0.0

- xAdDomainController: Update to complete fix for SiteName being required field.
- xADDomain: Added retry logic to prevent FaultException to crash in Get-TargetResource on subsequent reboots after a domain is created because the service is not yet running. This error is mostly occur when the resource is used with the DSCExtension on Azure.

## 2.15.0.0

- xAdDomainController: Fixes SiteName being required field.

## 2.14.0.0

- xADDomainController: Adds Site option.
- xADDomainController: Populate values for DatabasePath, LogPath and SysvolPath during Get-TargetResource.

## 2.13.0.0

- Converted AppVeyor.yml to pull Pester from PSGallery instead of Chocolatey
- xADUser: Adds 'PasswordAuthentication' option when testing user passwords to support NTLM authentication with Active Directory Certificate Services deployments
- xADUser: Adds descriptions to user properties within the schema file.
- xADGroup: Fixes bug when updating groups when alternate Credentials are specified.

## 2.12.0.0

- xADDomainController: Customer identified two cases of incorrect variables being called in Verbose output messages. Corrected.
- xADComputer: New resource added.
- xADComputer: Added RequestFile support.
- Fixed PSScriptAnalyzer Errors with v1.6.0.

## 2.11.0.0

- xWaitForADDomain: Made explicit credentials optional and other various updates

## 2.10.0.0

- xADDomainDefaultPasswordPolicy: New resource added.
- xWaitForADDomain: Updated to make it compatible with systems that don't have the ActiveDirectory module installed, and to allow it to function with domains/forests that don't have a domain controller with Active Directory Web Services running.
- xADGroup: Fixed bug where specified credentials were not used to retrieve existing group membership.
- xADDomain: Added check for Active Directory cmdlets.
- xADDomain: Added additional error trapping, verbose and diagnostic information.
- xADDomain: Added unit test coverage.
- Fixes CredentialAttribute and other PSScriptAnalyzer tests in xADCommon, xADDomain, xADGroup, xADOrganizationalUnit and xADUser resources.

## 2.9.0.0

- xADOrganizationalUnit: Merges xADOrganizationalUnit resource from the PowerShell gallery
- xADGroup: Added Members, MembersToInclude, MembersToExclude and MembershipAttribute properties.
- xADGroup: Added ManagedBy property.
- xADGroup: Added Notes property.
- xADUser: Adds additional property settings.
- xADUser: Adds unit test coverage.

## 2.8.0.0

- Added new resource: xADGroup
- Fixed issue with NewDomainNetbiosName parameter.

## 2.7.0.0

- Added DNS flush in retry loop
- Bug fixes in xADDomain resource

## 2.6.0.0

- Removed xDscResourceDesigner tests (moved to common tests)

## 2.5.0.0

- Updated xADDomainTrust and xADRecycleBin tests

## 2.4.0.0

- Added xADRecycleBin resource
- Minor fixes for xADUser resource

## 2.3

- Added xADRecycleBin.
- Modified xADUser to include a write-verbose after user is removed when Absent.
- Corrected xADUser to successfully create a disabled user without a password.

## 2.2

- Modified xAdDomain and xAdDomainController to support Ensure as Present / Absent, rather than True/False.
  Note: this may cause issues for existing scripts.
- Corrected return value to be a hashtable in both resources.

## 2.1.0.0

- Minor update: Get-TargetResource to use domain name instead of name.

## 2.0.0.0

- Updated release, which added the resource:
  - xADDomainTrust

## 1.0.0.0

- Initial release with the following resources:
  - xADDomain, xADDomainController, xADUser, and xWaitForDomain
