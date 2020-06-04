# Challenge 5 - Service Mesh

[< Previous Challenge](./04-resiliency.md)

## Introduction

A service mesh provides capabilities like traffic management, resiliency, policy, security, strong identity, and observability to your workloads. 

![ServiceMesh](https://servicemesh.es/img/servicemesh.png)
Credit: https://servicemesh.es/

There are multiple service meshes, these are the 3 most popular (all of which use [Envoy](https://www.envoyproxy.io/) as the proxy):
* [Istio](https://istio.io) - The most popular service mesh.  Pro:  Well known, most feature.  Con: Resource intenstive, high complexity
* [Linkerd](https://linkerd.io/) - CNCF Incubating Project.  Pro: Light-weight, low complexity.  Con: Deeply integrated with K8S
* [Consul](https://www.hashicorp.com/products/consul/) - Written by Hashicorp.  Pro: Azure Consul Service.  Con: Full features are with Consul Connect

Microsoft has also written the [Service Mesh Interface](https://smi-spec.io/) to abstract the Service Mesh requirements from the implementation.  Most popular service meshes have adopted it.

## Description

For this challenge, we will deploy a Service Mesh and review some of the top features.

1. Install a Service Mesh
1. Apply a virtual service
1. Apply weight-based routing
1. Apply distributed tracing with Jaeger

## Success Criteria
