# Challenge 2 - Helm

[< Previous Challenge](./01-setup.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](./03-gitops.md)

## Introduction

Helm is the package manager for Kubernetes.  It was created by Deis (now a part of Microsoft) and is a Graduated Project in the CNCF.

## Description

1. Create a new chart
1. Deploy the chart on your K8S cluster
1. Override default nginx images with https://hub.docker.com/r/stefanprodan/podinfo
1. Install Kubernetes Ingress using Helm
1. Update the chart and enable Ingress
1. Verify App is available at simple-app.$INGRESS_IP.nip.io

## Success Criteria

* `helm ls --all-namespaces` shows your chart and the Ingress controller
* `curl myapp.$INGRESS_IP.nip.io` returns a valid reponse

## Hints

* `INGRESS_IP=$(kubectl get service -n ingress-nginx nginx-ingress-controller -o json | jq '.status.loadBalancer.ingress[0].ip' -r)`
* HINT:  You will need to replace the appVersion in the Chart.yaml to match the tag version from Dockerhub
