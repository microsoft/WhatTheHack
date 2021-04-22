# Description

The ADManagedServiceAccount DSC resource will manage Single and Group Managed Service Accounts (MSAs) within Active Directory. A Managed Service Account is a managed domain account that provides automatic password management, simplified service principal name (SPN) management and the ability to delegate management to other administrators.
A Single Managed Service Account can only be used on a single computer, whereas a Group Managed Service Account can be shared across multiple computers.

## Requirements

* Target machine must be running Windows Server 2008 R2 or later.
* Group Managed Service Accounts need at least one Windows Server 2012 Domain Controller.
