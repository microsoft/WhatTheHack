# Description

The ADComputer DSC resource will manage computer accounts within Active Directory.
This resource can be used to provision a computer account before the computer is
added to the domain. These pre-created computer objects can be used with offline
domain join, unsecure domain Join and RODC domain join scenarios.

>**Note:** An Offline Domain Join (ODJ) request file will only be created
>when a computer account is first created in the domain. Setting an Offline
>Domain Join (ODJ) Request file path for a configuration that updates a
>computer account that already exists, or restore it from the recycle bin
>will not cause the Offline Domain Join (ODJ) request file to be created.

## Requirements

* Target machine must be running Windows Server 2008 R2 or later.
* The parameter `RestoreFromRecycleBin` requires that the feature Recycle
  Bin has been enabled prior to an object is deleted. If the feature
  Recycle Bin is disabled then the property `msDS-LastKnownRDN` is not
  added the deleted object.
