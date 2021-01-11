
# What The Hack Networking - Challenge 2



# Challenge \#2 - Network Security Groups


[< Previous Challenge](./Challenge-2.md) - [Home](../readme.md) - [Next Challenge >](./Challenge-2.md)

## Pre-requisites

*Before you start this challenge, ensure you have completed Challenge 1.*



## Introduction

*In this challenge you will secure Azure workloads using Network Security Groups.*



## Description

*Now that we have the subnet architecture in place, you need to secure communication to the virtual machines. Contoso has identified the flows that their application needs and would like to restrict flow accordingly.*


*Payment Solutions department application requirements:*

**The web application is accessible from the internet on http/ https ports.**

**Communication between the web tier to app tier is restricted to ports 80 and 8081.**

**The network and application teams will need access to manage the virtual machines.**


*Finance department application requirements:*

**- The finance department has internal applications that should need to be accessed directly from the internet.**


*For this challenge:*

**- Secure the workloads that will be deployed in Azure.**

**- Open inbound communication only to the required ports.**

**- All inbound communication unless explicitly permitted should be denied.**



## Success Criteria

*At the end of this challenge, you should be able to verify the following:*

**- Verify management access to each of the virtual machines.**

**- You should be able to access the web server successfully.**

**- Payment solution Web servers should be able to access the app server from the web server on port 80.**



## Learning Resources

**- [Network security groups](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)**

**- [Application security groups](https://docs.microsoft.com/en-us/azure/virtual-network/application-security-groups)**
