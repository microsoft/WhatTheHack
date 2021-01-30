
# Challenge 5 - Azure Firewall

[< Previous Challenge](./Challenge-4.md) - [Home](../README.md) - [Next Challenge>](./Challenge-6.md)

<br />

## Introduction

In this challenge, you will build an edge security architecture for Contoso.

<br />

## Description
Contoso's security team needs a centralized solution to restrict flows going into and out of the Azure environment. The environment should be protected from known malicious IP addresses.

For web traffic, web application protection from OWASP top 10 attacks and vulnerabilities is required. However the security team wants to review the logs before blocking any incoming requests. All logs should be captured and centrally stored for the security team to review.


For this challenge:

- Deploy a centralized firewall solution meeting the requirements above.

- The solution should be highly available and protect from any underlying infrastructure hardware failure.

<br />

## Success Criteria

- You should have all flows secured by the firewalls in the Azure environment.

- The virtual machine should be able to reach www.microsoft.com.

- Outbound traffic to site www.youtube.com should be blocked.

- On-premises servers should be able to access the servers deployed in Azure.

- Logs should be are captured and available for review for 30 days.

<br />

## Learning Resources

[Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/overview)

[Azure Web application firewall](https://docs.microsoft.com/en-us/azure/application-gateway/overview)

[User defined routes](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#custom-routes)

[Virtual network routing](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview)

[Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&tabs=azure-portal)
