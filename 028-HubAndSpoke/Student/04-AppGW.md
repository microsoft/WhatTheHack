# Challenge 4: Application Gateway

[< Previous Challenge](./03-Asymmetric.md) - **[Home](README.md)** - [Next Challenge >](./05-PaaS.md)

## Introduction

In this challenging you will integrate an Application Gateway in the design.

## Description

Your security department has decided that you need to put a Web Application Firewall in front of your web workloads, and you decide to go for the Azure Application Gateway.

![hubnspoke appgw](media/appgw.png)

## Success Criteria

1. You have enabled SSL in the App Gateway to provide HTTPS connectivity to users accessing your site
1. You can access the web sites in each VM in the hub and in the spokes through the Application Gateway via different URLs
1. Can you still see the client IP in the web servers?

## Related documentation

- [What is Azure Application Gateway](https://docs.microsoft.com/azure/application-gateway/overview)
- [How an Application Gateway works](https://docs.microsoft.com/azure/application-gateway/how-application-gateway-works)
- [nip.io](https://nip.io/)