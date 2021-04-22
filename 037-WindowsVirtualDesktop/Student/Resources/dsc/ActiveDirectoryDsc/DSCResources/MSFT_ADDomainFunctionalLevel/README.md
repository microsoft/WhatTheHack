# Description

This resource change the domain functional level. Functional levels can
be read more about in the article [Forest and Domain Functional Levels](https://docs.microsoft.com/sv-se/windows-server/identity/ad-ds/active-directory-functional-levels).

**WARNING: This action might be irreversibel!** Make sure to understand
the consequences by changing a functional level.

Read more about raising function levels and potential rolling back
scenarios in the Active Directory documentation, for example in the
article [Upgrade Domain Controllers to Windows Server 2016](https://docs.microsoft.com/sv-se/windows-server/identity/ad-ds/deploy/upgrade-domain-controllers).

## Requirements

* Target machine must be running Windows Server 2008 R2 or later.
* Target machine must be running the minimum required operating system
  version for the domain functional level to set.
