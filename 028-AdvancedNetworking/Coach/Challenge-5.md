# Challenge 5: Coach's Guide

[< Previous Challenge](./Challenge-4.md) - [Home](./README.md) - [Next Challenge >](./Challenge-6.md)

## Notes and Guidance

- Azure firewall should be deployed in the hub vnet.

- Routes should have next hop as NVA --> IP of Azure firewall.

- The Azure virtual machine should be able to reach www.microsoft.com but not be able to reach youtube.com.

- WAFv2 firewall should be enabled on the Application gateway in Detection mode.

- Logging should be enabled for both Azure Firewall and Web Application firewall.

- Storage account used for logging should show firewall logs and web application logs.
