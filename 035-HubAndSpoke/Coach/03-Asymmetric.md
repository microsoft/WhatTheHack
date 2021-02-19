# Challenge 3: Troubleshooting Routing

[< Previous Challenge](./02-AzFW.md) - **[Home](README.md)** - [Next Challenge >](./04-AppGW.md)

## Notes and Guidance

* Participants will introduce asymmetric routing when configuring the suggested route table in the spoke with a route for the whole hub vnet pointing at the AzFW VIP (SNATted traffic from the Internet would break), since the UDR in the spoke would send this SNATted traffic to the AzFW ALB, potentially hitting a different AzFW instance
* Discuss implications of poor IP address planning: if the IP address space is well-planned, summary routes can make configuration much easier
