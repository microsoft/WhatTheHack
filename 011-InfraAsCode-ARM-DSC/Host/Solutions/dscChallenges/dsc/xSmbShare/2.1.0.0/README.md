[![Build status](https://ci.appveyor.com/api/projects/status/ttp6jlhjyef83sic/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/xsmbshare/branch/master)

# xSmbShare

The **xSmbShare** module contains the **xSmbShare** DSC resource for setting up and configuring an [SMB share](http://technet.microsoft.com/en-us/library/cc734393%28v=WS.10%29.aspx).

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Contributing
Please check out common DSC Resources [contributing guidelines](https://github.com/PowerShell/DscResource.Kit/blob/master/CONTRIBUTING.md).


## Resources

### xSmbShare

* **Name**: Name of the SMB share.
* **Path**: Path to the share.
* **Description**: Description of the share.
* **ChangeAccess**: Specifies which user will be granted modify permission to access the share.
* **ConcurrentUserLimit**: Specifies the maximum number of concurrently connected users that the new SMB share may accommodate. 
If this parameter is set to 0, then the number of users is unlimited. 
The default value is 0.
* **EncryptData**: Indicates that the share is encrypted.
* **FolderEnumerationMode**: Specifies which files and folders in the new SMB share are visible to users.
* **FullAccess**: Specifies which accounts are granted full permission to access the share.
* **NoAccess**: Specifies which accounts are denied access to the share.
* **ReadAccess**: Specifies which accounts are granted read permission to access the share.
* **Ensure**: Specifies if the share should be added or removed.
* **ShareState**: State of the share.
* **ShareType**: Type of the share.
* **ShadowCopy**: Specifies if this share is a ShadowCopy.
* **Special**: Specifies if this share is a Special Share. 
Admin shares, default shares, IPC$ share are examples.


## Versions

### Unreleased

### 2.1.0.0
* Corrected typo on ShareState and ShareType descriptions (Specfies -> Specifies)

### 2.0.0.0
* Converted appveyor.yml to install Pester from PSGallery instead of from Chocolatey.
* Added default value of "Present" for the Ensure parameter.  (Note:  due to how the module's logic is written, this is a breaking change; DSC configs that did not specify a value for Ensure would have behaved as though it were set to Present in the Test-TargetResource function, but to absent in Set-TargetResource, removing the share instead of creating it.)

### 1.1.0.0
* Fixed bug in xSmbShare resource which was causing Test-TargetResource to return false negatives when more than three parameters were specified.

### 1.0.0.0

* Initial release with the following resources 
    - xSmbShare


## Examples
#### Ensure the an SMB share exists

This configuration ensures that there is a share with the description of "This is a test SMB Share". 

```powershell
Configuration ChangeDescriptionConfig
{
    Import-DscResource -Name MSFT_xSmbShare
    # A Configuration block can have zero or more Node blocks
    Node localhost
    {
        xSmbShare MySMBShare
        {
            Ensure = "Present" 
            Name   = "SMBShare1"
            Path = "C:\Users\Duser1\Desktop"  
            Description = "This is a test SMB Share"          
        }
    }
} 

ChangeDescriptionConfig
```

### Ensure description and permissions for a share

This configuration ensures that the description and permissions for a share are as specified.  

```powershell
Configuration ChangeDescriptionAndPermissionsConfig
{
    Import-DscResource -Name MSFT_xSmbShare
    # A Configuration block can have zero or more Node blocks
    Node localhost
    {
        # Next, specify one or more resource blocks

        xSmbShare MySMBShare
        {
            Ensure = "Present" 
            Name   = "SMBShare1"
            Path = "C:\Users\Duser1\Desktop"  
            ReadAccess = "User1"
            NoAccess = @("User3", "User4")
            Description = "This is an updated description for this share"
        } 
    }
}
ChangeDescriptionAndPermissionsConfig
```

### Remove an SMB share

This example ensures that the SMB share used in the previous examples does not exist.

```powershell
Configuration RemoveSmbShareConfig
{
    Import-DscResource -Name MSFT_xSmbShare
    # A Configuration block can have zero or more Node blocks
    Node localhost
    {
        # Next, specify one or more resource blocks

        xSmbShare MySMBShare
        {
            Ensure = "Absent" 
            Name   = "SMBShare1"
            Path = "C:\Users\Duser1\Desktop"          
        }
    }
} 

RemoveSmbShareConfig
```
