# Challenge 02 - My Availability Zone burned down, now what?

**[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites

Before creating your Azure Chaos Studio Experiment, ensure you have deployed and verified the pizzeria application is available. 

## Introduction

Welcome to Challenge 2. Can your Application Survive an Availability Zone Failure?

How did your application perform with pod failures? Are you still in business? Now that you have tested for pod faults and have
overcome with resiliency at the pod level --it is time to kick it up to the next level. Winter storms are a possibility on Superbowl Sunday and you need to
prepare for an Azure datacenter going offline. Choose your preferred region and AKS cluster to simulate an Availability Zone failure. 
 

## Description

As the purpose of this WTH is to show Chaos Studio, we are going to pretend that an Azure Availability Zone (datacenter) is offline. The way you will simulate this will be failing an AKS node with Chaos Studio. 

- Create and scope an Azure Chaos Studio Experiment to fail 1 of the pizza application's virtual machine(s)

During the experiment, were you able to order a pizza? If not, what could you do to make your application resilient at the Availability Zone / Virtual
Machine layer? 



## Success Criteria

- Chaos Experiment fails a node running the pizzeria application
- Observe any failure
- Scale the AKS cluster 
- Scale the pizza application replicas to run multiple virtual machines
- Re-run the Chaos Experiment
- Verify the pizza application is available while a virtual machine is offline

## Tips

Take note of your virutal machine's instanceID

Verify where your pods are running (Portal or CLI)

```bash
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=<node>

```

Scale your Kubernetes environment (hint it is a statefull deployment)

```bash
kubectl scale statefulset -n contosoappmysql contosopizza --replicas=2

```


All virtual machine scaling should be done via AKS (not at the scale set)


## Learning Resources
- [Simulate AKS pod failure with Chaos Studio](https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-tutorial-aks-portal)
- [Scale an AKS cluster](https://docs.microsoft.com/en-us/azure/aks/scale-cluster)
- [AKS cheat-sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

