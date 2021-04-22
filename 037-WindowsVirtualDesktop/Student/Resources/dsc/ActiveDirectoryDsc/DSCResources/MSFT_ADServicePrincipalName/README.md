# Description

The ADServicePrincipalName DSC resource will manage service principal names. A service principal name (SPN) is a unique identifier of a service instance. SPNs are used by Kerberos authentication to associate a service instance with a service logon account. This allows a client application to request that the service authenticate an account even if the client does not have the account name.

## Requirements

* Target machine must be running Windows Server 2008 R2 or later.
