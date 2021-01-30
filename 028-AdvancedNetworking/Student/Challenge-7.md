
# Challenge 7 - Azure Private Link

[< Previous Challenge](./Challenge-6.md) - [Home](../README.md) - [Next Challenge>](./Challenge-8.md)

<br />

## Introduction
In this challenge, you will learn how to enable secure private access to Azure Services. 

<br />

## Description
Contoso uses Azure Storage as part of their architecture. However, public access to the service is not acceptable as part of their compliance requirement. The security team also has data exfiltration concerns that need to be addressed.

For this challenge:

- Restrict public access to the Storage service.

<br />

## Success Criteria

- The servers in the Payments and Finance networks should be able to access the storage service successfully.

- The entire communication from the server to the storage service should be private.

- The DNS resolution for the storage service should resolve to a private IP.

<br />

## Learning Resources

[Azure Private Link](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview)

