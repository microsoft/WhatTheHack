# Challenge 4 - Resiliency

[< Previous Challenge](./03-gitops.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](./05-service-mesh.md)

## Introduction

Resiliency is the ability to recover quickly from issues.  For Cloud Native applications, we want to rely upon automation when possible.  We will add Readiness and Liveness Probes to our existing containers and validate them

## Description

For this challenge, we will continue to use https://github.com/stefanprodan/podinfo sicne it has a number of Web API's for interacting with the container.  

- Ensure you have multiple replicas of podinfo running
- Update the Liveness Probe for your Helm chart to use `/healthz`
- Update the Readiness Probe for your Helm chart to use `/readyz`
- Disable the Readiness Probe for a specifc instance
    - HINT: `/readyz/disable`

## Success Criteria

- Before disabling the readiness probe, when you refresh the podinfo page, the hostname should rotate through each of the running pods.
- After disabling a readiness probe, one of the hostnames should no longer be in the rotation
