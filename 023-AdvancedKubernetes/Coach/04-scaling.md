# Challenge 4: Coach's Guide - Scaling

[< Previous Challenge](./03-resiliency.md) - **[Home](README.md)** - [Next Challenge>](./05-gitops.md)

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

### Enable the cluster autoscaler on the user nodepool

#### Using az cli:

``` bash
az aks nodepool update --cluster-name $CLUSTER_NAME -g $RESOURCE_GROUP \
  -n $NODEPOOL_NAME \
  --enable-cluster-autoscaler \
  --min-count=1 --max-count=10
```

#### Using Azure portal:

Open AKS resource. Select "Node pools" on the left bar. Find the user nodepool and select the menu on the right side (three dots). Set scale method to "autoscale".

![Nodepool scaling from portal](./Solutions/img/scale-portal.png)

### Create a deployment and service using the container image `k8s.gcr.io/hpa-example`

Create a yaml file similar to the one [here](./Solutions/04-scaling/hpa-example.yaml).

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hpa-example
spec:
  selector:
    matchLabels:
      app: hpa-example
  template:
    metadata:
      labels:
        app: hpa-example
    spec:
      containers:
      - name: hpa-example
        image: k8s.gcr.io/hpa-example
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: hpa-example
spec:
  selector:
    app: hpa-example
  ports:
  - port: 80
    targetPort: 80


```

Make sure to set the resource limit, otherwise the node will become unresponsive!

Create by applying the file:

``` bash
kubectl apply -f hpa-example.yaml
```

### Create the HPA for this deployment

```bash
kubectl autoscale deployment/hpa-example --max=10
```

### Simulate load by sending requests to the service

Create pods to continuously send requests to the service

``` bash
kubectl create deployment busybox --image=busybox --replicas=10 -- /bin/sh -c "while true; do wget -q -O- hpa-example; done"
```

Examine pod resource usage:

```bash
$ kubectl top pods
NAME                           CPU(cores)   MEMORY(bytes)
busybox                        5m           1Mi
hpa-example-69757b4d69-q4kgb   501m         12Mi
```

Examine the pod autoscaler (it will take a few moments to update):

``` bash
$ kubectl get hpa -w
hpa-example   Deployment/hpa-example   100%/80%        1         10        1          15s
hpa-example   Deployment/hpa-example   100%/80%        1         10        2          30s
hpa-example   Deployment/hpa-example   64%/80%         1         10        2          61s
```

Notice that the autoscaler has scaled up the number of pods in the deployment due to load.

### Reduce service load

Kill the busybox pod from the prior step:

``` bash
kubectl delete deployment busybox
```

The pod autoscaler should automatically remove pods as load decreases.

## Success Criteria

- After starting the load test, you see the number of pods increase
- After starting the load test, you see the number of nodes increase
- After stopping the load test, you see the number of pods decrease
- After stopping the load test, you see the number of nodes decrease
