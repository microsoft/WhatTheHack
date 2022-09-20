# Challenge 3: Coach's Guide - Resiliency

[< Previous Challenge](./02-helm.md) - **[Home](README.md)** - [Next Challenge>](./04-scaling.md)

## Introduction

Resiliency is the ability to recover quickly from issues.  For Cloud Native applications, we want to rely upon automation when possible.  We will add Readiness and Liveness Probes to our existing containers and validate them

## Description

For this challenge, we will continue to use <https://github.com/stefanprodan/podinfo> since it has a number of Web API's for interacting with the container.

The below assumes we are still working with the same Helm deployment from the previous challenge.

### Ensure you have multiple replicas of podinfo running

Check the number of pods running

```bash
kubectl get pods
```

Modify the replicaCount in the values.yaml to 3

```yaml
replicaCount: 3
```
### Update the readiness and liveness probes

Modify the deployment.yaml file:

```yaml
          livenessProbe:
            httpGet:
              path: /healthz # change this
              port: http
          readinessProbe:
            httpGet:
              path: /readyz # change this
              port: http
```

Update the helm deployment

``` bash
helm upgrade myapp myapp
```

### Force the readiness probe to fail for a specific instance

Before starting this step, look at the status of the existing pods:

``` bash
$ kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
myapp-544f85989f-9vg9n   1/1     Running   0          11s
myapp-544f85989f-g96gc   1/1     Running   0          43s
myapp-544f85989f-hsv9h   1/1     Running   0          11s
```

The podinfo application readiness probe can be forced to fail by sending a POST request to readyz/disable.

``` bash
INGRESS_IP=$(kubectl get service -n nginx-ingress nginx-ingress-controller -o json | jq '.status.loadBalancer.ingress[0].ip' -r)
curl -d '' myapp.$INGRESS_IP.nip.io/readyz/disable
```

After a few seconds, check status of pods again:

``` bash
$ kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
myapp-544f85989f-9vg9n   1/1     Running   0          5m22s
myapp-544f85989f-g96gc   1/1     Running   0          5m54s
myapp-544f85989f-hsv9h   0/1     Running   0          5m22s
```

Note that the service routes traffic to a random matching pod, in this case the third one.

## Success Criteria

- Before disabling the readiness probe, when you refresh the podinfo page, the hostname should rotate through each of the running pods.
- After disabling the response to the readiness probe, one of the hostnames should no longer be in the rotation

## Hints

1. [cURL manual](https://curl.haxx.se/docs/manual.html)
1. [Kubernetes probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes)
