# Description

The ADOrganizational Unit DSC resource will manage Organizational Units (OUs) within Active Directory. An OU is a subdivision within an Active Directory into which you can place users, groups, computers, and other organizational units.

## Requirements

* Target machine must be running Windows Server 2008 R2 or later.
* The parameter `RestoreFromRecycleBin` requires that the feature Recycle
  Bin has been enabled prior to an object is deleted. If the feature
  Recycle Bin is disabled then the property `msDS-LastKnownRDN` is not
  added the deleted object.
