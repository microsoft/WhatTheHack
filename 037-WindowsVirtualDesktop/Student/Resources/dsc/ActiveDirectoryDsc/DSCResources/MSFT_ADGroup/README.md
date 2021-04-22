# Description

The ADGroup DSC resource will manage groups within Active Directory.

## Requirements

* Target machine must be running Windows Server 2008 R2 or later.
* The parameter `RestoreFromRecycleBin` requires that the feature Recycle
  Bin has been enabled prior to an object is deleted. If the feature
  Recycle Bin is disabled then the property `msDS-LastKnownRDN` is not
  added the deleted object.
