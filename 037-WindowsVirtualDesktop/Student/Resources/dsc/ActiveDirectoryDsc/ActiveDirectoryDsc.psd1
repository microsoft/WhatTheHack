@{
# Version number of this module.
moduleVersion = '4.2.0.0'

# ID used to uniquely identify this module
GUID = '9FECD4F6-8F02-4707-99B3-539E940E9FF5'

# Author of this module
Author = 'Microsoft Corporation'

# Company or vendor of this module
CompanyName = 'Microsoft Corporation'

# Copyright statement for this module
Copyright = '(c) 2019 Microsoft Corporation. All rights reserved.'

# Description of the functionality provided by this module
Description = 'The ActiveDirectoryDsc module contains DSC resources for deployment and configuration of Active Directory.

These DSC resources allow you to configure new domains, child domains, and high availability domain controllers, establish cross-domain trusts and manage users, groups and OUs.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '4.0'

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = '4.0'

# Nested modules to load when this module is imported.
NestedModules = 'Modules\ActiveDirectoryDsc.Common\ActiveDirectoryDsc.Common.psm1'

# Functions to export from this module
FunctionsToExport = @(
  # Exported so that WaitForADDomain can use this function in a separate scope.
  'Find-DomainController'
)

# Cmdlets to export from this module
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module
AliasesToExport = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('DesiredStateConfiguration', 'DSC', 'DSCResourceKit', 'DSCResource')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/PowerShell/ActiveDirectoryDsc/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/PowerShell/ActiveDirectoryDsc'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '- Changes to ActiveDirectoryDsc
  - Resolved custom Script Analyzer rules that was added to the test framework.
  - Resolve style guideline violations for hashtables ([issue 516](https://github.com/PowerShell/ActiveDirectoryDsc/issues/516)).
- Changes to ADReplicationSite
  - Added "Description" attribute parameter ([issue 500](https://github.com/PowerShell/ActiveDirectoryDsc/issues/500)).
  - Added Integration testing ([issue 355](https://github.com/PowerShell/ActiveDirectoryDsc/issues/355)).
  - Correct value returned for RenameDefaultFirstSiteName ([issue 502](https://github.com/PowerShell/ActiveDirectoryDsc/issues/502)).
- Changes to ADReplicationSubnet
  - Added "Description" attribute parameter ([issue 503](https://github.com/PowerShell/ActiveDirectoryDsc/issues/500))
  - Added Integration testing ([issue 357](https://github.com/PowerShell/ActiveDirectoryDsc/issues/357))
- Changes to ADReplicationSiteLink
  - Added Integration testing ([issue 356](https://github.com/PowerShell/ActiveDirectoryDsc/issues/356)).
  - Added ability to set "Options" such as Change Notification Replication ([issue 504](https://github.com/PowerShell/ActiveDirectoryDsc/issues/504)).
- Changes to ActiveDirectoryDsc.Common
  - Fix `Test-DscPropertyState` Failing when Comparing $Null and Arrays. ([issue 513](https://github.com/PowerShell/ActiveDirectoryDsc/issues/513))

'

    } # End of PSData hashtable

} # End of PrivateData hashtable
}




















