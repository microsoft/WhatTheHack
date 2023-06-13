# Challenge 05 - AKS Security

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

This challenge will cover the implementation of different security technologies in AKS.

## Description

You need to fulfill these requirements to complete this challenge:

- Make sure that the ingress controller is the only pod that can communicate to the Web pods
- Make sure that the API pods can only be accessed by the web pods or the ingress controller pods
- Make sure that no LoadBalancer services with a public IP address can be created in the Kubernetes cluster
- Add a second node pool to the cluster, and differentiate between user and system node pools
- Make sure that access to the application over the ingress controller is encrypted with SSL, if you hadn't configured it already
- Kubernetes administrators must authenticate to the cluster using their AAD credentials

## Success Criteria

- Participants can demonstrate that the network security controls are in place
- Application workloads are physically separated (in different nodes) from control plane workloads
- Access to the application via the ingress controller is carried out over SSL
- AAD authentication is required before being able to run any kubectl operation on the cluster

## Advanced Challenges (Optional)

- Make sure that the flag `--admin` is never required when using the command `az aks get-credentials`

## Learning Resources

These docs might help you achieving these objectives:

- [Policy in AKS](https://docs.microsoft.com/azure/governance/policy/concepts/policy-for-kubernetes)
- [Open Policy Agent](https://www.openpolicyagent.org/)
- [Kubernetes Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [AKS Overview](https://docs.microsoft.com/azure/aks/)