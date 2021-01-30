
# Challenge 8 - Azure Private Link Service

[< Previous Challenge](./Challenge-7.md) - [Home](../README.md)

<br />

## Introduction
In this challenge, you will learn how to expose a service to end customers privately. 

<br />

## Description

Contoso Payment Solutions provides SaaS service to it customers. One of the challenges is with IP addressing conflict with these customers IP ranges. For customers hosted in Azure, Contoso is looking for a way to avoid such conflicts and simplify access to it services.

<br />

For this challenge:

- Create another virtual network to simulate Contoso's client environment. Add a test virtual machine. The client network is using the same IP address range as Contoso.

- Create a private connectivity to the Payments Solution service.

- No public access to the service should be allowed from the client's server.

<br />

## Success Criteria

- The client should be able to successfully access the Payments application.

- The client should be able to resolve Contoso's service to a private IP address.

<br />

## Learning Resources

[Azure Private Link](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview)

