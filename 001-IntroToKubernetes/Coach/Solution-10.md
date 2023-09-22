# Challenge 10 - Networking and Ingress - Coach's Guide 

[< Previous Solution](./Solution-09.md) - **[Home](./README.md)** - [Next Solution >](./Solution-11.md)

## Notes & Guidance

- Make sure that students have a clear picture of what services are and the different types (ClusterIP, LoadBalancer, etc) and how they map to different types of networking.
  - *For deployment to Azure Government, the url will be similar to `http://[myserviceuniquelabel].[location].cloudapp.usgovcloudapi.net`*
- Part 1, Step 1:  The metadata they need to add is:
```
metadata:
  annotations:
    service.beta.kubernetes.io/azure-dns-label-name: myserviceuniquelabel
```
- Part 2b:
Adding a dns label to the ingress controller via helm can be tricky.  It's documented at this link: https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip
   - The instructions talk about installing a new ingress controller.  You already have one (from step 2a) so you don't need to do a fresh install.
   - Ignore the notes about creating and using a static IP.  For this challenge, a dynamic IP is fine.
   - Specifically, you will need to modify (upgrade) your previously-installed ingress controller deployment as follows:  _Note: This example is formatted for bash.  For powershell, change the line continuation character from \ to `_
```bash
helm upgrade  ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-basic --reuse-values \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="NEW-DNS-LABEL"
```

- Make sure that each student's AKS cluster has the nginx Ingress Controller installed. They should eventually find this page that is a step by step walkthrough on installing the nginx Ingress Controller on an AKS cluster:
	- <https://docs.microsoft.com/en-us/azure/aks/ingress-basic>
- Regarding the question _"Discuss with your coach how you might link a 'real' DNS name (eg, `conferenceinfo.fabmedical.com`) with this "azure-specific" DNS name (eg, `conferenceinfo.eastus.cloudapp.azure.com`)"_, the answer is, use a CNAME.
  - eg, in your DNS system of record, you would set `conferenceinfo.fabmedical.com` as a CNAME pointing to `conferenceinfo.eastus.cloudapp.azure.com`
- Optionally, if the coach has access to a valid (personal) domain, they could demonstrate setting up the CNAME for the students.
