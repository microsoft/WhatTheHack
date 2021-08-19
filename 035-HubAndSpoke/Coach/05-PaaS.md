# Challenge 5: PaaS Networking

[< Previous Challenge](./04-AppGW.md) - **[Home](README.md)**

## Notes and Guidance

* Let participants choose between Linux/Windows web apps, and between Azure SQL Database or mysql/postgres, but make sure they understand the consequences (potentially different features supported in the private link implementation)
* One database should use private link, the other service endpoints. Make sure the participants inspect the effective route tables and understand the differences
* If participants get stuck you can share this link: [https://docs.microsoft.com/azure/app-service/web-sites-integrate-with-vnet#azure-dns-private-zones](https://docs.microsoft.com/azure/app-service/web-sites-integrate-with-vnet#azure-dns-private-zones)
* When using private link, make sure that participants understand the DNS resolution process. Make a team member explain it, let them investigate, and as last resource explain it yourself

## Advanced Challenges (Optional)

* SNAT might be required in some circumstances. The overall recommendation is using SNAT "to prevent unexpected behavior"
* If Azure Firewall is used to inspect traffic destined to private endpoints, ensure DNS Proxy is enabled. 
* At the time of this writing the /32 behavior of private endpoints is being changed, watch out for that
