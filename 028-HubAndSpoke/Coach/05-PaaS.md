# Challenge 5: PaaS Networking

[< Previous Challenge](./04-AppGW.md) - **[Home](README.md)**

## Introduction

In this challenging you will have a deep look at ways of integrating Azure PaaS services with your Virtual Network.

## Description

* Let participants choose between Linux/Windows web apps, and between Azure SQL Database or mysql/postgres, but make sure they understand the consequences (potentially different features supported)
* One database should use private link, the other service endpoints. Make sure the participants inspect the effective route tables and understand the differences
* If participants get stuck you can share this link: [https://docs.microsoft.com/azure/app-service/web-sites-integrate-with-vnet#azure-dns-private-zones](https://docs.microsoft.com/azure/app-service/web-sites-integrate-with-vnet#azure-dns-private-zones)
* When using private link, make sure that participants understand the DNS resolution process. Make a team member explain it, let them investigate, and as last resource explain it yourself

## Optional objectives

* Force private link traffic to traverse the Azure Firewall (SNAT will be required in some circumstances)