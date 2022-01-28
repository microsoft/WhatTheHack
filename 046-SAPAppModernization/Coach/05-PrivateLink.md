# Challenge 5: Private Link

[< Previous Challenge](./04-AzureADPrincipalPropagation.md) - **[Home](README.md)** - [Next Challenge >](./06-SAPChatBot.md)

# Notes & Guidance
- Communication direct can be confusing. Clarify [Service Endpoint](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview) vs. [Private Endpoint](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview) vs. [Private Link (Service)](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview?toc=/azure/virtual-network/toc.json). Use this [FAQ](https://docs.microsoft.com/en-us/azure/private-link/private-link-faq) for an official compare.

## Common mistakes Regarding Private Link Service (PLS)
- Deployed Basic LB instead of required Standard LB. Only latter supported.
- Forgot to establish alternative outbound connectivity (NAT GW or public LB) after introduction of PLS. Symptom: Suddenly after setup all connections targeting outside of the VNet fail.

## Common mistakes Regarding Private Endpoint
- Wrong DNS entries, hosts files etc. that resolve routes to Azure PaaS.
