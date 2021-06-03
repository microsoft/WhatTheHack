# Challenge 5: High Availability & Disaster Recovery - Coach's Guide

[< Previous Challenge](./Solution04.md) - **[Home](README.md)** - [Next Challenge>](./Solution06.md)

## Notes & Guidance

### DNS zone

A unique ID that is automatically generated when a new SQL Managed Instance is created. A multi-domain (SAN) certificate for this instance is provisioned to authenticate the client connections to any instance in the same DNS zone. The two managed instances in the same failover group must share the DNS zone.

A DNS zone ID is not required for failover groups created for SQL Database.

* Failover group read-write listener.

A DNS CNAME record that points to the current primary's URL. It is created automatically when the failover group is created and allows the read-write workload to transparently reconnect to the primary database when the primary changes after failover. When the failover group is created on a server, the DNS CNAME record for the listener URL is formed as <fog-name>.database.windows.net. When the failover group is created on a SQL Managed Instance, the DNS CNAME record for the listener URL is formed as <fog-name>.<zone_id>.database.windows.net.

* Failover group read-only listener

A DNS CNAME record formed that points to the read-only listener that points to the secondary's URL. It is created automatically when the failover group is created and allows the read-only SQL workload to transparently connect to the secondary using the specified load-balancing rules. When the failover group is created on a server, the DNS CNAME record for the listener URL is formed as <fog-name>.secondary.database.windows.net. When the failover group is created on a SQL Managed Instance, the DNS CNAME record for the listener URL is formed as <fog-name>.secondary.<zone_id>.database.windows.net.
  
### Multiple failover groups

You can configure multiple failover groups for the same pair of servers to control the scope of failovers. Each group fails over independently. If your multi-tenant application uses elastic pools, you can use this capability to mix primary and secondary databases in each pool. This way you can reduce the impact of an outage to only half of the tenants.

SQL Managed Instance does not support multiple failover groups.

Enabling replication traffic between two instances
Because each instance is isolated in its own VNet, two-directional traffic between these VNets must be allowed. See [Azure VPN gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways).
 
* [Add SQL Managed Instance to a failover group](https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/failover-group-add-instance-tutorial?tabs=azure-portal)
  
* [Enabling geo-replication between managed instances and their VNet](https://docs.microsoft.com/en-us/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell#enabling-geo-replication-between-managed-instances-and-their-vnets)

When you set up a failover group between primary and secondary SQL Managed Instances in two different regions, each instance is isolated using an independent virtual network. To allow replication traffic between these VNets ensure these prerequisites are met:

* The two instances of SQL Managed Instance need to be in different Azure regions.

* The two instances of SQL Managed Instance need to be the same service tier and have the same storage size.

* Your secondary instance of SQL Managed Instance must be empty (no user databases).

* The virtual networks used by the instances of SQL Managed Instance need to be connected through a VPN Gateway or Express Route. When two virtual networks connect through an on-premises network, ensure there is no firewall rule blocking ports 5022, and 11000-11999. Global VNet Peering is supported with the limitation described in the note below.

* On 9/22/2020 we announced global virtual network peering for newly created virtual clusters. That means that global virtual network peering is supported for SQL Managed Instances created in empty subnets after the announcement date, as well for all the subsequent managed instances created in those subnets. For all the other SQL Managed Instances peering support is limited to the networks in the same region due to the constraints of global virtual network peering. See also the relevant section of the Azure Virtual Networks frequently asked questions article for more details.

* The two SQL Managed Instance VNets cannot have overlapping IP addresses.

* You need to set up your Network Security Groups (NSG) such that ports 5022 and the range 11000~12000 are open inbound and outbound for connections from the subnet of the other managed instance. This is to allow replication traffic between the instances.

* Misconfigured NSG security rules lead to stuck database copy operations.

* The secondary SQL Managed Instance is configured with the correct DNS zone ID. DNS zone is a property of a SQL Managed Instance and underlying virtual cluster, and its ID is included in the host name address. The zone ID is generated as a random string when the first SQL Managed Instance is created in each VNet and the same ID is assigned to all other instances in the same subnet. Once assigned, the DNS zone cannot be modified. SQL Managed Instances included in the same failover group must share the DNS zone. You accomplish this by passing the primary instance's zone ID as the value of DnsZonePartner parameter when creating the secondary instance.
