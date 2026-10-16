# Challenge 2 - Helm

[< Previous Challenge](./01-setup.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](./03-resiliency.md)

## Introduction

Helm is the package manager for Kubernetes.  It was created by Deis (now a part of Microsoft) and is a Graduated Project in the CNCF.

## Key Concepts

- Chart:  A collection of files that describe Kubernetes resources.
- Config: Configuration information that can be merged into a packaged chart
- Release:  A running instance of a chart with a specific config

## Description

In this challenge, you will create and deploy a Helm chart for a sample app, then expose it using the managed application routing add-on with Istio and Kubernetes Gateway API.

1. Create a new chart
   - HINT: Use `helm template <chart>` to render a chart locally and display the output
1. Deploy the chart on your K8S cluster
1. Override default nginx image with <https://hub.docker.com/r/stefanprodan/podinfo>
   - HINT: note that this application runs on port 9898
   - HINT: You will need to replace the appVersion in the Chart.yaml to match the tag version from Dockerhub
1. Enable the [managed application routing add-on with Istio](https://learn.microsoft.com/en-us/azure/aks/app-routing-gateway-api)
   - HINT: Enable managed Gateway API support as well
1. Update your created chart to add a Gateway and HTTPRoute
   - HINT: This updates the original chart you created
   - HINT: Recent versions of `helm create` include an HTTPRoute template, but not a Gateway template; add the Gateway manually using the `approuting-istio` GatewayClass
   - HINT: Keep the generated Ingress template disabled; using Ingress is discouraged in favor of Gateway API
   - HINT: Use nip.io for DNS resolution
   - HINT: OR, instead of nip.io, write a curl request with a custom host header
1. Verify App is available at myapp.$INGRESS_IP.nip.io
   - HINT: Find the external address in the Gateway status


## Success Criteria

* `helm ls --all-namespaces` shows your chart
* Your Gateway is programmed and your HTTPRoute is accepted with resolved backend references
* `curl myapp.$INGRESS_IP.nip.io` returns an HTTP 200 reponse

## Hints

1. [Helm commands](https://helm.sh/docs/helm/)
1. [Getting started with Helm charts](https://helm.sh/docs/chart_template_guide/getting_started)