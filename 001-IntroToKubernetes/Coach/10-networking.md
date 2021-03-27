# Challenge 10: Coach's Guide

[< Previous Challenge](./09-helm.md) - **[Home](README.md)** - [Next Challenge >](./11-opsmonitoring.md)

## Notes & Guidance

- Make sure that students have a clear picture of what services are and the different types (ClusterIP, LoadBalancer, etc) and how they map to different types of networking.
- The Ingress Controller has many capabilities, students are going to experiment only with its DNS routing capability in this challenge
- Make sure that each student's AKS cluster has the nginx Ingress Controller installed. They should eventually find this page that is a step by step walkthrough on installing the nginx Ingress Controller on an AKS cluster:
	- <https://docs.microsoft.com/en-us/azure/aks/ingress-basic>
- Regarding the question _"Discuss with your coach how you might link a 'real' DNS name (eg, conferenceinfo.fabmedical.com) with this "azure-specific" DNS name (eg, conferenceinfo.eastus.cloudapp.azure.com)"_, the answer is, use a CNAME.
  - eg, in your DNS system of record, you would set conferenceinfo.fabmedical.com as a CNAME pointing to conferenceinfo.eastus.cloudapp.azure.com
- Optionally, if the coach has access to a valid (personal) domain, they could demonstrate setting up the CNAME for the students.
