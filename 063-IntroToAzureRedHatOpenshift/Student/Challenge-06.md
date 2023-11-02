# Challenge 06 - Networking

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction
Have you ever wondered how to restrict traffic between applications? In challenge 6 we will be creating a network policy that does exactly that! It is time to apply some security hardening and restrict communication to our API.

## Description
In this challenge, we will be deploying two network policies that will restrict traffic between pods in our ARO cluster. Network policies can be deployed by using either the ARO Web Console or the OpenShift CLI.

- **NOTE:** Make sure you are in **Administrator** mode when configuring the cluster's network policies!
- Configure a network policy called `deny-all` that denies all traffic by default using a YAML file you create
    - To confirm the network policy is in effect, go the the application's homepage and the website should be broken
- Configure a network policy called `allow-rating-web` that will allow traffic to **rating-web** from all pods using a YAML file you create
    - To confirm the network policy is in effect, go to the application's homepage and the website should be working now. Submit ratings is still broken.
- Configure a network policy called `allow-rating-api` that will allow traffic to **rating-api** from **rating-web** using a YAML file you create 
    - To confirm the network policy is in effect, go the the application's homepage and you should be able to submit and see ratings

## Success Criteria
To complete this challenge successfully, you should be able to:
- Have demonstrated that your `deny-all` network policy blocked all traffic
- Demonstrate that your `allow-rating-web` network policy allows traffic
- Demonstrate that your `allow-rating-api` network policy allows traffic between the backend and frontend application

## Learning Resources
- [About network policy](https://docs.openshift.com/container-platform/4.11/networking/network_policy/about-network-policy.html)
- [Viewing network policies using the CLI](https://docs.openshift.com/container-platform/4.11/networking/network_policy/viewing-network-policy.html#nw-networkpolicy-view-cli_viewing-network-policy)
- [Using the OpenShift CLI](https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html#cli-using-cli_cli-developer-commands)
