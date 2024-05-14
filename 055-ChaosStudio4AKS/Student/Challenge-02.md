# Challenge 02: My AZ burned down, now what?

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites

Before creating your Azure Chaos Studio Experiment, ensure you have deployed and verified the pizzeria application is available. 

## Introduction

Welcome to Challenge 2.

Can your Application survive an Availability Zone Failure?

How did your application perform with pod failures? Are you still in business? Now that you have tested for pod faults and have
overcome with resiliency at the pod level --it is time to kick it up to the next level. Winter storms are a possibility on Superbowl Sunday and you need to
prepare for an Azure datacenter going offline. Choose your preferred region and AKS cluster to simulate an Availability Zone failure. 
 

## Description

As the purpose of this WTH is to show Chaos Studio, we are going to pretend that an Azure Availability Zone (datacenter) is offline. The way you will simulate this will be failing an AKS node with Chaos Studio. 

- Create and scope an Azure Chaos Studio Experiment to fail 1 of the pizza application's virtual machine(s)

During the experiment, were you able to order a pizza? If not, what could you do to make your application resilient at the Availability Zone/Virtual
Machine layer? 



## Success Criteria

- Show that Chaos Experiment fails a node running the pizzeria application
- Show any failure you observed during the experiment
- Discuss with your coach how your application is (or was made) resilient
- Verify the pizzeria application is available while a virtual machine is offline

## Tip

Take note of your virtual machine's instanceID


## Learning Resources
- [Simulate AKS pod failure with Chaos Studio](https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-tutorial-aks-portal)
- [Scale an AKS cluster](https://docs.microsoft.com/en-us/azure/aks/scale-cluster)
- [AKS cheat-sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

