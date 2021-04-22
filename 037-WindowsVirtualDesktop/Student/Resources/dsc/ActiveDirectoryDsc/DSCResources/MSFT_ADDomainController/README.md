# Description

The ADDomainController DSC resource will install and configure domain
controllers in Active Directory. Installation of Read-Only Domain Controllers
(RODC) is also supported.

Promotion of a Domain Controller using an existing DNS is available using
the `InstallDns` parameter. The parameter specifies if the DNS Server service
should be installed and configured on the domain controller. If this is
not set the default value of the parameter `InstallDns` of the cmdlet
[`Install-ADDSDomainController`](https://docs.microsoft.com/en-us/powershell/module/addsdeployment/install-addsdomaincontroller)
is used. The parameter `InstallDns` is only used during the provisioning
of a domain controller. The parameter cannot be used to install or uninstall
the DNS server on an already provisioned domain controller.

>**Note:** If the account used for the parameter `Credential`
>cannot connect to another domain controller, for example using a credential
>without the domain name, then the cmdlet `Install-ADDSDomainController` will
>seemingly halt (without reporting an error) when trying to replicate
>information from another domain controller.
>Make sure to use a correct domain account with the correct permission as
>the account for the parameter `Credential`.

The parameter `FlexibleSingleMasterOperationRole` is ignored until
the node has been provisioned as a domain controller. Take extra care
to make sure the Flexible Single Master Operation (FSMO) roles are moved
accordingly to avoid that two domain controller try to get to be the
owner of the same role (potential "ping-pong"-behavior).

>The resource does not support seizing of Flexible Single Master Operation
>(FSMO) roles

## Requirements

* Target machine must be running Windows Server 2008 R2 or later.
