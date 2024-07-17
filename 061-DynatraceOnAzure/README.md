# What The Hack - Dynatrace On Azure

## Introduction

This WhatTheHack challenges you to leverage the combined strengths of Dynatrace's all-in-one monitoring platform and the vast capabilities of Microsoft Azure to solve a real-world problem. Dive into application performance monitoring (APM), digital experience monitoring (DEM), infrastructure monitoring, and more, to showcase your skills and unearth hidden insights across your Azure cloud environment.

Here's what you can expect:

* **Full-Stack Monitoring on Azure:** Achieve end-to-end observability for your Azure infrastructure, applications, and services, including Azure VMs, Azure Kubernetes Service (AKS), Azure App Services, and more.
* **AI-Powered Insights:** Leverage Dynatrace’s AI engine, [Davis](https://www.dynatrace.com/platform/artificial-intelligence/), to automatically detect anomalies, pinpoint root causes, and provide predictive analytics specifically tailored for Azure environments.
* **Automated Operations:** Leverage our easy-to-use visual workflow creator or automation-as-code workflow capabilities to automatically act on the data gathered and answers provided by Dynatrace..
* **Real-Time Analytics:** With [Grail](https://www.dynatrace.com/platform/grail/), you can utilize real-time data to make informed decisions and optimize performance on Azure, ensuring seamless user experiences across your cloud-native and hybrid applications.
* **Enhanced Security:** Integrate [security monitoring](https://www.dynatrace.com/platform/security-protection/) to detect vulnerabilities within your Azure workloads and mitigate risks proactively.

This hack was designed specifically for Cloud Ops Engineers, DevOps engineers, Developers, and Architects who want to expand their knowledge on Dynatrace & Azure.  However, anyone with passion around Observability is welcome!


## Learning Objectives

In this hack you will be solving business problems that companies in any industry face by modernizing their legacy systems to cloud native architecture.  

This hack will :

* Master Full-Stack Observability: 
	* Monitor Azure infrastructure and applications using Dynatrace.
	* Visualize end-to-end transactions within Azure.
* Utilize AI-Powered Monitoring: 
	* Use Dynatrace’s AI engine for anomaly detection and root cause analysis in Azure. 
	* Automate problem resolution with AI-driven insights.
* Implement Automated Operations:
	* Apply best practices for seamless automation within Azure environments.
	* Automate workflows and remediation processes for operational efficiency.
* Enhance Security Monitoring:
	* Detect vulnerabilities and threats in Azure workloads.
	* Implement proactive risk mitigation strategies.

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Prepare your environment to work with Azure and Dynatrace.
- Challenge 01: **[OneAgent Observability on Azure VM](Student/Challenge-01.md)**
	 - Review the power on OneAgent.
- Challenge 02: **[Dynatrace Observability on AKS](Student/Challenge-02.md)**
	 - Deploy Dynatrace Operator on AKS cluster with a sample application and review AKS observability with Dynatrace.
- Challenge 03: **[Automated Root Cause Analysis with Davis](Student/Challenge-03.md)**
 	- Enable a problem in your sample application and walk through what Davis found.
- Challenge 04: **[Azure Monitor Metrics & Custom Dashboard](Student/Challenge-04.md)**
	 - In this challenge, you will create a custom dashboard to track Service Level Objects (SLO's)
- Challenge 05: **[Challenge 05 - Grail - Dashboards & Notebooks](Student/Challenge-05.md)**
	* In this challenge, you will query, visualize, and observe all your data stored in Grail via Dashboards and Notebooks.
- Challenge 06: **[Challenge 06 - Grail - SRE Guardian & Workflows](Student/Challenge-06.md)**
	* In this challenge you'll learn the benefits of Site  Reliability Guardian (SRG) and experience the power of Automation in dynatrace by creating workflows to automatically execute an SRG.
- Challenge 07: **[Cleanup](Student/Challenge-07.md)**
	 - In this challenge, you will cleanup any resources you've created during the Hack

## Prerequisites

- Your own Azure subscription with ``Owner`` privileges
- Knowledge of [Azure Cloudshell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Dynatrace Trial environment via Azure Marketplace](https://azuremarketplace.microsoft.com/en-US/marketplace/apps/dynatrace.dynatrace_portal_integration?tab=Overview)


## Contributors

- Jay Gurbani

