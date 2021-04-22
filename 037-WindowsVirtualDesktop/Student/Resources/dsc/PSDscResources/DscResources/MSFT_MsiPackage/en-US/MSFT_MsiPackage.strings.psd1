# Localized resources for MSFT_MsiPackage

ConvertFrom-StringData @'
    CheckingFileHash = Checking file '{0}' for expected {2} hash value of {1}
    CheckingFileSignature = Checking file '{0}' for valid digital signature
    CopyingTheSchemeStreamBytesToTheDiskCache = Copying the stream bytes to the disk cache
    CouldNotGetResponseFromWebRequest = An error occurred while trying to get the {0} response for file {1}
    CouldNotOpenDestFile = Could not open the file {0} for writing
    CouldNotOpenLog = The specified LogPath ({0}) could not be opened
    CouldNotStartProcess = The process {0} could not be started
    CreatingCacheLocation = Creating cache location
    CreatingTheDestinationCacheFile = Creating the destination cache file
    CreatingTheSchemeStream = Creating the {0} stream
    ErrorCopyingDataToFile = Encountered an error while copying the response to the output stream
    FileHasValidSignature = File '{0}' contains a valid digital signature. Signer Thumbprint: {1}, Subject: {2}
    GetTargetResourceFound = Successfully retrieved package {0}
    GetTargetResourceNotFound = Unable to find package: {0}
    GettingTheSchemeResponseStream = Getting the {0} response stream
    InvalidBinaryType = The specified Path ({0}) does not appear to specify an MSI file and as such is not supported
    InvalidFileHash = File '{0}' does not match expected {2} hash value of {1}
    InvalidFileSignature = File '{0}' does not have a valid Authenticode signature.  Status: {1}
    InvalidId = The specified IdentifyingNumber ({0}) does not match the IdentifyingNumber ({1}) in the MSI file
    InvalidIdentifyingNumber = The specified IdentifyingNumber ({0}) is not a valid GUID
    InvalidPath = The specified Path ({0}) is not in a valid format. Valid formats are local paths, UNC, HTTP, and HTTPS
    MachineRequiresReboot = The machine requires a reboot
    PackageAppearsInstalled = The package {0} is installed
    PackageConfigurationStarting = Package configuration starting
    PackageDoesNotAppearInstalled = The package {0} is not installed
    PathDoesNotExist = The given Path ({0}) could not be found
    PackageInstalled = Package has been installed
    PackageUninstalled = Package has been uninstalled
    ParsedProductIdAsIdentifyingNumber = Parsed {0} as {1}
    ParsingProductIdAsAnIdentifyingNumber = Parsing {0} as an identifyingNumber
    PostValidationError = Package from {0} was installed, but the specified ProductId does not match package details
    RedirectingPackagePathToCacheFileLocation = Redirecting package path to cache file location
    SettingAuthenticationLevel = Setting authentication level to None
    SettingCertificateValidationCallback = Assigning user-specified certificate verification callback
    SettingDefaultCredential = Setting default credential
    StartingWithStartInfoFileNameStartInfoArguments = Starting {0} with {1}
    ThePathExtensionWasPathExt = The path extension was {0}
    TheUriSchemeWasUriScheme = The uri scheme was {0}
    WrongSignerSubject = File '{0}' was not signed by expected signer subject '{1}'
    WrongSignerThumbprint = File '{0}' was not signed by expected signer certificate thumbprint '{1}'  
'@
