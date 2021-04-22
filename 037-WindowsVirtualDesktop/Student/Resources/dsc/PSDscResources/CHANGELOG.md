# Change log for PsDscResources

## Unreleased

## 2.12.0.0

* Ports style fixes that were recently made in xPSDesiredStateConfiguration
  on test related files.
* Ports most of the style upgrades from xPSDesiredStateConfiguration that have
  been made in files in the DscResources folder.
* Ports fixes for the following issues:
  [Issue #505](https://github.com/PowerShell/xPSDesiredStateConfiguration/issues/505)
  [Issue #590](https://github.com/PowerShell/xPSDesiredStateConfiguration/issues/590)
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
  [Issue #142](https://github.com/PowerShell/PSDscResources/issues/142)
* Improved speed of Test-IsNanoServer function
* Remove the Byte Order Mark (BOM) from all affected files
* Opt-in to 'Validate Module Files' and 'Validate Script Files' common meta-tests
* Opt-in to 'Common Tests - Relative Path Length' common meta-test
* Fix README markdownlint validation failures
* Move change log from README.md to CHANGELOG.md

## 2.11.0.0

* Fix Custom DSC Resource Kit PSSA Rule Failures

## 2.10.0.0

* Fixed CompanyName typo - Fixes [Issue #100](https://github.com/PowerShell/PSDscResources/issues/100)
* Update LICENSE file to match the Microsoft Open Source Team
  standard - Fixes [Issue #120](https://github.com/PowerShell/PSDscResources/issues/120).
* Update `CommonResourceHelper` unit tests to meet Pester 4.0.0
  standards ([issue #129](https://github.com/PowerShell/PSDscResources/issues/129)).
* Update `ResourceHelper` unit tests to meet Pester 4.0.0
  standards ([issue #129](https://github.com/PowerShell/PSDscResources/issues/129)).
* Ported fixes from [xPSDesiredStateConfiguration](https://github.com/PowerShell/xPSDesiredStateConfiguration):
  * xArchive
    * Fix end-to-end tests.
    * Update integration tests to meet Pester 4.0.0 standards.
    * Update end-to-end tests to meet Pester 4.0.0 standards.
    * Update unit and integration tests to meet Pester 4.0.0 standards.
    * Wrapped all path and identifier strings in verbose messages with
      quotes to make it easier to identify the limit of the string when
      debugging.
    * Refactored date/time checksum code to improve testability and ensure
      tests can run on machines with localized datetime formats that are not
      US.
    * Fix 'Get-ArchiveEntryLastWriteTime' to return `[datetime]`.
    * Improved verbose logging to make debugging path issues easier.
* Added .gitattributes file to ensure CRLF settings are configured correctly
  for the repository.
* Updated '.vscode\settings.json' to refer to AnalyzerSettings.psd1 so that
  custom syntax problems are highlighted in Visual Studio Code.
* Fixed style guideline violations in `CommonResourceHelper.psm1`.
* Updated 'appveyor.yml' to meet more recent standards.
* Removed OS image version from 'appveyor.yml' to use default image
  ([Issue #127](https://github.com/PowerShell/PSDscResources/issues/127)).
* Removed code to install WMF5.1 from 'appveyor.yml' because it is already
  installed in AppVeyor images ([Issue #128](https://github.com/PowerShell/PSDscResources/issues/128)).
* Removed .vscode from .gitignore so that Visual Studio code environment
  settings can be committed.
* Environment
  * Update tests to meet Pester 4.0.0 standards ([issue #129](https://github.com/PowerShell/PSDscResources/issues/129)).
* Group
  * Update tests to meet Pester 4.0.0 standards ([issue #129](https://github.com/PowerShell/PSDscResources/issues/129)).
  * Fix unit tests to run on Nano Server.
  * Refactored unit tests to enclude Context fixtures and change functions
    to Describe fixtures.
* GroupSet
  * Update tests to meet Pester 4.0.0 standards ([issue #129](https://github.com/PowerShell/PSDscResources/issues/129)).

## 2.9.0.0

* Added Description and Parameter description for composite resources

## 2.8.0.0

* Archive
  * Added handling of directory archive entries that end with a foward slash
  * Removed formatting of LastWriteTime timestamp and updated comparison of timestamps to handle dates in different formats
* WindowsProcess
  * Fix unreliable tests
* Updated Test-IsNanoServer to return false if Get-ComputerInfo fails
* Registry
  * Fixed bug when using the full registry drive name (e.g. HKEY\_LOCAL\_MACHINE) and using a key name that includes a drive with forward slashes (e.g. C:/)

## 2.7.0.0

* MsiPackage
  * Parse installation date from registry using invariant culture.
  * Fix a bug in unit test failing, when regional setting differs from English-US.

## 2.6.0.0

* Archive
  * Fixed a minor bug in the unit tests where sometimes the incorrect DateTime format was used.
* Added MsiPackage

## 2.5.0.0

* Enable codecov.io code coverage reporting
* Group
  * Added support for domain based group members on Nano server.
* Added the Archive resource
* Update Test-IsNanoServer cmdlet to properly test for a Nano server rather than the core version of PowerShell
* Registry
  * Fixed bug where an error was thrown when running Get-DscConfiguration if the registry already existed

## 2.4.0.0

* Cleaned User
* Updated User to have non-dependent unit tests.
* Ported fixes from [xPSDesiredStateConfiguration](https://github.com/PowerShell/xPSDesiredStateConfiguration):
  * WindowsProcess: Minor updates to integration tests
  * Registry: Fixed support for forward slashes in registry key names
* Group:
  * Group members in the "NT Authority", "BuiltIn" and "NT Service" scopes should now be resolved without an error. If you were seeing the errors "Exception calling ".ctor" with "4" argument(s): "Server names cannot contain a space character."" or "Exception calling ".ctor" with "2" argument(s): "Server names cannot contain a space character."", this fix should resolve those errors. If you are still seeing one of the errors, there is probably another local scope we need to add. Please let us know.
  * The resource will no longer attempt to resolve group members if Members, MembersToInclude, and MembersToExclude are not specified.
* Added Environment

## 2.3.0.0

* Updated manifest to include both WindowsOptionalFeature and WindowsOptionalFeatureSet instead of just WindowsOptionalFeature twice

## 2.2.0.0

* WindowsFeature:
  * Added Catch to ignore RuntimeException when importing ServerManager module. This solves the issue described [here](https://social.technet.microsoft.com/Forums/en-US/9fc314e1-27bf-4f03-ab78-5e0f7a662b8f/importmodule-servermanager-some-or-all-identity-references-could-not-be-translated?forum=winserverpowershell).
  * Updated unit tests.
* Added WindowsProcess
* CommonTestHelper:
  * Added Get-AppVeyorAdministratorCredential.
  * Added Set-StrictMode -'Latest' and $errorActionPreference -'Stop'.
* Service:
  * Updated resource module, unit tests, integration tests, and examples to reflect the changes made in xPSDesiredStateConfiguration.
* Group:
  * Updated resource module, examples, and integration tests to reflect the changes made in xPSDesiredStateConfiguration.
* Added Script.
* Added GroupSet, ServiceSet, WindowsFeatureSet, WindowsOptionalFeatureSet, and ProcessSet.
* Added Set-StrictMode -'Latest' and $errorActionPreference -'Stop' to Group, Service, User, WindowsFeature, WindowsOptionalFeature, WindowsPackageCab.
* Fixed bug in WindowsFeature in which is was checking the 'Count' property of an object that was not always an array.
* Cleaned Group and Service resources and tests.
* Added Registry.

## 2.1.0.0

* Added WindowsFeature.

## 2.0.0.0

* Initial release of PSDscResources.
