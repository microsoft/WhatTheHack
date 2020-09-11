# Challenge 3 - Resiliency

[< Previous Challenge](./02-helm.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](./04-scaling.md)

## Introduction

Resiliency is the ability to recover quickly from issues.  For Cloud Native applications, we want to rely upon automation when possible.  We will add Readiness and Liveness Probes to our existing containers and validate them

## Description

For this challenge, we will continue to use <https://github.com/stefanprodan/podinfo> since it has a number of Web API's for interacting with the container.  

- Ensure you have multiple replicas of podinfo running
- Update the Liveness Probe for your Helm chart to use `/healthz`
- Update the Readiness Probe for your Helm chart to use `/readyz`
- Force the Readiness Probe to fail for a specific instance
    - HINT: look through some of the APIs in the [repo README](https://github.com/stefanprodan/podinfo)

## Success Criteria

- Before disabling the readiness probe, when you refresh the podinfo page, the hostname should rotate through each of the running pods.
- After disabling the response to the readiness probe, one of the hostnames should no longer be in the rotation
- After disabling the response to the readiness probe, Use `kubectl` to verify that one pod is no longer in the rotation

## Optional challenge

- Get all pods back to a ready state
- After getting all pods in the ready state, use `kubectl` to verify all pods are ready

## Hints

1. [cURL manual](https://curl.haxx.se/docs/manual.html)
1. [Kubernetes probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes)
