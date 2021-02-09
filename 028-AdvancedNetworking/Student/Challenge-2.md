
# Challenge 2 - Network Security Groups


[< Previous Challenge](./Challenge-1.md) - [Home](../README.md) - [Next Challenge >](./Challenge-3.md)

<br />

## Introduction

In this challenge, you will secure Azure workloads using Network Security Groups.


<br />

## Description

Now that we have the subnet architecture in place, you need to secure communication to the virtual machines. Contoso has identified the flows that their application needs and would like to restrict the flow accordingly.

<br />
Payment Solutions department application requirements:

- The web application is accessible from the internet on http/ https ports.

- Communication between the web tier to app tier is restricted to ports 80 and 8081.

- The network and application teams will need access to manage the virtual machines.


Finance department application requirements:

- The finance department has internal applications that should not be accessed directly from the internet.

<br />
For this challenge:

- Secure the workloads that will be deployed in Azure.

- Open inbound communication only to the required ports.

- All inbound communication unless explicitly permitted should be denied.


<br />

## Success Criteria

- You should have management access to each of the virtual machines.

- You should be able to access the web service successfully.

- Payment solution group's web servers should be able to access the app servers on port 80.

<br />

## Learning Resources

- [Network security groups](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)

- [Application security groups](https://docs.microsoft.com/en-us/azure/virtual-network/application-security-groups)
