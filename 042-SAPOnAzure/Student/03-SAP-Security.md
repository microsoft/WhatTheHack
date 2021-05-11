# Challenge 3: Secure SAP on Azure

[< Previous Challenge](./02-Azure-Monitor.md) - **[Home](../README.md)** - [Next Challenge >](./04-BusinessContinuity-and-DR.md)

## Introduction

Contoso Inc. has deployed the SAP systems, activated Azure monitoring for SAP; now the team is looking to setup security checks and threat monitoring for the SAP application and its respective infrastucture components.

## Description

In this challenge we will be enrolling the Azure subscirption for Security Center and Azure defender, and also configure Setinel workspace for active SAP application security monitoring. This will give us an opportunity to learn how to use the Security Center Dashboard, check for security KPI of Azure resources and also enable continous SAP application-tier threat monitoring.

#### This challenge has two parts
1) Security center and Azure defender (intro and basics).

2) Azure Sentinel (requires Sentinel workspace and SAP knowledge) Detailed documentation provided seperately.

## Tips
- If the SAP system was deployed using provided terraform script as part of ([challenge 1](./01-SAP-Auto-Deployment.md)), note below mentioned points before proceeding to part 2 of this challenge.
  - The SAP system that you installed already have all required transports imported. 
  - SAP system already have all required Function modules, user and role provisioned. 
  - Change password for user Sentinel and use it wherever required. Custom role and user 'Sentinel' are available in client 100. So use client 100 wherever required. 
  - You can skip steps 2,3, and 4 from quick installation guide given to you by coach. 
  - You can also skip step 6 if you use linux jumpbox to install SAP connector for sentinel.

## Success Criteria

- Enabled Security Ceneter, Azure defender for the Azure subscription.
- Check security vulnerabilites, network map, download compliance reports.
- **For your OpenHack Resource Group Only** Improve security KPI by at least 5 pts.
- Setup Azure Sentinel workspace for SAP, configure SAP system for Sentinel integrations.



## Learning Resources

- [Azure Security Center overview](https://docs.microsoft.com/en-us/azure/security-center/security-center-introduction)

- [Azure Defender overview](https://docs.microsoft.com/en-us/azure/security-center/azure-defender)

- [Review your security recommendations](https://docs.microsoft.com/en-us/azure/security-center/security-center-recommendations)

- [Detect threats out-of-the-box](https://docs.microsoft.com/en-us/azure/sentinel/tutorial-detect-threats-built-in)

- [Azure Sentinel overview](https://docs.microsoft.com/en-us/azure/sentinel/overview)
