# Challenge 4 - Scaling

[< Previous Challenge](./03-resiliency.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge>](./05-gitops.md)

## Introduction

When scaling in Kubernetes, there are some considerations:

* [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) - Scales the number of pods based upon a series of metrics (e.g. CPU or custom metrics)
* [Cluster Scaling](https://docs.microsoft.com/en-us/azure/aks/cluster-autoscaler) - Scales the number of nodes (VM's)
  * Scale up - When there are unscheduled pods due to unavailable resources in the existing nodes
  * Scale down - When there are a surplus of node resources for the scheduled number of pods
  * The cluster and horizontal pod autoscalers can work together, and are often both deployed in a cluster. When combined, the horizontal pod autoscaler is focused on running the number of pods required to meet application demand. The cluster autoscaler is focused on running the number of nodes required to support the scheduled pods.
* [Requests and Limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) - Specify the resources needed for a pod
    * Requests - Used to determine which node to place pod on
    * Limit - Enforced limit for resources pod can use

## Description

- Enable the cluster autoscaler on the user nodepool
- Create a deployment and service using the container image `k8s.gcr.io/hpa-example`
    - Any web request this receives will run a CPU intensive computation (calculates Pi)
    - HINT: Don't forget about requests/limits
- Create the HPA for this deployment
- Simulate load by sending requests to the service
    - Use a busybox deployment to continuously send traffic:  `kubectl create deployment busybox --image=busybox --replicas=10 -- /bin/sh -c "while true; do wget -q -O- hpa-example; done"`
    - Adjust the number of replicas as needed

## Success Criteria

- After starting the load test, you see the number of pods increase
- After starting the load test, you see the number of nodes increase
- After stopping the load test, you see the number of pods decrease
- After stopping the load test, you see the number of nodes decrease
