# Challenge 06 - Networking

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction
Have you ever wondered how to restrict traffic between applications? In challenge 6 we will be creating a network policy that does exactly that! It is time to apply some security hardening and restrict communication to our API.

[So the above/below needs to be tested about deny all traffic and then allowing certain traffic meaning we have 2 network policies, then I will confirm I want this in writing for challenge 6.]

## Description
In this challenge, we will be deploying two network policies that will restrict traffic between pods in our ARO cluster. Network policies can be deployed by using either the ARO Web Console or the OpenShift CLI.

- **NOTE:** A sample YAML file to get you started can be found in the Student Resources folder
- **NOTE:** Make sure you are in **Administrator** mode when configuring the cluster's network policies!
- Configure a network policy that denies all traffic by default using a YAML file you create called `deny-all.yaml`
    - To confirm the network policy is in effect, go the the application's homepage, The website should be broken.
- Configure a network policy that will allow traffic to **rating-api** from **rating-web** using a yaml file you create called `allow-ratings.yaml`

## Success Criteria
To complete this challenge successfully, you should be able to:
- Show 
- Demonstrate successfully created Network Policy

## Learning Resources
- [About network policy](https://docs.openshift.com/container-platform/4.11/networking/network_policy/about-network-policy.html)
- [Viewing network policies using the CLI](https://docs.openshift.com/container-platform/4.11/networking/network_policy/viewing-network-policy.html#nw-networkpolicy-view-cli_viewing-network-policy)
- [Using the OpenShift CLI](https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html#cli-using-cli_cli-developer-commands)