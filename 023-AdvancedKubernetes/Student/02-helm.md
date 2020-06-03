# Challenge 2 - Helm

[< Previous Challenge](./01-setup.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](./03-gitops.md)

## Introduction

Helm is the package manager for Kubernetes.  It was created by Deis (now a part of Microsoft) and is a Graduated Project in the CNCF.

## Key Concepts

- Chart:  A collection of files that describe Kubernetes resources.
- Config: Configuration information that can be merged into a packaged chart
- Release:  A running instance of a chart with a specific config

## Description

In this challenge, you will create a new chart, deploy it and then also deploy an existing chart from a remote repository.  These charts will setup an Ingress Controller as well as a sample app.

1. Create a new chart
1. Deploy the chart on your K8S cluster
1. Override default nginx image with https://hub.docker.com/r/stefanprodan/podinfo
   - HINT:  You will need to replace the appVersion in the Chart.yaml to match the tag version from Dockerhub
1. Install Kubernetes Ingress using Helm
   - HINT: [Make sure to add an initial repo](https://helm.sh/docs/intro/quickstart/#initialize-a-helm-chart-repository)
1. Update the chart and enable Ingress
1. Verify App is available at simple-app.$INGRESS_IP.nip.io
   - HINT: `INGRESS_IP=$(kubectl get service -n ingress-nginx nginx-ingress-controller -o json | jq '.status.loadBalancer.ingress[0].ip' -r)`

## Success Criteria

* `helm ls --all-namespaces` shows your chart and the Ingress controller
* `curl myapp.$INGRESS_IP.nip.io` returns a valid reponse