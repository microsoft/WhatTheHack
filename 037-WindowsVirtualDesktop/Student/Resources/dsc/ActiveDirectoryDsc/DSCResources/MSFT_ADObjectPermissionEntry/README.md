# Description

The ADObjectPermissionEntry DSC resource will manage access control lists on Active Directory objects. The resource is
designed to to manage just one entry in the list of permissios (ACL) for one AD object. It will only interact with the
one permission and leave all others as they were. The resource can be used multiple times to add multiple entries into
one ACL.

## Requirements

* Target machine must be running Windows Server 2008 R2 or later.
