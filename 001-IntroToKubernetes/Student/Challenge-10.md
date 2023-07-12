# Challenge 10 - Networking and Ingress

[< Previous Challenge](./Challenge-09.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-11.md)

## Introduction

We started out with some very simple, default networking that Kubernetes gives us for free. But this is rarely what we'll need to go into production. Now we'll get a little more in depth on networking in Kubernetes, and investigate DNS as well as Ingress Controllers.

## Description

In this challenge you will be enabling DNS, installing an Ingress Controller and learning how the "Ingress" resource in Kubernetes works. 

## Part 1:  DNS for Public IPs
In the previous challenges, we accessed our service via an IP address.  Humans prefer names to IP addresses, so let's create a DNS name for accessing our service.

1. Your first task is to add a dns label to your __content-web__ service. 
2. Your service should now be available at the url `http://[myserviceuniquelabel].[location].cloudapp.azure.com`.
   *For deployment to Azure Government, the url will be similar to `http://[myserviceuniquelabel].[location].cloudapp.usgovcloudapi.net`*
3. Verify that the DNS record has been created (nslookup or dig), and then test this url in your browser.
4. Discuss with your coach how you might link a 'real' DNS name (eg, `conferenceinfo.fabmedical.com`) with this "azure-specific" DNS name (eg, `conferenceinfo.eastus.cloudapp.azure.com`)

## Part 2a: Ingress Controller
Switching gears, we will now start working with ingress controllers, which allow you to route http requests.

1. Delete the existing content-web service.
2. Create an nginx ingress controller. (Hint: use helm)
3. Deploy the content-web service and create an Ingress resource for it. 
   - The reference template (which will need editing!) can be found in the `Challenge-10` folder of the `Resources.zip` package: `template-web-ingress-deploy.yaml`
4. Show your coach that you can access the ingress in your browser via IP address

## Part 2b: Ingress Controller + DNS for Public IPs
Just like in part 1, you will now add a metadata annotation to the ingress controller to configure a dns name.

1. Your first challenge is to determine how to add a dns label to the ingress controller that you deployed using helm.  Note the following:
   - You already have an ingress controller (from step 2a) so you don't need to create a new one or do a fresh install.
   - Ignore any notes about creating and using a static IP.  For this challenge, a dynamic IP is fine.
   - Don't forget to add the host name to your ingress YAML template.
2. Verify that the DNS record has been created (nslookup or dig), and then access the application using the DNS name, e.g: 
    - `http://[new-dns-label].[REGION].cloudapp.azure.com`
      *For deployment to Azure Government, the url will be similar to `http://[new-dns-label].[REGION].cloudapp.usgovcloudapi.net`*

## Success Criteria

1. Verify the nginx Ingress Controller is installed in your cluster
2. You've recreated a new Ingress for content-web that allows access through a domain name.

## Learning Resources

_Make sure you review these! (Hint Hint)_
* [Apply a DNS label to a service](https://docs.microsoft.com/en-us/azure/aks/static-ip#apply-a-dns-label-to-the-service)
* [Create a basic ingress controller](https://docs.microsoft.com/en-us/azure/aks/ingress-basic)
* [Ingress controller DNS labels](https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip)
