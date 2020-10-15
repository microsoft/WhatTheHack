# What The Hack - Azure Arc enabled Kubernetes Hack

## Challenge 7 – Manage remote cluster via Azure Policy
[Back](challenge06.md) - [Home](../readme.md)

### Introduction

With Azure Policy enabled within the remote clusters, in this challenge lets build on it and start to fleet manage clusters via Azure Arc. Fleet management is the ability to manage the state of remote clusters. 

There are a number of ways we can accomplish the task of managing consistent state across clusters:
* Use GitOps to deploy resources on remote clusters
* Use Helm to deploy resources on remote clusters
* Use Azure Policy to ensure state of remote clusters is in compliance

 ![](../img/image9.png)

### Challenge

1. Use GitOps functionality that was enabled to deploy the [sample 'Hello Arc' application](https://github.com/likamrat/hello_arc).
2. Use Helm to deploy the [sample 'Hello Arc' application](https://github.com/likamrat/hello_arc).
3. Discuss how Azure Policy can be used to verify the state of the fleet aka the Arc enabled clusters.

### Success Criteria

This challenge will be complete when the [sample 'Hello Arc' application](https://github.com/likamrat/hello_arc) is deployed remotely to Arc enabled clusters using GitOps, Helm and/or Azure Policy.


[Back](challenge06.md) - [Home](../readme.md) - [Next](challenge08.md)
