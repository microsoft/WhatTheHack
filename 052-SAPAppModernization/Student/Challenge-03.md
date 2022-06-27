# Challenge 03 - Geode Pattern: Global Caching and replication of SAP source data

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

Geode Pattern: Global Caching and Replication of SAP Source Data

What happens if you have a service that could quickly overwhelm your SAP system with requests, or you need it to be globally accessible from multiple locations with globally low latency, but your SAP HANA or ECC system is only located in one place?

Let's build on the prior solution and add geographical caching of data my inserting a geo-caching and distribution layer in front of the Odata service.

## Description

- Familiarise yourself with this repository [SAP Geodes and Cosmos](https://github.com/MartinPankraz/AzCosmosDB-OData-Shim) 
- Read this associated blog post [SAP and Toilet Paper](https://blogs.sap.com/2021/06/11/sap-where-can-i-get-toilet-paper-an-implementation-of-the-geodes-pattern-with-s4-btp-and-azure-cosmosdb/)
- Deploy a CosmosDB SQL API instance with 2 regions present
- Deploy another API Management Developer tier instance for the other region 
- Deploy an Azure Front Door frontend, with backends pointing to the 2 APIM instances
    - Hint: Deployment Details are here [Cosmos OData Deployment](https://github.com/MartinPankraz/AzCosmosDB-OData-Shim#deployment-guide)

## Success Criteria

- Be able to successfully set up a two node geode shim caching data through CosmosDB over OData and benchmark to the theoretical global improvements in OData performance.

## Learning Resources

- [SAP Geodes and Cosmos](https://github.com/MartinPankraz/AzCosmosDB-OData-Shim) 
- [SAP and Toilet Paper](https://blogs.sap.com/2021/06/11/sap-where-can-i-get-toilet-paper-an-implementation-of-the-geodes-pattern-with-s4-btp-and-azure-cosmosdb/)
