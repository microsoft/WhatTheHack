# Challenge 3: Introduction To Azure Sentinel for SAP and Azure Security Center

[< Previous Challenge](./02-Azure-Monitor.md) - **[Home](../README.md)** - [Next Challenge >](./04-BCDR-with-ANF.md)

## Introduction

Now it is time to introduce Security and Threat Monitoring for SAP. Since challenge 1 and 2, Mango Inc. has deployed the SAP systems, activated Azure monitoring for SAP. Now the team is looking to setup security and threat monitoring checks for the SAP application and its respective infrastucture components.

## Description

In this challenge we will be enrolling the Azure subscirption for Security Center and Azure defender, and also configure Setinel workspace for active SAP application security monitoring. This will give us an opportunity to learn how to use the Security Center Dashboard, check for security KPI of Azure resources and also enable continous SAP application-tier threat monitoring.

- Install the Kubernetes command line tool (`kubectl`).
	- **Hint:** This can be done easily with the Azure CLI.
- Create a new, multi-node AKS cluster.
	- Use the default Kubernetes version used by AKS.
	- The cluster will use basic networking and kubenet.  
	- The cluster will use a managed identity
	- The cluster will use Availability Zones for improved worker node reliability.
- Use kubectl to prove that the cluster is a multi-node cluster and is working.
- Use kubectl to examine which availability zone each node is in.  
- **Optional:** Bring up the Kubernetes dashboard in your browser
	- **Hint:** Again, the Azure CLI makes this very easy.
	- **NOTE:** This will not work if you are using an Ubuntu Server jump box to connect to your cluster.
	- **NOTE:** Since the cluster is using RBAC by default, you will need to look up how to enable the special permissions needed to access the dashboard.

## Success Criteria

1. Enabled Security Ceneter, Azure defender for the Azure subscription.
2. Check security vulnerabilites, network map, download compliance reports.
3. Improve security KPI by atleast 5 pts.
4. Setup Azure Sentinel workspace for SAP, configure SAP system for Sentinel integrations.

NOTE: - Microsoft Azure Sentinel SAP / NetWeaver Continuous Threat Monitoring Limited Private Preview
	Copyright © Microsoft Corporation. This preview software is Microsoft Confidential, and is subject to your Non-Disclosure Agreement with Microsoft. 
	You may use this preview software internally and only in accordance with the Azure preview terms, located at [private peview-supplemental-terms](https://azure.microsoft.com/en-us/support/legal/preview-supplemental-terms/). Microsoft reserves all other rights



