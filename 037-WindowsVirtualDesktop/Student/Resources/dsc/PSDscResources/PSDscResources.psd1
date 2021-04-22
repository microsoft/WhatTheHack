@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
moduleVersion = '2.12.0.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '7b750b98-bc2c-4059-80b9-f7228941a34f'

# Author of this module
Author = 'Microsoft Corporation'

# Company or vendor of this module
CompanyName = 'Microsoft Corporation'

# Copyright statement for this module
Copyright = '(c) 2016 Microsoft Corporation. All rights reserved.'

# Description of the functionality provided by this module
Description = 'This module contains the standard DSC resources.
Because PSDscResources overwrites in-box resources, it is only available for WMF 5.1. Many of the resource updates provided here are also included in the xPSDesiredStateConfiguration module which is still compatible with WMF 4 and WMF 5 (though that module is not supported and may be removed in the future).
'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @()

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
DscResourcesToExport = @( 'Archive', 'Environment', 'Group', 'GroupSet', 'MsiPackage', 'Registry', 'Script', 'Service', 'ServiceSet', 'User', 'WindowsFeature', 'WindowsFeatureSet', 'WindowsOptionalFeature', 'WindowsOptionalFeatureSet', 'WindowsPackageCab', 'WindowsProcess', 'ProcessSet' )

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'DesiredStateConfiguration', 'DSC', 'DSCResourceKit', 'DSCResource', 'AzureAutomationNotSupported'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/PowerShell/PSDscResources/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/PowerShell/PSDscResources'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '* Ports style fixes that were recently made in xPSDesiredStateConfiguration
  on test related files.
* Ports most of the style upgrades from xPSDesiredStateConfiguration that have
  been made in files in the DscResources folder.
* Ports fixes for the following issues:
  [Issue 505](https://github.com/PowerShell/xPSDesiredStateConfiguration/issues/505)
  [Issue 590](https://github.com/PowerShell/xPSDesiredStateConfiguration/issues/590)
  Changes to test helper Enter-DscResourceTestEnvironment so that it only
  updates DSCResource.Tests when it is longer than 120 minutes since
  it was last pulled. This is to improve performance of test execution
  and reduce the likelihood of connectivity issues caused by inability to
  pull DSCResource.Tests.
* Fixes issue where MsiPackage Integration tests fail if the test HttpListener
  fails to start. Moves the test HttpListener objects to dynamically assigned,
  higher numbered ports to avoid conflicts with other services, and also checks
  to ensure that the ports are available before using them. Adds checks to
  ensure that no outstanding HTTP server jobs are running before attempting to
  setup a new one. Also adds additional instrumentation to make it easier to
  troubleshoot issues with the test HttpListener objects in the future.
  Specifically fixes
  [Issue 142](https://github.com/PowerShell/PSDscResources/issues/142)
* Improved speed of Test-IsNanoServer function
* Remove the Byte Order Mark (BOM) from all affected files
* Opt-in to "Validate Module Files" and "Validate Script Files" common meta-tests
* Opt-in to "Common Tests - Relative Path Length" common meta-test
* Fix README markdownlint validation failures
* Move change log from README.md to CHANGELOG.md

'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}












