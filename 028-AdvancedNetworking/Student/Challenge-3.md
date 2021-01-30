
# Challenge 3 - Load Balancing

[< Previous Challenge](./Challenge-2.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-4.md)

<br />

## Introduction

In this challenge, you will learn how to deploy resilient, auto-scaling applications.

<br />

## Description

With the virtual network design in place, Contoso is now ready to deploy their applications. The applications are business critical, downtime can have a significant impact on business. Contoso's architecture should incorporate best practices and deploy a highly available architecture. The application also sees varying traffic patterns throughout the year. It is important to cater to the peak traffic patterns, however, Contoso’s goal is also to reduce cost wherever possible.

<br />

For this challenge:

1. You need to ensure the web application servers scale to the incoming traffic.

2. Web servers should be protected from underlying network or hardware failures.

3. Cost is a concern for the customer. Resources should not be deployed when there isn't enough traffic.

<br />

## Success Criteria

- Application should be successfully accessible by external clients.

- Your solution has redundancy built in for resiliency.

- Your web servers and application gateway are able to scale to changing traffic.

<br />

## Learning Resources

[Azure Application gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview)

[Azure Application Gateway Autoscaling](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-autoscaling-zone-redundant)

[Virtual Machine Scale Sets](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview)

[Virtual Machine Scale Sets](https://docs.microsoft.com/en-us/azure/virtual-machines/availability?toc=/azure/virtual-machine-scale-sets/toc.json)
