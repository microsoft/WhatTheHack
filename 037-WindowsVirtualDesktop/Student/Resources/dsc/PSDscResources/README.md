# PSDscResources

PSDscResources is the new home of the in-box resources from PSDesiredStateConfiguration.

These resources are a combination of those in the in-box PSDesiredStateConfiguration module as well as community contributions from our experimental [xPSDesiredStateConfiguration](https://github.com/PowerShell/xPSDesiredStateConfiguration) module on GitHub.
These resources have also recently been updated to meet the DSC Resource Kit [High Quality Resource Module (HQRM) guidelines](https://github.com/PowerShell/DscResources/blob/master/HighQualityModuleGuidelines.md).

In-box resources not currently included in this module should not be affected and can still load from the in-box PSDesiredStateConfiguration module.

Because PSDscResources overwrites in-box resources, it is only available for WMF 5.1.
Many of the resource updates provided here are also included in the [xPSDesiredStateConfiguration](https://github.com/PowerShell/xPSDesiredStateConfiguration) module which is still compatible with WMF 4 and WMF 5 (though this module is not supported and may be removed in the future).

To update your in-box resources to the newest versions provided by PSDscResources, first install PSDscResources from the PowerShell Gallery:

```powershell
Install-Module PSDscResources
```

Then, simply add this line to your DSC configuration:

```powershell
Import-DscResource -ModuleName PSDscResources
```

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/9uf3wyys7ky7776d/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/psdscresources/branch/master)
[![codecov](https://codecov.io/gh/PowerShell/PSDscResources/branch/master/graph/badge.svg)](https://codecov.io/gh/PowerShell/PSDscResources)

This is the branch containing the latest release -
no contributions should be made directly to this branch.

### dev

[![Build status](https://ci.appveyor.com/api/projects/status/9nsi30ladk1jaax5/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/AuditPolicyDsc/branch/dev)
[![codecov](https://codecov.io/gh/PowerShell/AuditPolicyDsc/branch/dev/graph/badge.svg)](https://codecov.io/gh/PowerShell/AuditPolicyDsc/branch/dev)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

This module does not accept breaking changes.

Please check out the common DSC Resources [contributing guidelines](https://github.com/PowerShell/DscResource.Kit/blob/master/CONTRIBUTING.md).

## Change log

A full list of changes in each version can be found in the [change log](CHANGELOG.md).

## Resources

* [Archive](#archive): Provides a mechanism to expand an archive (.zip) file to a specific path or remove an expanded archive (.zip) file from a specific path on a target node.
* [Environment](#environment): Provides a mechanism to configure and manage environment variables for a machine or process.
* [Group](#group): Provides a mechanism to manage local groups on a target node.
* [GroupSet](#groupset): Provides a mechanism to configure and manage multiple Group resources with common settings but different names.
* [MsiPackage](#msipackage): Provides a mechanism to install and uninstall MSI packages.
* [Registry](#registry): Provides a mechanism to manage registry keys and values on a target node.
* [Script](#script): Provides a mechanism to run PowerShell script blocks on a target node.
* [Service](#service): Provides a mechanism to configure and manage Windows services on a target node.
* [ServiceSet](#serviceset): Provides a mechanism to configure and manage multiple Service resources with common settings but different names.
* [User](#user): Provides a mechanism to manage local users on a target node.
* [WindowsFeature](#windowsfeature): Provides a mechanism to install or uninstall Windows roles or features on a target node.
* [WindowsFeatureSet](#windowsfeatureset): Provides a mechanism to configure and manage multiple WindowsFeature resources on a target node.
* [WindowsOptionalFeature](#windowsoptionalfeature): Provides a mechanism to enable or disable optional features on a target node.
* [WindowsOptionalFeatureSet](#windowsoptionalfeatureset): Provides a mechanism to configure and manage multiple WindowsOptionalFeature resources on a target node.
* [WindowsPackageCab](#windowspackagecab): Provides a mechanism to install or uninstall a package from a Windows cabinet (cab) file on a target node.
* [WindowsProcess](#windowsprocess): Provides a mechanism to start and stop a Windows process.
* [ProcessSet](#processset): Provides a mechanism to configure and manage multiple WindowsProcess resources on a target node.

### Resources that Work on Nano Server

* [Group](#group)
* [Script](#script)
* [Service](#service)
* [User](#user)
* [WindowsOptionalFeature](#windowsoptionalfeature)
* [WindowsOptionalFeatureSet](#windowsoptionalfeatureset)
* [WindowsPackageCab](#windowspackagecab)

### Archive

Provides a mechanism to expand an archive (.zip) file to a specific path or remove an expanded archive (.zip) file from a specific path on a target node.

#### Requirements

* The System.IO.Compression type assembly must be available on the machine.
* The System.IO.Compression.FileSystem type assembly must be available on the machine.

#### Parameters

* **[String] Path** _(Key)_: The path to the archive file that should be expanded to or removed from the specified destination.
* **[String] Destination** _(Key)_: The path where the specified archive file should be expanded to or removed from.
* **[String] Ensure** _(Write)_: Specifies whether or not the expanded content of the archive file at the specified path should exist at the specified destination. To update the specified destination to have the expanded content of the archive file at the specified path, specify this property as Present. To remove the expanded content of the archive file at the specified path from the specified destination, specify this property as Absent. The default value is Present. { *Present* | Absent }.
* **[Boolean] Validate** _(Write)_: Specifies whether or not to validate that a file at the destination with the same name as a file in the archive actually matches that corresponding file in the archive by the specified checksum method. If the file does not match and Ensure is specified as Present and Force is not specified, the resource will throw an error that the file at the desintation cannot be overwritten. If the file does not match and Ensure is specified as Present and Force is specified, the file at the desintation will be overwritten. If the file does not match and Ensure is specified as Absent, the file at the desintation will not be removed. The default value is false.
* **[String] Checksum** _(Write)_: The Checksum method to use to validate whether or not a file at the destination with the same name as a file in the archive actually matches that corresponding file in the archive. An invalid argument exception will be thrown if Checksum is specified while Validate is specified as false. ModifiedDate will check that the LastWriteTime property of the file at the destination matches the LastWriteTime property of the file in the archive. CreatedDate will check that the CreationTime property of the file at the destination matches the CreationTime property of the file in the archive. SHA-1, SHA-256, and SHA-512 will check that the hash of the file at the destination by the specified SHA method matches the hash of the file in the archive by the specified SHA method. The default value is ModifiedDate. { *ModifiedDate* | CreatedDate | SHA-1 | SHA-256 | SHA-512 }
* **[System.Management.Automation.PSCredential] Credential** _(Write)_: The credential of a user account with permissions to access the specified archive path and destination if needed.
* **[Boolean] Force** _(Write)_: Specifies whether or not any existing files or directories at the destination with the same name as a file or directory in the archive should be overwritten to match the file or directory in the archive. When this property is false, an error will be thrown if an item at the destination needs to be overwritten. The default value is false.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Expand an archive without file validation](https://github.com/PowerShell/PSDscResources/blob/dev/Examples/Sample_Archive_ExpandArchiveNoValidation.ps1)
* [Expand an archive under a credential without file validation](https://github.com/PowerShell/PSDscResources/blob/dev/Examples/Sample_Archive_ExpandArchiveNoValidationCredential.ps1)
* [Expand an archive with default file validation and file overwrite allowed](https://github.com/PowerShell/PSDscResources/blob/dev/Examples/Sample_Archive_ExpandArchiveDefaultValidationAndForce.ps1)
* [Expand an archive with SHA-256 file validation and file overwrite allowed](https://github.com/PowerShell/PSDscResources/blob/dev/Examples/Sample_Archive_ExpandArchiveChecksumAndForce.ps1)
* [Remove an archive without file validation](https://github.com/PowerShell/PSDscResources/blob/dev/Examples/Sample_Archive_RemoveArchiveNoValidation.ps1)
* [Remove an archive with SHA-256 file validation](https://github.com/PowerShell/PSDscResources/blob/dev/Examples/Sample_Archive_RemoveArchiveChecksum.ps1)

### Environment

Provides a mechanism to configure and manage environment variables for a machine or process.

#### Requirements

None

#### Parameters

* **[String] Name** _(Key)_: The name of the environment variable to create, modify, or remove.
* **[String] Value** _(Write)_: The desired value for the environment variable. The default value is an empty string which either indicates that the variable should be removed entirely or that the value does not matter when testing its existence.
* **[String] Ensure** _(Write)_: Specifies if the environment varaible should exist. { *Present* | Absent }.
* **[Boolean] Path** _(Write)_: Indicates whether or not the environment variable is a path variable. If the variable being configured is a path variable, the value provided will be appended to or removed from the existing value, otherwise the existing value will be replaced by the new value. The default value is False.
* **[String[]] Target** _(Write)_: Indicates the target where the environment variable should be set. { Process | Machine | *Process, Machine* }.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Create a non-path environment variable](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_Environment_CreateNonPathVariable.ps1)
* [Create or update a path environment variable](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_Environment_CreatePathVariable.ps1)
* [Remove an environment variable](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_Environment_Remove.ps1)

### Group

Provides a mechanism to manage local groups on a target node.
This resource works on Nano Server.

#### Requirements

None

#### Parameters

* **[String] GroupName** _(Key)_: The name of the group to create, modify, or remove.
* **[String] Ensure** _(Write)_: Indicates if the group should exist or not. To add a group or modify an existing group, set this property to Present. To remove a group, set this property to Absent. The default value is Present. { *Present* | Absent }.
* **[String] Description** _(Write)_: The description the group should have.
* **[String[]] Members** _(Write)_: The members the group should have. This property will replace all the current group members with the specified members. Members should be specified as strings in the format of their domain qualified name (domain\username), their UPN (username@domainname), their distinguished name (CN=username,DC=...), or their username (for local machine accounts). Using either the MembersToExclude or MembersToInclude properties in the same configuration as this property will generate an error.
* **[String[]] MembersToInclude** _(Write)_: The members the group should include. This property will only add members to a group. Members should be specified as strings in the format of their domain qualified name (domain\username), their UPN (username@domainname), their distinguished name (CN=username,DC=...), or their username (for local machine accounts). Using the Members property in the same configuration as this property will generate an error.
* **[String[]] MembersToExclude** _(Write)_: The members the group should exclude. This property will only remove members from a group. Members should be specified as strings in the format of their domain qualified name (domain\username), their UPN (username@domainname), their distinguished name (CN=username,DC=...), or their username (for local machine accounts). Using the Members property in the same configuration as this property will generate an error.
* **[System.Management.Automation.PSCredential] Credential** _(Write)_: A credential to resolve non-local group members.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Set members of a group](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_Group_SetMembers.ps1)
* [Remove members of a group](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_Group_RemoveMembers.ps1)

### GroupSet

Provides a mechanism to configure and manage multiple Group resources with common settings but different names

#### Requirements

None

#### Parameters

* **[String] GroupName** _(Key)_: The names of the groups to create, modify, or remove.

The following parameters will be the same for each group in the set:

* **[String] Ensure** _(Write)_: Indicates if the groups should exist or not. To add groups or modify existing groups, set this property to Present. To remove groups, set this property to Absent. { Present | Absent }.
* **[String[]] MembersToInclude** _(Write)_: The members the groups should include. This property will only add members to groups. Members should be specified as strings in the format of their domain qualified name (domain\username), their UPN (username@domainname), their distinguished name (CN=username,DC=...), or their username (for local machine accounts).
* **[String[]] MembersToExclude** _(Write)_: The members the groups should exclude. This property will only remove members groups. Members should be specified as strings in the format of their domain qualified name (domain\username), their UPN (username@domainname), their distinguished name (CN=username,DC=...), or their username (for local machine accounts).
* **[System.Management.Automation.PSCredential] Credential** _(Write)_: A credential to resolve non-local group members.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Add members to multiple groups](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_GroupSet_AddMembers.ps1)

### MsiPackage

Provides a mechanism to install and uninstall MSI packages.

#### Requirements

None

#### Parameters

* **[String] ProductId** _(Key)_: The identifying number used to find the package, usually a GUID.
* **[String] Path** _(Required)_: The path to the MSI file that should be installed or uninstalled.
* **[String] Ensure** _(Write)_: Specifies whether or not the MSI file should be installed or not. To install the MSI file, specify this property as Present. To uninstall the .msi file, specify this property as Absent. The default value is Present. { *Present* | Absent }.
* **[String] Arguments** _(Write)_: The arguments to be passed to the MSI package during installation or uninstallation if needed.
* **[System.Management.Automation.PSCredential] Credential** _(Write)_: The credential of a user account to be used to mount a UNC path if needed.
* **[String] LogPath** _(Write)_: The path to the log file to log the output from the MSI execution.
* **[String] FileHash** _(Write)_: The expected hash value of the MSI file at the given path.
* **[String] HashAlgorithm** _(Write)_: The algorithm used to generate the given hash value.
* **[String] SignerSubject** _(Write)_: The subject that should match the signer certificate of the digital signature of the MSI file.
* **[String] SignerThumbprint** _(Write)_: The certificate thumbprint that should match the signer certificate of the digital signature of the MSI file.
* **[String] ServerCertificateValidationCallback** _(Write)_: PowerShell code that should be used to validate SSL certificates for paths using HTTPS.
* **[System.Management.Automation.PSCredential] RunAsCredential** _(Write)_: The credential of a user account under which to run the installation or uninstallation of the MSI package.

#### Read-Only Properties from Get-TargetResource

* **[String] Name** _(Read)_: The display name of the MSI package.
* **[String] InstallSource** _(Read)_: The path to the MSI package.
* **[String] InstalledOn** _(Read)_: The date that the MSI package was installed on or serviced on, whichever is later.
* **[UInt32] Size** _(Read)_: The size of the MSI package in MB.
* **[String] Version** _(Read)_: The version number of the MSI package.
* **[String] PackageDescription** _(Read)_: The description of the MSI package.
* **[String] Publisher** _(Read)_: The publisher of the MSI package.

#### Examples

* [Install the MSI file with the given ID at the given Path](https://github.com/PowerShell/PSDscResources/blob/dev/Examples/Sample_MsiPackage_InstallPackageFromFile.ps1)
* [Uninstall the MSI file with the given ID at the given Path](https://github.com/PowerShell/PSDscResources/blob/dev/Examples/Sample_MsiPackage_UninstallPackageFromFile.ps1)
* [Install the MSI file with the given ID at the given HTTP URL](https://github.com/PowerShell/PSDscResources/blob/dev/Examples/Sample_MsiPackage_InstallPackageFromHttp.ps1)
* [Uninstall the MSI file with the given ID at the given HTTPS URL](https://github.com/PowerShell/PSDscResources/blob/dev/Examples/Sample_MsiPackage_UnstallPackageFromHttps.ps1)

### Registry

Provides a mechanism to manage registry keys and values on a target node.

#### Requirements

None

#### Parameters

* **[String] Key** _(Key)_: The path of the registry key to add, modify, or remove. This path must include the registry hive/drive (e.g. HKEY_LOCAL_MACHINE, HKLM:).
* **[String] ValueName** _(Key)_: The name of the registry value. To add or remove a registry key, specify this property as an empty string without specifying ValueType or ValueData. To modify or remove the default value of a registry key, specify this property as an empty string while also specifying ValueType or ValueData.
* **[String] Ensure** _(Write)_: Specifies whether or not the registry key or value should exist. To add or modify a registry key or value, set this property to Present. To remove a registry key or value, set this property to Absent. { *Present* | Absent }.
* **[String] ValueData** _(Write)_: The data the specified registry key value should have as a string or an array of strings (MultiString only).
* **[String] ValueType** _(Write)_: The type the specified registry key value should have. { *String* | Binary | DWord | QWord | MultiString | ExpandString }
* **[Boolean] Hex** _(Write)_: Specifies whether or not the specified DWord or QWord registry key data is provided in a hexadecimal format. Not valid for types other than DWord and QWord. The default value is $false.
* **[Boolean] Force** _(Write)_: Specifies whether or not to overwrite the specified registry key value if it already has a value or whether or not to delete a registry key that has subkeys. The default value is $false.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Add a registry key](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_RegistryResource_AddKey.ps1)
* [Add or modify a registry key value](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_RegistryResource_AddOrModifyValue.ps1)
* [Remove a registry key value](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_RegistryResource_RemoveValue.ps1)
* [Remove a registry key](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_RegistryResource_RemoveKey.ps1)

### Script

Provides a mechanism to run PowerShell script blocks on a target node.
This resource works on Nano Server.

#### Requirements

None

#### Parameters

* **[String] GetScript** _(Key)_: A string that can be used to create a PowerShell script block that retrieves the current state of the resource. This script block runs when the Get-DscConfiguration cmdlet is called. This script block should return a hash table containing one key named Result with a string value.
* **[String] SetScript** _(Key)_: A string that can be used to create a PowerShell script block that sets the resource to the desired state. This script block runs conditionally when the Start-DscConfiguration cmdlet is called. The TestScript script block will run first. If the TestScript block returns False, this script block will run. If the TestScript block returns True, this script block will not run. This script block should not return.
* **[String] TestScript** _(Key)_: A string that can be used to create a PowerShell script block that validates whether or not the resource is in the desired state. This script block runs when the Start-DscConfiguration cmdlet is called or when the Test-DscConfiguration cmdlet is called. This script block should return a boolean with True meaning that the resource is in the desired state and False meaning that the resource is not in the desired state.
* **[PSCredential] Credential** _(Write)_: The credential of the user account to run the script under if needed.

#### Read-Only Properties from Get-TargetResource

* **[String] Result** _(Read)_: The result from the GetScript script block.

#### Examples

* [Create a file with content through Script](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_Script.ps1)

### Service

Provides a mechanism to configure and manage Windows services on a target node.
This resource works on Nano Server.

#### Requirements

None

#### Parameters

* **[String] Name** _(Key)_: Indicates the service name. Note that sometimes this is different from the display name. You can get a list of the services and their current state with the Get-Service cmdlet.
* **[String] Ensure** _(Write)_: Indicates whether the service is present or absent. Defaults to Present. { *Present* | Absent }.
* **[String] Path** _(Write)_: The path to the service executable file.
* **[String] StartupType** _(Write)_: Indicates the startup type for the service. { Automatic | Disabled | Manual }.
* **[String] BuiltInAccount** _(Write)_: Indicates the sign-in account to use for the service. { LocalService | LocalSystem | NetworkService }.
* **[PSCredential] Credential** _(Write)_: The credential to run the service under.
* **[Boolean] DesktopInteract** _(Write)_: Indicates whether the service can create or communicate with a window on the desktop. Must be false for services not running as LocalSystem. Defaults to False.
* **[String] State** _(Write)_: Indicates the state you want to ensure for the service. Defaults to Running. { *Running* | Stopped | Ignore }.
* **[String] DisplayName** _(Write)_: The display name of the service.
* **[String] Description** _(Write)_: The description of the service.
* **[String[]] Dependencies** _(Write)_: An array of strings indicating the names of the dependencies of the service.
* **[Uint32] StartupTimeout** _(Write)_: The time to wait for the service to start in milliseconds. Defaults to 30000.
* **[Uint32] TerminateTimeout** _(Write)_: The time to wait for the service to stop in milliseconds. Defaults to 30000.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Create a service](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_Service_CreateService.ps1)
* [Delete a service](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_Service_DeleteService.ps1)
* [Update a service with StartupType set to 'Ignore'](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_Service_UpdateStartupTypeIgnoreState)

### ServiceSet

Provides a mechanism to configure and manage multiple Service resources with common settings but different names.
This resource can only modify or delete existing services. It cannot create services.

#### Requirements

None

#### Parameters

* **[String[]] Name** _(Key)_: The names of the services to modify or delete. This may be different from the service's display name. To retrieve a list of all services with their names and current states, use the Get-Service cmdlet.

The following parameters will be the same for each service in the set:

* **[String] Ensure** _(Write)_: Indicates whether the services are present or absent. { *Present* | Absent }.
* **[String] BuiltInAccount** _(Write)_: The built-in account the services should start under. Cannot be specified at the same time as Credential. The user account specified by this property must have access to the service executable paths in order to start the services. { LocalService | LocalSystem | NetworkService }.
* **[PSCredential] Credential** _(Write)_: The credential of the user account the services should start under. Cannot be specified at the same time as BuiltInAccount. The user specified by this credential will automatically be granted the Log on as a Service right. The user account specified by this property must have access to the service executable paths in order to start the services.
* **[String] StartupType** _(Write)_: The startup type of the services. { Automatic | Disabled | Manual }.
* **[String] State** _(Write)_: The state the services. { *Running* | Stopped | Ignore }.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Ensure that multiple services are running](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_ServiceSet_StartServices.ps1)
* [Set multiple services to run under the built-in account LocalService](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_ServiceSet_BuiltInAccount.ps1)

### User

Provides a mechanism to manage local users on a target node.
This resource works on Nano Server.

#### Requirements

None

#### Parameters

* **[String] UserName** _(Key)_: Indicates the account name for which you want to ensure a specific state.
* **[String] Description** _(Write)_: Indicates the description you want to use for the user account.
* **[Boolean] Disabled** _(Write)_: Indicates if the account is disabled. Set this property to true to ensure that this account is disabled, and set it to false to ensure that it is enabled. The default value is false.
* **[String] Ensure** _(Write)_: Ensures that the feature is present or absent { *Present* | Absent }.
* **[String] FullName** _(Write)_: Represents a string with the full name you want to use for the user account.
* **[PSCredential] Password** _(Write)_: Indicates the password you want to use for this account.
* **[Boolean] PasswordChangeNotAllowed** _(Write)_: Indicates if the user can change the password. Set this property to true to ensure that the user cannot change the password, and set it to false to allow the user to change the password. The default value is false.
* **[Boolean] PasswordChangeRequired** _(Write)_: Indicates if the user must change the password at the next sign in. Set this property to true if the user must change their password. The default value is true.
* **[Boolean] PasswordNeverExpires** _(Write)_: Indicates if the password will expire. To ensure that the password for this account will never expire, set this property to true. The default value is false.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Create a new User](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_User_CreateUser.ps1)

### WindowsFeature

Provides a mechanism to install or uninstall Windows roles or features on a target node.
This resource **is not supported** on Nano Server.

#### Requirements

* Target machine must be running Windows Server 2008 or later.
* Target machine must have access to the DISM PowerShell module.
* Target machine must have access to the ServerManager module (provided by default on Windows Server).

#### Parameters

* **[String] Name** _(Key)_: Indicates the name of the role or feature that you want to ensure is added or removed. This is the same as the Name property from the Get-WindowsFeature cmdlet, and not the display name of the role or feature.
* **[PSCredential] Credential** _(Write)_: Indicates the credential to use to add or remove the role or feature if needed.
* **[String] Ensure** _(Write)_: Specifies whether the feature should be installed (Present) or uninstalled (Absent) { *Present* | Absent }.
* **[Boolean] IncludeAllSubFeature** _(Write)_: Specifies whether or not all subfeatures should be installed with the specified role or feature. The default value is false.
* **[String] LogPath** _(Write)_: Indicates the path to a log file to log the operation.

#### Read-Only Properties from Get-TargetResource

* **[String] DisplayName** _(Read)_: The display name of the retrieved role or feature.

#### Examples

* [Install or uninstall a Windows feature](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_WindowsFeature.ps1)

### WindowsFeatureSet

Provides a mechanism to configure and manage multiple WindowsFeature resources on a target node.

#### Requirements

* Target machine must be running Windows Server 2008 or later.
* Target machine must have access to the DISM PowerShell module.
* Target machine must have access to the ServerManager module.

#### Parameters

* **[String] Name** _(Key)_: The names of the roles or features to install or uninstall. This may be different from the display name of the feature/role. To retrieve the names of features/roles on a machine use the Get-WindowsFeature cmdlet.
* **[String] Ensure** _(Write)_: Specifies whether the feature should be installed or uninstalled. To install features, set this property to Present. To uninstall features, set this property to Absent. { Present | Absent }.
* **[Boolean] IncludeAllSubFeature** _(Write)_: Specifies whether or not all subfeatures should be installed or uninstalled alongside the specified roles or features. If this property is true and Ensure is set to Present, all subfeatures will be installed. If this property is false and Ensure is set to Present, subfeatures will not be installed or uninstalled. If Ensure is set to Absent, all subfeatures will be uninstalled.
* **[PSCredential] Credential** _(Write)_: The credential of the user account under which to install or uninstall the roles or features.
* **[String] LogPath** _(Write)_: The custom file path to which to log this operation. If not passed in, the default log path will be used (%windir%\logs\ServerManager.log).

#### Read-Only Properties from Get-TargetResource

* **[String] DisplayName** _(Read)_: The display names of the retrieved roles or features.

#### Examples

* [Install multiple Windows features](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_WindowsFeatureSet_Install.ps1)
* [Uninstall multiple Windows features](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_WindowsFeatureSet_Uninstall.ps1)

### WindowsOptionalFeature

Provides a mechanism to enable or disable optional features on a target node.
This resource works on Nano Server.

#### Requirements

* Target machine must be running a Windows client operating system, Windows Server 2012 or later, or Nano Server.
* Target machine must have access to the DISM PowerShell module

#### Parameters

* **[String] Name** _(Key)_: The name of the Windows optional feature to enable or disable.
* **[String] Ensure** _(Write)_: Specifies whether the feature should be enabled or disabled. To enable the feature, set this property to Present. To disable the feature, set the property to Absent. The default value is Present. { *Present* | Absent }.
* **[Boolean] RemoveFilesOnDisable** _(Write)_: Specifies that all files associated with the feature should be removed if the feature is being disabled.
* **[Boolean] NoWindowsUpdateCheck** _(Write)_: Specifies whether or not DISM contacts Windows Update (WU) when searching for the source files to enable the feature. If $true, DISM will not contact WU.
* **[String] LogPath** _(Write)_: The path to the log file to log this operation. There is no default value, but if not set, the log will appear at %WINDIR%\Logs\Dism\dism.log.
* **[String] LogLevel** _(Write)_: The maximum output level to show in the log. ErrorsOnly will log only errors. ErrorsAndWarning will log only errors and warnings. ErrorsAndWarningAndInformation will log errors, warnings, and debug information). The default value is "ErrorsAndWarningAndInformation".  { ErrorsOnly | ErrorsAndWarning | *ErrorsAndWarningAndInformation* }.

#### Read-Only Properties from Get-TargetResource

* **[String[]] CustomProperties** _(Read)_: The custom properties retrieved from the Windows optional feature as an array of strings.
* **[String] Description** _(Read)_: The description retrieved from the Windows optional feature.
* **[String] DisplayName** _(Read)_: The display name retrieved from the Windows optional feature.

#### Examples

* [Enable the specified Windows optional feature and output logs to the specified path](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_WindowsOptionalFeature.ps1)

### WindowsOptionalFeatureSet

Provides a mechanism to configure and manage multiple WindowsOptionalFeature resources on a target node.
This resource works on Nano Server.

#### Requirements

* Target machine must be running a Windows client operating system, Windows Server 2012 or later, or Nano Server.
* Target machine must have access to the DISM PowerShell module.

#### Parameters

* **[String[]] Name** _(Key)_: The names of the Windows optional features to enable or disable.

The following parameters will be the same for each Windows optional feature in the set:

* **[String] Ensure** _(Write)_: Specifies whether the Windows optional features should be enabled or disabled. To enable the features, set this property to Present. To disable the features, set this property to Absent. { Present | Absent }.
* **[Boolean] RemoveFilesOnDisable** _(Write)_: Specifies whether or not to remove the files associated with the Windows optional features when they are disabled.
* **[Boolean] NoWindowsUpdateCheck** _(Write)_: Specifies whether or not DISM should contact Windows Update (WU) when searching for the source files to restore Windows optional features on an online image.
* **[String] LogPath** _(Write)_: The file path to which to log the operation.
* **[String] LogLevel** _(Write)_: The level of detail to include in the log. { ErrorsOnly | ErrorsAndWarning | ErrorsAndWarningAndInformation }.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Enable multiple features](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_WindowsOptionalFeatureSet_Enable.ps1)
* [Disable multiple features](https://github.com/PowerShell/PSDscResources/blob/master/Examples/Sample_WindowsOptionalFeatureSet_Disable.ps1)

### WindowsPackageCab

Provides a mechanism to install or uninstall a package from a Windows cabinet (cab) file on a target node.
This resource works on Nano Server.

#### Requirements

* Target machine must have access to the DISM PowerShell module

#### Parameters

* **[String] Name** _(Key)_: The name of the package to install or uninstall.
* **[String] Ensure** _(Required)_: Specifies whether the package should be installed or uninstalled. To install the package, set this property to Present. To uninstall the package, set the property to Absent. { *Present* | Absent }.
* **[String] SourcePath** _(Required)_: The path to the cab file to install or uninstall the package from.
* **[String] LogPath** _(Write)_: The path to a file to log the operation to. There is no default value, but if not set, the log will appear at %WINDIR%\Logs\Dism\dism.log.

#### Read-Only Properties from Get-TargetResource

None

#### Examples

* [Install a cab file with the given name from the given path](https://github.com/PowerShell/PSDesResources/blob/master/Examples/Sample_WindowsPackageCab.ps1)

### WindowsProcess

Provides a mechanism to start and stop a Windows process.

#### Requirements

None

#### Parameters

* **[String] Path** _(Key)_: The executable file of the process. This can be defined as either the full path to the file or as the name of the file if it is accessible through the environment path. Relative paths are not supported.
* **[String] Arguments** _(Key)_: A single string containing all the arguments to pass to the process. Pass in an empty string if no arguments are needed.
* **[PSCredential] Credential** _(Write)_: The credential of the user account to run the process under. If this user is from the local system, the StandardOutputPath, StandardInputPath, and WorkingDirectory parameters cannot be provided at the same time.
* **[String] Ensure** _(Write)_: Specifies whether or not the process should be running. To start the process, specify this property as Present. To stop the process, specify this property as Absent. { *Present* | Absent }.
* **[String] StandardOutputPath** _(Write)_: The file path to which to write the standard output from the process. Any existing file at this file path will be overwritten. This property cannot be specified at the same time as Credential when running the process as a local user.
* **[String] StandardErrorPath** _(Write)_: The file path to which to write the standard error output from the process. Any existing file at this file path will be overwritten.
* **[String] StandardInputPath** _(Write)_: The file path from which to receive standard input for the process. This property cannot be specified at the same time as Credential when running the process as a local user.
* **[String] WorkingDirectory** _(Write)_: The file path to the working directory under which to run the file. This property cannot be specified at the same time as Credential when running the process as a local user.

#### Read-Only Properties from Get-TargetResource

* **[UInt64] PagedMemorySize** _(Read)_: The amount of paged memory, in bytes, allocated for the process.
* **[UInt64] NonPagedMemorySize** _(Read)_: The amount of nonpaged memory, in bytes, allocated for the process.
* **[UInt64] VirtualMemorySize** _(Read)_: The amount of virtual memory, in bytes, allocated for the process.
* **[SInt32] HandleCount** _(Read)_: The number of handles opened by the process.
* **[SInt32] ProcessId** _(Read)_: The unique identifier of the process.
* **[SInt32] ProcessCount** _(Read)_: The number of instances of the given process that are currently running.

#### Examples

* [Start a process](https://github.com/PowerShell/PSDesResources/blob/master/Examples/Sample_WindowsProcess_Start.ps1)
* [Stop a process](https://github.com/PowerShell/PSDesResources/blob/master/Examples/Sample_WindowsProcess_Stop.ps1)
* [Start a process under a user](https://github.com/PowerShell/PSDesResources/blob/master/Examples/Sample_WindowsProcess_StartUnderUser.ps1)
* [Stop a process under a user](https://github.com/PowerShell/PSDesResources/blob/master/Examples/Sample_WindowsProcess_StopUnderUser.ps1)

### ProcessSet

Provides a mechanism to configure and manage multiple WindowsProcess resources on a target node.

#### Requirements

None

#### Parameters

* **[String[]] Path** _(Key)_: The file paths to the executables of the processes to start or stop. Only the names of the files may be specified if they are all accessible through the environment path. Relative paths are not supported.

The following parameters will be the same for each process in the set:

* **[PSCredential] Credential** _(Write)_: The credential of the user account to run the processes under. If this user is from the local system, the StandardOutputPath, StandardInputPath, and WorkingDirectory parameters cannot be provided at the same time.
* **[String] Ensure** _(Write)_: Specifies whether or not the processes should be running. To start the processes, specify this property as Present. To stop the processes, specify this property as Absent. { Present | Absent }.
* **[String] StandardOutputPath** _(Write)_: The file path to which to write the standard output from the processes. Any existing file at this file path will be overwritten. This property cannot be specified at the same time as Credential when running the processes as a local user.
* **[String] StandardErrorPath** _(Write)_: The file path to which to write the standard error output from the processes. Any existing file at this file path will be overwritten.
* **[String] StandardInputPath** _(Write)_: The file path from which to receive standard input for the processes. This property cannot be specified at the same time as Credential when running the processes as a local user.
* **[String] WorkingDirectory** _(Write)_: The file path to the working directory under which to run the process. This property cannot be specified at the same time as Credential when running the processes as a local user.

#### Read-Only Properties from Get-TargetResource

* **[UInt64] PagedMemorySize** _(Read)_: The amount of paged memory, in bytes, allocated for the processes.
* **[UInt64] NonPagedMemorySize** _(Read)_: The amount of nonpaged memory, in bytes, allocated for the processes.
* **[UInt64] VirtualMemorySize** _(Read)_: The amount of virtual memory, in bytes, allocated for the processes.
* **[SInt32] HandleCount** _(Read)_: The number of handles opened by the processes.
* **[SInt32] ProcessId** _(Read)_: The unique identifier of the processes.
* **[SInt32] ProcessCount** _(Read)_: The number of instances of the given processes that are currently running.

#### Examples

* [Start multiple processes](https://github.com/PowerShell/PSDesResources/blob/master/Examples/Sample_ProcessSet_Start.ps1)
* [Stop multiple processes](https://github.com/PowerShell/PSDesResources/blob/master/Examples/Sample_ProcessSet_Stop.ps1)
