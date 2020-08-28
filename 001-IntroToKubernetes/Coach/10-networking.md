# Challenge 10: Coach's Guide

[< Previous Challenge](./09-helm.md) - **[Home](README.md)** - [Next Challenge >](./11-opsmonitoring.md)

## Notes & Guidance

- Make sure that students have a clear picture of what services are and the different types (ClusterIP, LoadBalancer, etc) and how they map to different types of networking.
- The Ingress Controller has many capabilities, students are going to experiment only with its DNS routing capability in this challenge
- Make sure that each student's AKS cluster has the nginx Ingress Controller installed. They should eventually find this page that is a step by step walkthrough on installing the nginx Ingress Controller on an AKS cluster:
	- <https://docs.microsoft.com/en-us/azure/aks/ingress-basic>
- Refer to the AKS documentation for the verification of logs
- Validate DNS entries in the portal by navigating to the "special" `MC_xxx` resource group created for each AKS cluster and find the **DNS Zone** object in there.

