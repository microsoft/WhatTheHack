# Challenge 2 - Helm

[< Previous Challenge](./01-setup.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](./03-resiliency.md)

## Introduction

Helm is the package manager for Kubernetes.  It was created by Deis (now a part of Microsoft) and is a Graduated Project in the CNCF.

## Key Concepts

- Chart:  A collection of files that describe Kubernetes resources.
- Config: Configuration information that can be merged into a packaged chart
- Release:  A running instance of a chart with a specific config

## Description

In this challenge, you will create a new chart, deploy it and then also deploy an existing chart from a remote repository.  These charts will setup an Ingress Controller as well as a sample app.

1. Create a new chart
   - HINT: Use `helm template <chart>` to render a chart locally and display the output
1. Deploy the chart on your K8S cluster
1. Override default nginx image with <https://hub.docker.com/r/stefanprodan/podinfo>
   - HINT: note that this application runs on port 9898
   - HINT: You will need to replace the appVersion in the Chart.yaml to match the tag version from Dockerhub
1. Install NGINX Ingress Controller using Helm
   - HINT: This will be a separate chart and release than the one you created
   - HINT: [Make sure to add an initial repo](https://helm.sh/docs/intro/quickstart/#initialize-a-helm-chart-repository)
1. Update your created chart to add the Ingress route
   - HINT: This updates the original chart you created
   - HINT: You only need to modify the values.yaml file
   - HINT: The default annotations need to be commented back in
   - HINT: Use nip.io for DNS resolution
1. Verify App is available at myapp.$INGRESS_IP.nip.io
   - HINT: `INGRESS_IP=$(kubectl get service -n ingress-basic nginx-ingress-ingress-nginx-controller -o json |
 jq '.status.loadBalancer.ingress[0].ip' -r)`


## Success Criteria

* `helm ls --all-namespaces` shows your chart and the Ingress controller
* `curl myapp.$INGRESS_IP.nip.io` returns an HTTP 200 reponse

## Hints

1. [Helm commands](https://helm.sh/docs/helm/)
1. [Getting started with Helm charts](https://helm.sh/docs/chart_template_guide/getting_started)